using FluentValidation;
using TransportMissionSystem.Application.Auth.Commands;

namespace TransportMissionSystem.Application.Auth.Validators;

public sealed class LoginCommandValidator : AbstractValidator<LoginCommand>
{
    public LoginCommandValidator()
    {
        RuleFor(x => x.Username).NotEmpty();
        RuleFor(x => x.Password).NotEmpty();
    }
}
