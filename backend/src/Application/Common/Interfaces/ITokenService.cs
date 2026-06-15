using TransportMissionSystem.Application.Auth.Models;
using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Application.Common.Interfaces;

public interface ITokenService
{
    TokenPair GenerateTokens(User user, IReadOnlyCollection<string> roles);
}
