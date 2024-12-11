---
external help file: DattoAPI-help.xml
grand_parent: _Unique
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/_Unique/Get-DattoSaaSDetailedBackupStats.html
parent: Special
schema: 2.0.0
title: Get-DattoSaaSDetailedBackupStats
---

# Get-DattoSaaSDetailedBackupStats

## SYNOPSIS
Get Datto SaaS protection detailed backup stats for a given customer

## SYNTAX

```powershell
Get-DattoSaaSDetailedBackupStats -saasCustomerId <Int32> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoSeat cmdlet gets Datto SaaS protection detailed backup stats
for a given customer

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoSaaSDetailedBackupStats -saasCustomerId "123456"
```

Gets the Datto SaaS protection detailed backup stats from the define customer id

## PARAMETERS

### -saasCustomerId
Defines the id of the Datto SaaS organization

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaSDetailedBackupStats.html](https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaSDetailedBackupStats.html)

