using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Application.Common.Interfaces;

public interface IPasswordHasherService
{
    string HashPassword(User user, string password);
    bool VerifyPassword(User user, string hashedPassword, string providedPassword);
}
