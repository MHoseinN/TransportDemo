using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TransportMissionSystem.Application.Common.Interfaces;
using TransportMissionSystem.Infrastructure.Authorization;
using TransportMissionSystem.Infrastructure.Options;
using TransportMissionSystem.Infrastructure.Persistence;
using TransportMissionSystem.Infrastructure.Seeding;
using TransportMissionSystem.Infrastructure.Services;

namespace TransportMissionSystem.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<JwtOptions>(configuration.GetSection(JwtOptions.SectionName));
        services.Configure<BootstrapIdentityOptions>(configuration.GetSection(BootstrapIdentityOptions.SectionName));

        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());
        services.AddSingleton<IDateTimeProvider, SystemDateTimeProvider>();
        services.AddScoped<PasswordHasherService>();
        services.AddScoped<IPasswordHasherService>(provider => provider.GetRequiredService<PasswordHasherService>());
        services.AddScoped<ITokenService, JwtTokenService>();

        var jwtOptions = configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>() ?? new JwtOptions();
        var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtOptions.SigningKey));

        services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateIssuerSigningKey = true,
                    ValidateLifetime = true,
                    ValidIssuer = jwtOptions.Issuer,
                    ValidAudience = jwtOptions.Audience,
                    IssuerSigningKey = signingKey,
                    ClockSkew = TimeSpan.FromMinutes(1)
                };
            });

        services.AddAuthorization(AuthorizationPolicies.Register);
        services.AddHostedService<IdentityBootstrapper>();

        return services;
    }
}
