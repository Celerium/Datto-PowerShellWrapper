---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoBaseURI.html
parent: POST
schema: 2.0.0
title: Add-DattoBaseURI
---

# Add-DattoBaseURI

## SYNOPSIS
Sets the base URI for the Datto API connection.

## SYNTAX

```powershell
Add-DattoBaseURI [[-base_uri] <String>] [[-data_center] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-DattoBaseURI cmdlet sets the base URI which is later used
to construct the full URI for all API calls.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-DattoBaseURI
```

The base URI will use https://api.datto.com/v1 which is Datto's default URI.

### EXAMPLE 2
```powershell
Add-DattoBaseURI -data_center US
```

The base URI will use https://api.datto.com/v1 which is Datto's US URI.

### EXAMPLE 3
```powershell
Add-DattoBaseURI -base_uri http://myapi.gateway.example.com
```

A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to Datto's API.

## PARAMETERS

### -base_uri
Define the base URI for the Datto API connection using Datto's URI or a custom URI.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://api.datto.com/v1
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -data_center
Datto's URI connection point that can be one of the predefined data centers.

The accepted values for this parameter are:
\[ US \]
    US = https://api.datto.com/v1

Placeholder for other data centers.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoBaseURI.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoBaseURI.html)

