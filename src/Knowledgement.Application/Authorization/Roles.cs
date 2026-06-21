namespace Knowledgement.Application.Authorization;

public static class Roles
{
    public const string Manager = nameof(Manager);
    public const string Supervisor = nameof(Supervisor);
    public const string Operator = nameof(Operator);
    public const string ExternalApp = nameof(ExternalApp);

    public static readonly string[] ContentManagers = [Manager, Supervisor];
}
