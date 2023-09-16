---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoModuleSettings.html
parent: DELETE
schema: 2.0.0
title: Remove-DattoModuleSettings
---

# Remove-DattoModuleSettings

## SYNOPSIS
Removes the stored Datto configuration folder.

## SYNTAX

```powershell
Remove-DattoModuleSettings [-dattoConfPath <String>] [-andVariables] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-DattoModuleSettings cmdlet removes the Datto folder and its files.
This cmdlet also has the option to remove sensitive Datto variables as well.

By default configuration files are stored in the following location and will be removed:
    $env:USERPROFILE\DattoAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-DattoModuleSettings
```

Checks to see if the default configuration folder exists and removes it if it does.

The default location of the Datto configuration folder is:
    $env:USERPROFILE\DattoAPI

### EXAMPLE 2
```powershell
Remove-DattoModuleSettings -DattoConfPath C:\DattoAPI -andVariables
```

Checks to see if the defined configuration folder exists and removes it if it does.
If sensitive Datto variables exist then they are removed as well.

The location of the Datto configuration folder in this example is:
    C:\DattoAPI

## PARAMETERS

### -dattoConfPath
Define the location of the Datto configuration folder.

By default the configuration folder is located at:
    $env:USERPROFILE\DattoAPI

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DattoAPI"}else{".DattoAPI"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -andVariables
Define if sensitive Datto variables should be removed as well.

By default the variables are not removed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoModuleSettings.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoModuleSettings.html)

