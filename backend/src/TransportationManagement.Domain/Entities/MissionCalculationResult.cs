using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class MissionCalculationResult : AuditableEntity
{
    public Guid MissionExecutionId { get; set; }
    public MissionExecution? MissionExecution { get; set; }
    public decimal BaseAmount { get; set; }
    public decimal KmAmount { get; set; }
    public decimal HourAmount { get; set; }
    public decimal SleepAmount { get; set; }
    public decimal StopCostAmount { get; set; }
    public decimal PenaltyAmount { get; set; }
    public decimal ExtraAmount { get; set; }
    public decimal TotalAmount { get; set; }
    public string? CalculationJson { get; set; }
    public string StrategyCode { get; set; } = string.Empty;
    public DateTime CalculatedAt { get; set; }
}
