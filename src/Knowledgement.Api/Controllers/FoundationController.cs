using Knowledgement.Application.Authorization;
using Knowledgement.Application.Common.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Knowledgement.Api.Controllers;

[ApiController]
[Route("api/v1/foundation")]
[Authorize]
public sealed class FoundationController(IApplicationDbContext dbContext) : ControllerBase
{
    [HttpGet("bootstrap")]
    [Authorize(Policy = Policies.ReadPublishedKnowledge)]
    public async Task<IActionResult> GetBootstrap(CancellationToken cancellationToken)
    {
        var snapshot = new
        {
            users = await dbContext.Users.CountAsync(cancellationToken),
            deputies = await dbContext.Deputies.CountAsync(cancellationToken),
            departments = await dbContext.Departments.CountAsync(cancellationToken),
            topics = await dbContext.Topics.CountAsync(cancellationToken),
            subTopics = await dbContext.SubTopics.CountAsync(cancellationToken),
            dailyMessages = await dbContext.DailyMessages.CountAsync(cancellationToken),
            generatedAt = DateTime.UtcNow
        };

        return Ok(snapshot);
    }
}
