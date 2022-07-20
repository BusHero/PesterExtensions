function Get-ProjectRoot {
	[CmdletBinding()]
	param (
		# Some documentation here and there
		[Parameter()]
		[string]
		$Path
	)
	return 'C:\projects\project'
}