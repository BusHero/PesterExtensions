function compress-directory([string]$dir, [string]$output) {
	$ddf = ".OPTION EXPLICIT
.Set CabinetNameTemplate=$output
.Set DiskDirectory1=.
.Set CompressionType=MSZIP
.Set Cabinet=on
.Set Compress=on
.Set CabinetFileCountThreshold=0
.Set FolderFileCountThreshold=0
.Set FolderSizeThreshold=0
.Set MaxCabinetSize=0
.Set MaxDiskFileCount=0
.Set MaxDiskSize=0
"
	$dirfullname = (Get-Item $dir).fullname
	$ddfpath = ($env:TEMP + '\temp.ddf')
	$ddf += (Get-ChildItem -Recurse $dir | Where-Object { !$_.PSIsContainer } | Select-Object -ExpandProperty FullName | ForEach-Object { '"' + $_ + '" "' + ($_ | Split-Path -Leaf) + '"' }) -join "`r`n"
	$ddf
	$ddf | Out-File -Encoding UTF8 $ddfpath
	makecab.exe /F $ddfpath
	Remove-Item $ddfpath
	Remove-Item setup.inf
	Remove-Item setup.rpt
}