---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Test-DattoAPIKey.html
parent: GET
schema: 2.0.0
title: Test-DattoAPIKey
---

# Test-DattoAPIKey

## SYNOPSIS
Test the Datto API public & secret keys.

## SYNTAX

```powershell
Test-DattoAPIKey [[-base_uri] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Test-DattoAPIKey cmdlet tests the base URI & API public & secret keys that were defined in the
Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

## EXAMPLES

### EXAMPLE 1
```powershell
Test-DattoBaseURI
```

Tests the base URI & API access token that was defined in the
Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

The default full base uri test path is:
    https://api.datto.com/v1/bcdr/device

### EXAMPLE 2
```powershell
Test-DattoBaseURI -base_uri http://myapi.gateway.example.com
```

Tests the base URI & API access token that was defined in the
Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

The full base uri test path in this example is:
    http://myapi.gateway.example.com/device

## PARAMETERS

### -base_uri
Define the base URI for the Datto API connection using Datto's URI or a custom URI.

The default base URI is https://api.datto.com/v1/bcdr

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Datto_Base_URI
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Test-DattoAPIKey.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Test-DattoAPIKey.html)

