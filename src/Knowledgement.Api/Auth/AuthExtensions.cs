using Microsoft.AspNetCore.Authentication;
using Microsoft.OpenApi.Models;

namespace Knowledgement.Api.Auth;

public static class AuthExtensions
{
    public static IServiceCollection AddApiAuthentication(this IServiceCollection services)
    {
        services.AddAuthentication(options =>
        {
            options.DefaultAuthenticateScheme = DemoAuthHandler.SchemeName;
            options.DefaultChallengeScheme = DemoAuthHandler.SchemeName;
        }).AddScheme<AuthenticationSchemeOptions, DemoAuthHandler>(DemoAuthHandler.SchemeName, _ => { });

        return services;
    }

    public static IServiceCollection AddApiSwagger(this IServiceCollection services)
    {
        services.AddOpenApi(options =>
        {
            options.AddDocumentTransformer((document, _, _) =>
            {
                document.Info.Title = "Knowledge Base API";
                document.Info.Version = "v1";
                document.Info.Description = "Foundation API for the Knowledge Base MVP.";

                document.Components ??= new OpenApiComponents();
                document.Components.SecuritySchemes["DemoHeaderAuth"] = new OpenApiSecurityScheme
                {
                    Type = SecuritySchemeType.ApiKey,
                    In = ParameterLocation.Header,
                    Name = "X-Demo-User",
                    Description = "Send X-Demo-User and X-Demo-Role headers for local development."
                };

                document.Components.SecuritySchemes["DemoRoleHeader"] = new OpenApiSecurityScheme
                {
                    Type = SecuritySchemeType.ApiKey,
                    In = ParameterLocation.Header,
                    Name = "X-Demo-Role"
                };

                return Task.CompletedTask;
            });
        });

        return services;
    }
}
