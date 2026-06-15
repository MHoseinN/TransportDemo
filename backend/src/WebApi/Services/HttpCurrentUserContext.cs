using System.Security.Claims;
using TransportMissionSystem.Application.Common.Interfaces;

namespace TransportMissionSystem.WebApi.Services;

public sealed class HttpCurrentUserContext(IHttpContextAccessor httpContextAccessor) : ICurrentUserContext
{
    public Guid? UserId
    {
        get
        {
            var raw = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
            return Guid.TryParse(raw, out var parsed) ? parsed : null;
        }
    }

    public string? Username => httpContextAccessor.HttpContext?.User.Identity?.Name;
    public bool IsAuthenticated => httpContextAccessor.HttpContext?.User.Identity?.IsAuthenticated ?? false;

    public IReadOnlyCollection<string> Roles =>
        httpContextAccessor.HttpContext?.User.FindAll(ClaimTypes.Role).Select(x => x.Value).ToArray()
        ?? Array.Empty<string>();
}
