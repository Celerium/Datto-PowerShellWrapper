function Remove-DattoModuleSettings {
<#
    .SYNOPSIS
        Removes the stored Datto configuration folder.

    .DESCRIPTION
        The Remove-DattoModuleSettings cmdlet removes the Datto folder and its files.
        This cmdlet also has the option to remove sensitive Datto variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfPath
        Define the location of the Datto configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\DattoAPI

    .PARAMETER AndVariables
        Define if sensitive Datto variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-DattoModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the Datto configuration folder is:
            $env:USERPROFILE\DattoAPI

    .EXAMPLE
        Remove-DattoModuleSettings -DattoConfPath C:\DattoAPI -AndVariables

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
        [string]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    if (Test-Path $DattoConfPath) {

        Remove-Item -Path $DattoConfPath -Recurse -Force

        If ($AndVariables) {
            Remove-DattoAPIKey
            Remove-DattoBaseURI
        }

        if (!(Test-Path $DattoConfPath)) {
            Write-Output "The DattoAPI configuration folder has been removed successfully from [ $DattoConfPath ]"
        }
        else {
            Write-Error "The DattoAPI configuration folder could not be removed from [ $DattoConfPath ]"
        }

    }
    else {
        Write-Warning "No configuration folder found at [ $DattoConfPath ]"
    }
}