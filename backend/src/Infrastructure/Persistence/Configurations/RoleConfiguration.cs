using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Infrastructure.Persistence.Configurations;

public sealed class RoleConfiguration : IEntityTypeConfiguration<Role>
{
    public void Configure(EntityTypeBuilder<Role> builder)
    {
        builder.ToTable("Roles", "dbo");
        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name).HasMaxLength(100).IsRequired();
        builder.Property(x => x.DisplayName).HasMaxLength(150);
        builder.Property(x => x.Description).HasMaxLength(500);

        builder.HasIndex(x => x.Name).IsUnique();
    }
}
