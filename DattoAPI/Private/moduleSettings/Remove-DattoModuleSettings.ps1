function Remove-DattoModuleSettings {
<#
    .SYNOPSIS
        Removes the stored Datto configuration folder.

    .DESCRIPTION
        The Remove-DattoModuleSettings cmdlet removes the Datto folder and its files.
        This cmdlet also has the option to remove sensitive Datto variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\DattoAPI

    .PARAMETER dattoConfPath
        Define the location of the Datto configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\DattoAPI

    .PARAMETER andVariables
        Define if sensitive Datto variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-DattoModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the Datto configuration folder is:
            $env:USERPROFILE\DattoAPI

    .EXAMPLE
        Remove-DattoModuleSettings -DattoConfPath C:\DattoAPI -andVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive Datto variables exist then they are removed as well.

        The location of the Datto configuration folder in this example is:
            C:\DattoAPI

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoModuleSettings.html
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$dattoConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DattoAPI"}else{".DattoAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [switch]$andVariables
    )

    begin {}

    process {

        if (Test-Path $dattoConfPath) {

            Remove-Item -Path $dattoConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($andVariables) {
                Remove-DattoAPIKey
                Remove-DattoBaseURI
            }

            if (!(Test-Path $dattoConfPath)) {
                Write-Output "The DattoAPI configuration folder has been removed successfully from [ $dattoConfPath ]"
            }
            else {
                Write-Error "The DattoAPI configuration folder could not be removed from [ $dattoConfPath ]"
            }

        }
        else {
            Write-Warning "No configuration folder found at [ $dattoConfPath ]"
        }

    }

    end {}

}