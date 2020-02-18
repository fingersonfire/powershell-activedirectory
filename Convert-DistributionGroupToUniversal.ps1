$MySearchBase = "*"

# For our first step – we load up a variable with the groups we want (filtered by type):
$MyGroupList = get-adgroup -Filter 'GroupCategory -eq "Distribution" -and GroupScope -eq "Global"' -SearchBase "$MySearchBase"

# If you want to validate you got the correct groups in the variable, list out the names of your objects in the variable:
$MyGroupList.name

# Now, for every group in the list, we flip the type to Universal:
$MyGroupList | Set-ADGroup -GroupScope Universal