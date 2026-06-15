using TransportMissionSystem.Application.Common.Interfaces;

namespace TransportMissionSystem.Infrastructure.Services;

public sealed class SystemDateTimeProvider : IDateTimeProvider
{
    public DateTime UtcNow => DateTime.UtcNow;
}
