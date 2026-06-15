namespace TransportMissionSystem.Application.Common.Models;

public sealed class Envelope<T>
{
    public required bool IsSuccess { get; init; }
    public string? Message { get; init; }
    public T? Data { get; init; }
    public IReadOnlyCollection<Error> Errors { get; init; } = Array.Empty<Error>();

    public static Envelope<T> FromResult(Result<T> result) => new()
    {
        IsSuccess = result.IsSuccess,
        Message = result.Message,
        Data = result.Value,
        Errors = result.Errors
    };
}
