---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-InvokeMetaData.html
parent: GET
schema: 2.0.0
title: Get-InvokeMetaData
---

# Get-InvokeMetaData

## SYNOPSIS
Gets various Api metadata values

## SYNTAX

```powershell
Get-InvokeMetaData [[-base_uri] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-InvokeMetaData cmdlet gets various Api metadata values from an
Invoke-WebRequest to assist in various troubleshooting scenarios such
as rate-limiting.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-InvokeMetaData
```

Gets various Api metadata values from an Invoke-WebRequest to assist
in various troubleshooting scenarios such as rate-limiting.

The default full base uri test path is:
    https://api.datto.com/v1

### EXAMPLE 2
```powershell
Get-InvokeMetaData -base_uri http://myapi.gateway.example.com
```

Gets various Api metadata values from an Invoke-WebRequest to assist
in various troubleshooting scenarios such as rate-limiting.

The full base uri test path in this example is:
    http://myapi.gateway.example.com/device

## PARAMETERS

### -base_uri
Define the base URI for the Datto API connection using Datto's URI or a custom URI.

The default base URI is https://api.datto.com/v1

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

[https://github.com/Celerium/Datto-PowerShellWrapper](https://github.com/Celerium/Datto-PowerShellWrapper)

