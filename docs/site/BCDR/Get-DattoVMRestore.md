---
external help file: DattoAPI-help.xml
grand_parent: BCDR
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVMRestore.html
parent: GET
schema: 2.0.0
title: Get-DattoVMRestore
---

# Get-DattoVMRestore

## SYNOPSIS
Gets Datto BCDR VM restores by serial number

## SYNTAX

```powershell
Get-DattoVMRestore -serialNumber <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoVMRestore cmdlet gets device VM restores
by serial number

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoVMRestore -serialNumber 12345
```

Gest Datto VM restores from the defined device

## PARAMETERS

### -serialNumber
Defines the BCDR serial number to get

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVMRestore.html](https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVMRestore.html)

