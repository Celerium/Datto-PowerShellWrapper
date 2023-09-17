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

    begin {}

    process {

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

    end {}

}