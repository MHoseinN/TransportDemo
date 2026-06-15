using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Infrastructure.Persistence.Configurations;

public sealed class UserRoleConfiguration : IEntityTypeConfiguration<UserRole>
{
    public void Configure(EntityTypeBuilder<UserRole> builder)
    {
        builder.ToTable("UserRoles", "dbo");
        builder.HasKey(x => x.Id);

        builder.HasIndex(x => new { x.UserId, x.RoleId }).IsUnique();

        builder.HasOne(x => x.Role)
            .WithMany(x => x.UserRoles)
            .HasForeignKey(x => x.RoleId);
    }
}
