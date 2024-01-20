---
external help file: DattoAPI-help.xml
grand_parent: BCDR
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoShare.html
parent: GET
schema: 2.0.0
title: Get-DattoShare
---

# Get-DattoShare

## SYNOPSIS
Gets Datto BCDR shares for a given device

## SYNTAX

```powershell
Get-DattoShare -serialNumber <String> [-page <Int64>] [-perPage <Int64>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoShare cmdlet gets Datto BCDR shares
for a given device

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoShare -serialNumber "12345678"
```

Gets the Datto BCDR with the defined serialNumber and returns any shares.

### EXAMPLE 2
```powershell
Get-DattoShare -serialNumber "12345678" -page 2 -pageSize 10
```

Gets the Datto BCDR with the defined serialNumber
with the first 10 shares from the 2nd page of results.

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

### -page
Defines the page number to return

The default value is 1

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -perPage
Defines the amount of items to return with each page

The default value is 100

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

When using this parameter there is no need to use either the page or perPage
parameters

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoShare.html](https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoShare.html)

