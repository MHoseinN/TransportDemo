using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Enums;

namespace TransportationManagement.Domain.Entities;

public class MissionAssignment : AuditableEntity
{
    public Guid MissionRequestId { get; set; }
    public MissionRequest? MissionRequest { get; set; }
    public Guid DriverId { get; set; }
    public Driver? Driver { get; set; }
    public Guid VehicleId { get; set; }
    public Vehicle? Vehicle { get; set; }
    public DateTime AssignedAt { get; set; }
    public string AssignedBy { get; set; } = string.Empty;
    public AssignmentStatus Status { get; set; }
    public bool OverrideInsuranceExpiry { get; set; }
    public string? OverrideReason { get; set; }
}
