---
external help file: DattoAPI-help.xml
grand_parent: SaaS
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Set-DattoBulkSeatChange.html
parent: GET
schema: 2.0.0
title: Set-DattoBulkSeatChange
---

# Set-DattoBulkSeatChange

## SYNOPSIS
Sets Datto SaaS Protection bulk seat changes

## SYNTAX

```powershell
Set-DattoBulkSeatChange -saasCustomerId <String> -externalSubscriptionId <String> -seatType <String> -remoteId <String[]> -actionType <String> [<CommonParameters>]
```

## DESCRIPTION
The `Set-DattoBulkSeatChange` cmdlet sets the Datto SaaS Protection bulk seat changes

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoBulkSeatChange -saasCustomerId "12345678" -externalSubscriptionId 'Classic:Office365:123456' -seatType "User" -remoteId "ab23-bdf234-1234-asdf" -actionType "License"
```

Sets the Datto SaaS protection seats from the defined Office365 customer id

### EXAMPLE 2
```powershell
Set-DattoBulkSeatChange -saasCustomerId "12345678" -externalSubscriptionId 'Classic:GoogleApps:123456' -seatType "SharedDrive" -remoteId "ab23-bdf234-1234-asdf","cd45-cfe567-5678-qwer" -actionType "Pause"
```

Sets the Datto SaaS protection seats from the defined Google customer id

## PARAMETERS

### -saasCustomerId
Defines the id of the Organization to set SaaS information from

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
Defines the external Subscription ID of the SaaS Protection Organization used to set SaaS bulk seat changes

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

### -seatType
Defines the seat type of the SaaS Protection SaaS bulk seat change

:warning: Input is case-sensitive, begin with Capital, and use PascalCase when needed.

e.g.
> Valid seat_type for O365:
> `User`,
> `SharedMailbox`,
> `Site`,
> `TeamSite`,
> `Team`
>
> Valid seat_type for Google:
> `User`,
> `SharedDrive`


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

### -actionType
Defines the action type of the SaaS Protection bulk seat change

:warning: Input is case-sensitive, begin with Capital, and use PascalCase when needed.

e.g.
> Valid action_type:
> `License`,
> `Pause`,
> `Unlicense`


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

### -remoteId
Defines the remote ID of the SaaS Protection Organization used to set SaaS bulk seat changes

For Microsoft this is the Entra / Azure **Object ID**

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

[https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Set-DattoBulkSeatChange.html](https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Set-DattoBulkSeatChange.html)

