$email = Read-Host "Enter the user's Email:"
Set-Mailbox $email -LitigationHoldEnabled $false
Set-Mailbox $email -RemoveDelayHoldApplied
Get-Mailbox $email | FL LitigationHoldEnabled,InPlaceHolds
Get-Mailbox $email | Select-Object -ExpandProperty InPlaceHolds
Get-Mailbox $email | FL *HoldApplied*