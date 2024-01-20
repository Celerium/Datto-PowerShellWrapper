---
external help file: DattoAPI-help.xml
grand_parent: BCDR
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVolume.html
parent: GET
schema: 2.0.0
title: Get-DattoVolume
---

# Get-DattoVolume

## SYNOPSIS
Gets an asset(s)(agent or share) for a specific volume on a device

## SYNTAX

```powershell
Get-DattoVolume -serialNumber <String> -volumeName <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoVolume cmdlet gets an asset(s)(agent or share)
for a specific volume on a device

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoVolume -serialNumber "12345678" -volumeName "0987654321"
```

Gets the Datto BCDR with the defined serialNumber and returns any
agents or shares for the defined volume.

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

### -volumeName
Defines the name (id) of the protected volume

The content of the 'volume' field when calling /v1/bcdr/device/{serialNumber}/asset

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVolume.html](https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVolume.html)

