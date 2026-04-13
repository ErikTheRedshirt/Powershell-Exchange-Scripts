# PowerShell Exchange Scripts

A collection of PowerShell scripts for Exchange Online (O365) administration, focused primarily on eDiscovery, litigation holds, and recoverable items management. Written and aggregated over the course of managing enterprise Microsoft 365 compliance environments.

Feel free to use or adapt any of these for your own environment. If you improve or fix anything, I'd love to hear about it.

## Scripts

- **Basic Purge-HardDelete** -- hard delete items from mailboxes
- **Connect-IPPSSession** -- connect to Security & Compliance PowerShell
- **Get Mailbox Folder IDs** -- retrieve folder IDs for targeted searches
- **Get Recoverable Stats and Lit Hold Status** -- report on recoverable item sizes and litigation hold state
- **Get-RecoverableSizes** -- get recoverable items folder sizes across mailboxes
- **Get-Remove Session** -- session cleanup utility
- **Purge Loop** -- loop-based purge for large recoverable items volumes
- **Recoverable Folderstats Loop** -- iterate folder statistics across mailboxes
- **Remove Lit Hold and Delay Hold** -- remove litigation holds and delay holds
- **TurnOffProcDisable / Run ManageFolderAssistant** -- disable processing holds and trigger folder assistant
- **Users with Top Recoverables Folder** -- identify mailboxes with largest recoverable items footprint

> **Note:** These haven't been actively maintained in a couple of years and may be out of date with current Exchange Online cmdlets and Microsoft 365 APIs. Use with caution and test in a non-production environment first.
