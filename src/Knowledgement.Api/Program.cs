using Knowledgement.Api.Auth;
using Knowledgement.Application.Authorization;
using Knowledgement.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddApiAuthentication();
builder.Services.AddInfrastructure(builder.Configuration);
builder.Services.AddApiSwagger();
builder.Services.AddAuthorizationBuilder()
    .AddPolicy(Policies.ManageCategories, policy => policy.RequireRole(Roles.Manager, Roles.Supervisor))
    .AddPolicy(Policies.ReviewApprovals, policy => policy.RequireRole(Roles.Manager))
    .AddPolicy(Policies.CreateOfficialContent, policy => policy.RequireRole(Roles.Manager, Roles.Supervisor))
    .AddPolicy(Policies.ReadPublishedKnowledge, policy => policy.RequireRole(Roles.Manager, Roles.Supervisor, Roles.Operator))
    .AddPolicy(Policies.ExternalKnowledgeAccess, policy => policy.RequireRole(Roles.ExternalApp));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
