using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/workflow-instances")]
public class WorkflowInstancesController : ControllerBase
{
    [HttpGet("{id:guid}")] public IActionResult GetById(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);
    [HttpPost("{id:guid}/actions")] public IActionResult CreateAction(Guid id) => StatusCode(StatusCodes.Status501NotImplemented);
}
