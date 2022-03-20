#Author: Harish Bezawada
#Contact: hBezawada@crimson.ua.edut
#!/bin/bash

Echo "Starting back up"

$user = $env:UserName
Echo "UserName is $user"

## User Change
Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgTitle = "Current User"
$msgBody = "Backing up for user: $user
"
$msgButton = 'YesNo'
$msgImage = 'Information'
$sUser = [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)
Write-Host "The user clicked: $sUser"

switch  ($sUser) {

  'Yes' {
	#Continue
  }

  'No' {
	get-localuser -Wait - PassThru
 	$newUser = Read-Host -Prompt 'Username to process'
	if ($newUser) {
	    Write-Host "Continuing with the username: $newUser"
	    $user = $newUser
	} else {
 	   Write-Warning -Message "No user name provided. Continuing with the $user"
	}
  }

  }



## Start Backup Process

#Back Up Path
New-Item -Path "c:\" -Name "BackedUp" -Itemtype "directory"

#Microsoft Edge Data - Back up
Echo "Backing up Microsoft Edge data"
Copy-Item "c:\users\$user\AppData\local\Microsoft\edge\user data" -Destination "C:\BackedUp\MicrosoftEdge" -Recurse
Echo "Done"

Echo "--------------------------------------------------"

#Chrome Data - Back up
Echo "Backing up Chrome data"
#Chrome - Back up
Copy-Item "c:\users\$user\AppData\local\Google\Chrome\user data" -Destination "C:\BackedUp\Chrome" -Recurse 
Echo "Done"

#Process Result
Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgTitle = "Task Complete"
$msgBody = " Errors Faced:
$error
"
$msgButton = 'Ok'
$msgImage = 'Information'
[System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)
 