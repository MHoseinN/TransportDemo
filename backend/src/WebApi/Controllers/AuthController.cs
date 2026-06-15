using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransportMissionSystem.Application.Auth.Commands;
using TransportMissionSystem.Application.Auth.Models;
using TransportMissionSystem.Application.Common.Models;
using TransportMissionSystem.WebApi.Models;

namespace TransportMissionSystem.WebApi.Controllers;

[ApiController]
[Route("api/v1/auth")]
public sealed class AuthController(ISender sender) : ControllerBase
{
    [AllowAnonymous]
    [HttpPost("login")]
    [ProducesResponseType(typeof(Envelope<AuthResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Envelope<AuthResponse>), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(Envelope<AuthResponse>), StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken cancellationToken)
    {
        var result = await sender.Send(new LoginCommand(request.Username, request.Password), cancellationToken);
        if (!result.IsSuccess)
        {
            return Unauthorized(ApiEnvelopeFactory.Create(result));
        }

        return Ok(ApiEnvelopeFactory.Create(result));
    }

    [AllowAnonymous]
    [HttpPost("refresh")]
    [ProducesResponseType(typeof(Envelope<AuthResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(Envelope<AuthResponse>), StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Refresh([FromBody] RefreshTokenRequest request, CancellationToken cancellationToken)
    {
        var result = await sender.Send(new RefreshTokenCommand(request.RefreshToken), cancellationToken);
        if (!result.IsSuccess)
        {
            return Unauthorized(ApiEnvelopeFactory.Create(result));
        }

        return Ok(ApiEnvelopeFactory.Create(result));
    }
}
