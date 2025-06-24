# failsafe
return

<#
Application Scopes
vs.
Delegate Scopes
#>

## Application Flows
#-> Client Secret
$secret = Get-Clipboard | ConvertTo-SecureString -AsPLaintext -Force
Connect-EntraService -ClientID $clientID -TenantID $tenantID -ClientSecret $secret
Invoke-EntraRequest users


#-> Client Certificate
$cert = New-SelfSignedCertificate -Subject "CN=PSCOnfEU" -CertStoreLocation Cert:\CurrentUser\My
$bytes = $cert.GetRawCertData()
[System.IO.File]::WriteAllBytes("C:\Temp\demo\cert.cer", $bytes)
Connect-EntraService -ClientID $clientID -TenantID $tenantID -Certificate $cert
Invoke-EntraRequest users

#-> Directly from cert store (could be the LocalMachine store)
Connect-EntraService -ClientID $clientID -TenantID $tenantID -CertificateName 'CN=PSCOnfEU'
Invoke-EntraRequest users


## Delegate Flows
#-> Authorization Code

#-> DeviceCode

#-> Web Authentication Manager (WAM)
Connect-AzAccount


## Managed Identity

$url = Get-Clipboard
Invoke-RestMethod $url

# Module: EntraAuth.Graph.Application
Connect-EntraService -ClientID graph
Add-EAGMsiScope -DisplayName psconfeudemo -Scope 'Users.Read.All' -Resource 'https://graph.microsoft.com/'


<#
Links:
https://github.com/FriedrichWeinmann/EntraAuth
https://github.com/FriedrichWeinmann/EntraAuth.Graph.Application
https://jwt.ms

Docs:
https://github.com/FriedrichWeinmann/EntraAuth/blob/master/docs/overview.md

Social Media:
Bluesky: psfred.bsky.social
#>