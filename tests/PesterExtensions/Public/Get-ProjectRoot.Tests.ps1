BeforeAll {
	Import-Module -Name PesterExtensions
	. "$(Get-ScriptPath -Path $PSCommandPath -Extension Script)"
	Remove-Module -Name PesterExtensions
}

Describe 'Get project root' {
	Context '|"<path>" ==> "<projectroot>"|' -ForEach @(
		@{ Path = '\projects\project1\foo.ps1'; ProjectRoot = '\projects\project1' }
		@{ Path = '\projects\project2\foo.ps1'; ProjectRoot = '\projects\project2' }
		@{ Path = '\projects\'; ProjectRoot = '\projects' }
	) {
		BeforeAll {
			$Path = Join-Path -Path $TestDrive -ChildPath $Path
			$ProjectRoot = Join-Path -Path $TestDrive -ChildPath $ProjectRoot
			New-Item -Path $path `
				-ItemType File `
				-Force
		}
		
		It 'asd' {
			Get-ProjectRoot -Path $Path | Should -Be $ProjectRoot
		}

		AfterAll {
			Remove-Item -Path $path `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}
}

Describe 'Specify root folder name' -ForEach @(
	@{ Path = 'foo\bar\baz'; Name = 'foo'; ProjectRoot = 'foo' }
	@{ Path = 'foo\bar\baz'; Name = 'bar'; ProjectRoot = 'foo\bar' }
	@{ Path = 'Projects\foo\bar\baz'; Name = 'bar'; ProjectRoot = 'projects\foo\bar' }
) {
	BeforeAll {
		$Path = "${TestDrive}\${Path}"
		$ProjectRoot = "${TestDrive}\${ProjectRoot}"
		New-Item -Path $Path `
			-ItemType File `
			-Force
	}

	It 'foo' {
		Get-ProjectRoot -Path $path -Name $name | Should -Be $ProjectRoot
	}

	AfterAll {
		Remove-Item -Path $Path `
			-Recurse `
			-Force `
			-ErrorAction Ignore
	}
}

Describe 'Specify projects root name' {
	Context '|"<path>" ==> "<projectroot>"|' -ForEach @(
		@{ Path = '\foo\project1\foo.ps1'; ProjectsRootName = 'foo'; ProjectRoot = '\foo\project1' }
		@{ Path = '\bar\project2\foo.ps1'; ProjectsRootName = 'bar'; ProjectRoot = '\bar\project2' }
		@{ Path = '\foo\project2\foo.ps1'; ProjectsRootName = 'foo', 'bar'; ProjectRoot = '\foo\project2' }
		@{ Path = '\bar\project2\foo.ps1'; ProjectsRootName = 'foo', 'bar'; ProjectRoot = '\bar\project2' }
	) {
		BeforeAll {
			$Path = Join-Path -Path $TestDrive -ChildPath $Path
			$ProjectRoot = Join-Path -Path $TestDrive -ChildPath $ProjectRoot
			New-Item -Path $path `
				-ItemType File `
				-Force
		}
		It 'asd' {
			Get-ProjectRoot -Path $Path -ProjectsRoot $ProjectsRootName | Should -Be $ProjectRoot
		}
		AfterAll {
			Remove-Item -Path $path `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}
}

Describe 'Fail' {
	Context 'invalid path' {
		BeforeAll {
			$NonExistingFile = "${TestDrive}\projects\this\path\does\not\exists"
			
			# Ensure that the file does not exist
			Remove-Item -Path $NonExistingFile `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
		It 'Fail' {
			{ Get-ProjectRoot -Path $NonExistingFile } | Should -Throw -Because "'${NonExistingFile}' does not exist"
		}
	}

	Context 'No root folder was found' -ForEach @(
		@{Parameters = @{ Path = '\foo\bar\baz' } }
		@{Parameters = @{ Path = '\projects\bar\baz'; ProjectsRoot = 'foo' } }
	) {
		BeforeAll {
			$Parameters.Path = "${TestDrive}$($Parameters.Path)"

			# Ensure new folder
			Remove-Item -Path $Parameters.Path `
				-Force `
				-Recurse `
				-ErrorAction Ignore

			New-Item -Path $Parameters.Path -Force
		}

		It 'Throw' {
			{ Get-ProjectRoot @Parameters } | Should -Throw -ExpectedMessage 'The project root could not be identified'
		}

		AfterAll {
			Remove-Item `
				-Path $Parameters.Path `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}
}