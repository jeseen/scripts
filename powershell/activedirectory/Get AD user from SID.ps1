$objSID = New-Object System.Security.Principal.SecurityIdentifier ("S-1-5-21-1542218267-3440723709-3642647908-20194")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value
