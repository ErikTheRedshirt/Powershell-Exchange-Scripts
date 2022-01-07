$username = Read-Host "Enter the user's username"
Get-MailboxFolderStatistics $username -FolderScope RecoverableItems | FL Name,FolderAndSubfolderSize,ItemsInFolderAndSubfolders
Get-Mailbox $username | FL LitigationHoldEnabled,InPlaceHolds
Get-Mailbox $username | Select-Object -ExpandProperty InPlaceHolds
Get-Mailbox $username | FL *HoldApplied*
