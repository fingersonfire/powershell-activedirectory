Import-Module ActiveDirectory 

$OU = "*"

$MembershipList = Import-csv -path C:\Temp\ADGroupMemberships.csv

foreach($member in $MembershipList){
    $Group = Get-ADGroup -LDAPFilter "(Name=$member.GroupName)"

    if ($Group -eq $null) {
        Write-Host "Creation of group :" $member.GroupName
        
        # Creation of the group
        # $Group = New-ADGroup -Name $member.GroupName -GroupCategory Security -GroupScope Global -Path $OU
    }

    # Depending on the type 
    if($member.ObjectType -eq "user"){
        write-host "Trying to retreive user" $member.SamAccountName
        $User = Get-ADUser -Filter "SamAccountName -eq $member.SamAccountName" # -LDAPFilter "(sAMAccountName=$member.ObjectName)"

        if ($User -eq $null) {
            write-host "SKIPPING : User" $member.ObjectName "does not exist"
            
        }
        else{
            # Add user into grouo
            Write-Host "Adding user" $member.ObjectName "into group" $member.GroupName
        }

    }
    elseif($member.ObjectType -eq "group"){
        $Group = Get-ADGroup -Filter "SamAccountName -eq $member.SamAccountName" # -LDAPFilter "(sAMAccountName=$member.ObjectName)"

        if ($Group -eq $null) {
            write-host "SKIPPING : Group does not exist"
        }
        else{
            # Add group into group
            Write-Host "Adding group" $member.ObjectName "into group" $member.GroupName
        }

    }
    else{
        Write-Host "Wrong type for object" $member.ObjectName
    }
}