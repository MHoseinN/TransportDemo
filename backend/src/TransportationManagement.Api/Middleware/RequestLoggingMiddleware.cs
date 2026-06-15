namespace TransportationManagement.Api.Middleware;

public class RequestLoggingMiddleware(RequestDelegate next)
{
    public Task InvokeAsync(HttpContext context) => next(context);
}
