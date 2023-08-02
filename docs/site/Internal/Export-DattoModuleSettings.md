---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Export-DattoModuleSettings.html
parent: GET
schema: 2.0.0
title: Export-DattoModuleSettings
---

# Export-DattoModuleSettings

## SYNOPSIS
Exports the Datto BaseURI, API, & JSON configuration information to file.

## SYNTAX

```powershell
Export-DattoModuleSettings [-DattoConfPath <String>] [-DattoConfFile <String>] [<CommonParameters>]
```

## DESCRIPTION
The Export-DattoModuleSettings cmdlet exports the Datto BaseURI, API, & JSON configuration information to file.

Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
This means that you cannot copy your configuration file to another computer or user account and expect it to work.

## EXAMPLES

### EXAMPLE 1
```powershell
Export-DattoModuleSettings
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's Datto configuration file located at:
    $env:USERPROFILE\DattoAPI\config.psd1

### EXAMPLE 2
```powershell
Export-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's Datto configuration file located at:
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

[https://github.com/Celerium/Datto-PowerShellWrapper](https://github.com/Celerium/Datto-PowerShellWrapper)

