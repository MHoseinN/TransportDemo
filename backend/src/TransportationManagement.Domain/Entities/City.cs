using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class City : SoftDeletableEntity
{
    public Guid ProvinceId { get; set; }
    public Province? Province { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
}
