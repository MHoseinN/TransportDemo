using TransportationManagement.Domain.Common;

namespace TransportationManagement.Application.Abstractions.Persistence;

public interface IRepository<TEntity> where TEntity : Entity
{
}
