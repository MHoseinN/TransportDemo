using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using TransportMissionSystem.Application.Auth.Models;
using TransportMissionSystem.Application.Common.Interfaces;
using TransportMissionSystem.Application.Common.Models;
using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Application.Auth.Commands;

public sealed record LoginCommand(string Username, string Password) : IRequest<Result<AuthResponse>>;

public sealed class LoginCommandHandler(
    IApplicationDbContext dbContext,
    IPasswordHasherService passwordHasherService,
    ITokenService tokenService,
    IDateTimeProvider dateTimeProvider,
    ILogger<LoginCommandHandler> logger) : IRequestHandler<LoginCommand, Result<AuthResponse>>
{
    public async Task<Result<AuthResponse>> Handle(LoginCommand request, CancellationToken cancellationToken)
    {
        var normalizedUsername = request.Username.Trim();

        var user = await dbContext.Users
            .Include(x => x.UserRoles)
            .ThenInclude(x => x.Role)
            .Include(x => x.RefreshTokens)
            .FirstOrDefaultAsync(x => x.Username == normalizedUsername && !x.IsDeleted, cancellationToken);

        if (user is null || !passwordHasherService.VerifyPassword(user, user.PasswordHash, request.Password))
        {
            logger.LogWarning("Login failed for username {Username}", normalizedUsername);
            return Result<AuthResponse>.Failure(ApplicationErrors.Unauthorized);
        }

        if (!user.Status.Equals(UserStatus.Active, StringComparison.OrdinalIgnoreCase))
        {
            logger.LogWarning("Inactive or locked user {Username} attempted login with status {Status}", normalizedUsername, user.Status);
            return Result<AuthResponse>.Failure(ApplicationErrors.InactiveUser);
        }

        var roles = user.UserRoles.Select(x => x.Role.Name).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
        var tokenPair = tokenService.GenerateTokens(user, roles);

        user.LastLoginAt = dateTimeProvider.UtcNow;
        user.RefreshTokens.Add(new RefreshToken
        {
            UserId = user.Id,
            Token = tokenPair.RefreshToken,
            ExpiresAt = tokenPair.RefreshTokenExpiresAtUtc,
            CreatedAt = dateTimeProvider.UtcNow
        });

        await dbContext.SaveChangesAsync(cancellationToken);

        logger.LogInformation("User {Username} logged in successfully", normalizedUsername);

        return Result<AuthResponse>.Success(new AuthResponse(
            tokenPair.AccessToken,
            tokenPair.RefreshToken,
            tokenPair.AccessTokenExpiresAtUtc,
            user.ToDto(roles)));
    }
}
