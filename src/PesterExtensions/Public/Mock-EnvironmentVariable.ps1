function Set-EnvironmentVariable {
	param (
		[string]
		$Variable,

		[string]
		$Value,

		[EnvironmentVariableTarget]
		$Target
	)
	if ($Target -eq [System.EnvironmentVariableTarget]::Process) {
		[System.Environment]::SetEnvironmentVariable($Variable, $value, 'Process')
	}
	elseif ($Target -eq [System.EnvironmentVariableTarget]::User) {
		if ($Value) {
			New-ItemProperty -Path 'HKCU:\Environment' -Name $Variable -Value $Value -Force > $null
		}
		else {
			Remove-ItemProperty -Path 'HKCU:\Environment' -Name $Variable -ErrorAction Ignore
		}
	}
}

function Restore {
	param (
		[hashtable]
		$Backup
	)
	foreach ($variable in $Backup.Keys) {
		foreach ($target in $Backup.$variable.Keys) {
			Set-EnvironmentVariable -Variable $variable -Value $Backup.$variable.$target -Target $target
		}
	}
}

function Backup {
	param (
		[string[]]
		$Variables,
		
		[EnvironmentVariableTarget[]]
		$Targets,

		[string]
		$value
	)
	$Backup = @{}

	foreach ($variable in $Variables) {
		$VariableBackup = @{}
		foreach ($target in $Targets) {
			$OriginalValue = [Environment]::GetEnvironmentVariable($variable, $target)
			$VariableBackup.Add($target, $OriginalValue)
			if ($Value) {
				Set-EnvironmentVariable -Variable $variable -Value $value -Target $target
			}
		}
		$Backup.Add($variable, $VariableBackup)
	}
	
	return $Backup
}


function Mock-EnvironmentVariable {
	param (
		[parameter(Mandatory = $true)]
		[string[]]
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

	$Backup = Backup -Variables $Variable -Targets $Targets -value $Value

	try { Invoke-Command -ScriptBlock $Fixture }
	finally { Restore -Backup $Backup }

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