namespace TransportMissionSystem.Domain.Identity;

public static class RoleNames
{
    public const string Admin = "Admin";
    public const string Employee = "Employee";
    public const string Manager = "Manager";
    public const string Dispatcher = "Dispatcher";
    public const string Driver = "Driver";
    public const string Finance = "Finance";
    public const string ITOperator = "ITOperator";

    public static readonly string[] All =
    [
        Admin,
        Employee,
        Manager,
        Dispatcher,
        Driver,
        Finance,
        ITOperator
    ];
}
