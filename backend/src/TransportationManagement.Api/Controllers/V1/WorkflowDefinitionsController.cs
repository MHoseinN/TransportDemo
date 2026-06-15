using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/workflow-definitions")]
public class WorkflowDefinitionsController : ControllerBase
{
    [HttpGet] public IActionResult GetAll() => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpGet("{id:guid}")] public IActionResult GetById(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpPost] public IActionResult Create() => StatusCode(StatusCodes.Status501NotImplemented);
}
