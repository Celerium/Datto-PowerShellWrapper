---
external help file: DattoAPI-help.xml
grand_parent: _Unique
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/_Unique/Set-DattoAPIKey.html
parent: Special
schema: 2.0.0
title: Set-DattoAPIKey
---

# Set-DattoAPIKey

## SYNOPSIS
Sets the API public & secret keys used to authenticate API calls.

## SYNTAX

## DESCRIPTION
The Add-DattoAPIKey cmdlet sets the API public & secret keys which are used to
authenticate all API calls made to Datto.

Once the API public & secret keys are defined, the secret key is encrypted using SecureString.

The Datto API public & secret keys are generated via the Datto portal at Admin \> Integrations

## EXAMPLES

### EXAMPLE 1
```powershell
Add-DattoAPIKey
```

Prompts to enter in the API public key and secret key.

### EXAMPLE 2
```powershell
Add-DattoAPIKey -Api_Key_Public '12345'
```

The Datto API will use the string entered into the \[ -Api_Key_Public \] parameter as the
public key & will then prompt to enter in the secret key.

### EXAMPLE 3
```
'12345' | Add-DattoAPIKey
```

The Datto API will use the string entered as the secret key & will prompt to enter in the public key.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoAPIKey.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoAPIKey.html)

