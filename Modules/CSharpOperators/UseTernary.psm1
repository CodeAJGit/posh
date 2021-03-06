<#PSScriptInfo

    .VERSION 1.0.2

    .GUID 3c2ae6e7-fe2b-4d32-83ff-bdcd0e589fb1

    .AUTHOR Anthony J. Raymond

    .COMPANYNAME

    .COPYRIGHT (c) 2022 Anthony J. Raymond

    .TAGS operators ternary ?: c# csharp

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
        Impliments the Ternary operator (?:) using the pipeline.

    .EXAMPLE
        1 -le 2 | ?: "True" "False"

    .EXAMPLE
        $true, $false, $true | ?: "True" "False" -NoEnumerate

    .PARAMETER InputObject
        Specifies the <condition> expression to be evaluated and converted to a boolean.

    .PARAMETER IfTrue
        Specifies the expression to be executed if the <condition> expression is true.

    .PARAMETER IfFalse
        Specifies the expression to be executed if the <condition> expression is false.

    .PARAMETER NoEnumerate
        <Optional> Specifies to evaluate the input object, not the enumerated items of a collection.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/conditional-operator

    .LINK
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators

    .LINK
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pipelines

#>
function Use-Ternary {
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
        $IfTrue,

        [Parameter(
            Mandatory,
            Position = 1
        )]
        [object]
        $IfFalse,

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
        switch ($NoEnumerate) {
            $false {
                foreach ($Object in $InputObjects) {
                    if ($Object) {
                        $IfTrue
                    } else {
                        $IfFalse
                    }
                }
            }
            $true {
                if ($InputObjects) {
                    $IfTrue
                } else {
                    $IfFalse
                }
            }
        }

        $null = [System.GC]::GetTotalMemory($true)
    }
}


Set-Alias -Name ?: -Value Use-Ternary
Export-ModuleMember -Function Use-Ternary -Alias ?:
