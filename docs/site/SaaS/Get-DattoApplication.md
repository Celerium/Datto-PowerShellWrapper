---
external help file: DattoAPI-help.xml
grand_parent: SaaS
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html
parent: GET
schema: 2.0.0
title: Get-DattoApplication
---

# Get-DattoApplication

## SYNOPSIS
Get Datto SaaS protection backup data for a given customer

## SYNTAX

```powershell
Get-DattoApplication -saasCustomerId <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoApplication cmdlet gets Datto SaaS protection
backup data for a given customer

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoApplication -saasCustomerId "12345678"
```

Gets the Datto SaaS protection backup data from the define customer id

## PARAMETERS

### -saasCustomerId
Defines the id of the customer to get SaaS information from

The parameter is mandatory

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

[https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html](https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html)

