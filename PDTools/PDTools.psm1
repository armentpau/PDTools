<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.154
	 Created on:   	8/27/2018 3:20 PM
	 Created by:   	949237a
	 Organization: 	
	 Filename:     	PDTools.psm1
	-------------------------------------------------------------------------
	 Module Name: PDTools
	===========================================================================
#>
Add-Type @"
public struct PDCSVVerification{
	public string
}
"@
$scriptPath = Split-Path $MyInvocation.MyCommand.Path

try
{
	Get-ChildItem "$scriptPath\Public" -filter *.ps1 | Select-Object -ExpandProperty FullName | ForEach-Object{
		$function = Split-Path $_ -Leaf
		. $_
	}
}
catch
{
	Write-Warning "There was an error loading $($function) and the error is $($psitem.tostring())"
	exit
}

