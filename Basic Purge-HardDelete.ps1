$SearchName = Read-Host "Enter the name of the Complaince Search"
New-ComplianceSearchAction -SearchName "$SearchName" -Purge -PurgeType HardDelete