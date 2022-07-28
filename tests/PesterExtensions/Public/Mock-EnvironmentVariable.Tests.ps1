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
		Mock-EnvironmentVariable -Variable $environmentVariableName -Value $InitialValue -Fixture {
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
		Arguments            = @{
			Value = 'Mocked Value';
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{
			Value = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = $null; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{ }
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value'; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { }
	}
	@{ 
		MockedTargets = @([EnvironmentVariableTarget]::Process)
		Script        = { } 
	}
	@{
		Arguments            = @{
			Value = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}
	@{
		Arguments            = @{ }
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Initial Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}
	@{
		Arguments            = @{
			Value = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}
	@{
		Arguments            = @{ }
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = $null;
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value') 
		}
	}

	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = $null; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value'; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { }
	}
	@{ 
		Arguments     = @{
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets = @([EnvironmentVariableTarget]::User)
		Script        = { } 
	}
	@{
		Arguments            = @{
			Targets = @([EnvironmentVariableTarget]::User)
			Value   = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User') 
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Initial Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User')
		}
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = $null;
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User')
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = $null;
		ValueInsideTheScript = $null;
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User') 
		}
	}

	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = $null; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value'; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { }
	}
	@{ 
		Arguments     = @{
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		Script        = { } 
	}
	@{
		Arguments            = @{
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
			Value   = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User') 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'Process') 
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Initial Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User')
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'Process')
		}
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User')
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'Process')
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = $null;
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User') 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'Process') 
		}
	}
) {
	BeforeAll {
		$environmentVariableName = "test_$(New-Guid)"
		foreach	($target in $MockedTargets) {
			[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue, $target)
		}
	}
	It 'Test <MockedTargets>' {
		Mock-EnvironmentVariable -Variable $environmentVariableName @arguments -Fixture {
			foreach ($target in $MockedTargets) {
				[Environment]::GetEnvironmentVariable($environmentVariableName, $target) | Should -Be $ValueInsideTheScript
			}
			Invoke-Command -ScriptBlock $script -ArgumentList $environmentVariableName
		}
		foreach ($target in $MockedTargets) {
			[Environment]::GetEnvironmentVariable($environmentVariableName, $target) | Should -Be $InitialValue
		}
	}
	AfterAll {
		foreach ($target in $MockedTargets) {
			[Environment]::SetEnvironmentVariable($environmentVariableName, $null, $target)
		}
	}
}

Describe 'Check env mocking' -ForEach @(
	@{
		Arguments            = @{
			Value = 'Mocked Value';
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{
			Value = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = $null; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{ }
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value'; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { }
	}
	@{ 
		MockedTargets = @([EnvironmentVariableTarget]::Process)
		Script        = { } 
	}
	@{
		Arguments            = @{
			Value = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value') 
			} 
		}
	}
	@{
		Arguments            = @{ }
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Initial Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value') 
			} 
		}
	}
	@{
		Arguments            = @{
			Value = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value') 
			}
		}
	}
	@{
		Arguments            = @{ }
		MockedTargets        = @([EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = $null;
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value') 
			}
		}
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = $null; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value'; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { }
	}
	@{ 
		Arguments     = @{
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets = @([EnvironmentVariableTarget]::User)
		Script        = { } 
	}
	@{
		Arguments            = @{
			Targets = @([EnvironmentVariableTarget]::User)
			Value   = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'User') 
			}
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Initial Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'User') 
			}
		}
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = $null;
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'User') 
			}
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User)
		InitialValue         = $null;
		ValueInsideTheScript = $null;
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'User') 
			}
		}
	}

	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = $null; 
		ValueInsideTheScript = 'Mocked Value';
		Script               = { }
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value'; 
		ValueInsideTheScript = 'Initial Value';
		Script               = { }
	}
	@{ 
		Arguments     = @{
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		Script        = { } 
	}
	@{
		Arguments            = @{
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
			Value   = 'Mocked Value'
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'User') 
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'Process') 
			}
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = 'Initial Value';
		ValueInsideTheScript = 'Initial Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'User')
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'Process')
			}
		}
	}
	@{
		Arguments            = @{
			Value   = 'Mocked Value';
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = 'Mocked Value';
		Script               = { 
			foreach ($variable in $args[0]) {
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'User')
				[Environment]::SetEnvironmentVariable($variable, 'Some updated value', 'Process')
			}
		}
	}
	@{
		Arguments            = @{ 
			Targets = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		}
		MockedTargets        = @([EnvironmentVariableTarget]::User, [EnvironmentVariableTarget]::Process)
		InitialValue         = $null;
		ValueInsideTheScript = $null;
		Script               = { 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'User') 
			[Environment]::SetEnvironmentVariable($args[0], 'Some updated value', 'Process') 
		}
	}
) {
	BeforeAll {
		$variables = @(
			"test_$(New-Guid)"
			"test_$(New-Guid)"
			"test_$(New-Guid)"
		)
		foreach	($target in $MockedTargets) {
			foreach ($environmentVariableName in $variables) {
				[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue, $target)
			}
		}
	}
	It 'Test <MockedTargets>' {
		Mock-EnvironmentVariable -Variable $variables @arguments -Fixture {
			foreach ($target in $MockedTargets) {
				foreach ($environmentVariableName in $variables) {
					[Environment]::GetEnvironmentVariable($environmentVariableName, $target) | Should -Be $ValueInsideTheScript
				}
			}
			Invoke-Command -ScriptBlock $script -ArgumentList $variables
		}
		foreach ($target in $MockedTargets) {
			foreach ($environmentVariableName in $variables) {
				[Environment]::GetEnvironmentVariable($environmentVariableName, $target) | Should -Be $InitialValue
			}
		}
	}
	AfterAll {
		foreach ($target in $MockedTargets) {
			foreach ($environmentVariableName in $variables) {
				[Environment]::SetEnvironmentVariable($environmentVariableName, $null, $target)
			}
		}
	}
}


Describe 'Should throw' -ForEach @(
	@{
		InitialValue = 'Initial Value';
		MockedValue  = 'Mocked Value';
	}
	@{
		InitialValue = 'Initial Value';
		MockedValue  = $null; 
	}
	@{
		InitialValue = $null;
		MockedValue  = 'Mocked Value'; 
	}
	@{
		InitialValue = $null;
		MockedValue  = $null; 
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
				throw 'Some exception here and there'
			} 
		} | Should -Throw -ExpectedMessage 'Some exception here and there'
		[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
	}
	AfterAll {
		[Environment]::SetEnvironmentVariable($environmentVariableName, $null)
	}
}