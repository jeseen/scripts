#Import-Module ActiveDirectory

Set-Location AD:

# Set OU of the account
$account = "CN=Service Account NAV Kernel NAS FOST - Production,OU=Service Accounts,OU=Navision,OU=Services,DC=ad,DC=fugro,DC=com"

# Get complete ACL list of the account
$acl = get-acl "AD:$account"

# To get access right of the OU
#$acl.Access
# Get access list of the specific objecttype
#$acl.Access | where ObjectType -eq 'e48d0154-bcf8-11d1-8702-00c04fb96050' | Format-Table -AutoSize

# Get the SID object of NT
$self = 'NT AUTHORITY\SELF'
$SID = [System.Security.Principal.SecurityIdentifier] (New-Object System.Security.Principal.NTAccount($self)).Translate([System.Security.Principal.SecurityIdentifier]) 
# $user = get-ADUser $account
# $sid = $user.SID

# Create a new access control entry to allow access to the OU
$identity = [System.Security.Principal.IdentityReference] $sid
$adRights = [System.DirectoryServices.ActiveDirectoryRights] "WriteProperty"
$type = [System.Security.AccessControl.AccessControlType] "Allow"
$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "None"
# Retrieve objectType GUID from the list of GUIDS
$objectTypeDescription = 'Public Information'
$rootdse = Get-ADRootDSE
$adObjectControlAccessRightGuids = Get-ADObject -SearchBase ($rootdse.ConfigurationNamingContext) -LDAPFilter "(&(objectclass=controlAccessRight)(rightsguid=*))" -Properties displayName, rightsGuid `
    | where displayName -eq $objectTypeDescription `
    | select rightsGuid
$objectType = $adObjectControlAccessRightGuids.rightsGuid


# Create new AD Access Rule
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $identity, $adRights, $type, $objectType, $inheritanceType

# Add the ACE to the ACL, then set the ACL to save the changes
$acl.AddAccessRule($ace) 
Set-acl -aclobject $acl -path "AD:$account" 

