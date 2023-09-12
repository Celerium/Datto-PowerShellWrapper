#Region '.\Private\apiCalls\ConvertTo-DattoQueryString.ps1' 0
function ConvertTo-DattoQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-DattoRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-DattoRequest & any public functions that define parameters

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-DattoQueryString -uri_Filter $uri_Filter -resource_Uri '/account'

        Example: (From public function)
            $uri_Filter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
                if( $excludedParameters -contains $Key.Key ){$null}
                else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://api.datto.com/v1/account?accountId=12345
            2x key = https://api.datto.com/v1/account?accountId=12345&details=True

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/ConvertTo-DattoQueryString.html

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [hashtable]$uri_Filter,

    [Parameter(Mandatory = $true)]
    [String]$resource_Uri
)

    begin{}

    process{

        if (-not $uri_Filter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages', 'page', 'perPage',
                                'endpoint_Agents', 'endpoint_Devices', 'endpoint_byDevice', 'endpoint_byDeviceAgent',
                                'endpoint_byDeviceAlert', 'endpoint_byDeviceAsset', 'endpoint_byDeviceShare', 'endpoint_byDeviceVolume',
                                'endpoint_Domains', 'endpoint_CustomerSeats', 'endpoint_CustomerApps', 'saasCustomerId'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        ForEach ( $Key in $uri_Filter.GetEnumerator() ){

            if( $excludedParameters -contains $Key.Key ){$null}
            elseif ( $Key.Value.GetType().IsArray ){
                Write-Verbose "[ $($Key.Key) ] is an array parameter"
                foreach ($Value in $Key.Value) {
                    #$ParameterName = $Key.Key
                    $query_Parameters.Add($Key.Key, $Value)
                }
            }
            else{
                $query_Parameters.Add($Key.Key, $Key.Value)
            }

        }

        # Build the request and load it with the query string.
        $uri_Request        = [System.UriBuilder]($Datto_Base_URI + $resource_Uri)
        $uri_Request.Query  = $query_Parameters.ToString()

        return $uri_Request

    }

    end{}

}
#EndRegion '.\Private\apiCalls\ConvertTo-DattoQueryString.ps1' 98
#Region '.\Private\apiCalls\Get-DattoMetaData.ps1' 0
function Get-DattoMetaData {
<#
    .SYNOPSIS
        Gets various Api metadata values

    .DESCRIPTION
        The Get-DattoMetaData cmdlet gets various Api metadata values from an
        Invoke-WebRequest to assist in various troubleshooting scenarios such
        as rate-limiting.

    .PARAMETER base_uri
        Define the base URI for the Datto API connection using Datto's URI or a custom URI.

        The default base URI is https://api.datto.com/v1

    .EXAMPLE
        Get-DattoMetaData

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The default full base uri test path is:
            https://api.datto.com/v1

    .EXAMPLE
        Get-DattoMetaData -base_uri http://myapi.gateway.example.com

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoMetaData.html
#>

    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$base_uri = $Datto_Base_URI
    )

    begin { $resource_uri = "/bcdr/agent" }

    process {

        try {

            $Api_Token = Get-DattoAPIKey -plainText
            $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).PublicKey,($Api_Token).SecretKey) ) )

            $Datto_Headers.Add('Authorization', 'Basic {0}'-f $Api_Token_base64)

            $rest_output = Invoke-WebRequest -method Get -uri ($base_uri + $resource_uri) -headers $Datto_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($Datto_Base_URI + $resource_uri)
            }

        }
        finally {
            [void] ( $Datto_Headers.Remove('Authorization') )
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                ResponseUri             = $data.BaseResponse.ResponseUri.AbsoluteUri
                ResponsePort            = $data.BaseResponse.ResponseUri.Port
                StatusCode              = $data.StatusCode
                StatusDescription       = $data.StatusDescription
                'Content-Type'          = $data.headers.'Content-Type'
                'X-Request-Id'          = $data.headers.'X-Request-Id'
                'X-API-Limit-Remaining' = $data.headers.'X-API-Limit-Remaining'
                'X-API-Limit-Resets'    = $data.headers.'X-API-Limit-Resets'
                'X-API-Limit-Cost'      = $data.headers.'X-API-Limit-Cost'
                raw                     = $data
            }
        }

    }

    end {}
}
#EndRegion '.\Private\apiCalls\Get-DattoMetaData.ps1' 97
#Region '.\Private\apiCalls\Invoke-DattoRequest.ps1' 0
function Invoke-DattoRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-DattoRequest cmdlet invokes an API request to Datto API.

        This is an internal function that is used by all public functions

        As of 2023-08 the Datto v1 API only supports GET requests

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER resource_Uri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uri_Filter
        Used with the internal function [ ConvertTo-DattoQueryString ] to combine
        a functions parameters with the resource_Uri parameter.

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $Datto_Base_URI + $resource_Uri + ConvertTo-DattoQueryString

    .PARAMETER data
        Place holder parameter to use when other methods are supported
        by the Datto v1 API

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Invoke-DattoRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter

        Invoke a rest method against the defined resource using any of the provided parameters

        Example:
            Name                           Value
            ----                           -----
            Method                         GET
            Uri                            https://api.datto.com/v1/account?accountId=12345&details=True
            Headers                        {Authorization = Bearer 123456789}
            Body


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Invoke-DattoRequest.html

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('GET')]
        [String]$method = 'GET',

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri,

        [Parameter(Mandatory = $false)]
        [Hashtable]$uri_Filter = $null,

        [Parameter(Mandatory = $false)]
        [Hashtable]$data = $null,

        [Parameter(Mandatory = $false)]
        [Switch]$allPages

    )

    begin{}

    process{

        $query_string = ConvertTo-DattoQueryString -uri_Filter $uri_Filter -resource_Uri $resource_Uri

        Set-Variable -Name 'Datto_queryString' -Value $query_string -Scope Global -Force

        if ($null -eq $data) {
            $body = $null
        } else {
            $body = @{'data'= $data} | ConvertTo-Json -Depth $Datto_JSON_Conversion_Depth
        }

        try {
            $Api_Token = Get-DattoAPIKey -PlainText
            $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).PublicKey,($Api_Token).SecretKey) ) )

            $parameters = [ordered] @{
                "Method"    = $method
                "Uri"       = $query_string.Uri
                "Headers"   = @{ 'Authorization' = 'Basic {0}'-f $Api_Token_base64 }
                "Body"      = $body
            }
            Set-Variable -Name 'Datto_invokeParameters' -Value $parameters -Scope Global -Force

            if ($allPages){

                Write-Verbose "Gathering all items from [  $( $Datto_Base_URI + $resource_Uri ) ] "

                $page_number = 1
                $all_responseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $parameters['Uri'] = $query_string.Uri -replace '_page=\d+',"_page=$page_number"

                    $current_page = Invoke-RestMethod @parameters -ErrorAction Stop

                    Write-Verbose "[ $page_number ] of [ $($current_page.pagination.totalPages) ] pages"

                        foreach ($item in $current_page.items){
                            $all_responseData.add($item)
                        }

                    $page_number++

                } while ($current_page.pagination.totalPages -ne $page_number - 1 -and $current_page.pagination.totalPages -ne 0)

            }
            else{
                $api_response = Invoke-RestMethod @parameters -ErrorAction Stop
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ Datto_invokeParameters, Datto_queryString, & Datto_CmdletNameParameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*404*' { Write-Error "Invoke-DattoRequest : [ $resource_Uri ] not found!" }
                '*429*' { Write-Error 'Invoke-DattoRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-DattoRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

        }
        finally {
            [void] ( $Datto_Headers.Remove('Authorization') )
        }


        if($allPages){

            #Making output consistent
            if( [string]::IsNullOrEmpty($all_responseData.data) ){
                $api_response = $null
            }
            else{
                $api_response = [PSCustomObject]@{
                    data = $all_responseData
                }
            }

            return $api_response

        }
        else{ return $api_response }

    }

    end{}

}
#EndRegion '.\Private\apiCalls\Invoke-DattoRequest.ps1' 178
#Region '.\Private\apiKeys\Add-DattoAPIKey.ps1' 0
function Add-DattoAPIKey {
<#
    .SYNOPSIS
        Sets the API public & secret keys used to authenticate API calls.

    .DESCRIPTION
        The Add-DattoAPIKey cmdlet sets the API public & secret keys which are used to
        authenticate all API calls made to Datto.

        Once the API public & secret keys are defined, the secret key is encrypted using SecureString.

        The Datto API public & secret keys are generated via the Datto portal at Admin > Integrations

    .PARAMETER Api_Key_Public
        Defines your API public key.

    .PARAMETER Api_Key_Secret
        Defines your API secret key.

    .EXAMPLE
        Add-DattoAPIKey

        Prompts to enter in the API public key and secret key.

    .EXAMPLE
        Add-DattoAPIKey -Api_Key_Public '12345'

        The Datto API will use the string entered into the [ -Api_Key_Public ] parameter as the
        public key & will then prompt to enter in the secret key.

    .EXAMPLE
        '12345' | Add-DattoAPIKey

        The Datto API will use the string entered as the secret key & will prompt to enter in the public key.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Api_Key_Public,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Api_Key_Secret
    )

    if ($Api_Key_Secret) {
        $x_api_key = ConvertTo-SecureString $Api_Key_Secret -AsplainText -Force

        Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
    else {
        $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

        Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
}

New-Alias -Name Set-DattoAPIKey -Value Add-DattoAPIKey -Force
#EndRegion '.\Private\apiKeys\Add-DattoAPIKey.ps1' 69
#Region '.\Private\apiKeys\Get-DattoAPIKey.ps1' 0
function Get-DattoAPIKey {
<#
    .SYNOPSIS
        Gets the Datto API public & secret key global variables.

    .DESCRIPTION
        The Get-DattoAPIKey cmdlet gets the Datto API public & secret key
        global variables and returns them as an object.

    .PARAMETER plainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-DattoAPIKey

        Gets the Datto API public & secret key global variables and returns them as an object
        with the secret key as a SecureString.

    .EXAMPLE
        Get-DattoAPIKey -plainText

        Gets the Datto API public & secret key global variables and returns them as an object
        with the secret key as plain text.


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [Switch]$plainText
    )

    begin {}

    process{

        try {

            if ($Datto_Secret_Key){

                if ($plainText){
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Datto_Secret_Key)

                    [PSCustomObject]@{
                        PublicKey = $Datto_Public_Key
                        SecretKey = ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                    }
                }
                else {
                    [PSCustomObject]@{
                        PublicKey = $Datto_Public_Key
                        SecretKey = $Datto_Secret_Key
                    }
                }

            }
            else { Write-Warning "The Datto API [ secret ] key is not set. Run Add-DattoAPIKey to set the API key." }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }


    }

    end{}

}
#EndRegion '.\Private\apiKeys\Get-DattoAPIKey.ps1' 81
#Region '.\Private\apiKeys\Remove-DattoAPIKey.ps1' 0
function Remove-DattoAPIKey {
<#
    .SYNOPSIS
        Removes the Datto API public & secret key global variables.

    .DESCRIPTION
        The Remove-DattoAPIKey cmdlet removes the Datto API public & secret key global variables.

    .EXAMPLE
        Remove-DattoAPIKey

        Removes the Datto API public & secret key global variables.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoAPIKey.html
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    switch ([bool]$Datto_Public_Key) {
        $true   { Remove-Variable -Name "Datto_Public_Key" -Scope global -Force }
        $false  { Write-Warning "The Datto API [ public ] key is not set. Nothing to remove" }
    }

    switch ([bool]$Datto_Secret_Key) {
        $true   { Remove-Variable -Name "Datto_Secret_Key" -Scope global -Force }
        $false  { Write-Warning "The Datto API [ secret ] key is not set. Nothing to remove" }
    }

}
#EndRegion '.\Private\apiKeys\Remove-DattoAPIKey.ps1' 35
#Region '.\Private\apiKeys\Test-DattoAPIKey.ps1' 0
function Test-DattoAPIKey {
<#
    .SYNOPSIS
        Test the Datto API public & secret keys.

    .DESCRIPTION
        The Test-DattoAPIKey cmdlet tests the base URI & API public & secret keys that were defined in the
        Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the Datto API connection using Datto's URI or a custom URI.

        The default base URI is https://api.datto.com/v1/bcdr

    .EXAMPLE
        Test-DattoBaseURI

        Tests the base URI & API access token that was defined in the
        Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

        The default full base uri test path is:
            https://api.datto.com/v1/bcdr/device

    .EXAMPLE
        Test-DattoBaseURI -base_uri http://myapi.gateway.example.com

        Tests the base URI & API access token that was defined in the
        Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Test-DattoAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline = $true)]
        [string]$base_uri = $Datto_Base_URI
    )

    $resource_uri = "/bcdr/agent"

    try {

        $Api_Token = Get-DattoAPIKey -plainText
        $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).PublicKey,($Api_Token).SecretKey) ) )

        $Datto_Headers.Add('Authorization', 'Basic {0}'-f $Api_Token_base64)

        $rest_output = Invoke-WebRequest -method Get -uri ($base_uri + $resource_uri) -headers $Datto_Headers -ErrorAction Stop
    }
    catch {

        [PSCustomObject]@{
            Method = $_.Exception.Response.Method
            StatusCode = $_.Exception.Response.StatusCode.value__
            StatusDescription = $_.Exception.Response.StatusDescription
            Message = $_.Exception.Message
            URI = $($Datto_Base_URI + $resource_uri)
        }

    }
    finally {
        [void] ( $Datto_Headers.Remove('Authorization') )
    }

    if ($rest_output){
        $data = @{}
        $data = $rest_output

        [PSCustomObject]@{
            StatusCode = $data.StatusCode
            StatusDescription = $data.StatusDescription
            URI = $($Datto_Base_URI + $resource_uri)
        }
    }
}
#EndRegion '.\Private\apiKeys\Test-DattoAPIKey.ps1' 83
#Region '.\Private\baseUri\Add-DattoBaseURI.ps1' 0
function Add-DattoBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the Datto API connection.

    .DESCRIPTION
        The Add-DattoBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the Datto API connection using Datto's URI or a custom URI.

    .PARAMETER data_center
        Datto's URI connection point that can be one of the predefined data centers.

        The accepted values for this parameter are:
        [ US ]
            US = https://api.datto.com/v1

        Placeholder for other data centers.

    .EXAMPLE
        Add-DattoBaseURI

        The base URI will use https://api.datto.com/v1 which is Datto's default URI.

    .EXAMPLE
        Add-DattoBaseURI -data_center US

        The base URI will use https://api.datto.com/v1 which is Datto's US URI.

    .EXAMPLE
        Add-DattoBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to Datto's API.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoBaseURI.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$base_uri = 'https://api.datto.com/v1',

        [ValidateSet( 'US' )]
        [String]$data_center
    )

    # Trim superfluous forward slash from address (if applicable)
    if ($base_uri[$base_uri.Length-1] -eq "/") {
        $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
    }

    switch ($data_center) {
        'US' { $base_uri = 'https://api.datto.com/v1' }
    }

    Set-Variable -Name "Datto_Base_URI" -Value $base_uri -Option ReadOnly -Scope global -Force
}

New-Alias -Name Set-DattoBaseURI -Value Add-DattoBaseURI
#EndRegion '.\Private\baseUri\Add-DattoBaseURI.ps1' 66
#Region '.\Private\baseUri\Get-DattoBaseURI.ps1' 0
function Get-DattoBaseURI {
<#
    .SYNOPSIS
        Shows the Datto base URI global variable.

    .DESCRIPTION
        The Get-DattoBaseURI cmdlet shows the Datto base URI global variable value.

    .EXAMPLE
        Get-DattoBaseURI

        Shows the Datto base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoBaseURI.html
#>

    [cmdletbinding()]
    Param ()

    switch ([bool]$Datto_Base_URI) {
        $true   { $Datto_Base_URI }
        $false  { Write-Warning "The Datto base URI is not set. Run Add-DattoBaseURI to set the base URI." }
    }

}
#EndRegion '.\Private\baseUri\Get-DattoBaseURI.ps1' 30
#Region '.\Private\baseUri\Remove-DattoBaseURI.ps1' 0
function Remove-DattoBaseURI {
<#
    .SYNOPSIS
        Removes the Datto base URI global variable.

    .DESCRIPTION
        The Remove-DattoBaseURI cmdlet removes the Datto base URI global variable.

    .EXAMPLE
        Remove-DattoBaseURI

        Removes the Datto base URI global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoBaseURI.html
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    switch ([bool]$Datto_Base_URI) {
        $true   { Remove-Variable -Name "Datto_Base_URI" -Scope global -Force }
        $false  { Write-Warning "The Datto base URI variable is not set. Nothing to remove" }
    }

}
#EndRegion '.\Private\baseUri\Remove-DattoBaseURI.ps1' 30
#Region '.\Private\moduleSettings\Export-DattoModuleSettings.ps1' 0
function Export-DattoModuleSettings {
<#
    .SYNOPSIS
        Exports the Datto BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-DattoModuleSettings cmdlet exports the Datto BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER DattoConfPath
        Define the location to store the Datto configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfFile
        Define the name of the Datto configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-DattoModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's Datto configuration file located at:
            $env:USERPROFILE\DattoAPI\config.psd1

    .EXAMPLE
        Export-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's Datto configuration file located at:
            C:\DattoAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Export-DattoModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfFile = 'config.psd1'
    )

    # Confirm variables exist and are not null before exporting
    if ($Datto_Base_URI -and $Datto_Public_Key -and $Datto_Secret_Key -and $Datto_JSON_Conversion_Depth) {
        $secureString = $Datto_Secret_Key | ConvertFrom-SecureString
        New-Item -Path $DattoConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = 'hidden' }
@"
    @{
        Datto_Base_URI = '$Datto_Base_URI'
        Datto_Public_Key = '$Datto_Public_Key'
        Datto_Secret_Key = '$secureString'
        Datto_JSON_Conversion_Depth = '$Datto_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath ($DattoConfPath + "\" + $DattoConfFile) -Force

    }
    else {
        Write-Error $_
        Write-Error "Failed to export Datto Module settings to [ $DattoConfPath\$DattoConfFile ]"
    }
}
#EndRegion '.\Private\moduleSettings\Export-DattoModuleSettings.ps1' 74
#Region '.\Private\moduleSettings\Get-DattoModuleSettings.ps1' 0
function Get-DattoModuleSettings {
<#
    .SYNOPSIS
        Gets the saved Datto configuration settings

    .DESCRIPTION
        The Get-DattoModuleSettings cmdlet gets the saved Datto configuration settings
        from the local system.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfPath
        Define the location to store the Datto configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfFile
        Define the name of the Datto configuration file.

        By default the configuration file is named:
            config.psd1

    .PARAMETER openConfFile
        Opens the Datto configuration file

    .EXAMPLE
        Get-DattoModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-DattoModuleSettings

        The default location of the Datto configuration file is:
            $env:USERPROFILE\DattoAPI\config.psd1

    .EXAMPLE
        Get-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the Datto configuration file in this example is:
            C:\DattoAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$DattoConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin{}

    process{

        if ( Test-Path -Path $($DattoConfPath + '\' + $DattoConfFile) ){

            if($openConfFile){
                Invoke-Item -Path $($DattoConfPath + '\' + $DattoConfFile)
            }
            else{
                Import-LocalizedData -BaseDirectory $DattoConfPath -FileName $DattoConfFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $DattoConfPath\$DattoConfFile ]"
        }

    }

    end{}

}
#EndRegion '.\Private\moduleSettings\Get-DattoModuleSettings.ps1' 87
#Region '.\Private\moduleSettings\Import-DattoModuleSettings.ps1' 0
function Import-DattoModuleSettings {
<#
    .SYNOPSIS
        Imports the Datto BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-DattoModuleSettings cmdlet imports the Datto BaseURI, API, & JSON configuration
        information stored in the Datto configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfPath
        Define the location to store the Datto configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfFile
        Define the name of the Datto configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-DattoModuleSettings

        Validates that the configuration file created with the Export-DattoModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the Datto configuration file is:
            $env:USERPROFILE\DattoAPI\config.psd1

    .EXAMPLE
        Import-DattoModuleSettings -DattoConfPath C:\DattoAPI -DattoConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-DattoModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the Datto configuration file in this example is:
            C:\DattoAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Import-DattoModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfFile = 'config.psd1'
    )

    if ( test-path ($DattoConfPath + "\" + $DattoConfFile) ) {
        $tmp_config = Import-LocalizedData -BaseDirectory $DattoConfPath -FileName $DattoConfFile

        # Send to function to strip potentially superfluous slash (/)
        Add-DattoBaseURI $tmp_config.Datto_Base_URI

        $tmp_config.Datto_Secret_Key = ConvertTo-SecureString $tmp_config.Datto_Secret_Key

        Set-Variable -Name "Datto_Public_Key" -Value $tmp_config.Datto_Public_key -Option ReadOnly -Scope global -Force

        Set-Variable -Name "Datto_Secret_Key" -Value $tmp_config.Datto_Secret_Key -Option ReadOnly -Scope global -Force

        Set-Variable -Name "Datto_JSON_Conversion_Depth" -Value $tmp_config.Datto_JSON_Conversion_Depth -Scope global -Force

        Write-Verbose "DattoAPI Module configuration loaded successfully from [ $DattoConfPath\$DattoConfFile ]"

        # Clean things up
        Remove-Variable "tmp_config"
    }
    else {
        Write-Verbose "No configuration file found at [ $DattoConfPath\$DattoConfFile ] run Add-DattoAPIKey to get started."

        Add-DattoBaseURI

        Set-Variable -Name "Datto_Base_URI" -Value $(Get-DattoBaseURI) -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_JSON_Conversion_Depth" -Value 100 -Scope global -Force
    }
}
#EndRegion '.\Private\moduleSettings\Import-DattoModuleSettings.ps1' 87
#Region '.\Private\moduleSettings\Initialize-DattoModule.ps1' 0
function Initialize-DattoModule {
<#
    .SYNOPSIS
        Initialize the DattoAPI module

    .DESCRIPTION
        The Invoke-DattoRequest cmdlet initialize the DattoAPI module
        when the imported into the users session.

        Only used during the import of the module

    .EXAMPLE
        Initialize-DattoModule

        Initialize the DattoAPI module with starter values

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Initialize-DattoModule.html

#>

[CmdletBinding()]
param()

    begin{}

    process{

        $Datto_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $Datto_Headers.Add("Content-Type", 'application/json')

        Set-Variable -Name "Datto_Headers"  -Value $Datto_Headers -Scope global

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        Import-DattoModuleSettings

    }

    end{}

}
#EndRegion '.\Private\moduleSettings\Initialize-DattoModule.ps1' 49
#Region '.\Private\moduleSettings\Remove-DattoModuleSettings.ps1' 0
function Remove-DattoModuleSettings {
<#
    .SYNOPSIS
        Removes the stored Datto configuration folder.

    .DESCRIPTION
        The Remove-DattoModuleSettings cmdlet removes the Datto folder and its files.
        This cmdlet also has the option to remove sensitive Datto variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\DattoAPI

    .PARAMETER DattoConfPath
        Define the location of the Datto configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\DattoAPI

    .PARAMETER AndVariables
        Define if sensitive Datto variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-DattoModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the Datto configuration folder is:
            $env:USERPROFILE\DattoAPI

    .EXAMPLE
        Remove-DattoModuleSettings -DattoConfPath C:\DattoAPI -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive Datto variables exist then they are removed as well.

        The location of the Datto configuration folder in this example is:
            C:\DattoAPI

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoModuleSettings.html
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DattoConfPath = "$($env:USERPROFILE)\DattoAPI",

        [Parameter(ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    if (Test-Path $DattoConfPath) {

        Remove-Item -Path $DattoConfPath -Recurse -Force

        If ($AndVariables) {
            Remove-DattoAPIKey
            Remove-DattoBaseURI
        }

        if (!(Test-Path $DattoConfPath)) {
            Write-Output "The DattoAPI configuration folder has been removed successfully from [ $DattoConfPath ]"
        }
        else {
            Write-Error "The DattoAPI configuration folder could not be removed from [ $DattoConfPath ]"
        }

    }
    else {
        Write-Warning "No configuration folder found at [ $DattoConfPath ]"
    }
}
#EndRegion '.\Private\moduleSettings\Remove-DattoModuleSettings.ps1' 78
#Region '.\Public\BCDR\Get-DattoAgent.ps1' 0
function Get-DattoAgent {
<#
    .SYNOPSIS
        Get Datto BCDR agents from a given device

    .DESCRIPTION
        The Get-DattoAgent cmdlet get agents from a given BCDR device

        /bcdr/Agent - Does not return data
        /bcdr/device/serialNumber/Asset/Agent

        Can also gets a list of your clients and the agents under those clients.
        As of 2022-04 this endpoint does not return any data.

    .PARAMETER serialNumber
        Defines the BCDR serial number to get agents from

        The parameter is mandatory

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoAgent

        Gets a list of clients and the agents under those clients.

        As of 2022-04 this endpoint does not return any data.
        Leaving this here in the event Datto corrects this endpoint.

    .EXAMPLE
        Get-DattoAgent -serialNumber "12345678"

        Returns the agents from the defined Datto BCDR

    .EXAMPLE
        Get-DattoAgent -serialNumber "12345678" -page 2 -perPage 10

        Returns the first 10 agents from page 2 from the defined Datto BCDR

    .NOTES
        The /agent uri does NOT return any data as this appears to be a deprecated endpoint in the Datto API.
            The /asset/agent DOES return data.

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoAgent.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    #[Alias('Get-DattoBCDRAgent')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexByDevice')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [Parameter(Mandatory = $false, ParameterSetName = 'indexByDevice')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [Parameter(Mandatory = $false, ParameterSetName = 'indexByDevice')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false)]
        [Switch]$allPages
    )

    begin{

        switch ( [bool]$serialNumber ) {
            $true   { $resource_uri = "/bcdr/device/$serialNumber/asset/agent" }
            $false  { $resource_uri = "/bcdr/agent" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_agentParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
#EndRegion '.\Public\BCDR\Get-DattoAgent.ps1' 115
#Region '.\Public\BCDR\Get-DattoAlert.ps1' 0
function Get-DattoAlert {
<#
    .SYNOPSIS
        Gets Datto BCDR alerts for a given device.

    .DESCRIPTION
        The Get-DattoAlert cmdlet gets Datto BCDR alerts for a given device.

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

        The parameter is mandatory

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoAlert -serialNumber "12345678"

        Gets the Datto BCDR with the defined serialNumber and returns any alerts.

    .EXAMPLE
        Get-DattoAlert -serialNumber "12345678" -page 2 -pageSize 10

        Gets the Datto BCDR with the defined serialNumber
        with the first 10 alerts from the 2nd page of results.

    .NOTES
        PerPage always gets set to 100 regardless of value, appears this is not
        a valid parameter for this endpoint.

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoAlert.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$allPages
    )

    begin{

        $resource_uri = "/bcdr/device/$serialNumber/alert"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_alertParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
#EndRegion '.\Public\BCDR\Get-DattoAlert.ps1' 96
#Region '.\Public\BCDR\Get-DattoAsset.ps1' 0
function Get-DattoAsset {
<#
    .SYNOPSIS
        Get Datto BCDR assets (agents and shares) for a given device

    .DESCRIPTION
        The Get-DattoAsset cmdlet gets Datto BCDR assets (agents and shares)
        for a given device

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

        The parameter is mandatory

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoAsset -serialNumber "12345678"

        Gets the Datto BCDR with the defined serialNumber and returns any agents or shares.

    .EXAMPLE
        Get-DattoAsset -serialNumber "12345678" -page 2 -pageSize 10

        Gets the Datto BCDR with the defined serialNumber and returns
        the first 10 agents or shares from the 2nd page of results.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoAsset.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$allPages
    )

    begin{

        $resource_uri = "/bcdr/device/$serialNumber/asset"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_assetParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
#EndRegion '.\Public\BCDR\Get-DattoAsset.ps1' 96
#Region '.\Public\BCDR\Get-DattoBCDR.ps1' 0
function Get-DattoBCDR {
<#
    .SYNOPSIS
        Gets Datto BCDR devices and assets

    .DESCRIPTION
        The Get-DattoBCDR cmdlet gets Datto BCDR devices and assets by combing all endpoints
        into a single command.

        This unique function does not contain any Reporting or SaaS endpoints. This function
        was added to simply testing & generating reports

    .PARAMETER endpoint_Agents
        Returns a list of BCDR clients and the agents under those clients

        As of 2022-04 this endpoint always returns no data

        Endpoint = /bcdr/agent

    .PARAMETER endpoint_Devices
        Returns a list of BCDR devices registered under your portal

        Endpoint = /bcdr/device

    .PARAMETER endpoint_byDevice
        Returns a single BCDR device registered under your portal

        Endpoint = /bcdr/device/{serialNumber}

    .PARAMETER endpoint_byDeviceAgent
        Returns a list BCDR agents from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset/agent

    .PARAMETER endpoint_byDeviceAlert
        Returns a list BCDR alerts from a given device

        Endpoint = /bcdr/device/{serialNumber}/alert

    .PARAMETER endpoint_byDeviceAsset
        Returns a list BCDR agents & shares from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset

    .PARAMETER endpoint_byDeviceShare
        Returns a list BCDR shares from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset/share

    .PARAMETER endpoint_byDeviceVolume
        Returns a list BCDR volumes from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset/volume

    .PARAMETER serialNumber
        Defines the BCDR serial number to get information from

        The parameter is mandatory if you want to get a specific device.

    .PARAMETER showHiddenDevices
        Whether hidden devices should be included in your results

        Acceptable values are:
            '0', '1'

        By default '1' is returned by the API which shows hidden devices.

    .PARAMETER showChildResellerDevices
        Whether child reseller devices should be included in your results

        Acceptable values are:
            '0', '1'

        By default '1' is returned by the API which shows child reseller devices.

    .PARAMETER volumeName
        Gets an asset(s)(agent or share) for a specific volume on a device

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoBCDR

        Gets the first 100 Datto BCDR devices

        This function uses the -endpoint_Devices switch by default

    .EXAMPLE
        Get-DattoBCDR -endpoint_Agents -serialNumber '12345678'

        Returns a list of BCDR clients and the agents under those clients

        As of 2022-04 this endpoint always returns no data

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDevice -serialNumber '12345678'

        Returns a single BCDR device registered under your portal

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceAgent -serialNumber '12345678'

        Returns a list BCDR agents from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceAlert -serialNumber '12345678'

        Returns a list BCDR alerts from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceAsset -serialNumber '12345678'

        Returns a list BCDR agents & shares from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceShare -serialNumber '12345678'

        Returns a list BCDR shares from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceVolume -serialNumber '12345678'

        Returns a list BCDR volumes from a given device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoBCDR.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index_Devices')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'index_Agents')]
        [switch]$endpoint_Agents,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices')]
        [switch]$endpoint_Devices,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDevice')]
        [switch]$endpoint_byDevice,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceAgent')]
        [switch]$endpoint_byDeviceAgent,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceAlert')]
        [switch]$endpoint_byDeviceAlert,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceAsset')]
        [switch]$endpoint_byDeviceAsset,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceShare')]
        [switch]$endpoint_byDeviceShare,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceVolume')]
        [switch]$endpoint_byDeviceVolume,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDevice'        )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceAgent'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceAlert'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceAsset'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceShare'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceVolume'  )]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices')]
        [ValidateSet('0','1')]
        [string]$showHiddenDevices,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices')]
        [ValidateSet('0','1')]
        [string]$showChildResellerDevices,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceVolume')]
        [ValidateNotNullOrEmpty()]
        [string]$volumeName,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Agents'            )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices'           )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAgent'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAlert'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAsset'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceShare'     )]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Agents'            )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices'           )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAgent'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAlert'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAsset'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceShare'     )]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Agents'            )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices'           )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAgent'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAlert'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAsset'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceShare'     )]
        [Switch]$allPages
    )

    begin{

        switch ($PSCmdlet.ParameterSetName) {
            'index_Agents'          { $resource_uri = "/bcdr/agent" }
            'index_Devices'         { $resource_uri = "/bcdr/device" }
            'index_byDevice'        { $resource_uri = "/bcdr/device/$serialNumber" }
            'index_byDeviceAgent'   { $resource_uri = "/bcdr/device/$serialNumber/asset/agent" }
            'index_byDeviceAlert'   { $resource_uri = "/bcdr/device/$serialNumber/alert" }
            'index_byDeviceAsset'   { $resource_uri = "/bcdr/device/$serialNumber/asset" }
            'index_byDeviceShare'   { $resource_uri = "/bcdr/device/$serialNumber/asset/share" }
            'index_byDeviceVolume'  { $resource_uri = "/bcdr/device/$serialNumber/asset/$volumeName" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        if (($PSCmdlet.ParameterSetName -eq 'index_Agents') -or
            ($PSCmdlet.ParameterSetName -eq 'index_Devices') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceAgent') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceAlert') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceAsset') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceShare'))
        {

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }
        }

        Set-Variable -Name 'Datto_bcdrParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
#EndRegion '.\Public\BCDR\Get-DattoBCDR.ps1' 267
#Region '.\Public\BCDR\Get-DattoDevice.ps1' 0
function Get-DattoDevice {
<#
    .SYNOPSIS
        Gets Datto BCDR devices from the the Datto API.

    .DESCRIPTION
        The Get-DattoDevice cmdlet gets can get a one or more
        Datto BCDR devices.

        /bcdr/device - Returns all BCDR devices
        /bcdr/device/serialNumber - Returns a single BCDR device

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

        The parameter is mandatory if you want to get a specific device.

    .PARAMETER showHiddenDevices
        Whether hidden devices should be included in your results

        Acceptable values are:
            '0', '1'

        By default '1' is returned by the API which shows hidden devices.

    .PARAMETER showChildResellerDevices
        Whether child reseller devices should be included in your results

        Acceptable values are:
            '0', '1'

        By default '1' is returned by the API which shows child reseller devices.

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoDevice

        Gets the first 100 Datto BCDR devices with any hidden or child reseller devices.

    .EXAMPLE
        Get-DattoDevice -showHiddenDevices 0 -showChildResellerDevices 0

        Gets the first 100 Datto BCDR devices without any hidden or child reseller devices.

    .EXAMPLE
        Get-DattoDevice -page 2 -pageSize 10

        Gets the first 10 Datto BCDR devices from the second page.
        Hidden and child reseller devices will be included.

    .NOTES
        Setting some parameters to an [INT] causes them to not be added to the body. (Show*Devices)
        Documentation around the Show* endpoints just defines that an integer is accepted.
            In testing only 0 or 1 appear to do anything.

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoDevice.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexByDevice')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showHiddenDevices,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showChildResellerDevices,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$allPages
    )

    begin{

        switch ( [bool]$serialNumber ) {
            $true   { $resource_uri = "/bcdr/device/$serialNumber" }
            $false  { $resource_uri = "/bcdr/device" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_deviceParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
#EndRegion '.\Public\BCDR\Get-DattoDevice.ps1' 133
#Region '.\Public\BCDR\Get-DattoShare.ps1' 0
function Get-DattoShare {
<#
    .SYNOPSIS
        Gets Datto BCDR shares for a given device

    .DESCRIPTION
        The Get-DattoShare cmdlet gets Datto BCDR shares
        for a given device

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

        The parameter is mandatory

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoShare -serialNumber "12345678"

        Gets the Datto BCDR with the defined serialNumber and returns any shares.

    .EXAMPLE
        Get-DattoShare -serialNumber "12345678" -page 2 -pageSize 10

        Gets the Datto BCDR with the defined serialNumber
        with the first 10 shares from the 2nd page of results.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoShare.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$allPages
    )

    begin{

        $resource_uri = "/bcdr/device/$serialNumber/asset/share"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_assetShareParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
#EndRegion '.\Public\BCDR\Get-DattoShare.ps1' 96
#Region '.\Public\BCDR\Get-DattoVolume.ps1' 0
function Get-DattoVolume {
<#
    .SYNOPSIS
        Gets an asset(s)(agent or share) for a specific volume on a device

    .DESCRIPTION
        The Get-DattoVolume cmdlet gets an asset(s)(agent or share)
        for a specific volume on a device

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

        The parameter is mandatory

    .PARAMETER volumeName
        Defines the name (id) of the protected volume

        The content of the 'volume' field when calling /v1/bcdr/device/{serialNumber}/asset

        The parameter is mandatory

    .EXAMPLE
        Get-DattoVolume -serialNumber "12345678" -volumeName "0987654321"

        Gets the Datto BCDR with the defined serialNumber and returns any
        agents or shares for the defined volume.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVolume.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$volumeName
    )

    begin{

        $resource_uri = "/bcdr/device/$serialNumber/asset/$volumeName"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_assetVolumeParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
#EndRegion '.\Public\BCDR\Get-DattoVolume.ps1' 65
#Region '.\Public\Reporting\Get-DattoActivityLog.ps1' 0
function Get-DattoActivityLog {
<#
    .SYNOPSIS
        Gets a filtered list of activity logs ordered by date

    .DESCRIPTION
        The Get-DattoActivityLog cmdlet gets a filtered list of activity logs ordered by date

    .PARAMETER clientName
        Defines a client name with which to do a partial/prefix match

        2022-04: Filter does not appear to work

    .PARAMETER since
        Defines the number of days (unless overridden with sinceUnits), up until now,
        for which to produce logs

        Default value : 1

    .PARAMETER sinceUnits
        Defines the units to use for the since filter

        Available values : days, hours, minutes

        Default value : days

    .PARAMETER target
        Defines a comma-separated array of targetType:targetId tuples

        Example: bcdr-device:DC1234DC1234

        2022-04: Only works with 1 item in the array right now (See Notes)

    .PARAMETER targetType
        Defines the type of target for which to find activity logs

        Example : bcdr-device

    .PARAMETER  user
        Defines a username with which to do a partial/prefix match

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoActivityLog

        Gets the Datto BCDR platform activity logs from the past day.

    .EXAMPLE
        Get-DattoActivityLog -since 7 -sinceUnits days

        Gets the Datto BCDR platform activity logs from the past 7 day.

    .EXAMPLE
        Get-DattoActivityLog -user bob -since 7 -sinceUnits days

        Gets the Datto BCDR platform activity logs for the user named bob from the past 7 day.

    .EXAMPLE
        Get-DattoActivityLog -since 30 -sinceUnits days -target 'bcdr-device:D0123456789','bcdr-device:D9876543210'

        Gets the Datto BCDR platform activity logs from the defined targets for the past 30 day.

    .EXAMPLE
        Get-DattoActivityLog -since 30 -sinceUnits days -page 2 -pageSize 10

        Gets the Datto BCDR platform activity logs from the past 30 day.

        Returns the second page of 10 items.

    .NOTES
        As of 2022-04 the clientName parameter does not appear to be a working filter for this endpoint
            Cannot get the filter to returned data when run from Datto's own portal as well.

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Reporting/Get-DattoActivityLog.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$clientName,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$since = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [validateSet('days', 'hours', 'minutes')]
        [string]$sinceUnits = 'days',

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [string[]]$target,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$targetType,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$user,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [switch]$allPages
    )

    begin{

        $resource_uri = "/report/activity-log"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_activityLogParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
#EndRegion '.\Public\Reporting\Get-DattoActivityLog.ps1' 159
#Region '.\Public\SaaS\Get-DattoApplication.ps1' 0
function Get-DattoApplication {
<#
    .SYNOPSIS
        Get Datto SaaS protection backup data for a given customer

    .DESCRIPTION
        The Get-DattoApplication cmdlet gets Datto SaaS protection
        backup data for a given customer

    .PARAMETER saasCustomerId
        Defines the id of the customer to get SaaS information from

        The parameter is mandatory

    .EXAMPLE
        Get-DattoApplication -saasCustomerId "12345678"

        Gets the Datto SaaS protection backup data from the define customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId
    )

    begin{

        $resource_uri = "/saas/$saasCustomerId/applications"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_applicationParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}
}
#EndRegion '.\Public\SaaS\Get-DattoApplication.ps1' 52
#Region '.\Public\SaaS\Get-DattoDomain.ps1' 0
function Get-DattoDomain {
<#
    .SYNOPSIS
        Get Datto SaaS protection data about what domains are being protected

    .DESCRIPTION
        The Get-DattoDomain cmdlet gets SaaS protection data
        about what domains are being protected

    .EXAMPLE
        Get-DattoDomain

        Gets SaaS protection data about what domains are being protected

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoDomain.html
#>

    [CmdletBinding()]
    Param ()

    begin{

        $resource_uri = "/saas/domains"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_domainParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
#EndRegion '.\Public\SaaS\Get-DattoDomain.ps1' 44
#Region '.\Public\SaaS\Get-DattoSaaS.ps1' 0
function Get-DattoSaaS {
<#
    .SYNOPSIS
        Gets Datto SaaS protection data

    .DESCRIPTION
        The Get-DattoSaaS cmdlet gets Datto SaaS protection data by combing all endpoints
        into a single command.

        This unique function does not contain any BCDR or Reporting endpoints. This function
        was added to simply testing & generating reports

    .PARAMETER endpoint_Domains
        Returns SaaS protection data about what domains are being protected

        Endpoint = /SaaS/domains

    .PARAMETER endpoint_CustomerSeats
        Returns SaaS protection seats for a given customer

        Endpoint = /SaaS/domains/{sassCustomerId}/seats

    .PARAMETER endpoint_CustomerApps
        Returns SaaS protection backup data for a given customer

        Endpoint = /SaaS/domains/{sassCustomerId}/applications

    .PARAMETER saasCustomerId
        Defines the id of the customer to get SaaS information from

        The parameter is mandatory

    .EXAMPLE
        Get-DattoSaaS

        Returns SaaS protection data about what domains are being protected

        This function uses the -endpoint_Domains switch by default

    .EXAMPLE
        Get-DattoSaaS -endpoint_CustomerSeats -saasCustomerId 12345678

        Returns SaaS protection seats for a given customer

    .EXAMPLE
        Get-DattoSaaS -endpoint_CustomerApps -saasCustomerId 12345678

        Returns SaaS protection backup data for a given customer

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaS.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index_Domains')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Domains')]
        [switch]$endpoint_Domains,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byCustomerSeats')]
        [switch]$endpoint_CustomerSeats,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byCustomerApps')]
        [switch]$endpoint_CustomerApps,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byCustomerSeats' )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byCustomerApps'  )]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId
    )

    begin{

        switch ($PSCmdlet.ParameterSetName) {
            'index_Domains'         { $resource_uri = "/saas/domains" }
            'index_byCustomerSeats' { $resource_uri = "/saas/$saasCustomerId/seats" }
            'index_byCustomerApps'  { $resource_uri = "/saas/$saasCustomerId/applications" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_bcdrParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
#EndRegion '.\Public\SaaS\Get-DattoSaaS.ps1' 97
#Region '.\Public\SaaS\Get-DattoSeat.ps1' 0
function Get-DattoSeat {
<#
    .SYNOPSIS
        Get Datto SaaS protection seats for a given customer

    .DESCRIPTION
        The Get-DattoSeat cmdlet gets Datto SaaS protection seats
        for a given customer

    .PARAMETER saasCustomerId
        Defines the id of the customer to get SaaS information from

        The parameter is mandatory

    .EXAMPLE
        Get-DattoSeat -saasCustomerId "12345678"

        Gets the Datto SaaS protection seats from the define customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSeat.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId
    )

    begin{

        $resource_uri = "/saas/$saasCustomerId/seats"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_seatParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}
}
#EndRegion '.\Public\SaaS\Get-DattoSeat.ps1' 52
