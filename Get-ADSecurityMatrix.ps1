#requires -version 4
<#
.SYNOPSIS
  AD Permission Security Matrix
.DESCRIPTION
  Create a data matrix showing users and groups memberships to a list of groups

.SOURCE
  https://gist.github.com/irwins/b5c7972521d70511c55e62d39e40e571

.INPUTS
  None

.OUTPUTS
  GridView of Permissions

.NOTES
  Version:        1.0
  Author:         Irwin Strachan
  Creation Date:  Oct 12, 2016
  Purpose/Change: Initial script development

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  #Script parameters go here
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$Groups = @(
   'APP-MS Outlook','APP-Adobe Reader','APP-MS Word',
   'APP-MS Powerpoint','APP-MS Excel','APP-MS Visio Viewer','Rol-Consultant'
)

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Convert-ArrayToHash($a){
    begin { $hash = @{} }
    process { $hash[$_] = $null }
    end { return $hash }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$template = [PSCustomObject]([Ordered]@{UserID=$null} + $($Groups | Convert-ArrayToHash))
$arrMatrix = @()

#Get current Group memberships
$SnapshotADGroupMembers = @{}

$Groups |
ForEach-Object{
   $SnapshotADGroupMembers.$($_) = Get-ADGroupMember -Identity $_ | Select-Object -ExpandProperty SamAccountName
}

$Groups |
ForEach-Object{
   $GroupName = $_
   if($SnapshotADGroupMembers.$_){
      $SnapshotADGroupMembers.$_ |
      ForEach-Object{
         if($arrMatrix.Count -eq 0) {
            $newItem = $template.PSObject.Copy()
            $newItem.UserID = $_
            $newItem.$GroupName = '1'
            $arrMatrix += $newItem
         }
         else{
            if($arrMatrix.UserID.contains($($_))){
               $index = [array]::IndexOf($arrMatrix.UserID, $_)
               $arrMatrix[$index].$GroupName = '1'
            }
            else{
               $newItem = $template.PSObject.Copy()
               $newItem.UserID = $_
               $newItem.$GroupName = '1'
               $arrMatrix += $newItem
            }
         }
      }
   }
}

$arrMatrix |
Select-Object 'UserID', 'APP-MS Outlook','APP-Adobe Reader','APP-MS Word',
   'APP-MS Powerpoint','APP-MS Excel','APP-MS Visio Viewer','Rol-Consultant' |
Out-GridView
