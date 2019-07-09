$Auth = [convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(":$Env:SYSTEM_ACCESSTOKEN"))
$azDevopsOrg = "vibrato-mark"
$azDevopsProject = "New%20Signature"

$RepoUrl = "https://$azDevopsOrg@dev.azure.com/$azDevopsOrg/$azDevopsProject/_git/$(Build.Repository.Name)"

git -c http.$RepoUrl.extraheader="AUTHORIZATION: basic $Auth" clone $RepoUrl
