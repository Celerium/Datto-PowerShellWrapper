function Initialize-DattoModule {
<#
    .SYNOPSIS
        Initialize the DattoAPI module

    .DESCRIPTION
        The Invoke-DattoRequest cmdlet initialize the DattoAPI module
        when the imported into the users session.

        Only used during the import of the module

    .EXAMPLE
        Initialize-DattoModule

        Initialize the DattoAPI module with starter values

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Initialize-DattoModule.html

#>

[CmdletBinding()]
param()

    begin{}

    process{

        $Datto_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $Datto_Headers.Add("Content-Type", 'application/json')

        Set-Variable -Name "Datto_Headers"  -Value $Datto_Headers -Scope global

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        Import-DattoModuleSettings

    }

    end{}

}