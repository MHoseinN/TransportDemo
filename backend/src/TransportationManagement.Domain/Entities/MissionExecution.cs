using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class MissionExecution : AuditableEntity
{
    public Guid MissionRequestId { get; set; }
    public MissionRequest? MissionRequest { get; set; }
    public DateTime ActualStartTime { get; set; }
    public DateTime? ActualEndTime { get; set; }
    public int StartKm { get; set; }
    public int? EndKm { get; set; }
    public int? TotalKm { get; set; }
    public decimal? DrivingHours { get; set; }
    public decimal SleepHours { get; set; }
    public decimal StopCost { get; set; }
    public decimal PenaltyAmount { get; set; }
    public decimal ExtraPayment { get; set; }
    public bool NoSalary { get; set; }
    public string? Description { get; set; }
}
