using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/mission-executions")]
public class MissionExecutionsController : ControllerBase
{
    [HttpGet] public IActionResult GetAll() => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpPost] public IActionResult Create() => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpPost("{id:guid}/recalculate")] public IActionResult Recalculate(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);
}
