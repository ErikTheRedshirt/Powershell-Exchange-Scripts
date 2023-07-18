# This PowerShell script will prompt you for:
#   * Admin credentials for a user who can run the Get-MailboxFolderStatistics cmdlet in Exchange Online
#     and who is an eDiscovery Manager in the Microsoft 365 compliance center.
# The script will then:
#   * If an email address is supplied: list the folders for the target mailbox.
#   * If a SharePoint or OneDrive for Business site is supplied: list the document links (folder paths)
#     for the site.
#   * In both cases, the script supplies the correct search properties (folderid: or documentlink:)
#     appended to the folder ID or document link to use in a Content Search.
# Notes:
#   * For SharePoint and OneDrive for Business, the paths are searched recursively; this means the
#     the current folder and all sub-folders are searched.
#   * For Exchange, only the specified folder will be searched; this means sub-folders in the folder
#     will not be searched. To search sub-folders, you need to use the specify the folder ID for
#     each sub-folder that you want to search.
#   * For Exchange, only folders in the user's primary mailbox will be returned by the script.

# Collect the target email address or SharePoint URL
$addressOrSite = Read-Host "Enter an email address or a URL for a SharePoint or OneDrive for Business site"

# Authenticate with Exchange Online and the Microsoft 365 compliance center (Exchange Online Protection - EOP)
if ($addressOrSite -like '*@*') {
    # List the folder IDs for the target mailbox
    $emailAddress = $addressOrSite
    # Connect to Exchange Online PowerShell
    if (-not $ExoSession) {
        Import-Module ExchangeOnlineManagement
        Connect-ExchangeOnline
    }
    $folderQueries = Get-MailboxFolderStatistics $emailAddress | ForEach-Object {
        $folderId = $_.FolderId
        $folderPath = $_.FolderPath
        $indexIdBytes = [System.Convert]::FromBase64String($folderId) | Select-Object -Skip 23 -First 24 | ForEach-Object {
            [System.Text.Encoding]::ASCII.GetString(@("0123456789ABCDEF")[($_ -shr 4), ($_ -band 0xF)])
        }
        $folderQuery = "folderid:$indexIdBytes"
        [PsCustomObject]@{
            FolderPath = $folderPath
            FolderQuery = $folderQuery
        }
    }
    Write-Host "-----Exchange Folders-----"
    $folderQueries | Format-Table
}
elseif ($addressOrSite -like 'http*') {
    $searchName = "SPFoldersSearch"
    $searchActionName = "SPFoldersSearch_Preview"
    # List the folders for the SharePoint or OneDrive for Business site
    $siteUrl = $addressOrSite
    # Connect to Security & Compliance Center PowerShell
    if (-not $SccSession) {
        Import-Module ExchangeOnlineManagement
        Connect-IPPSSession
    }
    # Clean-up, if the script was aborted, the search we created might not have been deleted. Try to do so now.
    Remove-ComplianceSearch $searchName -Confirm:$false -ErrorAction 'SilentlyContinue'
    # Create a Content Search against the SharePoint Site or OneDrive for Business site and only search for folders; wait for the search to complete
    $complianceSearch = New-ComplianceSearch -Name $searchName -ContentMatchQuery "contenttype:folder" -SharePointLocation $siteUrl
    Start-ComplianceSearch $searchName
    do {
        Write-Host "Waiting for search to complete..."
        Start-Sleep -Seconds 5
        $complianceSearch = Get-ComplianceSearch $searchName
    } while ($complianceSearch.Status -ne 'Completed')
    if ($complianceSearch.Items -gt 0) {
        # Create a Compliance Search Action and wait for it to complete. The folders will be listed in the .Results parameter
        $complianceSearchAction = New-ComplianceSearchAction -SearchName $searchName -Preview
        do {
            Write-Host "Waiting for search action to complete..."
            Start-Sleep -Seconds 5
            $complianceSearchAction = Get-ComplianceSearchAction $searchActionName
        } while ($complianceSearchAction.Status -ne 'Completed')
        # Get the results and print out the folders
        $results = $complianceSearchAction.Results
        $matches = $results | Select-String -Pattern "Data Link:.+[,}]"
        foreach ($match in $matches.Matches) {
            $rawUrl = $match.Value -replace "Data Link: " -replace ",", "}" -replace 'DocumentLink:', ''
            Write-Host "DocumentLink:`"$rawUrl`""
        }
    }
    else {
        Write-Host "No folders were found for $siteUrl"
    }
    Remove-ComplianceSearch $searchName -Confirm:$false -ErrorAction 'SilentlyContinue'
}
else {
    Write-Error "Couldn't recognize $addressOrSite as an email address or a site URL"
}
