$Datto_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Datto_Headers.Add("Content-Type", 'application/json')

Set-Variable -Name "Datto_Headers"  -Value $Datto_Headers -Scope global

# Load Web assembly when needed as PowerShell Core has the assembly preloaded
if ( !("System.Web.HttpUtility" -as [Type]) ) {
    Add-Type -Assembly System.Web
}

Import-DattoModuleSettings