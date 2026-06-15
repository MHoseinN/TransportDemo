using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/driver-attendance")]
public class DriverAttendanceController : ControllerBase
{
    [HttpGet] public IActionResult GetAll() => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpPost] public IActionResult Create() => StatusCode(StatusCodes.Status501NotImplemented);
}
