using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class MissionCompanion : AuditableEntity
{
    public Guid MissionRequestId { get; set; }
    public MissionRequest? MissionRequest { get; set; }
    public string PersonName { get; set; } = string.Empty;
    public string? NationalCode { get; set; }
    public string? EmployeeUserId { get; set; }
}
