namespace TransportMissionSystem.Domain.Common;

public interface IDomainEventHolder
{
    IReadOnlyCollection<DomainEvent> DomainEvents { get; }
    void ClearDomainEvents();
}
