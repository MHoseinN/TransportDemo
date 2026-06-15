using Microsoft.AspNetCore.Mvc;

namespace TransportationManagement.Api.Controllers.V1;

[ApiController]
[Route("api/v1/workflow")]
public class WorkflowController : ControllerBase
{
    [HttpGet("inbox")]
    public IActionResult Inbox() => StatusCode(StatusCodes.Status501NotImplemented);

    [HttpGet("history/{entityType}/{entityId:guid}")]
    public IActionResult History(string entityType, Guid entityId) => StatusCode(StatusCodes.Status501NotImplemented);
}
