###############################################################################################################################################################################
###                                                                                                           																###
###		.INFORMATIONS																																						###
###  	Script by Drago Petrovic -                                                                            																###
###     Technical Blog -               https://blog.abstergo.ch                                               																###
###     GitHub Repository -            https://github.com/MSB365                                          	  																###
###     Webpage -                                                                  																							###
###     Xing:				   		   https://www.xing.com/profile/Drago_Petrovic																							###
###     LinkedIn:					   https://www.linkedin.com/in/drago-petrovic-86075730																					###
###																																											###
###		.VERSION																																							###
###     Version 1.0 - 02/02/2017                                                                              																###
###     Version 2.0 - 06/09/2017                                                                              																###
###     Revision -                                                                                            																###
###                                                                                                           																### 
###               v1.0 - Initial script										                                  																###
###               v2.0 - Added Azure AD Rights Management connection                                          																###
###																																											###
###																																											###
###		.SYNOPSIS																																							###
###		MsCloudPsConnector.ps1																																				###
###																																											###
###		.DESCRIPTION																																						###
###		Script to connect to all Microsoft Office 365 Cloud services.																										###
###																																											###
###		.PARAMETER																																							###
###																																											###
###																																											###
###		.EXAMPLE																																							###
###		.\MsCloudPsConnector.ps1																																			###
###																																											###
###		.NOTES																																								###
###		Ensure you update the script with your tenant name and username																										###
###		Your username is in the Exchange Online section for Get-Credential																									### 	
###		The tenant name is used in the Exchange Online section for Get-Credential																							###
###		The tenant name is used in the SharePoint Online section for SharePoint connection URL																				###
###                                                                                                           																###  	
###     .COPIRIGHT                                                            																								###
###		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 					###
###		to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 					###
###		and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:							###
###																																											###
###		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.										###
###																																											###
###		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 				###
###		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 		###
###		WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.			###
###                 																																						###
###                                                																															###
###                                                                                                           																###
###                                                                                                           																###
###############################################################################################################################################################################
#
Write-Host "!!! with great power comes great responsibility !!!" -ForegroundColor magenta -Verbose
#
#####################################################################################################

# Variables
Write-Host "Enter your Company Variables of the Tenant" -ForegroundColor yellow
$Tenant = Read-Host "TenantName e.g. contoso"
$user = Read-Host "Username of your Account for the connection e.g. 'john.doe'"
$Cred = Get-credential "$user@$tenant.onmicrosoft.com"

#####################################################################################################

###   Exchange Online
Write-Host "Connecting Exchange Online..." -ForegroundColor cyan
$cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session –AllowClobber
Write-Host "Done!" -ForegroundColor green

### Exchange Online Protection
Write-Host "Connecting Exchange Online Protection..." -ForegroundColor cyan
$EOPSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.protection.outlook.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $EOPSession –AllowClobber
Write-Host "Done!" -ForegroundColor green

### Compliance Center
Write-Host "Connecting Compliance Center..." -ForegroundColor cyan
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.compliance.protection.outlook.com/powershell-liveid/" -Credential $cred -Authentication "Basic" -AllowRedirection
Import-PSSession $ccSession –AllowClobber
Write-Host "Done!" -ForegroundColor green

### Azure Active Directory Rights Management
Write-Host "Connecting Azure Active Directory Rights Management..." -ForegroundColor cyan
Import-Module AADRM
Connect-AadrmService -Credential $cred
Write-Host "Done!" -ForegroundColor green    

### Azure Resource Manager
Write-Host "Connecting Azure Resource Manager..." -ForegroundColor cyan
Login-AzureRmAccount -Credential $cred
Write-Host "Done!" -ForegroundColor green

###   Azure Active Directory v1.0
Write-Host "Connecting Azure Active Directory..." -ForegroundColor cyan
Import-Module MsOnline
Connect-MsolService -Credential $cred
Write-Host "Done!" -ForegroundColor green

###  SharePoint Online
Write-Host "Connecting SharePoint Online..." -ForegroundColor cyan
Import-Module Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url "https://$($Tenant)-admin.sharepoint.com" -Credential $cred
Write-Host "Done!" -ForegroundColor green

### Skype Online
Write-Host "Connecting Skype Online..." -ForegroundColor cyan
Import-Module LyncOnlineConnector
Import-Module SkypeOnlineConnector
$SkypeSession = New-CsOnlineSession -Credential $cred
Import-PSSession $SkypeSession 
Write-Host "Done!" -ForegroundColor green

### Azure AD v2.0
Write-Host "Connecting Azure AD..." -ForegroundColor cyan
Connect-AzureAD -Credential $cred
Write-Host "Done!" -ForegroundColor green

### Finishing
Write-Host "All Tasks of the Script are done, pleas recheck your connections!" -ForegroundColor magenta -Verbose