namespace TransportMissionSystem.Application.Common.Models;

public static class ApplicationErrors
{
    public static readonly Error Validation = new("validation_error", "One or more validation errors occurred.");
    public static readonly Error Unauthorized = new("auth_unauthorized", "Invalid username or password.");
    public static readonly Error RefreshTokenInvalid = new("auth_refresh_invalid", "Refresh token is invalid or expired.");
    public static readonly Error Forbidden = new("auth_forbidden", "You are not allowed to perform this action.");
    public static readonly Error NotFound = new("resource_not_found", "The requested resource was not found.");
    public static readonly Error InactiveUser = new("auth_inactive_user", "Inactive or locked users cannot log in.");
}
