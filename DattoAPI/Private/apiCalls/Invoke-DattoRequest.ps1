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

    begin {}

    process {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

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
                "Headers"   = @{ 'Authorization' = 'Basic {0}'-f $Api_Token_base64; 'Content-Type' = 'application/json' }
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
            [void] ( $Datto_invokeParameters.Remove('Authorization') )
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

    end {}

}