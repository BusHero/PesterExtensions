BeforeAll {
	Import-Module -Name PesterExtensions -DisableNameChecking
	. "$(Get-ScriptPath -Path $PSCommandPath)"
	Remove-Module -Name PesterExtensions
}

Describe 'Mock an environment variable' {
	BeforeAll {
		$EnvironmentVariableName = "test$(New-Guid)"
		$InitialValue = 'Some value here and there'
	}
	
	It 'Code is called' {
		$script:called = $false
		Mock-EnvironmentVariable -Variable $environmentVariableName -Value $InitialValue {
			$script:called = $true
		}
		$called | Should -BeTrue
	}

	AfterAll {
		[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
	}
}

Describe 'Check env mocking' -ForEach @(
	@{ 
		InitialValue         = 'Initial Value';
		MockedValue          = 'Mocked Value'; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{ 
		InitialValue         = $null; 
		MockedValue          = 'Mocked Value'; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{ 
		InitialValue         = 'Initial Value'; 
		MockedValue          = $null; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { }
	}
	@{ 
		Script = { } 
	}
	@{
		InitialValue         = 'Initial Value';
		MockedValue          = 'Mocked Value'; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}
	@{
		InitialValue         = 'Initial Value';
		MockedValue          = $null; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}
	@{
		InitialValue         = $null;
		MockedValue          = 'Mocked Value'; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}
	@{
		InitialValue         = $null;
		MockedValue          = $null; 
		ValueInsideTheScript = $null;
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}
) {
	BeforeAll {
		$environmentVariableName = "test_$(New-Guid)"
		[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue)
	}
	It 'Test' {
		Mock-EnvironmentVariable `
			-Variable $environmentVariableName `
			-Value $MockedValue {
			[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $ValueInsideTheScript
			Invoke-Command -ScriptBlock $script -ArgumentList $environmentVariableName
		} 
		[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
	}
	AfterAll {
		[Environment]::SetEnvironmentVariable($environmentVariableName, $null)
	}
}

# Describe 'Check env mocking' -ForEach @(
# 	@{ 
# 		InitialValue         = 'Initial Value';
# 		MockedValue          = 'Mocked Value'; 
# 		ValueInsideTheScript = 'Mocked Value';
# 		TargetsToSet          = @([EnvironmentVariableTarget]::Process)
# 		TargetNotToSet       = ''
# 		Script               = { }
# 	}
# 	@{ 
# 		InitialValue         = $null; 
# 		MockedValue          = 'Mocked Value'; 
# 		ValueInsideTheScript = 'Mocked Value';
# 		Script               = { }
# 	}
# 	@{ 
# 		InitialValue         = 'Initial Value'; 
# 		MockedValue          = $null; 
# 		ValueInsideTheScript = 'Initial Value';
# 		Script               = { }
# 	}
# 	@{ 
# 		Script = { } 
# 	}
# 	@{
# 		InitialValue         = 'Initial Value';
# 		MockedValue          = 'Mocked Value'; 
# 		ValueInsideTheScript = 'Mocked Value';
# 		Script               = { 
# 			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
# 		}
# 	}
# 	@{
# 		InitialValue         = 'Initial Value';
# 		MockedValue          = $null; 
# 		ValueInsideTheScript = 'Initial Value';
# 		Script               = { 
# 			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
# 		}
# 	}
# 	@{
# 		InitialValue         = $null;
# 		MockedValue          = 'Mocked Value'; 
# 		ValueInsideTheScript = 'Mocked Value';
# 		Script               = { 
# 			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
# 		}
# 	}
# 	@{
# 		InitialValue         = $null;
# 		MockedValue          = $null; 
# 		ValueInsideTheScript = $null;
# 		Script               = { 
# 			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
# 		}
# 	}
# ) {
# 	BeforeAll {
# 		$environmentVariableName = "test_$(New-Guid)"
# 		[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue)
# 	}
# 	It 'Test' {
# 		Mock-EnvironmentVariable `
# 			-Variable $environmentVariableName `
# 			-Value $MockedValue {
# 			[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $ValueInsideTheScript
# 			Invoke-Command -ScriptBlock $script -ArgumentList $environmentVariableName
# 		} 
# 		[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
# 	}
# 	AfterAll {
# 		[Environment]::SetEnvironmentVariable($environmentVariableName, $null)
# 	}
# }



Describe 'Should throw' -ForEach @(
	@{
		InitialValue = 'Initial Value';
		MockedValue  = 'Mocked Value'; 
		Script       = { 
			throw 'Some exception here and there'
		}
	}
	@{
		InitialValue = 'Initial Value';
		MockedValue  = $null; 
		Script       = { 
			throw 'Some exception here and there'
		}
	}
	@{
		InitialValue = $null;
		MockedValue  = 'Mocked Value'; 
		Script       = { 
			throw 'Some exception here and there'
		}
	}
	@{
		InitialValue = $null;
		MockedValue  = $null; 
		Script       = { 
			throw 'Some exception here and there'
		}
	}
) {
	BeforeAll {
		$environmentVariableName = "test_$(New-Guid)"
		[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue)
	}
	It 'Test' {
		{ 
			Mock-EnvironmentVariable `
				-Variable $environmentVariableName `
				-Value $MockedValue {
				Invoke-Command -ScriptBlock $script -ArgumentList $environmentVariableName
			} 
		} | Should -Throw  
		[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
	}
	AfterAll {
		[Environment]::SetEnvironmentVariable($environmentVariableName, $null)
	}
}