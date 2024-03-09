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
Get-DattoApplication -saasCustomerId <Int32> [-daysUntil <Int32>] [-includeRemoteID <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoApplication cmdlet gets Datto SaaS protection
backup data for a given customer

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoApplication -saasCustomerId "123456"
```

Gets the Datto SaaS protection backup data from the define customer ID and
does not include remote IDs

### EXAMPLE 2
```powershell
Get-DattoApplication -saasCustomerId "123456" -includeRemoteID 1
```

Gets the Datto SaaS protection backup data from the define customer ID and
includes remote IDs

## PARAMETERS

### -saasCustomerId
Defines the ID of the Datto SaaS organization

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

### -daysUntil
Defines the number of days until the report should be generated

If not set default value of '10' days is returned by the API.

As of 2024-02, maximum value of '30' days returns data from the endpoint.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -includeRemoteID
Defines if remote IDs are included in the return

Note:
    0 = No
    1 = Yes

Allowed Values:
    0, 1

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html](https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html)

