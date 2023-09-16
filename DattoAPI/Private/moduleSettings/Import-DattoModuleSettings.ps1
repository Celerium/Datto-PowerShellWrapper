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
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Import-DattoModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$dattoConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DattoAPI"}else{".DattoAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$dattoConfFile = 'config.psd1'
    )

    $dattoConfig = Join-Path -Path $dattoConfPath -ChildPath $dattoConfFile

    if ( Test-Path $dattoConfig ) {
        $tmp_config = Import-LocalizedData -BaseDirectory $dattoConfPath -FileName $dattoConfFile

        # Send to function to strip potentially superfluous slash (/)
        Add-DattoBaseURI $tmp_config.Datto_Base_URI

        $tmp_config.Datto_Secret_Key = ConvertTo-SecureString $tmp_config.Datto_Secret_Key

        Set-Variable -Name "Datto_Public_Key" -Value $tmp_config.Datto_Public_key -Option ReadOnly -Scope global -Force

        Set-Variable -Name "Datto_Secret_Key" -Value $tmp_config.Datto_Secret_Key -Option ReadOnly -Scope global -Force

        Set-Variable -Name "Datto_JSON_Conversion_Depth" -Value $tmp_config.Datto_JSON_Conversion_Depth -Scope global -Force

        Write-Verbose "DattoAPI Module configuration loaded successfully from [ $dattoConfig ]"

        # Clean things up
        Remove-Variable "tmp_config"
    }
    else {
        Write-Verbose "No configuration file found at [ $dattoConfig ] run Add-DattoAPIKey to get started."

        Add-DattoBaseURI

        Set-Variable -Name "Datto_Base_URI" -Value $(Get-DattoBaseURI) -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_JSON_Conversion_Depth" -Value 100 -Scope global -Force
    }
}