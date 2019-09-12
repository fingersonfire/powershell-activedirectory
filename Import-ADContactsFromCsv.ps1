# Source : MigrationWiz

$importFile = ""
$ouName = ""

&{
	Write-Host -Foreground White "Locating Contacts OU" $ouName "..."
	$ldap = "LDAP://RootDse"
	$rootDse = [adsi] $ldap
	$defaultNamingContext = $rootDse.defaultNamingContext
	$ldap = "LDAP://OU=" + $ouName + "," + $defaultNamingContext
	$ou = [adsi] $ldap
	if($ou.Name -ne $null)
	{
		Write-Host -Foreground Yellow "  Contacts OU already exists"
	}
	else
	{
		Write-Host -Foreground White "  Creating contacts OU"

		$ldap = "LDAP://" + $defaultNamingContext
		$domainRoot = [adsi] $ldap
		$ou = $domainRoot.Create("OrganizationalUnit", "OU=" + $ouName)
		$ou.SetInfo()
	}

    $contacts = import-csv $importFile | select *
    foreach($contact in $contacts)
    {
        $c								= $contact.'c'
	   $alias							= $contact.'First Name' + $contact.'Last Name'
	   $alias 							= $alias -replace '[^a-zA-Z0-9]', '' 
        $company						= $contact.'Company'
        $department						= $contact.'Department'
        $displayName					= $contact.'First Name' + " " + $contact.'Last Name'
        $displayNamePrintable			= $contact.'First Name' + " " + $contact.'Last Name'
        $extensionAttribute1			= $contact.'extensionAttribute1'
        $extensionAttribute2			= $contact.'extensionAttribute2'
        $extensionAttribute3			= $contact.'extensionAttribute3'
        $extensionAttribute4			= $contact.'extensionAttribute4'
        $extensionAttribute5			= $contact.'extensionAttribute5'
        $extensionAttribute6			= $contact.'extensionAttribute6'
        $extensionAttribute7			= $contact.'extensionAttribute7'
        $extensionAttribute8			= $contact.'extensionAttribute8'
        $extensionAttribute9			= $contact.'extensionAttribute9'
        $extensionAttribute10			= $contact.'extensionAttribute10'
        $extensionAttribute11			= $contact.'extensionAttribute11'
        $extensionAttribute12			= $contact.'extensionAttribute12'
        $extensionAttribute13			= $contact.'extensionAttribute13'
        $extensionAttribute14			= $contact.'extensionAttribute14'
        $extensionAttribute15			= $contact.'extensionAttribute15'
        $facsimileTelephoneNumber		= $contact.'facsimileTelephoneNumber'
        $givenName						= $contact.'Last Name'
        $homePhone						= $contact.'Home Phone'
        $initials						= $contact.'initials'
        $info							= $contact.'info'
        $l								= $contact.'l'
        $mailNickname					= $contact.'E-mail Address'
        $mobile							= $contact.'Mobile Phone'
        $otherFacsimileTelephoneNumber	= $contact.'otherFacsimileTelephoneNumber'
        $otherHomePhone					= $contact.'otherHomePhone'
        $otherTelephone					= $contact.'otherTelephone'
        $pager							= $contact.'pager'
		$physicalDeliveryOfficeName		= $contact.'physicalDeliveryOfficeName'
		$postalCode						= $contact.'Business Postal Code'
		$postOfficeBox					= $contact.'postOfficeBox'
        $sn								= $contact.'sn'
        $st								= $contact.'st'
        $streetAddress					= $contact.'Business Street'
        $targetAddress					= $contact.'E-mail Address'
        $telephoneNumber				= $contact.'telephoneNumber'
		$title							= $contact.'Title'
		$wWWHomePage					= $contact.'Web Page'
       
        Write-Host -Foreground White "Importing contact" $displayName "..."
		
		if($c -eq "") { $c = $null }
		if($company -eq "") { $company = $null }
		if($department -eq "") { $department = $null }
		if($displayName -eq "") { $displayName = $null }
		if($displayNamePrintable -eq "") { $displayNamePrintable = $null }
		if($extensionAttribute1 -eq "") { $extensionAttribute1 = $null }
		if($extensionAttribute2 -eq "") { $extensionAttribute2 = $null }
		if($extensionAttribute3 -eq "") { $extensionAttribute3 = $null }
		if($extensionAttribute4 -eq "") { $extensionAttribute4 = $null }
		if($extensionAttribute5 -eq "") { $extensionAttribute5 = $null }
		if($extensionAttribute6 -eq "") { $extensionAttribute6 = $null }
		if($extensionAttribute7 -eq "") { $extensionAttribute7 = $null }
		if($extensionAttribute8 -eq "") { $extensionAttribute8 = $null }
		if($extensionAttribute9 -eq "") { $extensionAttribute9 = $null }
		if($extensionAttribute10 -eq "") { $extensionAttribute10 = $null }
		if($extensionAttribute11 -eq "") { $extensionAttribute11 = $null }
		if($extensionAttribute12 -eq "") { $extensionAttribute12 = $null }
		if($extensionAttribute13 -eq "") { $extensionAttribute13 = $null }
		if($extensionAttribute14 -eq "") { $extensionAttribute14 = $null }
		if($extensionAttribute15 -eq "") { $extensionAttribute15 = $null }
		if($facsimileTelephoneNumber -eq "") { $facsimileTelephoneNumber = $null }
		if($givenName -eq "") { $givenName = $null }
		if($homePhone -eq "") { $homePhone = $null }
		if($initials -eq "") { $initials = $null }
		if($info -eq "") { $info = $null }
		if($l -eq "") { $l = $null }
		if($mailNickname -eq "") { $mailNickname = $null }
		if($mobile -eq "") { $mobile = $null }
		if($otherFacsimileTelephoneNumber -eq "") { $otherFacsimileTelephoneNumber = $null }
		if($otherFacsimileTelephoneNumber) { $otherFacsimileTelephoneNumber = $otherFacsimileTelephoneNumber.Split(";") }
		if($otherHomePhone -eq "") { $otherHomePhone = $null }
		if($otherHomePhone) { $otherHomePhone = $otherHomePhone.Split(";") }
		if($otherTelephone -eq "") { $otherTelephone = $null }
		if($otherTelephone) { $otherTelephone = $otherTelephone.Split(";") }
		if($pager -eq "") { $pager = $null }
		if($physicalDeliveryOfficeName -eq "") { $physicalDeliveryOfficeName = $null }
		if($postalCode -eq "") { $postalCode = $null }
		if($postOfficeBox -eq "") { $postOfficeBox = $null }
		if($sn -eq "") { $sn = $null }
		if($st -eq "") { $st = $null }
		if($streetAddress -eq "") { $streetAddress = $null }
		if($targetAddress -eq "") { $targetAddress = $null }
		if($telephoneNumber -eq "") { $telephoneNumber = $null }
		if($title -eq "") { $title = $null }
		if($wWWHomePage -eq "") { $wWWHomePage = $null }

		$mc = Get-MailContact $mailNickname -ErrorAction SilentlyContinue
		if($mc)
		{
			Write-Host -Foreground Yellow "  Contact already exists"
			Set-MailContact -Identity $mailNickname -Alias $alias -ExternalEmailAddress $targetAddress
			Set-Contact -Identity $mailNickname -Name $displayName -DisplayName $displayName -FirstName $givenName -Initials $initials -LastName $sn
		}
		else
		{
			Write-Host -Foreground White "  Creating contact"
			$mc = New-MailContact -OrganizationalUnit $ou.distinguishedName.ToString() -Name $displayName -Alias $alias -DisplayName $displayName -ExternalEmailAddress $targetAddress -FirstName $givenName -Initials $initials -LastName $sn
		}
		Set-MailContact -Identity $mailNickname -CustomAttribute1 $extensionAttribute1 -CustomAttribute2 $extensionAttribute2 -CustomAttribute3 $extensionAttribute3 -CustomAttribute4 $extensionAttribute4 -CustomAttribute5 $extensionAttribute5 -CustomAttribute6 $extensionAttribute6 -CustomAttribute7 $extensionAttribute7 -CustomAttribute8 $extensionAttribute8 -CustomAttribute9 $extensionAttribute9 -CustomAttribute10 $extensionAttribute10 -CustomAttribute11 $extensionAttribute11 -CustomAttribute12 $extensionAttribute12 -CustomAttribute13 $extensionAttribute13 -CustomAttribute14 $extensionAttribute14 -CustomAttribute15 $extensionAttribute15
		Set-Contact -Identity $mailNickname -City $l -Company $company -CountryOrRegion $c -Department $department -Fax $facsimileTelephoneNumber -HomePhone $homePhone -MobilePhone $mobile -Notes $info -Office $physicalDeliveryOfficeName -OtherFax $otherFacsimileTelephoneNumber -OtherHomePhone $otherHomePhone -OtherTelephone $otherTelephone -Pager $pager -Phone $telephoneNumber -PostalCode $postalCode -PostOfficeBox $postOfficeBox -SimpleDisplayName $displayNamePrintable -StateOrProvince $st -StreetAddress $streetAddress -Title $title -WebPage $wWWHomePage

        Write-Host ""
    }
}
trap
{
    break
}