function Out-PDLog
{
	[CmdletBinding(DefaultParameterSetName = 'Default')]
	param
	(
		[Parameter(ParameterSetName = 'Default',
				   Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $false,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$Message,
		[Parameter(Mandatory = $true)]
		[Alias('FilePath', 'File')]
		[string]$Path,
		[Parameter(ParameterSetName = 'Default')]
		[string]$ScriptName,
		[Parameter(ParameterSetName = 'Default')]
		[ValidateSet('Information', 'Warning', 'Error', 'Debug', 'Verbose', IgnoreCase = $true)]
		[string]$Level = 'Information',
		[Parameter(ParameterSetName = 'Start')]
		[switch]$Start,
		[Parameter(ParameterSetName = 'End')]
		[switch]$End,
		[switch]$AppendUserName,
		[switch]$AppendComputerName,
		[switch]$Mirror,
		[int]$MaxLogSize = 2 * 1MB,
		[int]$MaxLogs = 5
	)	
	BEGIN
	{
		if (-not (Test-Path "$($Path)"))
		{
			New-Item -Path "$($Path)" -ItemType directory
		}
		
		if ($PSBoundParameters.ContainsKey("ScriptName"))
		{
			Write-Verbose "The paramter ScriptName contains the value $($ScriptName)"
		}
		else
		{
			if ((Get-Host).Version.Major -eq 2)
			{
				try
				{
					Write-Verbose "PowerShell Version 2 detected.  This version is depreciated.  You should update your version of PowerShell.  Future versions of this function may not work with Powershell V2."
					$scriptName = (Split-Path $MyInvocation.ScriptName -Leaf).tolower().Replace('.ps1', '')
					Write-Verbose "Setting the value of scriptname value to $($ScriptName)"
				}
				catch
				{
					Write-Warning "Unable to determine script name.  Defaulting to Unknown."
					$scriptName = "Unknown"
				}
			}
			elseif ((get-host).Version.Major -eq 1)
			{
				Write-Warning "Version 1 of Powershell is not supported by this function.  Exiting function."
				exit
			}
			else #version greater than 2
			{
				Write-Verbose "PowerShell version detected is $((Get-Host).Version.Major).  Attempting to determine the script name."
				try
				{
					$scriptName = (Split-Path $MyInvocation.PSCommandPath -Leaf).tolower().Replace('.ps1', '')
					Write-Verbose "Setting scriptname variable to $($ScriptName)"
				}
				catch
				{
					Write-Warning "Unable to determine script name.  Defaulting to Unknown."
					$scriptName = "Unknown"
				}
			}
		}
		
		if ($ScriptName -eq "Unknown" -and ((get-process -Id $pid).name -ne "Powershell"))
		{
			Write-Verbose "The script is a packaged EXE.  Attempting to determine the name of the EXE."
			$ScriptName = (Get-Process -Id $pid).name
		}
		if ($ScriptName -eq "Unknown")
		{
			Write-Warning "The script name is unknown.  Unable to determine the script name automatically."
		}
		
		if ($AppendUserName)
		{
			$ScriptName = "$($ScriptName)_$($env:USERNAME)"
		}
		if ($AppendUserName)
		{
			$ScriptName = "$($ScriptName)_$($env:COMPUTERNAME)"
		}
		
		$fullPath = "$($path)\$($ScriptName).pdl"
		$newFileHeader = @("239", "187", "191")
	}
	PROCESS
	{
		
		if ($Start -or $End)
		{
			if (-not (Test-Path $fullPath))
			{
				New-Item -Path $fullPath -ItemType file
				[io.file]::WriteAllBytes($fullPath,$newFileHeader)
			}
			if ($start)
			{
				if ([double](Get-Item "$($Path)\$($ScriptName).log").length -gt $maxlogsize)
				{
					$counter = 0
					
				}
			}
		}
	}
	END
	{
		
	}
}