using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class Province : SoftDeletableEntity
{
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public ICollection<City> Cities { get; set; } = [];
}
