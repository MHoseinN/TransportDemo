using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Infrastructure.Persistence.Configurations;

public sealed class RefreshTokenConfiguration : IEntityTypeConfiguration<RefreshToken>
{
    public void Configure(EntityTypeBuilder<RefreshToken> builder)
    {
        builder.ToTable("RefreshTokens", "dbo");
        builder.HasKey(x => x.Id);

        builder.Property(x => x.Token).HasMaxLength(512).IsRequired();
        builder.Property(x => x.ReasonRevoked).HasMaxLength(250);
        builder.HasIndex(x => x.Token).IsUnique();
    }
}
