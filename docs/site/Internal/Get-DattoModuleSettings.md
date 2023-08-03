---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-DattoModuleSettings
---

# Get-DattoModuleSettings

## SYNOPSIS
Gets the saved Datto configuration settings

## SYNTAX

### index (Default)
```powershell
Get-DattoModuleSettings [-DattoConfPath <String>] [-DattoConfFile <String>] [<CommonParameters>]
```

### show
```powershell
Get-DattoModuleSettings [-openConfFile] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoModuleSettings cmdlet gets the saved Datto configuration settings
from the local system.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\DattoAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-DattoModuleSettings

The default location of the Datto configuration file is:
    $env:USERPROFILE\DattoAPI\config.psd1

### EXAMPLE 2
```powershell
Get-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the Datto configuration file in this example is:
    C:\DattoAPI\MyConfig.psd1

## PARAMETERS

### -DattoConfPath
Define the location to store the Datto configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\DattoAPI

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: "$($env:USERPROFILE)\DattoAPI"
Accept pipeline input: False
Accept wildcard characters: False
```

### -DattoConfFile
Define the name of the Datto configuration file.

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -openConfFile
Opens the Datto configuration file

```yaml
Type: SwitchParameter
Parameter Sets: show
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoModuleSettings.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoModuleSettings.html)

