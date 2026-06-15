using TransportationManagement.Domain.Common;

namespace TransportationManagement.Domain.Entities;

public class Driver : SoftDeletableEntity
{
    public Guid BranchId { get; set; }
    public Branch? Branch { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? FatherName { get; set; }
    public string NationalCode { get; set; } = string.Empty;
    public string? IdentityNumber { get; set; }
    public string? BirthPlace { get; set; }
    public DateOnly? BirthDate { get; set; }
    public string? MobileNumber { get; set; }
    public string DrivingLicenseNumber { get; set; } = string.Empty;
    public DateOnly? DrivingLicenseExpiryDate { get; set; }
    public DateOnly? InsuranceExpiryDate { get; set; }
    public bool IsActive { get; set; } = true;
    public ICollection<DriverAttendance> Attendances { get; set; } = [];
}
