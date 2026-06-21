using Knowledgement.Application.Common.Interfaces;
using Knowledgement.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Knowledgement.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("KnowledgeBase");
        var resolvedConnectionString = string.IsNullOrWhiteSpace(connectionString)
            ? "Server=(localdb)\\MSSQLLocalDB;Database=KnowledgementDb;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=true"
            : connectionString;

        services.AddDbContext<KnowledgeBaseDbContext>(options =>
        {
            options.UseSqlServer(resolvedConnectionString, sql =>
            {
                sql.MigrationsAssembly(typeof(KnowledgeBaseDbContext).Assembly.FullName);
                sql.UseQuerySplittingBehavior(QuerySplittingBehavior.SplitQuery);
            });
        });

        services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<KnowledgeBaseDbContext>());

        return services;
    }
}
