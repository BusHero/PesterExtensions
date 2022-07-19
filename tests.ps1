param(
	[int]$RunNumber
)

$container0 = New-PesterContainer `
	-Path '.\tests\PesterExtensions\Public'

$container1 = New-PesterContainer `
	-Path '.\tests\PesterExtensions\PesterExtensions.Tests.ps1' `
	-Data @{ Revision = $RunNumber }


Invoke-Pester -Container $container0 
Invoke-Pester -Container $container1 