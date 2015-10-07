#requires -Version 3

    <#
        .SYNOPSIS
        Check the SSL Lab API availability
        .DESCRIPTION
        IT should return an object with details about the number of assesment allowed and the term of service.
        .EXAMPLE
        Get-SSLLabsAvailability
        After runing the Cmdlet, it shouldreturn a object with the enpoint informations.
    #>
function Get-SSLLabsAvailability
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([Object])]
    param(
    )

    Begin{    
        Write-Verbose -Message "[$(Get-Date)] List of Parameters :: $($PSBoundParameters.GetEnumerator() | Out-String)"  
        Write-Verbose -Message "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
        $ApiEnpoint = 'https://api.ssllabs.com/api/v2/'
        $Uri = $ApiEnpoint + 'info'
    }
    Process{
        try
        {
            $Result = Invoke-RestMethod -Method Get -Uri $Uri
            $Result
        }
        catch [Exception] 
        {
            Write-Output -InputObject "[$(Get-Date)] Info  :: $($MyInvocation.MyCommand)"
            Write-Output -InputObject "[$(Get-Date)] Error :: $_ "
        }
    }
    End{
        Write-Verbose -Message "[$(Get-Date)] End   :: Finished"
    }
}

    <#
        .SYNOPSIS
        Perform a new SSL Assessment using Qualys SSL Labs API.
        .DESCRIPTION
        Execute a SSL Test using the free online service created by Qualys Labs. It performs a deep analysis of the configuration of any SSL web server on the public Internet. 
        .EXAMPLE
        Invoke-Assessment -Domain 'letsencrypt.org' -All done -Publish off -OutJson
        It will start the assessment of the domain 'letsencrypt.org' with a full report option and generates an output in JSON format using the -OutJson Parameter while not publishing the report on the public report page.
        .EXAMPLE
        Invoke-Assessment -Domain 'letsencrypt.org' -All done -Publish on
        It will start the assessment of the domain 'letsencrypt.org' with a full report option and generates an object. It will also publish the report on the public report page.
        .EXAMPLE
        Invoke-Assessment -Domain 'letsencrypt.org' -FromCache off -StartNew on -MaxAge 1 -IgnoreMismatch off
        It will pull the assessment of the domain 'letsencrypt.org' from the cache
    #>
function Invoke-Assessment
{
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [CmdletBinding()]
    [Alias()]
    [OutputType([Object])]
    param(
        [parameter(Mandatory = $true, Position = 0)]
        [String]$Domain,
        [parameter(Mandatory = $false, Position = 1, ParameterSetName = 'All')]
        [ValidateSet('on','done')]
        [string]$All,
        [parameter(Mandatory = $false, Position = 2, ParameterSetName = 'All')]
        [ValidateSet('on','off')]
        [string]$Publish = 'off',
        #[parameter(Mandatory = $false, Position = 3, ParameterSetName = 'All')]
        [parameter(Mandatory = $false, Position = 3,ParameterSetName = 'Cache')]
        [ValidateSet('on','off')]
        [string]$FromCache = 'off',
        #[parameter(Mandatory = $false, Position = 4, ParameterSetName = 'All')]
        [parameter(Mandatory = $false, Position = 4,ParameterSetName = 'Cache')]
        [ValidateSet('on','off')]
        [string]$StartNew = 'on',  
        #[parameter(Mandatory = $false, Position = 5, ParameterSetName = 'All')]
        [parameter(Mandatory = $false,Position = 5, ParameterSetName = 'Cache')]
        [Int]$MaxAge = 1,
        #[parameter(Mandatory = $false, Position = 6, ParameterSetName = 'All')]
        [parameter(Mandatory = $false, Position = 6,ParameterSetName = 'Cache')]
        [ValidateSet('on','off')]
        [string]$IgnoreMismatch = 'on',
        #[parameter(Mandatory = $false, Position = 7, ParameterSetName = 'All')]
        [switch]$OutJson
    )

    Begin{    
        Write-Verbose -Message "[$(Get-Date)] List of Parameters :: $($PSBoundParameters.GetEnumerator() | Out-String)"  
        Write-Verbose -Message "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
        $ApiEnpoint = 'https://api.ssllabs.com/api/v2'
        
        $UriBase = $ApiEnpoint + "/analyze?host=$Domain"              

        if (($PSBoundParameters.ContainsKey('All')) -and (($All -eq 'on')) -or ($All -eq 'done'))
        {
            $Uri = $UriBase + "&all=$All"
        }
        if(($PSBoundParameters.ContainsKey('Publish')) -and ($Publish -eq 'on'))
        {
            $Uri = $UriBase + "&publish=$Publish"
        }
        if(($PSBoundParameters.ContainsKey('FromCache')) -and ($FromCache -eq 'on'))
        {
            $Uri = $UriBase + "&fromCache=$FromCache"
            if($MaxAge -ne 0)
            {
                $Uri = $UriBase + "&MaxAge=$MaxAge"
            }
        }
        elseif(($PSBoundParameters.ContainsKey('StartNew')) -and ($StartNew -eq 'on')) 
        {
            $Uri = $UriBase +  "&startNew=$StartNew"
        }

        if($PSBoundParameters.ContainsKey('IgnoreMismatch'))
        {
            $Uri = $UriBase + "&ignoreMismatch=$IgnoreMismatch"
        }
    }
    Process{
        try
        {
            $Uri
            $Result = Invoke-RestMethod -Method Get -Uri $Uri
            If ($OutJson)
            {
                $Result | ConvertTo-Json -Depth 5
            }
            else
            {
                $Result
            }
        }
        catch [Exception] 
        {
            Write-Output -InputObject "[$(Get-Date)] Info  :: $($MyInvocation.MyCommand)"
            Write-Output -InputObject "[$(Get-Date)] Error :: $_ "
        }
    }
    End{
        Write-Verbose -Message "[$(Get-Date)] End   :: Finished"
    }
}

#TODO: Fix bug in this function. It generate a 400 bad request
function Get-EndpointInformation
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([Object])]
    param(
        [String]$Domain,
        [String]$IPAddress,
        [ValidateSet('on','off')]
        [string]$FromCache = 'off'
    )

    Begin{    
        Write-Verbose -Message "[$(Get-Date)] List of Parameters :: $($PSBoundParameters.GetEnumerator() | Out-String)"  
        Write-Verbose -Message "[$(Get-Date)] Begin :: $($MyInvocation.MyCommand)"
        $ApiEnpoint = 'https://api.ssllabs.com/api/v2'
        
        $Cache = "&fromCache=$FromCache"
        
        $Uri = $ApiEnpoint + "/getEndpointData?host=$Domain&s=$IPAddress$Cache"
        
    }
    Process{
        try
        {
            #$Result = Invoke-RestMethod -Method Get -Uri $Uri
            #$Result
            Write-Output -InputObject 'I have a bug, yeah! a bug, but not for a long time'
        }
        catch [Exception] 
        {
            Write-Output -InputObject "[$(Get-Date)] Info  :: $($MyInvocation.MyCommand)"
            Write-Output -InputObject "[$(Get-Date)] Error :: $_ "
        }
    }
    End{
        Write-Verbose -Message "[$(Get-Date)] End   :: Finished"
    }
}


