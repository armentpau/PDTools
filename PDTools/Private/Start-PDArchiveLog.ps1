function Start-PDArchiveLog
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[int]$MaxLogs,
		[Parameter(Mandatory = $true)]
		[string]$ScriptName,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Path
	)
	
	$fileNotFoundFlag = 0
	$logFile = $null
	foreach ($item in (1 .. $($MaxLogs)))
	{
		if (-not (Test-Path "$($Path)\$($ScriptName)-$([int]($item)).log") -and $fileNotFoundFlag -eq 0)
		{
			$fileNotFoundFlag = 1
			$logFile = "$($Path)\$($ScriptName)-$([int]($item)).log"
		}
	}
	if ($fileNotFoundFlag -eq 0)
	{
		Rename-PDLog -MaxLogs $MaxLogs -ScriptName $ScriptName -Path $Path
		$logFile = Start-PDArchiveLog -MaxLogs $MaxLogs -ScriptName $ScriptName -Path $Path
	}
	return $logFile
}