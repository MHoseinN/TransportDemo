using Microsoft.AspNetCore.Authorization;
using TransportMissionSystem.Domain.Identity;

namespace TransportMissionSystem.Infrastructure.Authorization;

public static class AuthorizationPolicies
{
    public const string AuthenticatedUser = "Policies.Auth.Authenticated";
    public const string UsersViewAll = "Policies.Users.ViewAll";
    public const string UsersManage = "Policies.Users.Manage";
    public const string AuditView = "Policies.Audit.View";
    public const string DispatchAssign = "Policies.Dispatch.Assign";
    public const string ExecutionRecord = "Policies.Execution.Record";
    public const string FinanceCalculate = "Policies.Finance.Calculate";

    public static void Register(AuthorizationOptions options)
    {
        options.AddPolicy(AuthenticatedUser, policy => policy.RequireAuthenticatedUser());
        options.AddPolicy(UsersViewAll, policy => policy.RequireRole(RoleNames.Admin, RoleNames.ITOperator));
        options.AddPolicy(UsersManage, policy => policy.RequireRole(RoleNames.Admin));
        options.AddPolicy(AuditView, policy => policy.RequireRole(RoleNames.Admin, RoleNames.ITOperator));
        options.AddPolicy(DispatchAssign, policy => policy.RequireRole(RoleNames.Admin, RoleNames.Dispatcher));
        options.AddPolicy(ExecutionRecord, policy => policy.RequireRole(RoleNames.Admin, RoleNames.Dispatcher, RoleNames.Driver));
        options.AddPolicy(FinanceCalculate, policy => policy.RequireRole(RoleNames.Admin, RoleNames.Finance));
    }
}
