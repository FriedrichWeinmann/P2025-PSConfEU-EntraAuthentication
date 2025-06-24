# failsafe
return

# Module: EntraAuth
# https://github.com/FriedrichWeinmann/EntraAuth

$clientID = '0dfa9522-80cc-4f67-943e-18418325068a'
$tenantID = 'a948c2b3-8eb2-498a-9108-c32aeeaa0f90' # 'organizations'

<#
Create Application:
- Graph: User.ReadBasic.All
- Sharepoint: AllSites.Read, Sites.Search.All
#>

$resource = 'https://graph.microsoft.com/'
$token = Connect-EntraService -ClientID $clientID -TenantID $tenantID -Resource $resource

$token
$token.AccessToken
$token.AccessToken | Set-Clipboard

# jwt.ms

Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/me' -Headers @{
	Authorization = "Bearer $($token.AccessToken)"
}

#-> Don't do manual labor! Get that header directly
$token.GetHeader()


# Moving on to Sharepoint
#--------------------------
$wayTooLongSharepointAPICall = "https://psfred.sharepoint.com/_api/search/query?querytext='contentclass:STS_Site'&selectproperties='Title,Path'&rowlimit=1"
Invoke-RestMethod -Uri $wayTooLongSharepointAPICall -Headers $token.GetHeader()

#-> Who's the better Audience?
$token.Audience
$token.Scopes

$resourceSP = 'https://microsoft.sharepoint.com' # What Resource?
$tokenSP = Connect-EntraService -ClientID $clientID -TenantID $tenantID -Resource $resourceSP
$tokenSP.Audience

#-> Getting the token is easy, not every API is
$site = Invoke-RestMethod -Uri $wayTooLongSharepointAPICall -Headers $tokenSP.GetHeader()
$site
$site | ConvertTo-Json -Depth 10


$site.query.PrimaryQueryResult.RelevantResults.Table.Rows.element.Cells.element

# Refresh Tokens
#-----------------

# Story Time

$token.RefreshToken

$tokenSP2 = Connect-EntraService -RefreshTokenObject $token -Resource $resourceSP
$tokenSP2
$site = Invoke-RestMethod -Uri $wayTooLongSharepointAPICall -Headers $tokenSP2.GetHeader()
$site.query.PrimaryQueryResult.RelevantResults.Table.Rows.element.Cells.element

#-> Back to the slides