namespace TransportMissionSystem.Application.Auth.Models;

public sealed record UserDto(
    Guid Id,
    Guid? BranchId,
    Guid? OrganizationUnitId,
    string FirstName,
    string LastName,
    string? NationalCode,
    string? Mobile,
    string? PersonnelCode,
    string Username,
    IReadOnlyCollection<string> Roles,
    bool IsActive);
