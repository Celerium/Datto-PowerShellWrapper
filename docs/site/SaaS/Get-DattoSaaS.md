---
external help file: DattoAPI-help.xml
grand_parent: SaaS
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaS.html
parent: GET
schema: 2.0.0
title: Get-DattoSaaS
---

# Get-DattoSaaS

## SYNOPSIS
Gets Datto SaaS protection data

## SYNTAX

### index_Domains (Default)
```powershell
Get-DattoSaaS [-endpoint_Domains] [<CommonParameters>]
```

### index_byCustomerSeats
```powershell
Get-DattoSaaS [-endpoint_CustomerSeats] -saasCustomerId <String> [<CommonParameters>]
```

### index_byCustomerApps
```powershell
Get-DattoSaaS [-endpoint_CustomerApps] -saasCustomerId <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoSaaS cmdlet gets Datto SaaS protection data by combing all endpoints
into a single command.

This unique function does not contain any BCDR or Reporting endpoints.
This function
was added to simply testing & generating reports

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoSaaS
```

Returns SaaS protection data about what domains are being protected

This function uses the -endpoint_Domains switch by default

### EXAMPLE 2
```powershell
Get-DattoSaaS -endpoint_CustomerSeats -saasCustomerId 12345678
```

Returns SaaS protection seats for a given customer

### EXAMPLE 3
```powershell
Get-DattoSaaS -endpoint_CustomerApps -saasCustomerId 12345678
```

Returns SaaS protection backup data for a given customer

## PARAMETERS

### -endpoint_Domains
Returns SaaS protection data about what domains are being protected

Endpoint = /SaaS/domains

```yaml
Type: SwitchParameter
Parameter Sets: index_Domains
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_CustomerSeats
Returns SaaS protection seats for a given customer

Endpoint = /SaaS/domains/{sassCustomerId}/seats

```yaml
Type: SwitchParameter
Parameter Sets: index_byCustomerSeats
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_CustomerApps
Returns SaaS protection backup data for a given customer

Endpoint = /SaaS/domains/{sassCustomerId}/applications

```yaml
Type: SwitchParameter
Parameter Sets: index_byCustomerApps
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -saasCustomerId
Defines the id of the customer to get SaaS information from

The parameter is mandatory

```yaml
Type: String
Parameter Sets: index_byCustomerSeats, index_byCustomerApps
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaS.html](https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaS.html)

