$email = Read-Host "Enter the email address of the user in you're trying process"
Set-Mailbox -Identity $email -ElcProcessingDisabled $false
Start-ManagedFolderAssistant -Identity $email