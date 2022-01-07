$count
Get-Mailbox -ResultSize Unlimited -Filter "IsMailboxEnabled '$true'" | Get-MailboxFolderStatistics -FolderScope RecoverableItems | Sort-Object TotalItemSize -Descending | Select-Object DisplayName,TotalItemSize -First $count | Export-CSV .\topmailboxes.csv
