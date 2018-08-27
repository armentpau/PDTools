<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.154
	 Created on:   	8/27/2018 3:26 PM
	 Created by:   	949237a
	 Organization: 	
	 Filename:     	Test-PDCsv.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

<#
	.SYNOPSIS
		A brief description of the Test-PDCSV function.
	
	.DESCRIPTION
		This function validates the contents of a CSV file
	
	.PARAMETER Path
		The CSV file to validate the contents of before using the file.
	
	.PARAMETER Rules
		A description of the Rules parameter.
	
	.PARAMETER AllowEmptyValue
		A description of the AllowEmptyValue parameter.
	
	.PARAMETER AllowHeadersWithoutRules
		A description of the AllowHeadersWithoutRules parameter.
	
	.EXAMPLE
		PS C:\> Test-PDCSV
	
	.NOTES
		Additional information about the function.
#>
function Test-PDCSV
{
	[CmdletBinding(SupportsShouldProcess = $false)]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateScript({ test-path $_ })]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('.csv')]
		[Alias('File', 'FilePath', 'csv', 'csvfile')]
		[string]$Path,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[hashtable]$Rules,
		[switch]$AllowEmptyValue,
		[switch]$AllowHeadersWithoutRules,
		[switch]$AllowRulesWithoutHeaders
	)
	
	BEGIN
	{
		$csvData = Import-Csv $Path
		$CSVHeader = $csvData[0] | Get-Member | where-object{ $_.MemberType -eq 'NoteProperty' }
		$headersNotInRules = [System.Collections.ArrayList]@()
		$headersNotInCSV = [System.Collections.ArrayList]@()
	}
	PROCESS
	{
		
		foreach ($item in $CSVHeader.name)
		{
			if ($Rules.$($item))
			{
				
			}
			else
			{
				$headersNotInRules.add($item)
			}
		}
		foreach ($item in $Rules.keys)
		{
			if ($CSVHeader.name -contains $item)
			{
				
			}
			else
			{
				$headersNotInCSV.add($item)
			}
		}
	}
	END
	{
		
	}
}

