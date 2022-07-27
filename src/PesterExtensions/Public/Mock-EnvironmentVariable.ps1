function Restore {
	param (
		[string]
		$Variable,
		
		[EnvironmentVariableTarget[]]
		$Targets,

		[hashtable]
		$Backup
	)
	foreach ($target in $targets) {
		[Environment]::SetEnvironmentVariable($Variable, $Backup[$target], $target)
	}
}

function Set-Values {
	param (
		[string]
		$Variable,
		
		[EnvironmentVariableTarget[]]
		$Targets,

		[string]
		$value
	)
	$Backup = @{}
	
	foreach ($target in $Targets) {
		$OriginalValue = [Environment]::GetEnvironmentVariable($Variable, $target)
		$Backup.Add($target, $OriginalValue)
		if ($Value) {
			[Environment]::SetEnvironmentVariable($Variable, $Value, $target)
		}
	}
	
	return $Backup
}


function Mock-EnvironmentVariable {
	param (
		[parameter(Mandatory = $true)]
		[string]
		$Variable,
		
		[Parameter(Mandatory = $true)]
		[ScriptBlock]
		$Fixture,

		[Parameter(Mandatory = $false)]
		[string]
		$Value,

		[Parameter(Mandatory = $false)]
		[EnvironmentVariableTarget[]]
		$Targets = @([EnvironmentVariableTarget]::Process)
	)

	$Backup = Set-Values -Variable $Variable -Targets $Targets -value $Value

	try { Invoke-Command -ScriptBlock $Fixture }
	catch { throw $_ }
	finally { Restore -Variable $Variable -Targets $Targets -Backup $Backup }

	<#
	.PARAMETER Variable
	The environment variable to mock.

	.PARAMETER Value
	The initial value of the mocked environment variable.

	.PARAMETER Fixture
	The code to be executed.

	.PARAMETER Targets
	Specifies that user environment variable should also be managed.
	#>
}