# This script assumed the administrator has access to folder's ACL
# It will fail to retreive ACL is it cannot ready the main shared folder.  


Import-Module ActiveDirectory

$ADUsersWithHomeDrive = @()
$ExcludedUsers = @("NT AUTHORITY\SYSTEM", "NT AUTHORITY\SYSTEM", "CREATOR OWNER", "BUILTIN\Administrators")

$ACLReport = @();


Write-Host "Retreiving Users"
$ADUsers = Get-ADUser -filter * -properties scriptpath, homedrive, homedirectory


Write-Host "Analysing Users"
foreach($ADUser in $ADUsers){
    
    try{
    
        if(($ADUser.homedirectory -eq "") -or ($ADUser.homedirectory -eq $null)){
            Write-Host $ADUser.SamAccountName "- Home Directory not set" 
        }
        elseif(-not(Test-Path $ADUser.homedirectory -ErrorAction SilentlyContinue)){
            Write-Host $ADUser.SamAccountName "-" $ADUser.homedirectory "- Home Directory does not exists or access denied" 
        }
        else{
    
            $UserDriveData = @{
            "SamAccountName" = $ADUser.SamAccountName;
            "HomeDirectory" = $ADUser.homedirectory;}

            $ADUsersWithHomeDrive += (New-Object -TypeName PSObject -Property $UserDriveData)
        }
     }
     catch{
        Write-Host "[ERROR] user :" $ADUser.SamAccountName
     }   
}


Write-Host "Checking ACL on available Home Directories"
foreach ($User in $ADUsersWithHomeDrive){

    $FolderACLList = Get-Acl $User.HomeDirectory | Select -expand Access

    foreach ($FolderACL in $FolderACLList){
    
        if($ExcludedUsers -notcontains $FolderACL.IdentityReference){
    
           $ACLReportData = @{
                "FolderName" = $User.SamAccountName;
                "FolderFullName" = $User.HomeDirectory;
                "Identity" = $FolderACL.IdentityReference;
                "AccessRights" = $FolderACL.FileSystemRights;
           }

           $ACLReport += (New-Object -TypeName PSObject -Property $ACLReportData)

        }
    
    }

}

$ACLReport