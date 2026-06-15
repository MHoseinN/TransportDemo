namespace TransportMissionSystem.Infrastructure.Options;

public sealed class JwtOptions
{
    public const string SectionName = "Jwt";

    public string Issuer { get; set; } = "TransportMissionSystem";
    public string Audience { get; set; } = "TransportMissionSystem.Client";
    public string SigningKey { get; set; } = "TODO_CHANGE_ME_DEVELOPMENT_ONLY_SIGNING_KEY_1234567890";
    public int AccessTokenMinutes { get; set; } = 60;
    public int RefreshTokenDays { get; set; } = 7;
}
