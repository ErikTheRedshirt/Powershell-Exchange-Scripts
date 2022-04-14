##This one is still in the works. I haven't gotten it to work just yet, but it may be becasue the server was just too big. ¯\_(ツ)_/¯

$count
Get-Mailbox -ResultSize Unlimited -Filter "IsMailboxEnabled '$true'" | Get-MailboxFolderStatistics -FolderScope RecoverableItems | Sort-Object TotalItemSize -Descending | Select-Object DisplayName,TotalItemSize -First $count | Export-CSV .\topmailboxes.csv
