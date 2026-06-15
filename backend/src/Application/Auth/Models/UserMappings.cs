using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Application.Auth.Models;

public static class UserMappings
{
    public static UserDto ToDto(this User user, IReadOnlyCollection<string> roles) =>
        new(
            user.Id,
            user.BranchId,
            user.OrganizationUnitId,
            user.FirstName,
            user.LastName,
            user.NationalCode,
            user.Mobile,
            user.PersonnelCode,
            user.Username,
            roles,
            user.IsActive);
}
