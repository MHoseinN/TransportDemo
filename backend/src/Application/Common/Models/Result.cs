namespace TransportMissionSystem.Application.Common.Models;

public class Result
{
    protected Result(bool isSuccess, string? message, IReadOnlyCollection<Error> errors)
    {
        IsSuccess = isSuccess;
        Message = message;
        Errors = errors;
    }

    public bool IsSuccess { get; }
    public string? Message { get; }
    public IReadOnlyCollection<Error> Errors { get; }

    public static Result Success(string? message = null) => new(true, message, Array.Empty<Error>());

    public static Result Failure(params Error[] errors) => new(false, null, errors);
}

public sealed class Result<T> : Result
{
    private Result(bool isSuccess, T? value, string? message, IReadOnlyCollection<Error> errors)
        : base(isSuccess, message, errors)
    {
        Value = value;
    }

    public T? Value { get; }

    public static Result<T> Success(T value, string? message = null) => new(true, value, message, Array.Empty<Error>());

    public static new Result<T> Failure(params Error[] errors) => new(false, default, null, errors);
}
