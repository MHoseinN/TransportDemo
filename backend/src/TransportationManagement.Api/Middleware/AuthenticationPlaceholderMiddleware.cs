namespace TransportationManagement.Api.Middleware;

public class AuthenticationPlaceholderMiddleware(RequestDelegate next)
{
    public Task InvokeAsync(HttpContext context) => next(context);
}
