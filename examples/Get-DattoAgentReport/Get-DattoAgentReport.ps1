<#
    .SYNOPSIS
        Gets a BCDR agent report from the Datto API.

    .DESCRIPTION
        The Get-DattoAgentReport script gets a BCDR agent report from the Datto API.

        Can be run against a single BCDR device or all BCDR devices registered in the Datto portal

        This is a proof of concept script. It is not intended to be used in production.

    .PARAMETER Api_Key_Public
        Defines your Datto API public key.

    .PARAMETER Api_Key_Secret
        Defines your Datto API secret key.

    .PARAMETER APIEndPoint
        Define what Datto endpoint to connect to.

        The default is https://api.datto.com/v1

    .PARAMETER serialNumber
        Defines the BCDR's serial number that  should be returned.

        This is optional. If not specified, all BCDR agents will be returned.

    .PARAMETER Report
        Defines if the script should output the results to a CSV, HTML or Both.

    .PARAMETER ShowReport
        Switch statement to open the report folder after the script runs.

    .EXAMPLE
        Get-DattoAgentReport -Api_Key_Public 12345 -Api_Key_Secret 12345

        Gets all BCDR agents from every registered BCDR in the Datto portal.

        Returned data is outputted to a CSV file.

    .EXAMPLE
        Get-DattoAgentReport -Api_Key_Public 12345 -Api_Key_Secret 12345 -serialNumber 1234567890

        Gets BCDR agents from the defined BCDR.

        Returned data is outputted to a CSV file.

    .EXAMPLE
        Get-DattoAgentReport -Api_Key_Public 12345 -Api_Key_Secret 12345 -Report All

        Gets all BCDR agents from every registered BCDR in the Datto portal.

        Returned data is outputted to both a CSV & HTML file.

    .NOTES
        N\A

    .LINK
        https://celerium.org/

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper

#>

#Requires -Version 5.1

#Region    [ Parameters ]

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Api_Key_Public,

        [Parameter(Mandatory=$True)]
        [string]$Api_Key_Secret,

        [Parameter(Mandatory=$false)]
        $APIEndpoint = 'https://api.datto.com/v1',

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory=$false)]
        [ValidateSet('All','CSV','HTML')]
        [String]$Report = 'CSV',

        [Parameter(Mandatory=$false)]
        [Switch]$ShowReport

    )

#EndRegion [ Parameters ]

''
Write-Output "Start - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
''

#Region    [ Prerequisites ]

    $ScriptName = 'Get-DattoAgentReport'
    $ReportFolderName = "$ScriptName-Report"
    $FileDate = Get-Date -Format 'yyyy-MM-dd-HHmm'
    $HTMLDate = (Get-Date -Format 'yyyy-MM-dd h:mmtt').ToLower()

    #Install Datto Module
    Try {
        If(Get-PackageProvider -ListAvailable -Name NuGet -ErrorAction Stop){}
        Else{
            Install-PackageProvider -Name NuGet -Confirm:$False
        }

        If(Get-Module -ListAvailable -Name DattoAPI) {
            Import-module DattoAPI -ErrorAction Stop
        }
        Else {
            Install-Module DattoAPI -Force -ErrorAction Stop
            Import-Module DattoAPI -ErrorAction Stop
        }
    }
    Catch {
        Write-Error $_
        break
    }


    #Settings Datto login information
    Add-DattoBaseURI -base_uri $APIEndpoint
    Add-DattoAPIKey -Api_Key_Public $Api_Key_Public -Api_Key_Secret $Api_Key_Secret -ErrorAction Stop


    #Define & create logging location
    Try{

        $Log = "C:\Audits\$ReportFolderName"

        If ($Report -ne 'Console'){
            $CSVReport  = "$Log\$ScriptName-$FileDate.csv"
            $HTMLReport = "$Log\$ScriptName-$FileDate.html"

            If ((Test-Path -Path $Log -PathType Container) -eq $false){
                New-Item -Path $Log -ItemType Directory > $Null
            }
        }
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion [ Prerequisites ]

Write-Output " - (1/3) - $(Get-Date -Format MM-dd-HH:mm) - Getting Datto agents from the API"

#Region     [ Datto API ]

    #Customize the results
    Try{

        if ($serialNumber){

            $DattoBCDR = Get-DattoDevice -serialNumber $serialNumber
            $DattoAgents = (Get-DattoAgent -serialNumber $serialNumber).items

            $DattoAgentResults = $DattoAgents | Select-Object `
                @{Name='resellerCompanyName';Expression={$DattoBCDR.resellerCompanyName}}, `
                @{Name='clientCompanyName';Expression={$DattoBCDR.clientCompanyName}}, `
                @{Name='BCDR';Expression={$DattoBCDR.Name}}, `
                @{Name='BCDRip';Expression={$DattoBCDR.internalIP}}, `
                @{Name='Model';Expression={$DattoBCDR.Model}}, `
                @{Name='serialNumber';Expression={$DattoBCDR.serialNumber}}, `
                @{Name='Agent';Expression={$_.name}}, `
                @{Name='AgentOS';Expression={$_.os}}, `
                @{Name='AgentVersion';Expression={$_.AgentVersion}}, `
                @{Name='AgentIP';Expression={$_.localIp}}, `
                @{Name='protectedVolumesCount';Expression={$_.protectedVolumesCount}}, `
                @{Name='unprotectedVolumesCount';Expression={$_.unprotectedVolumesCount}}, `
                @{Name='protectedVolumeNames';Expression={$_.protectedVolumeNames}}, `
                @{Name='unprotectedVolumeNames';Expression={$_.unprotectedVolumeNames}}, `
                @{Name='localSnapshots';Expression={$_.localSnapshots}}, `
                @{Name='latestOffsite';Expression={ (([System.DateTimeOffset]::FromUnixTimeSeconds($_.latestOffsite)).DateTime).ToString('yyyy-MM-dd-HHmm') }}, `
                @{Name='lastSnapshot';Expression={ (([System.DateTimeOffset]::FromUnixTimeSeconds($_.lastSnapshot)).DateTime).ToString('yyyy-MM-dd-HHmm') }}, `
                @{Name='lastScreenshotAttempt';Expression={ (([System.DateTimeOffset]::FromUnixTimeSeconds($_.lastScreenshotAttempt)).DateTime).ToString('yyyy-MM-dd-HHmm') }}, `
                @{Name='lastScreenshotAttemptStatus';Expression={$_.lastScreenshotAttemptStatus}}, `
                @{Name='isPaused';Expression={$_.isPaused}}, `
                @{Name='isArchived';Expression={$_.isArchived}}, `
                @{Name='volume';Expression={$_.volume}}, `
                @{Name='lastScreenshotUrl';Expression={$_.lastScreenshotUrl}}, `
                @{Name='backups';Expression={$_.backups}}


        }
        else{

            $DattoBCDR = (Get-DattoDevice).items
            $DattoAgentResults = ForEach ($BCDR in $DattoBCDR){

                $Agents = (Get-DattoAgent -serialNumber $BCDR.serialNumber).items

                $Agents | Select-Object `
                    @{Name='resellerCompanyName';Expression={$BCDR.resellerCompanyName}}, `
                    @{Name='clientCompanyName';Expression={$BCDR.clientCompanyName}}, `
                    @{Name='BCDR';Expression={$BCDR.Name}}, `
                    @{Name='BCDRip';Expression={$BCDR.internalIP}}, `
                    @{Name='Model';Expression={$BCDR.Model}}, `
                    @{Name='serialNumber';Expression={$BCDR.serialNumber}}, `
                    @{Name='Agent';Expression={$_.name}}, `
                    @{Name='AgentOS';Expression={$_.os}}, `
                    @{Name='AgentVersion';Expression={$_.AgentVersion}}, `
                    @{Name='AgentIP';Expression={$_.localIp}}, `
                    @{Name='protectedVolumesCount';Expression={$_.protectedVolumesCount}}, `
                    @{Name='unprotectedVolumesCount';Expression={$_.unprotectedVolumesCount}}, `
                    @{Name='protectedVolumeNames';Expression={$_.protectedVolumeNames}}, `
                    @{Name='unprotectedVolumeNames';Expression={$_.unprotectedVolumeNames}}, `
                    @{Name='localSnapshots';Expression={$_.localSnapshots}}, `
                    @{Name='latestOffsite';Expression={ (([System.DateTimeOffset]::FromUnixTimeSeconds($_.latestOffsite)).DateTime).ToString('yyyy-MM-dd-HHmm') }}, `
                    @{Name='lastSnapshot';Expression={ (([System.DateTimeOffset]::FromUnixTimeSeconds($_.lastSnapshot)).DateTime).ToString('yyyy-MM-dd-HHmm') }}, `
                    @{Name='lastScreenshotAttempt';Expression={ (([System.DateTimeOffset]::FromUnixTimeSeconds($_.lastScreenshotAttempt)).DateTime).ToString('yyyy-MM-dd-HHmm') }}, `
                    @{Name='lastScreenshotAttemptStatus';Expression={$_.lastScreenshotAttemptStatus}}, `
                    @{Name='isPaused';Expression={$_.isPaused}}, `
                    @{Name='isArchived';Expression={$_.isArchived}}, `
                    @{Name='volume';Expression={$_.volume}}, `
                    @{Name='lastScreenshotUrl';Expression={$_.lastScreenshotUrl}}, `
                    @{Name='backups';Expression={$_.backups}}

            }
        }
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion  [ Datto API ]

#Region     [ CSV Report ]
    Try{
        If($Report -eq 'All' -or $Report -eq 'CSV'){
            Write-Output " - (2/3) - $(Get-Date -Format MM-dd-HH:mm) - Generating CSV"
            $DattoAgentResults | Sort-Object clientCompanyName | Select-Object $ScriptName,* | Export-Csv $CSVReport -NoTypeInformation
        }
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion  [ CSV Report ]

#Region    [ HTML Report]

    Try{
        If ($Report -eq 'All' -or $Report -eq 'HTML'){
            Write-Output " - (3/3) - $(Get-Date -Format MM-dd-HH:mm) - Generating HTML"

            #HTML card header data to highlight useful information
            $TotalAgents                = ($DattoBCDR.agentCount | Measure-Object -Sum).sum
            $AgentVersion               = ($DattoAgentResults.AgentVersion | Select-Object -Unique).Count
            $TotalProtectedVolumes      = ($DattoAgentResults.protectedVolumesCount | Measure-Object -Sum).sum
            $TotalUnProtectedVolumes    = ($DattoAgentResults.unprotectedVolumesCount | Measure-Object -Sum).sum
            $TotalPaused                = ($DattoAgentResults | Where-Object {$_.isPaused -eq 'True'}).count
            $TotalArchived              = ($DattoAgentResults | Where-Object {$_.isArchived -eq 'True'}).count

    #Region    [ HTML Report Building Blocks ]

        # Build the HTML header
        # This grabs the raw text from files to shorten the amount of lines in the PSScript
        # General idea is that the HTML assets would infrequently be changed once set
            $Meta = Get-Content -Path "$PSScriptRoot\Assets\Meta.html" -Raw
            $Meta = $Meta -replace 'xTITLECHANGEx',"$ScriptName"
            $CSS = Get-Content -Path "$PSScriptRoot\Assets\Styles.css" -Raw
            $JavaScript = Get-Content -Path "$PSScriptRoot\Assets\JavaScriptHeader.html" -Raw
            $Head = $Meta + ("<style>`n") + $CSS + ("`n</style>") + $JavaScript

        # HTML Body Building Blocks (In order)
            $TopNav = Get-Content -Path "$PSScriptRoot\Assets\TopBar.html" -Raw
            $DivMainStart = '<div id="layoutSidenav">'
            $SideBar = Get-Content -Path "$PSScriptRoot\Assets\SideBar.html" -Raw
            $SideBar = $SideBar -replace ('xTIMESETx',"$HTMLDate")
            $DivSecondStart = '<div id="layoutSidenav_content">'
            $PreLoader = Get-Content -Path "$PSScriptRoot\Assets\PreLoader.html" -Raw
            $MainStart = '<main>'

        #Base Table Container
            $BaseTableContainer = Get-Content -Path "$PSScriptRoot\Assets\TableContainer.html" -Raw

        #Summary Header
            $SummaryTableContainer = $BaseTableContainer
            $SummaryTableContainer = $SummaryTableContainer -replace ('xHEADERx',"$ScriptName - Summary")
            $SummaryTableContainer = $SummaryTableContainer -replace ('xBreadCrumbx','')

        #Summary Cards
        #HTML in Summary.html would be edited depending on the report and summary info you want to show
            $SummaryCards = Get-Content -Path "$PSScriptRoot\Assets\Summary.html" -Raw
            $SummaryCards = $SummaryCards -replace ('xCARD1Valuex',$TotalAgents)
            $SummaryCards = $SummaryCards -replace ('xCARD2Valuex',$AgentVersion)
            $SummaryCards = $SummaryCards -replace ('xCARD3Valuex',$TotalProtectedVolumes)
            $SummaryCards = $SummaryCards -replace ('xCARD4Valuex',$TotalUnProtectedVolumes)
            $SummaryCards = $SummaryCards -replace ('xCARD5Valuex',$TotalPaused)
            $SummaryCards = $SummaryCards -replace ('xCARD6Valuex',$TotalArchived)

        #Body table headers, would be duplicated\adjusted depending on how many tables you want to show
            $BodyTableContainer = $BaseTableContainer
            $BodyTableContainer = $BodyTableContainer -replace ('xHEADERx',"$ScriptName - Details")
            $BodyTableContainer = $BodyTableContainer -replace ('xBreadCrumbx',"Data gathered from $(hostname)")

        #Ending HTML
            $DivEnd = '</div>'
            $MainEnd = '</main>'
            $JavaScriptEnd = Get-Content -Path "$PSScriptRoot\Assets\JavaScriptEnd.html" -Raw

    #EndRegion [ HTML Report Building Blocks ]
    #Region    [ Example HTML Report Data\Structure ]

        #Creates an HTML table from PowerShell function results without any extra HTML tags
        $TableResults = $DattoAgentResults | ConvertTo-Html -As Table -Fragment -Property clientCompanyName,Agent,AgentVersion,protectedVolumeNames,unprotectedVolumeNames,isPaused,isArchived `
                                        -PostContent    '   <ul>
                                                                <li>Note: SAMPLE 1 = Only applies to stuff and things</li>
                                                                <li>Note: SAMPLE 2 = Only applies to stuff and things</li>
                                                                <li>Note: SAMPLE 3 = Only applies to stuff and things</li>
                                                            </ul>
                                                        '

        #Table section segregation
        #PS doesn't create a <thead> tag so I have find the first row and make it so
        $TableHeader = $TableResults -split "`r`n" | Where-Object {$_ -match '<th>'}
        #Unsure why PS makes empty <colgroup> as it contains no data
        $TableColumnGroup = $TableResults -split "`r`n" | Where-Object {$_ -match '<colgroup>'}

        #Table ModIfications
        #Replacing empty html table tags with simple replaceable names
        #It was annoying me that empty rows showed in the raw HTML and I couldn't delete them as they were not $NUll but were empty
        $TableResults = $TableResults -replace ($TableHeader,'xblanklinex')
        $TableResults = $TableResults -replace ($TableColumnGroup,'xblanklinex')
        $TableResults = $TableResults | Where-Object {$_ -ne 'xblanklinex'} | ForEach-Object {$_.Replace('xblanklinex','')}

        #Inject modified data back into the table
        #Makes the table have a <thead> tag
        $TableResults = $TableResults -replace '<Table>',"<Table>`n<thead>$TableHeader</thead>"
        $TableResults = $TableResults -replace '<table>','<table class="dataTable-table" style="width: 100%;">'

        #Mark Focus Data to draw attention\talking points
        #Need to understand RegEx more as this doesn't scale at all
        $TableResults = $TableResults -replace '<td>True</td>','<td class="WarningStatus">True</td>'


        #Building the final HTML report using the various ordered HTML building blocks from above.
        #This is injecting html\css\javascript in a certain order into a file to make an HTML report
        $HTML = ConvertTo-HTML -Head $Head -Body "  $TopNav $DivMainStart $SideBar $DivSecondStart $PreLoader $MainStart
                                                    $SummaryTableContainer $SummaryCards $DivEnd $DivEnd $DivEnd
                                                    $BodyTableContainer $TableResults $DivEnd $DivEnd $DivEnd
                                                    $MainEnd $DivEnd $DivEnd $JavaScriptEnd
                                                "
        $HTML = $HTML -replace '<body>','<body class="sb-nav-fixed">'
        $HTML | Out-File $HTMLReport -Encoding utf8

    }
}
Catch{
    Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
    ''
    Write-Error $_
    break
}
#EndRegion [ HTML Report ]

    If ($ShowReport){
        Invoke-Item $Log
    }

''
Write-Output "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
''