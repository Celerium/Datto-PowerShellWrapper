---
external help file: DattoAPI-help.xml
grand_parent: SaaS
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Set-DattoBulkSeatChange.html
parent: PUT
schema: 2.0.0
title: Set-DattoBulkSeatChange
---

# Set-DattoBulkSeatChange

## SYNOPSIS
Sets Datto SaaS Protection bulk seat changes

## SYNTAX

```powershell
Set-DattoBulkSeatChange -saasCustomerId <String> -externalSubscriptionId <String> -seatType <String>
 -actionType <String> -remoteId <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-DattoBulkSeatChange cmdlet is used to bulk set SaaS Protection seat changes

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoBulkSeatChange -customerId "123456" -externalSubscriptionId 'Classic:Office365:654321' -seatType "User" -actionType License -remoteId "ab23-bdf234-1234-asdf"
```

Sets the Datto SaaS protection seats from the defined Office365 customer id

### EXAMPLE 2
```powershell
Set-DattoBulkSeatChange -customerId "123456" -externalSubscriptionId 'Classic:GoogleApps:654321' -seatType "SharedDrive" -actionType Pause -remoteId "ab23-bdf234-1234-asdf","cd45-cfe567-5678-1234"
```

Sets the Datto SaaS protection seats from the defined Google customer id

## PARAMETERS

### -saasCustomerId
Defines the id of the Datto SaaS organization

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
Defines the external Subscription ID used to set SaaS bulk seat changes

The externalSubscriptionId can be found by referencing the data returned form Get-DattoApplication

Example:
    'Classic:Office365:123456'
    'Classic:GoogleApps:123456'

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
Defines the seat type to backup

Example:
    SharedMailbox, Site, TeamSite, User

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -actionType
Defines what active to take against the seat

Active:         The seat exists in the organization and is actively backed up, meaning the seat is protected.
Paused:         The seat exists in the organization; backups were enabled but are currently paused.
Unprotected:    The seat exists in the organization but backups are not enabled.

Allowed values:
    License, Pause, Unlicense

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -remoteId
Defines the target ids to change

Remote ids can be found by referencing the data returned form Get-DattoApplication

Example:
    ab23-bdf234-1234-asdf

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
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

