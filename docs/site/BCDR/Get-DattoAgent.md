---
external help file: DattoAPI-help.xml
grand_parent: BCDR
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoAgent.html
parent: GET
schema: 2.0.0
title: Get-DattoAgent
---

# Get-DattoAgent

## SYNOPSIS
Get Datto BCDR agents from a given device

## SYNTAX

### index (Default)
```powershell
Get-DattoAgent [-page <Int64>] [-perPage <Int64>] [-allPages] [<CommonParameters>]
```

### indexByDevice
```powershell
Get-DattoAgent -serialNumber <String> [-page <Int64>] [-perPage <Int64>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoAgent cmdlet get agents from a given BCDR device

/bcdr/Agent - Does not return data
/bcdr/device/serialNumber/Asset/Agent

Can also gets a list of your clients and the agents under those clients.
As of 2022-04 this endpoint does not return any data.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoAgent
```

Gets a list of clients and the agents under those clients.

As of 2022-04 this endpoint does not return any data.
Leaving this here in the event Datto corrects this endpoint.

### EXAMPLE 2
```powershell
Get-DattoAgent -serialNumber "12345678"
```

Returns the agents from the defined Datto BCDR

### EXAMPLE 3
```powershell
Get-DattoAgent -serialNumber "12345678" -page 2 -perPage 10
```

Returns the first 10 agents from page 2 from the defined Datto BCDR

## PARAMETERS

### -serialNumber
Defines the BCDR serial number to get agents from

The parameter is mandatory

```yaml
Type: String
Parameter Sets: indexByDevice
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
The /agent uri does NOT return any data as this appears to be a deprecated endpoint in the Datto API.
    The /asset/agent DOES return data.

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoAgent.html](https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoAgent.html)

