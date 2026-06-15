using MediatR;
using Microsoft.EntityFrameworkCore;
using TransportMissionSystem.Application.Auth.Models;
using TransportMissionSystem.Application.Common.Interfaces;
using TransportMissionSystem.Application.Common.Models;

namespace TransportMissionSystem.Application.Auth.Queries;

public sealed record GetCurrentUserQuery : IRequest<Result<UserDto>>;

public sealed class GetCurrentUserQueryHandler(
    ICurrentUserContext currentUserContext,
    IApplicationDbContext dbContext) : IRequestHandler<GetCurrentUserQuery, Result<UserDto>>
{
    public async Task<Result<UserDto>> Handle(GetCurrentUserQuery request, CancellationToken cancellationToken)
    {
        if (!currentUserContext.IsAuthenticated || currentUserContext.UserId is null)
        {
            return Result<UserDto>.Failure(ApplicationErrors.Forbidden);
        }

        var user = await dbContext.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == currentUserContext.UserId.Value, cancellationToken);

        if (user is null)
        {
            return Result<UserDto>.Failure(ApplicationErrors.NotFound);
        }

        return Result<UserDto>.Success(user.ToDto(currentUserContext.Roles));
    }
}
