using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Enums;

namespace TransportationManagement.Domain.Entities;

public class MissionRequest : SoftDeletableEntity
{
    public string RequestNumber { get; set; } = string.Empty;
    public string RequesterUserId { get; set; } = string.Empty;
    public string RequesterDisplayName { get; set; } = string.Empty;
    public Guid RequesterBranchId { get; set; }
    public Branch? RequesterBranch { get; set; }
    public MissionType MissionType { get; set; }
    public TransportType TransportType { get; set; }
    public MissionArea MissionArea { get; set; }
    public DateTime StartDateTime { get; set; }
    public DateTime EndDateTime { get; set; }
    public Guid OriginProvinceId { get; set; }
    public Province? OriginProvince { get; set; }
    public Guid OriginCityId { get; set; }
    public City? OriginCity { get; set; }
    public string? OriginAddress { get; set; }
    public Guid DestinationProvinceId { get; set; }
    public Province? DestinationProvince { get; set; }
    public Guid DestinationCityId { get; set; }
    public City? DestinationCity { get; set; }
    public string? DestinationAddress { get; set; }
    public string Reason { get; set; } = string.Empty;
    public string? Description { get; set; }
    public MissionStatus Status { get; set; }
    public ICollection<MissionCompanion> Companions { get; set; } = [];
}
