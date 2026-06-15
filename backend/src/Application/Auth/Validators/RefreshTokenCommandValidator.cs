using FluentValidation;
using TransportMissionSystem.Application.Auth.Commands;

namespace TransportMissionSystem.Application.Auth.Validators;

public sealed class RefreshTokenCommandValidator : AbstractValidator<RefreshTokenCommand>
{
    public RefreshTokenCommandValidator()
    {
        RuleFor(x => x.RefreshToken).NotEmpty();
    }
}
