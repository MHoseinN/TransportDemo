namespace TransportMissionSystem.Application.Auth.Models;

public sealed record TokenPair(
    string AccessToken,
    string RefreshToken,
    DateTime AccessTokenExpiresAtUtc,
    DateTime RefreshTokenExpiresAtUtc);
