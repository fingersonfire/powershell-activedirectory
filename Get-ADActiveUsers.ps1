#requires -version 4
<#
.SYNOPSIS
  List ever active users in a Active Directory.

.DESCRIPTION
  List ever active users inthe currect Active Directory domain.

.INPUTS
  None

.OUTPUTS
  List of users with the following properties : Name, Surname, SamAccountName, DistinguishedName

.NOTES
  Version:        1.0
  Author:         FingersOnFire
  Creation Date:  2019-05-02
  Purpose/Change: Initial script development

.EXAMPLE
  Simple Example
  
  Get-ADActiveUsers.ps1
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Any Global Declarations go here

#-----------------------------------------------------------[Functions]------------------------------------------------------------



#-----------------------------------------------------------[Execution]------------------------------------------------------------


$Users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "DisplayName" | Where-Object {$_.DisplayName -ne $null} | Select Name, Surname, SamAccountName, DistinguishedName

$Users