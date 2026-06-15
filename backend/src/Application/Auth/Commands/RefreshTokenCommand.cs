using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using TransportMissionSystem.Application.Auth.Models;
using TransportMissionSystem.Application.Common.Interfaces;
using TransportMissionSystem.Application.Common.Models;

namespace TransportMissionSystem.Application.Auth.Commands;

public sealed record RefreshTokenCommand(string RefreshToken) : IRequest<Result<AuthResponse>>;

public sealed class RefreshTokenCommandHandler(
    IApplicationDbContext dbContext,
    ITokenService tokenService,
    IDateTimeProvider dateTimeProvider,
    ILogger<RefreshTokenCommandHandler> logger) : IRequestHandler<RefreshTokenCommand, Result<AuthResponse>>
{
    public async Task<Result<AuthResponse>> Handle(RefreshTokenCommand request, CancellationToken cancellationToken)
    {
        var refreshToken = await dbContext.RefreshTokens
            .Include(x => x.User)
            .ThenInclude(x => x.UserRoles)
            .ThenInclude(x => x.Role)
            .FirstOrDefaultAsync(x => x.Token == request.RefreshToken && !x.IsDeleted, cancellationToken);

        if (refreshToken is null || !refreshToken.IsActive || !refreshToken.User.IsActive)
        {
            logger.LogWarning("Refresh token was rejected");
            return Result<AuthResponse>.Failure(ApplicationErrors.RefreshTokenInvalid);
        }

        refreshToken.RevokedAt = dateTimeProvider.UtcNow;
        refreshToken.ReasonRevoked = "Rotated";
        refreshToken.UpdatedAt = dateTimeProvider.UtcNow;

        var roles = refreshToken.User.UserRoles.Select(x => x.Role.Name).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
        var tokenPair = tokenService.GenerateTokens(refreshToken.User, roles);

        dbContext.RefreshTokens.Add(new Domain.Identity.RefreshToken
        {
            UserId = refreshToken.UserId,
            Token = tokenPair.RefreshToken,
            ExpiresAt = tokenPair.RefreshTokenExpiresAtUtc,
            CreatedAt = dateTimeProvider.UtcNow
        });

        await dbContext.SaveChangesAsync(cancellationToken);

        logger.LogInformation("Refresh token rotated for user {UserId}", refreshToken.UserId);

        return Result<AuthResponse>.Success(new AuthResponse(
            tokenPair.AccessToken,
            tokenPair.RefreshToken,
            tokenPair.AccessTokenExpiresAtUtc,
            refreshToken.User.ToDto(roles)));
    }
}
