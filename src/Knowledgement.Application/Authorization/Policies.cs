namespace Knowledgement.Application.Authorization;

public static class Policies
{
    public const string ManageCategories = nameof(ManageCategories);
    public const string ReviewApprovals = nameof(ReviewApprovals);
    public const string CreateOfficialContent = nameof(CreateOfficialContent);
    public const string ReadPublishedKnowledge = nameof(ReadPublishedKnowledge);
    public const string ExternalKnowledgeAccess = nameof(ExternalKnowledgeAccess);
}
