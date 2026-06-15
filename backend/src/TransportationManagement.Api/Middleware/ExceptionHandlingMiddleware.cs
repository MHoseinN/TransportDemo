namespace TransportationManagement.Api.Middleware;

public class ExceptionHandlingMiddleware(RequestDelegate next)
{
    public Task InvokeAsync(HttpContext context) => next(context);
}
