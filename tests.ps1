param(
	[int]$RunNumber
)

Invoke-Pester -Container @(New-PesterContainer -Path . -Data @{ Revision = $RunNumber })