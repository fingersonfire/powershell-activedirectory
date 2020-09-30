#requires -version 4
<#
.SYNOPSIS
  Recreate an OU structure based on another 

.DESCRIPTION
  Read the OU and it structure and recreates a copy of it
  Source : https://www.it-connect.fr/active-directory-comment-dupliquer-plusieurs-ous/

.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None>

.NOTES
  Version:        1.0
  Author:         Florian B, FingersOnFire
  Creation Date:  2020-09-30
  Purpose/Change: Initial script development

.EXAMPLE
  <Example explanation goes here>
  
  <Example goes here. Repeat this attribute for more than one example>
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

# Target Domain Controler
$DC = "SRV-ADDS-01.it-connect.local"

# OU to duplicate
$OUSource = "OU=Paris,OU=Agences,DC=IT-CONNECT,DC=LOCAL"

# New OU locations 
$RootNewOU = "OU=Agences,DC=IT-CONNECT,DC=LOCAL"

# List of the OU to be created
$RootDestList = @("Caen","Rouen")

#-----------------------------------------------------------[Functions]------------------------------------------------------------



#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Get OU structure
$GetOUStructure = Get-ADOrganizationalUnit -SearchBase $OUSource -Filter * -SearchScope Subtree -Server $DC

# Get Source DN and the name of the lowest OU in the structure
$BaseDNSource = $GetOUStructure.distinguishedname[0]

# Go through the list of new OU to be created
Foreach($RootDest in $RootDestList){

  # Recreate OU structure
  Foreach($OU in $GetOUStructure){

    if($OU.DistinguishedName -eq $BaseDNSource){

      $RootSource = (($BaseDNSource).Split(",")[0]).Split("=")[1]
      $BaseDNDest = $GetOUStructure.distinguishedname[0] -replace $RootSource , $RootDest

      # Create Root structure
      New-ADOrganizationalUnit -Name $RootDest -Path $RootNewOU -Server $DC
      Write-Host -f Yellow "Create ROOT DN '$RootDest' under : $RootNewOU"

    }else{

      if(Get-ADOrganizationalUnit -Identity "OU=$RootDest,$RootNewOU" -ErrorAction SilentlyContinue -Server $DC){

        $DN = $OU.distinguishedname.replace($BaseDNSource,$BaseDNDest)
        $ParentDN = $DN.trimstart($DN.split(',')[0]).trim(",")
        $OUName = $OU.name

        New-ADOrganizationalUnit -Name $OUName -Path $ParentDN -Server $DC
        Write-Host -f Cyan "Create OU '$OUName' under : $ParentDN"

      }else{

        Write-Host -f Red "Error ! Root $RootDest does not exist under : $RootNewOU"
      }
    }
  }
}
