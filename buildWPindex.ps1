
Function Build_Index
{
	param
	(
		[Parameter(Mandatory=$True,Position=1)]
		[ValidateSet("plugins","themes")]
		[string]$Index
	)
	#test
	#instatiate arraylist to contain all plugins/themes in loop
	[System.Collections.ArrayList]$extractionsArray = @()
	#count to iterate through pages via URI
	$count = 1
	#flag for loop exit
	$nullPage = $False
	Do
	{
		#retrieve html
		$html = Invoke-WebRequest -Uri https://wpvulndb.com/$($Index)?page=$($count)
		
		#extract from the links all plugins or themes
		$extractions = ($html.links.href | Select-String -Pattern "/$($Index)/") | % {$_.tostring().split('/')[2]}
		
		#if there are no plugins or themes (last page), set exit flag true to exit loop
		If ($extractions -eq $Null)
		{
			$nullPage = $True
		}
		#add the extracted plugins/themes to the arraylist. Out-null because adding items to array has terminal output. increment page count by one.
		Else
		{
			Foreach ($link in $extractions)
			{
				$extractionsArray.Add($link) | Out-Null
			}
			$count++
		}
	}
	Until ($nullpage -eq $True)

	# take arraylist and sort alphabetically removing duplicates. output to text file.
	$extractionsArray | Sort-Object -Unique | Out-File -Path #***WHERE?***

}