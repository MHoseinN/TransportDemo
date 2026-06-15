namespace TransportMissionSystem.Application.Common.Models;

public sealed record PagedResult<T>(IReadOnlyCollection<T> Items, PaginationMeta Meta);

public sealed record PaginationMeta(int Page, int PageSize, int TotalCount);
