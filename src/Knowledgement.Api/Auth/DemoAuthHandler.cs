using System.Security.Claims;
using System.Text.Encodings.Web;
using Knowledgement.Application.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace Knowledgement.Api.Auth;

public sealed class DemoAuthHandler(
    IOptionsMonitor<AuthenticationSchemeOptions> options,
    ILoggerFactory logger,
    UrlEncoder encoder)
    : AuthenticationHandler<AuthenticationSchemeOptions>(options, logger, encoder)
{
    public const string SchemeName = "DemoHeader";

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        var username = Request.Headers["X-Demo-User"].FirstOrDefault();
        var role = Request.Headers["X-Demo-Role"].FirstOrDefault();

        if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(role))
        {
            return Task.FromResult(AuthenticateResult.NoResult());
        }

        var normalizedRole = role switch
        {
            Roles.Manager => Roles.Manager,
            Roles.Supervisor => Roles.Supervisor,
            Roles.Operator => Roles.Operator,
            Roles.ExternalApp => Roles.ExternalApp,
            _ => string.Empty
        };

        if (string.IsNullOrWhiteSpace(normalizedRole))
        {
            return Task.FromResult(AuthenticateResult.Fail("Unsupported role."));
        }

        var claims = new[]
        {
            new Claim(ClaimTypes.Name, username),
            new Claim(ClaimTypes.Role, normalizedRole)
        };

        var identity = new ClaimsIdentity(claims, SchemeName);
        var principal = new ClaimsPrincipal(identity);
        var ticket = new AuthenticationTicket(principal, SchemeName);

        return Task.FromResult(AuthenticateResult.Success(ticket));
    }
}
