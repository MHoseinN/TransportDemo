using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Enums;

namespace TransportationManagement.Domain.Entities;

public class Vehicle : SoftDeletableEntity
{
    public Guid BranchId { get; set; }
    public Branch? Branch { get; set; }
    public string PlateNumber { get; set; } = string.Empty;
    public string ChassisNumber { get; set; } = string.Empty;
    public string VehicleType { get; set; } = string.Empty;
    public string? Model { get; set; }
    public string? Color { get; set; }
    public int? Capacity { get; set; }
    public OwnershipType OwnershipType { get; set; }
    public DateOnly ThirdPartyInsuranceExpiryDate { get; set; }
    public DateOnly? BodyInsuranceExpiryDate { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsAvailable { get; set; } = true;
    public string? Description { get; set; }
}
