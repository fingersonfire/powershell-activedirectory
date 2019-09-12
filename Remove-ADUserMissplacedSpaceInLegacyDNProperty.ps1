#
# Removes missplaced spaces in legacyExchangeDN value
#
# From :    legacyExchangeDN : /o=  First Organization/ou=Exchange
# To :      legacyExchangeDN : /o=First Organization/ou=Exchange
# Source :  https://stackoverflow.com/questions/47166250/replace-legacyexchangedn-value-in-adsi-via-powershell
#

$Users = Get-ADUser -Filter { legacyExchangeDN -like '*/o= *' } -Properties @('name','EmailAddress','legacyExchangeDN')
ForEach ($User in $Users)
{
    $Replace = $User.legacyExchangeDN -replace '/o=\s','/o='
    Set-ADUser -Identity $User -Replace @{ legacyExchangeDN = $Replace }

    Write-Host ('Updated "{0}" ({1}) to "{2}"' -f
        @($User.name,$User.EmailAddress,$Replace))
}