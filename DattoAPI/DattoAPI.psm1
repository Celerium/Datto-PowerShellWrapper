$Datto_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Datto_Headers.Add("Content-Type", 'application/vnd.api+json')

Set-Variable -Name "Datto_Headers"  -Value $Datto_Headers -Scope global

Import-DattoModuleSettings