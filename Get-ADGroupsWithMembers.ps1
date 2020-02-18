Import-Module ActiveDirectory 

$OU = "*"
$groups = Get-ADgroup -Filter * -SearchBase $OU

$memberships = @()

foreach($group in $groups){
    try{
        $members = Get-ADGroupMember -Identity $group

        foreach($member in $members){
            $memberships += [PSCustomObject]@{
            GroupName = $group.Name
            ObjectType = $member.ObjectClass
            ObjectName = $member.Name
            SamAccountName = $member.SamAccountName
            }   
        }

    }
    catch{
        Write-Host "Issue when retreiving members of" $group.Name
    }

}

$memberships | Export-csv -path C:\Temp\ADGroupMemberships.csv -NoTypeInformation