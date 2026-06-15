using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class Contract : SoftDeletableEntity
{
    public Guid DriverId { get; set; }
    public Driver? Driver { get; set; }
    public Guid? VehicleId { get; set; }
    public Vehicle? Vehicle { get; set; }
    public string ContractNumber { get; set; } = string.Empty;
    public DateOnly StartDate { get; set; }
    public DateOnly EndDate { get; set; }
    public decimal HourlyRate { get; set; }
    public decimal GoKmRate { get; set; }
    public decimal ReturnKmRate { get; set; }
    public decimal SleepHourRate { get; set; }
    public bool IsActive { get; set; } = true;
    public ICollection<ContractCalculationRule> CalculationRules { get; set; } = [];
}
