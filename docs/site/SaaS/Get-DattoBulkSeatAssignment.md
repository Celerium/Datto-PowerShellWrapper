---
external help file: DattoAPI-help.xml
grand_parent: SaaS
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoBulkSeatAssignment.html
parent: GET
schema: 2.0.0
title: Get-DattoBulkSeatAssignment
---

# Get-DattoBulkSeatAssignment

## SYNOPSIS
Get SaaS Protection bulk seats assignment

## SYNTAX

```powershell
Get-DattoBulkSeatAssignment -saasCustomerId <String> -externalSubscriptionId <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoBulkSeatAssignment cmdlet get SaaS Protection
bulk seats assignment

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoBulkSeatAssignment -saasCustomerId "12345678" -externalSubscriptionId 'ab23-bdf234-1234-asdf'
```

Gets the Datto SaaS protection seats from the define customer id

## PARAMETERS

### -saasCustomerId
Defines the id of the customer to get SaaS information from

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

### -externalSubscriptionId
Defines the external Subscription Id of the customer to
get SaaS bulk seat information from

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

[https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoBulkSeatAssignment.html](https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoBulkSeatAssignment.html)

