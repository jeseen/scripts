
Import-Module ActiveDirectory  

# Account info
$DisplayName =  "Service Account Display Name"
$OU = "OU=Service Accounts,OU=Navision,OU=Services,DC=ad,DC=fugro,DC=com"
$SAM = "SA-Service-Account"
$UPN = "SA-Serivce-Account@ad.fugro.com"
$Password = "*****"
$Server = "ad.fugro.com"

# Access Rule info
$AccountOU = "CN=$DisplayName,$OU"
$Identity = "NT AUTHORITY\SELF"
$Permission = "WriteProperty" # Enumeration item
$PermissionType = "Allow"
$PermissionInheritanceType = "None"
$ObjectTypeDescription = "Public Information" 
# List of all ObjectTypes: Get-ADObject -SearchBase ($(Get-ADRootDSE).ConfigurationNamingContext) -LDAPFilter "(&(objectclass=controlAccessRight)(rightsguid=*))" -Properties * | select DisplayName, rightsGuid

<# 
------------------------------
Create AD Service Account
------------------------------
#>

New-ADUser `
    -Name "$DisplayName" `
    -DisplayName "$DisplayName" `
    -SamAccountName $SAM `
    -UserPrincipalName $UPN `
    -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
    -Enabled $true `
    -Path "$OU" `
    -ChangePasswordAtLogon $false `
    -PasswordNeverExpires $true `
    -Server $Server             

<# 
------------------------------
Add the access rule
------------------------------
#>

# Prepare Access Rule
$SID = [System.Security.Principal.SecurityIdentifier] (New-Object System.Security.Principal.NTAccount($Identity)).Translate([System.Security.Principal.SecurityIdentifier]) 
$IdentityReference = [System.Security.Principal.IdentityReference] $([System.Security.Principal.SecurityIdentifier] (New-Object System.Security.Principal.NTAccount($Identity)).Translate([System.Security.Principal.SecurityIdentifier]))
$ADRights = [System.DirectoryServices.ActiveDirectoryRights] $Permission
$AclType = [System.Security.AccessControl.AccessControlType] $PermissionType
$InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] $PermissionInheritanceType
$ObjectTypeGUID = $(Get-ADObject -SearchBase ($(Get-ADRootDSE).ConfigurationNamingContext) -LDAPFilter "(&(objectclass=controlAccessRight)(rightsguid=*))" -Properties * | where displayName -EQ $ObjectTypeDescription | select rightsGuid).rightsGuid

# Get current Access Control List
$ACL = Get-Acl "AD:$AccountOU"

# Create new AD Access Rule
$AccessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $IdentityReference, $ADRights, $AclType, $ObjectTypeGUID, $InheritanceType

# Add the ACE to the ACL, then set the ACL to save the changes
$ACL.AddAccessRule($AccessRule) 
Set-Acl -AclObject $ACL -Path "AD:$AccountOU" 
       