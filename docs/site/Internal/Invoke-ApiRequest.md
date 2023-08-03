---
external help file: DattoAPI-help.xml
grand_parent: Internal
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Invoke-ApiRequest.html
parent: GET
schema: 2.0.0
title: Invoke-ApiRequest
---

# Invoke-ApiRequest

## SYNOPSIS
Makes an API request

## SYNTAX

```powershell
Invoke-ApiRequest [[-method] <String>] [-resource_Uri] <String> [[-uri_Filter] <Hashtable>]
 [[-data] <Hashtable>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-ApiRequest cmdlet invokes an API request to Datto API.

This is an internal function that is used by all public functions

As of 2023-08 the Datto v1 API only supports GET requests

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-ApiRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter
```

Invoke a rest method against the defined resource using any of the provided parameters

Example:
    Name                           Value
    ----                           -----
    Method                         GET
    Uri                            https://api.datto.com/v1/account?accountId=12345&details=True
    Headers                        {Authorization = Bearer 123456789}
    Body

## PARAMETERS

### -method
Defines the type of API method to use

Allowed values:
'GET'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -resource_Uri
Defines the resource uri (url) to use when creating the API call

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uri_Filter
Used with the internal function \[ ConvertTo-QueryString \] to combine
a functions parameters with the resource_Uri parameter.

This allows for the full uri query to occur

The full resource path is made with the following data
$Datto_Base_URI + $resource_Uri + ConvertTo-QueryString

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -data
Place holder parameter to use when other methods are supported
by the Datto v1 API

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Invoke-ApiRequest.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Invoke-ApiRequest.html)

