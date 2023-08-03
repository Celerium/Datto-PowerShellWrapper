function ConvertTo-QueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-ApiRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-ApiRequest & any public functions that define parameters

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-QueryString -uri_Filter $uri_Filter -resource_Uri '/account'

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
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/ConvertTo-QueryString.html

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



function Invoke-ApiRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-ApiRequest cmdlet invokes an API request to Datto API.

        This is an internal function that is used by all public functions

        As of 2023-08 the Datto v1 API only supports GET requests

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER resource_Uri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uri_Filter
        Used with the internal function [ ConvertTo-QueryString ] to combine
        a functions parameters with the resource_Uri parameter.

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $Datto_Base_URI + $resource_Uri + ConvertTo-QueryString

    .PARAMETER data
        Place holder parameter to use when other methods are supported
        by the Datto v1 API

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Invoke-ApiRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter

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
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Invoke-ApiRequest.html

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

        $query_string = ConvertTo-QueryString -uri_Filter $uri_Filter -resource_Uri $resource_Uri

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
                '*404*' { Write-Error "Invoke-ApiRequest : [ $resource_Uri ] not found!" }
                '*429*' { Write-Error 'Invoke-ApiRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-ApiRequest : Gateway Timeout" }
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



function Get-InvokeMetaData {
<#
    .SYNOPSIS
        Gets various Api metadata values

    .DESCRIPTION
        The Get-InvokeMetaData cmdlet gets various Api metadata values from an
        Invoke-WebRequest to assist in various troubleshooting scenarios such
        as rate-limiting.

    .PARAMETER base_uri
        Define the base URI for the Datto API connection using Datto's URI or a custom URI.

        The default base URI is https://api.datto.com/v1

    .EXAMPLE
        Get-InvokeMetaData

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The default full base uri test path is:
            https://api.datto.com/v1

    .EXAMPLE
        Get-InvokeMetaData -base_uri http://myapi.gateway.example.com

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-InvokeMetaData.html
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