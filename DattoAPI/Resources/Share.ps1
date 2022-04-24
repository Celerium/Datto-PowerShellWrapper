function Get-DattoShare {
<#
    .SYNOPSIS
        Gets Datto BCDR shares for a given device

    .DESCRIPTION
        The Get-DattoShare cmdlet gets Datto BCDR shares for a given device

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
        "name": "test-host",
        "volume": "4b65219643aa4bc78e359928ead7fab5",
        "localIp": "10.10.100.1",
        "os": "Windows 10",
        "protectedVolumesCount": 5,
        "unprotectedVolumesCount": 5,
        "protectedVolumeNames": [
        "string"
        ],
        "unprotectedVolumeNames": [
        "string"
        ],
        "agentVersion": "2.5.0.0",
        "isPaused": false,
        "isArchived": false,
        "latestOffsite": 1584817262,
        "localSnapshots": 5,
        "lastSnapshot": 1584817262,
        "lastScreenshotAttempt": 1584817262,
        "lastScreenshotAttemptStatus": true,
        "lastScreenshotUrl": "https://device.dattobackup.com/sirisReporting/image/latest/abcdefabcdefabcdef.png?cb=1234576",
        "fqdn": "test-host",
        "backups": [
        {
            "timestamp": "2020-04-29T14:01:03+00:00",
            "backup": {
            "status": "string",
            "errorMessage": "string"
            },
            "localVerification": {
            "status": "string",
            "errors": [
                {
                "errorType": "string",
                "errorMessage": "string"
                }
            ]
            },
            "advancedVerification": {
            "screenshotVerification": {
                "status": "string",
                "image": "string"
            }
            }
        }
        ]
    }

    .EXAMPLE
        Get-DattoShare -serialNumber "12345678"

        Gets the Datto BCDR with the defined serialNumber and returns any shares.

    .EXAMPLE
        Get-DattoShare -serialNumber "12345678" -page 2 -pageSize 10

        Gets the Datto BCDR with the defined serialNumber and returns any shares.
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

    $resource_uri = "/device/$serialNumber/asset/share"

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
