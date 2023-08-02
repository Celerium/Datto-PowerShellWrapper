---
external help file: DattoAPI-help.xml
grand_parent: BCDR
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoBCDR.html
parent: GET
schema: 2.0.0
title: Get-DattoBCDR
---

# Get-DattoBCDR

## SYNOPSIS
Gets Datto BCDR devices and assets

## SYNTAX

### index_Devices (Default)
```powershell
Get-DattoBCDR [-endpoint_Devices] [-showHiddenDevices <String>] [-showChildResellerDevices <String>]
 [-page <Int64>] [-perPage <Int64>] [-allPages] [<CommonParameters>]
```

### index_Agents
```powershell
Get-DattoBCDR [-endpoint_Agents] [-page <Int64>] [-perPage <Int64>] [-allPages] [<CommonParameters>]
```

### index_byDevice
```powershell
Get-DattoBCDR [-endpoint_byDevice] -serialNumber <String> [<CommonParameters>]
```

### index_byDeviceAgent
```powershell
Get-DattoBCDR [-endpoint_byDeviceAgent] -serialNumber <String> [-page <Int64>] [-perPage <Int64>] [-allPages]
 [<CommonParameters>]
```

### index_byDeviceAlert
```powershell
Get-DattoBCDR [-endpoint_byDeviceAlert] -serialNumber <String> [-page <Int64>] [-perPage <Int64>] [-allPages]
 [<CommonParameters>]
```

### index_byDeviceAsset
```powershell
Get-DattoBCDR [-endpoint_byDeviceAsset] -serialNumber <String> [-page <Int64>] [-perPage <Int64>] [-allPages]
 [<CommonParameters>]
```

### index_byDeviceShare
```powershell
Get-DattoBCDR [-endpoint_byDeviceShare] -serialNumber <String> [-page <Int64>] [-perPage <Int64>] [-allPages]
 [<CommonParameters>]
```

### index_byDeviceVolume
```powershell
Get-DattoBCDR [-endpoint_byDeviceVolume] -serialNumber <String> -volumeName <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoBCDR cmdlet gets Datto BCDR devices and assets by combing all endpoints
into a single command.

This unique function does not contain any Reporting or SaaS endpoints.
This function
was added to simply testing & generating reports

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoBCDR
```

Gets the first 100 Datto BCDR devices

This function uses the -endpoint_Devices switch by default

### EXAMPLE 2
```powershell
Get-DattoBCDR -endpoint_Agents -serialNumber '12345678'
```

Returns a list of BCDR clients and the agents under those clients

As of 2022-04 this endpoint always returns no data

### EXAMPLE 3
```powershell
Get-DattoBCDR -endpoint_byDevice -serialNumber '12345678'
```

Returns a single BCDR device registered under your portal

### EXAMPLE 4
```powershell
Get-DattoBCDR -endpoint_byDeviceAgent -serialNumber '12345678'
```

Returns a list BCDR agents from a given device

### EXAMPLE 5
```powershell
Get-DattoBCDR -endpoint_byDeviceAlert -serialNumber '12345678'
```

Returns a list BCDR alerts from a given device

### EXAMPLE 6
```powershell
Get-DattoBCDR -endpoint_byDeviceAsset -serialNumber '12345678'
```

Returns a list BCDR agents & shares from a given device

### EXAMPLE 7
```powershell
Get-DattoBCDR -endpoint_byDeviceShare -serialNumber '12345678'
```

Returns a list BCDR shares from a given device

### EXAMPLE 8
```powershell
Get-DattoBCDR -endpoint_byDeviceVolume -serialNumber '12345678'
```

Returns a list BCDR volumes from a given device

## PARAMETERS

### -endpoint_Agents
Returns a list of BCDR clients and the agents under those clients

As of 2022-04 this endpoint always returns no data

Endpoint = /bcdr/agent

```yaml
Type: SwitchParameter
Parameter Sets: index_Agents
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_Devices
Returns a list of BCDR devices registered under your portal

Endpoint = /bcdr/device

```yaml
Type: SwitchParameter
Parameter Sets: index_Devices
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_byDevice
Returns a single BCDR device registered under your portal

Endpoint = /bcdr/device/{serialNumber}

```yaml
Type: SwitchParameter
Parameter Sets: index_byDevice
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_byDeviceAgent
Returns a list BCDR agents from a given device

Endpoint = /bcdr/device/{serialNumber}/asset/agent

```yaml
Type: SwitchParameter
Parameter Sets: index_byDeviceAgent
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_byDeviceAlert
Returns a list BCDR alerts from a given device

Endpoint = /bcdr/device/{serialNumber}/alert

```yaml
Type: SwitchParameter
Parameter Sets: index_byDeviceAlert
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_byDeviceAsset
Returns a list BCDR agents & shares from a given device

Endpoint = /bcdr/device/{serialNumber}/asset

```yaml
Type: SwitchParameter
Parameter Sets: index_byDeviceAsset
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_byDeviceShare
Returns a list BCDR shares from a given device

Endpoint = /bcdr/device/{serialNumber}/asset/share

```yaml
Type: SwitchParameter
Parameter Sets: index_byDeviceShare
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -endpoint_byDeviceVolume
Returns a list BCDR volumes from a given device

Endpoint = /bcdr/device/{serialNumber}/asset/volume

```yaml
Type: SwitchParameter
Parameter Sets: index_byDeviceVolume
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -serialNumber
Defines the BCDR serial number to get information from

The parameter is mandatory if you want to get a specific device.

```yaml
Type: String
Parameter Sets: index_byDevice, index_byDeviceAgent, index_byDeviceAlert, index_byDeviceAsset, index_byDeviceShare, index_byDeviceVolume
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
Parameter Sets: index_Devices
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
Parameter Sets: index_Devices
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -volumeName
Gets an asset(s)(agent or share) for a specific volume on a device

```yaml
Type: String
Parameter Sets: index_byDeviceVolume
Aliases:

Required: True
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
Parameter Sets: index_Devices, index_Agents, index_byDeviceAgent, index_byDeviceAlert, index_byDeviceAsset, index_byDeviceShare
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
Parameter Sets: index_Devices, index_Agents, index_byDeviceAgent, index_byDeviceAlert, index_byDeviceAsset, index_byDeviceShare
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
Parameter Sets: index_Devices, index_Agents, index_byDeviceAgent, index_byDeviceAlert, index_byDeviceAsset, index_byDeviceShare
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

