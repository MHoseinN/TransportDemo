using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class Branch : SoftDeletableEntity
{
    public Guid? ParentId { get; set; }
    public Branch? Parent { get; set; }
    public Guid? CityId { get; set; }
    public City? City { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public ICollection<Branch> Children { get; set; } = [];
}
