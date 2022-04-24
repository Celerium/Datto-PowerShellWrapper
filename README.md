# Datto API PowerShell Wrapper

This PowerShell module acts as a wrapper for the [Datto BCDR](https://www.datto.com/) API.

---

## Introduction

The Datto BCDR API offers users the ability to extract data from Datto into a third-party reporting tools.

- Full documentation for Datto's RESTful API can be found [here](https://portal.dattobackup.com/integrations/xml) *[ Requires a login ]*.

This module serves to abstract away the details of interacting with Datto's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using Datto's API to create documentation scripts, automation, and integrations.

### Function Naming

Datto features a REST API that makes use of common HTTPs GET actions. In order to maintain PowerShell best practices, only approved verbs are used.

- GET -> Get-

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `Datto` in an attempt to prevent naming problems.

For example, one might access the `/Device` API endpoint by running the following PowerShell command with the appropriate parameters:

```posh
Get-DattoDevice -serialNumber 12345
```

---

## Install & Import

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/DattoAPI) with the following command:

- :information_source: This module supports PowerShell 5.0+ and should work in PowerShell Core.

```posh
Install-Module -Name DattoAPI
```

If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *Master* branch and place the *DattoAPI* folder into the (default) `C:\Program Files\WindowsPowerShell\Modules` folder.

After installation (by either methods), load the module into your workspace:

```posh
Import-Module DattoAPI
```

---

## Initial Setup

After importing this module, you will need to configure both the *base URI* & *API access tokens* that are used to talk with the Datto API.

1. Run `Add-DattoBaseURI`
   - By default, Datto's `https://api.datto.com/v1/bcdr` uri is used.
   - If you have your own API gateway or proxy, you may put in your own custom uri by specifying the `-base_uri` parameter:
      -  `Add-DattoBaseURI -base_uri http://myapi.gateway.example.com`
<br><br>

2. Run `Add-DattoAPIKey -Api_Key_Public 12345 -Api_Key_Secret 123456789`
   - It will prompt you to enter in your API access tokens if you do not specify them.
   - Datto API access tokens are generated via the Datto portal at *Admin > Integrations*
<br><br>

[optional]

1. Run `Export-DattoModuleSettings`
   - This will create a config file at `%UserProfile%\DattoAPI` that securely holds the *base uri* & *API access tokens* information.
   - Next time you run `Import-Module -Name DattoAPI`, this configuration file will automatically be loaded.
      - :warning: Exporting module settings encrypts your API access tokens in a format that can **only be unencrypted with your Windows account**. It makes use of PowerShell's `System.Security.SecureString` type, which uses reversible encrypted tied to your user principal. This means that you cannot copy your configuration file to another computer or user account and expect it to work.
      - :warning: Exporting and importing module settings requires use of the `ConvertTo-SecureString` cmdlet, which is currently buggy in Linux & Mac PowerShell core ports.

---

## Usage

Calling an API resource is as simple as running `Get-Datto<resourceName>`

- The following is a table of supported functions and their corresponding API resources:
- Table entries with [ `-` ] indicate that the functionality is NOT supported by the Datto API at this time.

| API Resource    | Create    | Read                      | Update    | Delete    |
| --------------  | --------- | ------------------------- | --------- | --------- |
| ActivityLog     | -         | `Get-DattoActivityLog`    | -         | -         |
| Agent           | -         | `Get-DattoAgent`          | -         | -         |
| Alert           | -         | `Get-DattoAlert`          | -         | -         |
| Asset           | -         | `Get-DattoAsset`          | -         | -         |
| BCDR *          | -         | `Get-DattoBCDR`           | -         | -         |
| Device          | -         | `Get-DattoDevice`         | -         | -         |
| Share           | -         | `Get-DattoShare`          | -         | -         |
| Volume          | -         | `Get-DattoVolume`         | -         | -         |

:warning: `Get-DattoBCDR` is a special case. It is **NOT** an endpoint in Datto API. It is a single command the can run all other listed endpoints. I included it because it was a nice to have feature IMO.

Each `Get-Datto*` function will respond with the raw data that Datto's API provides. Returned data is mostly structured the same but can vary between commands.

- pagination - Information about the number of pages of results are available and other metadata.
- items - The actual information requested (this is what most people care about)

---

## Wiki & Help :blue_book:

Most resources allow for filters and parameters to be used to specify the desired output from Datto's API. Check out the wiki article on [Using Filters and Parameters](https://github.com/Celerium/Datto-PowerShellWrapper/wiki/Using-Filters-and-Parameters).

- A full list of functions can be retrieved by running `Get-Command -Module DattoAPI`.
- Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-DattoDevice
Get-Help Get-DattoDevice -Full
```

For more information about using this module, as well as examples and advanced functionality, check out the [wiki](https://github.com/Celerium/Datto-PowerShellWrapper/wiki)!

---

## ToDo List :dart:

- [ ] Build more robust Pester & ScriptAnalyzer tests
- [ ] Build a better API authentication parameters to more securely handle API keys
- [ ] Figure out how to do CI & PowerShell gallery automation
