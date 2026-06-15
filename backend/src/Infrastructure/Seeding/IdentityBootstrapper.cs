using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using TransportMissionSystem.Domain.Identity;
using TransportMissionSystem.Infrastructure.Options;
using TransportMissionSystem.Infrastructure.Persistence;
using TransportMissionSystem.Infrastructure.Services;

namespace TransportMissionSystem.Infrastructure.Seeding;

public sealed class IdentityBootstrapper(
    IServiceProvider serviceProvider,
    IOptions<BootstrapIdentityOptions> options,
    ILogger<IdentityBootstrapper> logger) : IHostedService
{
    private readonly BootstrapIdentityOptions _options = options.Value;

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        if (!_options.Enabled)
        {
            logger.LogInformation("Bootstrap identity seeding is disabled");
            return;
        }

        using var scope = serviceProvider.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        var passwordHasher = scope.ServiceProvider.GetRequiredService<PasswordHasherService>();

        await dbContext.Database.EnsureCreatedAsync(cancellationToken);

        foreach (var roleName in RoleNames.All)
        {
            if (await dbContext.Roles.AnyAsync(x => x.Name == roleName, cancellationToken))
            {
                continue;
            }

            dbContext.Roles.Add(new Role
            {
                Name = roleName,
                DisplayName = roleName,
                Description = $"{roleName} role seeded from the default permission matrix.",
                CreatedAt = DateTime.UtcNow
            });
        }

        var existingUser = await dbContext.Users
            .Include(x => x.UserRoles)
            .FirstOrDefaultAsync(x => x.Username == _options.Username, cancellationToken);

        if (existingUser is null)
        {
            var adminRole = await dbContext.Roles.FirstAsync(x => x.Name == RoleNames.Admin, cancellationToken);
            var user = new User
            {
                FirstName = _options.FirstName,
                LastName = _options.LastName,
                Username = _options.Username,
                Status = UserStatus.Active,
                CreatedAt = DateTime.UtcNow
            };

            user.PasswordHash = passwordHasher.HashPassword(user, _options.Password);
            user.UserRoles.Add(new UserRole
            {
                RoleId = adminRole.Id,
                CreatedAt = DateTime.UtcNow
            });

            dbContext.Users.Add(user);
        }

        await dbContext.SaveChangesAsync(cancellationToken);
        logger.LogInformation("Bootstrap identity seeding completed");
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
