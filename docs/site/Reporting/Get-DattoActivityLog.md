---
external help file: DattoAPI-help.xml
grand_parent: Reporting
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/Reporting/Get-DattoActivityLog.html
parent: GET
schema: 2.0.0
title: Get-DattoActivityLog
---

# Get-DattoActivityLog

## SYNOPSIS
Gets a filtered list of activity logs ordered by date

## SYNTAX

```powershell
Get-DattoActivityLog [-clientName <String>] [-since <Int32>] [-sinceUnits <String>] [-target <String[]>]
 [-targetType <String>] [-user <String>] [-page <Int64>] [-perPage <Int64>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoActivityLog cmdlet gets a filtered list of activity logs ordered by date

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoActivityLog
```

Gets the Datto BCDR platform activity logs from the past day.

### EXAMPLE 2
```powershell
Get-DattoActivityLog -since 7 -sinceUnits days
```

Gets the Datto BCDR platform activity logs from the past 7 day.

### EXAMPLE 3
```powershell
Get-DattoActivityLog -user bob -since 7 -sinceUnits days
```

Gets the Datto BCDR platform activity logs for the user named bob from the past 7 day.

### EXAMPLE 4
```powershell
Get-DattoActivityLog -since 30 -sinceUnits days -target 'bcdr-device:D0123456789','bcdr-device:D9876543210'
```

Gets the Datto BCDR platform activity logs from the defined targets for the past 30 day.

### EXAMPLE 5
```powershell
Get-DattoActivityLog -since 30 -sinceUnits days -page 2 -pageSize 10
```

Gets the Datto BCDR platform activity logs from the past 30 day.

Returns the second page of 10 items.

## PARAMETERS

### -clientName
Defines a client name with which to do a partial/prefix match

2022-04: Filter does not appear to work

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -since
Defines the number of days (unless overridden with sinceUnits), up until now,
for which to produce logs

Default value : 1

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -sinceUnits
Defines the units to use for the since filter

Available values : days, hours, minutes

Default value : days

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Days
Accept pipeline input: False
Accept wildcard characters: False
```

### -target
Defines a comma-separated array of targetType:targetId tuples

Example: bcdr-device:DC1234DC1234

2022-04: Only works with 1 item in the array right now (See Notes)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetType
Defines the type of target for which to find activity logs

Example : bcdr-device

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -user
Defines a username with which to do a partial/prefix match

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -page
Defines the page number to return

The default value is 1

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -perPage
Defines the amount of items to return with each page

The default value is 100

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
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
As of 2022-04 the clientName parameter does not appear to be a working filter for this endpoint
    Cannot get the filter to returned data when run from Datto's own portal as well.

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/Reporting/Get-DattoActivityLog.html](https://celerium.github.io/Datto-PowerShellWrapper/site/Reporting/Get-DattoActivityLog.html)

