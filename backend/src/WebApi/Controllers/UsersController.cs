using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransportMissionSystem.Application.Auth.Models;
using TransportMissionSystem.Application.Auth.Queries;
using TransportMissionSystem.Application.Common.Models;
using TransportMissionSystem.Infrastructure.Authorization;
using TransportMissionSystem.WebApi.Models;

namespace TransportMissionSystem.WebApi.Controllers;

[ApiController]
[Route("api/v1")]
public sealed class UsersController(ISender sender) : ControllerBase
{
    [Authorize(Policy = AuthorizationPolicies.AuthenticatedUser)]
    [HttpGet("me")]
    [ProducesResponseType(typeof(Envelope<UserDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Envelope<UserDto>), StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Me(CancellationToken cancellationToken)
    {
        var result = await sender.Send(new GetCurrentUserQuery(), cancellationToken);
        if (!result.IsSuccess)
        {
            return Unauthorized(ApiEnvelopeFactory.Create(result));
        }

        return Ok(ApiEnvelopeFactory.Create(result));
    }
}
