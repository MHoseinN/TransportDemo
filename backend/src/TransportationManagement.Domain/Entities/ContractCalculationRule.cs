using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class ContractCalculationRule : AuditableEntity
{
    public Guid ContractId { get; set; }
    public Contract? Contract { get; set; }
    public string RuleCode { get; set; } = string.Empty;
    public string StrategyCode { get; set; } = string.Empty;
    public int Priority { get; set; }
    public string? ConfigurationJson { get; set; }
    public bool IsActive { get; set; } = true;
}
