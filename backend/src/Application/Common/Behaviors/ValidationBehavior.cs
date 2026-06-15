using FluentValidation;
using MediatR;
using TransportMissionSystem.Application.Common.Models;

namespace TransportMissionSystem.Application.Common.Behaviors;

public sealed class ValidationBehavior<TRequest, TResponse>(IEnumerable<IValidator<TRequest>> validators)
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
{
    public async Task<TResponse> Handle(
        TRequest request,
        RequestHandlerDelegate<TResponse> next,
        CancellationToken cancellationToken)
    {
        if (!validators.Any())
        {
            return await next();
        }

        var context = new ValidationContext<TRequest>(request);
        var failures = await Task.WhenAll(validators.Select(validator => validator.ValidateAsync(context, cancellationToken)));
        var errors = failures
            .SelectMany(result => result.Errors)
            .Where(error => error is not null)
            .Select(error => new Error(error.PropertyName, error.ErrorMessage))
            .ToArray();

        if (errors.Length == 0)
        {
            return await next();
        }

        var responseType = typeof(TResponse);
        if (!responseType.IsGenericType || responseType.GetGenericTypeDefinition() != typeof(Result<>))
        {
            throw new ValidationException(failures.SelectMany(f => f.Errors));
        }

        var failureMethod = responseType.GetMethod(nameof(Result<object>.Failure), System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static);
        if (failureMethod is null)
        {
            throw new ValidationException(failures.SelectMany(f => f.Errors));
        }

        return (TResponse)failureMethod.Invoke(null, [errors])!;
    }
}
