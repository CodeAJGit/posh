<#PSScriptInfo

    .VERSION 1.0.2

    .GUID 3dbe34cb-6c77-4df2-a983-14fac15b78ce

    .AUTHOR Anthony J. Raymond

    .COMPANYNAME

    .COPYRIGHT (c) 2022 Anthony J. Raymond

    .TAGS operators null-coalescing ?? c# csharp

    .LICENSEURI https://github.com/CodeAJGit/posh/blob/main/LICENSE

    .PROJECTURI https://github.com/CodeAJGit/posh

    .ICONURI

    .EXTERNALMODULEDEPENDENCIES

    .REQUIREDSCRIPTS

    .EXTERNALSCRIPTDEPENDENCIES

    .RELEASENOTES
        Packaged in CSharpOperators Module

    .PRIVATEDATA

#>

<#

    .DESCRIPTION
        Impliments the Null-coalescing operator (??) using the pipeline.

    .EXAMPLE
        $null | ?? "InputNull"

    .EXAMPLE
        $null, "value", $null | ?? "InputNull" -NoEnumerate

    .PARAMETER InputObject
        Specifies the <condition> expression to be evaluated and returned if not null.

    .PARAMETER IfNull
        Specifies the expression to be executed if the <condition> expression is null.

    .PARAMETER NoEnumerate
        <Optional> Specifies to evaluate the input object, not the enumerated items of a collection.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/null-coalescing-operator

    .LINK
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators

    .LINK
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines

#>
function Use-NullCoalescing {
    [CmdletBinding()]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object]
        $InputObject,

        [Parameter(
            Mandatory,
            Position = 0
        )]
        [object]
        $IfNull,

        [switch]
        $NoEnumerate
    )

    ## BEGIN ##################################################################
    begin {
        Write-Verbose "start begin block"
        $InputObjects = [System.Collections.Generic.List[object]] @()
    }

    ## PROCESS ################################################################
    process {
        Write-Verbose "start process block"
        $null = $InputObjects.Add($InputObject)
    }

    ## END ####################################################################
    end {
        Write-Verbose "start end block"
        # I know it looks weird but we gotta handle a lot of "NULL" stuff, catches:
        # $null; empty strings; empty collections; $null, empty string, and empty collections in collections
        # examples: $null, "", @(), @{}, @($null), @(""), @(@()), @(@{})
        # yes, $null is on the right on purpose. we want to pull out $null if $_ is a collection
        # by that same token "" is on the left becuase of how comparisons work with $false and 0
        switch ($NoEnumerate) {
            $false {
                foreach ($Object in $InputObjects) {
                    if (($IfNotNull = $Object | Where-Object { ($_ -ne $null) -and ("" -ne $_) -and ($_.Count -gt 0) -and (@($_).GetEnumerator().Count -gt 0) }).Count -gt 0) {
                        $IfNotNull
                    } else {
                        $IfNull
                    }
                }
            }
            $true {
                if (($IfNotNull = $InputObjects | Where-Object { ($_ -ne $null) -and ("" -ne $_) -and ($_.Count -gt 0) -and (@($_).GetEnumerator().Count -gt 0) }).Count -gt 0) {
                    $IfNotNull
                } else {
                    $IfNull
                }
            }
        }

        $null = [System.GC]::GetTotalMemory($true)
    }
}


Set-Alias -Name ?? -Value Use-NullCoalescing
Export-ModuleMember -Function Use-NullCoalescing -Alias ??
