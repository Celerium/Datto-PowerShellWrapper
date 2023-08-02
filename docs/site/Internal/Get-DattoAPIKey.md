---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoAPIKey.html
parent: GET
schema: 2.0.0
title: Get-DattoAPIKey
---

# Get-DattoAPIKey

## SYNOPSIS
Gets the Datto API public & secret key global variables.

## SYNTAX

```powershell
Get-DattoAPIKey [-plainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoAPIKey cmdlet gets the Datto API public & secret key
global variables and returns them as an object.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoAPIKey
```

Gets the Datto API public & secret key global variables and returns them as an object
with the secret key as a SecureString.

### EXAMPLE 2
```powershell
Get-DattoAPIKey -plainText
```

Gets the Datto API public & secret key global variables and returns them as an object
with the secret key as plain text.

## PARAMETERS

### -plainText
Decrypt and return the API key in plain text.

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

[https://github.com/Celerium/Datto-PowerShellWrapper](https://github.com/Celerium/Datto-PowerShellWrapper)

