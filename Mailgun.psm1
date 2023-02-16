<#	
	===========================================================================
	 Created on:   	2/15/2023 8:21 PM
	 Created by:   	Connor aka WizardTux
	 Organization: 	IT Bible
	 Filename:     	Mailgun.psm1
	-------------------------------------------------------------------------
	 Module Name: Mailgun
	===========================================================================
#>

function Send-MessageTemplate
{
	param (
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = "Mailgun API key.")]
		[string]$APIKey,
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = "Mailgun domain")]
		[string]$MailGunDomain,
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = "From address for email to be sent from.")]
		[string]$From,
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = "To address for email to be sent to.")]
		[string]$To,
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = "Email Subject")]
		[string]$Subject,
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = "The name of the Mailgun template.")]
		[string]$Template,
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = "A table of values outlined in the Mailgun template.")]
		$Variables
		#[Parameter(Mandatory = $true)]
		#[string]$Body
		
	)
	
	$Variables = ($Variables | ConvertTo-Json)
	
	$BasicAuth = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("api:$($APIKey)"))
	$Params = @{
		"URI"  = "https://api.mailgun.net/v3/$($MailGunDomain)/messages"
		"Body" = @{
			"from"				    = $From
			"to"				    = $To
			"subject"			    = $Subject
			"template"			    = $Template
			"h:X-Mailgun-Variables" = $Variables
			#"text"    = $Body
			#"html"	  = $Body
		}
		"Headers" = @{ Authorization = "Basic $BasicAuth" }
		"Method" = 'POST'
	}
	
	Invoke-RestMethod @Params | Out-Null
}

Export-ModuleMember -Function Send-MessageTemplate