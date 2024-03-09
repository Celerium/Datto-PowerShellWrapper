---
title: Tracking CSV
parent: Home
nav_order: 2
---

# Tracking CSV

When updating the documentation for this project, the tracking CSV plays a huge part in organizing of the markdown documents. Any new functions or endpoints should be added to the tracking CSV when publishing an updated module or documentation version.

{: .warning }
I recommend downloading the CSV from the link provided rather then viewing the table below.

[Tracking CSV](https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/docs/Endpoints.csv)

---

## CSV markdown table

| Category  | EndpointUri                                                  | Method | Function                   | Complete | Notes                                                 |
| --------- | ------------------------------------------------------------ | ------ | -------------------------- | -------- | ----------------------------------------------------- |
| BCDR      | /bcdr/agent                                                  | GET    | Get-DattoAgent             | YES      | Used for Endpoint Backup for PC agents (EB4PC) |
| BCDR      | /bcdr/device/{serialNumber}/asset/agent                      | GET    | Get-DattoAgent             | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/alert                            | GET    | Get-DattoAlert             | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/asset                            | GET    | Get-DattoAsset             | YES      |                                                       |
| BCDR      | /bcdr/                                                       | GET    | Get-DattoBCDR              | YES      | Special command that combines all BCDR endpoints      |
| BCDR      | /bcdr/device                                                 | GET    | Get-DattoDevice            | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}                                  | GET    | Get-DattoDevice            | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/asset/share                      | GET    | Get-DattoShare             | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/vm-restores                      | GET    | Get-DattoVMRestore         | Yes      | Cannot fully validate at this time                    |
| BCDR      | /bcdr/device/{serialNumber}/asset/{volumeName}               | GET    | Get-DattoVolume            | YES      |                                                       |
| Internal  |                                                              | POST   | Add-DattoAPIKey            | YES      |                                                       |
| Internal  |                                                              | POST   | Add-DattoBaseURI           | YES      |                                                       |
| Internal  |                                                              | PUT    | ConvertTo-DattoQueryString | YES      |                                                       |
| Internal  |                                                              | GET    | Export-DattoModuleSettings | YES      |                                                       |
| Internal  |                                                              | GET    | Get-DattoAPIKey            | YES      |                                                       |
| Internal  |                                                              | GET    | Get-DattoBaseURI           | YES      |                                                       |
| Internal  |                                                              | GET    | Get-DattoMetaData          | YES      |                                                       |
| Internal  |                                                              | GET    | Get-DattoModuleSettings    | YES      |                                                       |
| Internal  |                                                              | GET    | Import-DattoModuleSettings | YES      |                                                       |
| Internal  |                                                              | GET    | Invoke-DattoRequest        | YES      |                                                       |
| Internal  |                                                              | DELETE | Remove-DattoAPIKey         | YES      |                                                       |
| Internal  |                                                              | DELETE | Remove-DattoBaseURI        | YES      |                                                       |
| Internal  |                                                              | DELETE | Remove-DattoModuleSettings | YES      |                                                       |
| Internal  |                                                              | GET    | Test-DattoAPIKey           | YES      |                                                       |
| Reporting | /report/activity-log                                         | GET    | Get-DattoActivityLog       | YES      |                                                       |
| SaaS      | /sass/{sassCustomerId}/applications                          | GET    | Get-DattoApplication       | YES      |                                                       |
| SaaS      | /saas/{saasCustomerId}/{externalSubscriptionId}/bulkSeatChange | PUT    | Set-DattoBulkSeatChange    | YES      |                                                       |
| SaaS      | /sass/domains                                                | GET    | Get-DattoDomain            | YES      |                                                       |
| SaaS      | /sass/                                                       | GET    | Get-DattoSaaS              | YES      | Special command that combines all SaaS endpoints      |
| SaaS      | /sass/{sassCustomerId}/seats                                 | GET    | Get-DattoSeat              | YES      |                                                       |
