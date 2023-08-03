---
external help file: DattoAPI-help.xml
grand_parent: BCDR
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoDevice.html
parent: GET
schema: 2.0.0
title: Get-DattoDevice
---

# Get-DattoDevice

## SYNOPSIS
Gets Datto BCDR devices from the the Datto API.

## SYNTAX

### index (Default)
```powershell
Get-DattoDevice [-showHiddenDevices <String>] [-showChildResellerDevices <String>] [-page <Int64>]
 [-perPage <Int64>] [-allPages] [<CommonParameters>]
```

### indexByDevice
```powershell
Get-DattoDevice -serialNumber <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoDevice cmdlet gets can get a one or more
Datto BCDR devices.

/bcdr/device - Returns all BCDR devices
/bcdr/device/serialNumber - Returns a single BCDR device

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoDevice
```

Gets the first 100 Datto BCDR devices with any hidden or child reseller devices.

### EXAMPLE 2
```powershell
Get-DattoDevice -showHiddenDevices 0 -showChildResellerDevices 0
```

Gets the first 100 Datto BCDR devices without any hidden or child reseller devices.

### EXAMPLE 3
```powershell
Get-DattoDevice -page 2 -pageSize 10
```

Gets the first 10 Datto BCDR devices from the second page.
Hidden and child reseller devices will be included.

## PARAMETERS

### -serialNumber
Defines the BCDR serial number to get

The parameter is mandatory if you want to get a specific device.

```yaml
Type: String
Parameter Sets: indexByDevice
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -showHiddenDevices
Whether hidden devices should be included in your results

Acceptable values are:
    '0', '1'

By default '1' is returned by the API which shows hidden devices.

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -showChildResellerDevices
Whether child reseller devices should be included in your results

Acceptable values are:
    '0', '1'

By default '1' is returned by the API which shows child reseller devices.

```yaml
Type: String
Parameter Sets: index
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
Parameter Sets: index
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
Parameter Sets: index
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
Parameter Sets: index
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
Setting some parameters to an \[INT\] causes them to not be added to the body.
(Show*Devices)
Documentation around the Show* endpoints just defines that an integer is accepted.
    In testing only 0 or 1 appear to do anything.

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoDevice.html](https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoDevice.html)

