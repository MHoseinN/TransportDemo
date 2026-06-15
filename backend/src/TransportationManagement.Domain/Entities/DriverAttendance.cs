using TransportationManagement.Domain.Common;
using TransportationManagement.Domain.Enums;

namespace TransportationManagement.Domain.Entities;

public class DriverAttendance : AuditableEntity
{
    public Guid DriverId { get; set; }
    public Driver? Driver { get; set; }
    public DateOnly AttendanceDate { get; set; }
    public DateTime CheckInAt { get; set; }
    public DateTime? CheckOutAt { get; set; }
    public AttendanceStatus Status { get; set; }
    public string? Notes { get; set; }
}
