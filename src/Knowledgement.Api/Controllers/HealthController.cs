using Microsoft.AspNetCore.Mvc;

namespace Knowledgement.Api.Controllers;

[ApiController]
[Route("api/health")]
public sealed class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new
        {
            service = "Knowledgement.Api",
            status = "Healthy",
            utcTime = DateTime.UtcNow
        });
    }
}
