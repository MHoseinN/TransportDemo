namespace TransportMissionSystem.Application.Common.Interfaces;

public interface ICurrentUserContext
{
    Guid? UserId { get; }
    string? Username { get; }
    bool IsAuthenticated { get; }
    IReadOnlyCollection<string> Roles { get; }
}
