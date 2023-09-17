function Export-DattoModuleSettings {
<#
    .SYNOPSIS
        Exports the Datto BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-DattoModuleSettings cmdlet exports the Datto BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER dattoConfPath
        Define the location to store the Datto configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER dattoConfFile
        Define the name of the Datto configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-DattoModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's Datto configuration file located at:
            $env:USERPROFILE\DattoAPI\config.psd1

    .EXAMPLE
        Export-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's Datto configuration file located at:
            C:\DattoAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Export-DattoModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$dattoConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DattoAPI"}else{".DattoAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$dattoConfFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $dattoConfig = Join-Path -Path $dattoConfPath -ChildPath $dattoConfFile

        # Confirm variables exist and are not null before exporting
        if ($Datto_Base_URI -and $Datto_Public_Key -and $Datto_Secret_Key -and $Datto_JSON_Conversion_Depth) {
            $secureString = $Datto_Secret_Key | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $dattoConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $dattoConfPath -ItemType Directory -Force
            }
@"
    @{
        Datto_Base_URI = '$Datto_Base_URI'
        Datto_Public_Key = '$Datto_Public_Key'
        Datto_Secret_Key = '$secureString'
        Datto_JSON_Conversion_Depth = '$Datto_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $dattoConfig -Force
        }
        else {
            Write-Error "Failed to export Datto Module settings to [ $dattoConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}