using TransportationManagement.Application.Abstractions.Persistence;
using TransportationManagement.Domain.Common;

namespace TransportationManagement.Infrastructure.Repositories;

public class Repository<TEntity> : IRepository<TEntity> where TEntity : Entity
{
}
