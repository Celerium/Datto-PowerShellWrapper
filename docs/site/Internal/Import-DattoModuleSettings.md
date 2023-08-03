---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Import-DattoModuleSettings.html
parent: GET
schema: 2.0.0
title: Import-DattoModuleSettings
---

# Import-DattoModuleSettings

## SYNOPSIS
Imports the Datto BaseURI, API, & JSON configuration information to the current session.

## SYNTAX

```powershell
Import-DattoModuleSettings [-DattoConfPath <String>] [-DattoConfFile <String>] [<CommonParameters>]
```

## DESCRIPTION
The Import-DattoModuleSettings cmdlet imports the Datto BaseURI, API, & JSON configuration
information stored in the Datto configuration file to the users current session.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\DattoAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Import-DattoModuleSettings
```

Validates that the configuration file created with the Export-DattoModuleSettings cmdlet exists
then imports the stored data into the current users session.

The default location of the Datto configuration file is:
    $env:USERPROFILE\DattoAPI\config.psd1

### EXAMPLE 2
```powershell
Import-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1
```

Validates that the configuration file created with the Export-DattoModuleSettings cmdlet exists
then imports the stored data into the current users session.

The location of the Datto configuration file in this example is:
    C:\DattoAPI\MyConfig.psd1

## PARAMETERS

### -DattoConfPath
Define the location to store the Datto configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\DattoAPI

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Config.psd1
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Import-DattoModuleSettings.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Import-DattoModuleSettings.html)

