param(
	[parameter(Mandatory)]
	[version]
	$CurrentVersion,

	[parameter(Mandatory = $false)]
	[version[]]
	$excludeVersions
)

$versions = @()

for ($major = 0; $major -lt 11; $major++) {
	for ($minor = 0; $minor -lt 11; $minor++) {
		for ($patch = 0; $patch -lt 11; $patch++) {
			$versions += "$major.$minor.$patch"
		}
	}
}

$versions = $versions | Where-Object { !($excludeVersions -contains $_) }

foreach	($foo in $exclude) {
	if ($versions -contains $foo) {
		Write-Error "$foo is not excluded" -ErrorAction Stop
	}
}

foreach ($version in $versions) {
	"@{ Current = '${CurrentVersion}'; Next = '${version}' }"
}
