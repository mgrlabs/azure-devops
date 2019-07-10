if ("$(Build.BuildNumber)" -notlike "*Release*") 
{
    # Take the agent OAuth token and convert it to base64
    $Auth = [convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(":$Env:SYSTEM_ACCESSTOKEN"))

    # Clone the Azure Repo using the basic auth
    git -c http.$(Release.Artifacts.GitSource.Repository.Uri).extraheader="AUTHORIZATION: basic $Auth" `
        clone "$(Release.Artifacts.GitSource.Repository.Uri)"

    cd $(Build.Repository.Name)

    # Configure git with the context of the user who initiated the pipeline, checkout the commit and tag then push the tag
    git config --global user.email "$(Release.RequestedForEmail)"
    git config --global user.name "$(Release.RequestedFor)"
    git checkout $(Release.Artifacts.BuildSource.SourceVersion)
    git tag -a $(Build.BuildNumber) -m $(Build.BuildNumber)
    git -c http.$(Release.Artifacts.GitSource.Repository.Uri).extraheader="AUTHORIZATION: basic $Auth" push origin --tag

    # Update the build number relating  to this to mark for release
    Write-Host "##vso[Build.UpdateBuildNumber]$(Build.BuildNumber)-Release"
} else {
    Write-Host "Build already tagged for release..."
}
