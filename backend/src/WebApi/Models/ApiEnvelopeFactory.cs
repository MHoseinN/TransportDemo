using TransportMissionSystem.Application.Common.Models;

namespace TransportMissionSystem.WebApi.Models;

public static class ApiEnvelopeFactory
{
    public static Envelope<T> Create<T>(Result<T> result) => Envelope<T>.FromResult(result);
}
