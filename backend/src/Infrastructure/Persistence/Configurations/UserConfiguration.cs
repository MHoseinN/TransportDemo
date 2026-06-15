using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Infrastructure.Persistence.Configurations;

public sealed class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("Users", "dbo");
        builder.HasKey(x => x.Id);

        builder.Property(x => x.FirstName).HasMaxLength(100).IsRequired();
        builder.Property(x => x.LastName).HasMaxLength(100).IsRequired();
        builder.Property(x => x.Username).HasMaxLength(100).IsRequired();
        builder.Property(x => x.PasswordHash).HasMaxLength(512).IsRequired();
        builder.Property(x => x.PersonnelCode).HasMaxLength(50);
        builder.Property(x => x.NationalCode).HasMaxLength(10);
        builder.Property(x => x.Mobile).HasMaxLength(20);
        builder.Property(x => x.Email).HasMaxLength(256);
        builder.Property(x => x.Status).HasMaxLength(20).IsRequired();

        builder.HasIndex(x => x.Username).IsUnique();
        builder.HasIndex(x => x.NationalCode).IsUnique().HasFilter("[NationalCode] IS NOT NULL");

        builder.HasMany(x => x.UserRoles)
            .WithOne(x => x.User)
            .HasForeignKey(x => x.UserId);

        builder.HasMany(x => x.RefreshTokens)
            .WithOne(x => x.User)
            .HasForeignKey(x => x.UserId);
    }
}
