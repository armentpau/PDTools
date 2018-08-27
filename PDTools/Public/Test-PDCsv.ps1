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
#todo
<#
rules options:
	present,absent
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
		[switch]$DisallowHeadersWithoutRules
	)
	
	BEGIN
	{
		$csvData = Import-Csv $Path
		$CSVHeader = $csvData[0] | Get-Member | where-object{ $_.MemberType -eq 'NoteProperty' }
		$headersNotInRules = [System.Collections.ArrayList]@()
		$missingHeaders = [System.Collections.arraylist]@()
		$rulesResults = [pscustomobject]@{
			"HeadersInRules" = $null
			"RulesAllPresent" = $null
			"AllValuesPresent" = $null
			"CSVValid" = $null
		}
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
				$headersNotInRules.add($item) | Out-Null
			}
		}
		
		foreach ($item in $Rules.keys)
		{
			if ($CSVHeader -contains $item)
			{		
			}
			else
			{
				$missingHeaders.add($item)
			}
		}
		
		if ((($headersNotInRules | measure-object).count -gt 0) -and $DisallowHeadersWithoutRules)
		{
			Write-Warning "The CSV file $($Path) has headers which are not defined in the rules. Testing all of the rules now."
			$rulesResults.HeadersInRules = $false
		}
		elseif(($headersNotInRules | measure-object).count -gt 0)
		{
			Write-Verbose "The CSV file $($Path) has headers which are not defined in the rules.  The switch DisallowHeadersWithoutRules is not given, therfore processing will continue as normal. Testing all of the rules now."
			$rulesResults.HeadersInRules = $false
		}
		else
		{
			Write-Verbose "All the headers in CSV file $($Path) are found in the rules.  Testing all of the rules now."
			$rulesResults.headersInRules = $true
		}
		
		if (($missingHeaders | measure-object).count -gt 0)
		{
			Write-Warning "The CSV file $($Path) has defined headers in the ruleset which are not in the csv file"
			$rulesResults.rulesallpresent = $false
		}
		else
		{
			Write-Verbose "All of the headers defined in the rules are present in the CSV file"
			$rulesResults.rulesallpresent = $true
		}
		
		if ($rulesResults.rulesallpresent -eq $false -or $rulesResults.headersinrules -eq $false)
		{
			$rulesResults.csvValid = $false
		}
		else
		{
			$rulesResults.csvValid = $true
		}
	}
	END
	{
		$rulesResults
	}
}

