function Get-PDLogData
{
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({ test-path $_ })]
		[Alias('file', 'filepath')]
		[string]$Path
	)
	$rawdata = Get-Content $Path
	$PreProcessedData = $rawdata -split "<!seg!>"
	$lineNumbers = $PreProcessedData | Select-String -Pattern "<!start!>" | Select-Object LineNumber
	$PreProcessedData = $PreProcessedData.replace("<!start!>","")
	$lineNumbercounter = 0
	do
	{
		$postProcessedData = ($PreProcessedData[$($lineNumbers[$linenumbercounter].linenumber - 1) .. [int]$($lineNumbers[$linenumbercounter + 1].linenumber - 2)] -join "`r`n").trim()
		$attributes = ($PreProcessedData[$($lineNumbers[$linenumbercounter + 1].linenumber - 6) .. [int]$($lineNumbers[$linenumbercounter + 1].linenumber - 2)] -join "`r`n").trim() -split "`r`n"
		
		[psobject]@{
			"LogData" = $postProcessedData
			"Time" = $attributes[0].substring(1,$($attributes[0].length -2))
			"Date" = $attributes[1].substring(1, $($attributes[1].length - 2))
			"Level" = $attributes[2].substring(1, $($attributes[2].length - 2))
			"LineNumber" = $attributes[3].substring(1, $($attributes[3].length - 2))
			"Computer" = $attributes[4].substring(1, $($attributes[4].length - 2))
		}
		$lineNumbercounter++
	}
	while ($lineNumbercounter -le ($($linenumbers | Measure-Object).count - 1))
}