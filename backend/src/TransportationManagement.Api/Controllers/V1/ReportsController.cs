using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/reports")]
public class ReportsController : ControllerBase
{
    [HttpGet("missions")] public IActionResult Missions() => StatusCode(StatusCodes.Status501NotImplemented);
}
