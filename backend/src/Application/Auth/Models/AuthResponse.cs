namespace TransportMissionSystem.Application.Auth.Models;

public sealed record AuthResponse(string AccessToken, string RefreshToken, DateTime ExpiresAt, UserDto User);
