function Get-DattoModuleSettings {
<#
    .SYNOPSIS
        Gets the saved Datto configuration settings

    .DESCRIPTION
        The Get-DattoModuleSettings cmdlet gets the saved Datto configuration settings
        from the local system.

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

    .PARAMETER openConfFile
        Opens the Datto configuration file

    .EXAMPLE
        Get-DattoModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-DattoModuleSettings

        The default location of the Datto configuration file is:
            $env:USERPROFILE\DattoAPI\config.psd1

    .EXAMPLE
        Get-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the Datto configuration file in this example is:
            C:\DattoAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$DattoConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin{}

    process{

        if ( Test-Path -Path $($DattoConfPath + '\' + $DattoConfFile) ){

            if($openConfFile){
                Invoke-Item -Path $($DattoConfPath + '\' + $DattoConfFile)
            }
            else{
                Import-LocalizedData -BaseDirectory $DattoConfPath -FileName $DattoConfFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $DattoConfPath\$DattoConfFile ]"
        }

    }

    end{}

}