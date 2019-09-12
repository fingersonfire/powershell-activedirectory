#requires -version 4
<#
.SYNOPSIS
  Get password expiration dates

.DESCRIPTION
  List every users and the date their password will expire

.INPUTS
  None

.OUTPUTS
  List of users with the following properties : Name, Password Expiration Date

.NOTES
  Version:        1.0
  Author:         FingersOnFire
  Creation Date:  2019-06-18
  Purpose/Change: Initial script development
  Source : https://activedirectorypro.com/how-to-get-ad-users-password-expiration-date/

.EXAMPLE
  Simple Example
  
  Get-ADUsersPasswordExpirationDate.ps1
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

$Users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

$Users