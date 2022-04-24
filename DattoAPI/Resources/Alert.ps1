function Get-DattoAlert {
<#
    .SYNOPSIS
        Gets Datto BCDR alerts for a given device.

    .DESCRIPTION
        The Get-DattoAlert cmdlet gets Datto BCDR alerts for a given device.

    .PARAMETER serialNumber
        Defines the device's serial number

        The parameter is mandatory

    .PARAMETER page
        Defines the page number to return.

        The default value is 1

    .PARAMETER pageSize
        Defines the amount of items to return with each page.

        The default value is 100

    .EXAMPLE
        Example Response Body:

    {
        "pagination": {
            "page": 0,
            "perPage": 0,
            "totalPages": 0,
            "count": 0
    },
    "items": [
            {
                "type": "Device Not Seen Alert",
                "threshold": 60,
                "unit": "Minutes",
                "dateTriggered": "2018-08-28T19:00:16+00:00",
                "dateSent": "2018-08-28T19:00:16+00:00"
            }
        ]
    }

    .EXAMPLE
        Get-DattoAlert -serialNumber "12345678"

        Gets the Datto BCDR with the defined serialNumber and returns any alerts.

    .EXAMPLE
        Get-DattoAlert -serialNumber "12345678" -page 2 -pageSize 10

        Gets the Datto BCDR with the defined serialNumber and returns any alerts.
        The returned data will be paginated if _page or _perPage is specified.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(ParameterSetName = 'index', Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$pageSize = 100
    )

    $resource_uri = "/device/$serialNumber/alert"

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($serialNumber) {
            $body += @{'serialNumber' = $serialNumber}
        }
        if ($page) {
            $body += @{'_page' = $page}
        }
        if ($pageSize) {
            $body += @{'_perPage' = $pageSize}
        }
    }

    try {
        if ($null -eq $Datto_Public_Key -or $null -eq $Datto_Secret_Key) {
            throw "The Datto API keys are not set. Run Add-DattoAPIKey to set the API keys."
        }

        $Datto_Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Datto_Public_Key, $Datto_Secret_Key
        $Credentials = Get-Credential $Datto_Credentials

        $rest_output = Invoke-RestMethod    -method 'GET' -uri ( $Datto_Base_URI + $resource_uri ) -headers $Datto_Headers -Credential $Credentials `
            -body $body -ErrorAction Stop -ErrorVariable web_error
    }
    catch {
        Write-Error $_
    }
    finally {}

    $data = @{}
    $data = $rest_output
    return $data
}
