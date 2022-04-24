function Export-DattoModuleSettings {
<#
    .SYNOPSIS
        Exports the Datto BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-DattoModuleSettings cmdlet exports the Datto BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER DattoConfPath
        Define the location to store the Datto configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfFile
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
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfFile = 'config.psd1'
    )

    # Confirm variables exist and are not null before exporting
    if ($Datto_Base_URI -and $Datto_Public_Key -and $Datto_Secret_Key -and $Datto_JSON_Conversion_Depth) {
        $secureString = $Datto_Secret_Key | ConvertFrom-SecureString
        New-Item -ItemType Directory -Force -Path $DattoConfPath | ForEach-Object { $_.Attributes = 'hidden' }
@"
    @{
        Datto_Base_URI = '$Datto_Base_URI'
        Datto_Public_Key = '$Datto_Public_Key'
        Datto_Secret_Key = '$secureString'
        Datto_JSON_Conversion_Depth = '$Datto_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath ($DattoConfPath + "\" + $DattoConfFile) -Force

    }
    else {
        Write-Error $_
        Write-Error "Failed to export Datto Module settings to [ $DattoConfPath\$DattoConfFile ]"
    }
}

function Import-DattoModuleSettings {
<#
    .SYNOPSIS
        Imports the Datto BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-DattoModuleSettings cmdlet imports the Datto BaseURI, API, & JSON configuration
        information stored in the Datto configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfPath
        Define the location to store the Datto configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfFile
        Define the name of the Datto configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-DattoModuleSettings

        Validates that the configuration file created with the Export-DattoModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the Datto configuration file is:
            $env:USERPROFILE\DattoAPI\config.psd1

    .EXAMPLE
        Import-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-DattoModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the Datto configuration file in this example is:
            C:\DattoAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://api.datto.com/v1/bcdr/developer
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfFile = 'config.psd1'
    )

    if ( test-path ($DattoConfPath + "\" + $DattoConfFile) ) {
        $tmp_config = Import-LocalizedData -BaseDirectory $DattoConfPath -FileName $DattoConfFile

        # Send to function to strip potentially superfluous slash (/)
        Add-DattoBaseURI $tmp_config.Datto_Base_URI

        $tmp_config.Datto_Secret_Key = ConvertTo-SecureString $tmp_config.Datto_Secret_Key

        Set-Variable -Name "Datto_Public_Key"  -Value $tmp_config.Datto_Public_key `
            -Option ReadOnly -Scope global -Force

        Set-Variable -Name "Datto_Secret_Key"  -Value $tmp_config.Datto_Secret_Key `
            -Option ReadOnly -Scope global -Force

        Set-Variable -Name "Datto_JSON_Conversion_Depth" -Value $tmp_config.Datto_JSON_Conversion_Depth `
            -Scope global -Force

        Write-Host "DattoAPI Module configuration loaded successfully from [ $DattoConfPath\$DattoConfFile ]" -ForegroundColor Green

        # Clean things up
        Remove-Variable "tmp_config"
    }
    else {
        Write-Verbose "No configuration file found at [ $DattoConfPath\$DattoConfFile ]"
        Write-Verbose "Please run Add-DattoAPIKey to get started."

        Set-Variable -Name "Datto_Base_URI" -Value "https://api.datto.com/v1/bcdr" -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_JSON_Conversion_Depth" -Value 100 -Scope global -Force
    }
}

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
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    if (Test-Path $DattoConfPath) {

        Remove-Item -Path $DattoConfPath -Recurse -Force

        If ($AndVariables) {
            if ($Datto_Public_Key) {
                Remove-Variable -Name "Datto_Public_Key" -Scope global -Force
            }
            Else{
                Write-Warning "The Datto API [ public ] key is not set. Nothing to remove"
            }

            if ($Datto_Secret_Key) {
                Remove-Variable -Name "Datto_Secret_Key" -Scope global -Force
            }
            Else{
                Write-Warning "The Datto API [ secret ] key is not set. Nothing to remove"
            }
            if ($Datto_Base_URI) {
                Remove-Variable -Name "Datto_Base_URI" -Scope global -Force
            }
        }

        if (!(Test-Path $DattoConfPath)) {
            Write-Host "The DattoAPI configuration folder has been removed successfully from [ $DattoConfPath ]" -ForegroundColor Green
        }
        else {
            Write-Error "The DattoAPI configuration folder could not be removed from [ $DattoConfPath ]"
        }

    }
    else {
        Write-Warning "No configuration folder found at [ $DattoConfPath ]"
    }
}