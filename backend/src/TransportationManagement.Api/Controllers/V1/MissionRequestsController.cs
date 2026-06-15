using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/mission-requests")]
public class MissionRequestsController : ControllerBase
{
    [HttpGet] public IActionResult GetAll() => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpGet("{id:guid}")] public IActionResult GetById(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpPost] public IActionResult Create() => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpPost("{id:guid}/submit")] public IActionResult Submit(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);
}
