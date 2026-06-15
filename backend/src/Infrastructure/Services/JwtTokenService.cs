using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using TransportMissionSystem.Application.Auth.Models;
using TransportMissionSystem.Application.Common.Interfaces;
using TransportMissionSystem.Domain.Identity;
using TransportMissionSystem.Infrastructure.Options;

namespace TransportMissionSystem.Infrastructure.Services;

public sealed class JwtTokenService(IOptions<JwtOptions> options, IDateTimeProvider dateTimeProvider) : ITokenService
{
    private readonly JwtOptions _options = options.Value;

    public TokenPair GenerateTokens(User user, IReadOnlyCollection<string> roles)
    {
        var accessTokenExpiresAt = dateTimeProvider.UtcNow.AddMinutes(_options.AccessTokenMinutes);
        var refreshTokenExpiresAt = dateTimeProvider.UtcNow.AddDays(_options.RefreshTokenDays);
        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new(JwtRegisteredClaimNames.UniqueName, user.Username),
            new(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new(ClaimTypes.Name, user.Username)
        };

        claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_options.SigningKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var jwt = new JwtSecurityToken(
            issuer: _options.Issuer,
            audience: _options.Audience,
            claims: claims,
            expires: accessTokenExpiresAt,
            signingCredentials: credentials);

        return new TokenPair(
            new JwtSecurityTokenHandler().WriteToken(jwt),
            Convert.ToBase64String(RandomNumberGenerator.GetBytes(64)),
            accessTokenExpiresAt,
            refreshTokenExpiresAt);
    }
}
