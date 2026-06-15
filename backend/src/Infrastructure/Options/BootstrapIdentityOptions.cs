namespace TransportMissionSystem.Infrastructure.Options;

public sealed class BootstrapIdentityOptions
{
    public const string SectionName = "BootstrapIdentity";

    public bool Enabled { get; set; }
    public string Username { get; set; } = "admin";
    public string Password { get; set; } = "ChangeMe123!";
    public string FirstName { get; set; } = "System";
    public string LastName { get; set; } = "Administrator";
}
