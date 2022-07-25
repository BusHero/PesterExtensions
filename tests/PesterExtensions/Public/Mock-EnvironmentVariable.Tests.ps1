BeforeAll {
	Import-Module -Name PesterExtensions
	. "$(Get-ScriptPath -Path $PSCommandPath)"
	Remove-Module -Name PesterExtensions
}

Describe 'Mock an environment variable' {
	BeforeAll {
		$script:environmentVariable = "test$(New-Guid)"
		$script:InitialValue = 'Some value here and there'

	}
	It 'Code is called' {
		$script:environmentVariable = "test$(New-Guid)"
		$script:InitialValue = 'Some value here and there'
		$script:called = $false
		Mock-EnvironmentVariable -Variable $environmentVariable -Value $InitialValue {
			$script:called = $true
		}
		$script:called | Should -BeTrue
	}

	It 'Environment variable is set up' {
		$environmentVariable = "test$(New-Guid)"
		$InitialValue = 'Some value here and there'
		Test-Path -Path $environmentVariable | Should -BeFalse 
		Mock-EnvironmentVariable -Variable $environmentVariable -Value $InitialValue {
			$foo = Get-ChildItem -Path "env:${environmentVariable}"
			$foo.Value | Should -Be $InitialValue
		}
		Test-Path -Path $environmentVariable | Should -BeFalse 
	}

	Describe 'asd' {
		BeforeAll {
			$environmentVariable = "test$(New-Guid)"
			$InitialValue = 'Some value here and there'
			$UpdatedValue = 'Some updated value'
			New-Item -Path "env:${environmentVariable}" -Value $InitialValue
		}
		It 'Environment variable is set up' {
			Mock-EnvironmentVariable -Variable $environmentVariable -Value $UpdatedValue {
				$foo = Get-ChildItem -Path "env:${environmentVariable}"
				$foo.Value | Should -Be $UpdatedValue
			}
			$bar = Get-ChildItem -Path "env:${environmentVariable}"
			$bar.Value | Should -Be $InitialValue
		}
		AfterAll {
			Remove-Item -Path "env:${environmentVariable}" -Force -Recurse -ErrorAction Ignore
		}
	}
}