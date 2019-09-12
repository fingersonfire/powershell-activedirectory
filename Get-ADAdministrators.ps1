$Users = Get-ADGroupMember -Identity "Domain Admins" | Select DisplayName, SamAccountName, DistinguishedName

$Users