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
        20220303-AJR: v1.0.0 - Initial Release
        20220305-AJR: v1.0.1 - Updated Metadata
        20220314-AJR: v1.0.2 - Removed Hyphen from Naming

    .PRIVATEDATA

#>

<#

    .DESCRIPTION
        Impliments the Ternary operator (?:) using the pipeline.

    .EXAMPLE
        1 -le 2 | ?: "True" "False"

    .EXAMPLE
        $true, $false, $true | ?: "True" "False" -ParseElements

    .PARAMETER InputObject
        Specifies the <condition> expression to be evaluated and converted to a boolean.

    .PARAMETER IfTrue
        Specifies the expression to be executed if the <condition> expression is true.

    .PARAMETER IfFalse
        Specifies the expression to be executed if the <condition> expression is false.

    .PARAMETER ParseElements
        <Optional> Specifies to evaluate each collection element independently.

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
        $ParseElements
    )

    ## BEGIN ##################################################################
    begin {
        Write-Verbose "start begin block"
        $InputObjects = [System.Collections.Generic.List[object]]::new()

        ## TRAP ###############################################################
        trap {
            Write-Verbose "throw unhandled exceptions"
            throw $_
        }
    }

    ## PROCESS ################################################################
    process {
        Write-Verbose "start process block"
        $null = $InputObjects.Add($InputObject)
    }

    ## END ####################################################################
    end {
        Write-Verbose "start end block"
        switch ($ParseElements) {
            $true {
                foreach ($Object in $InputObjects) {
                    if ($Object) {
                        $IfTrue
                    } else {
                        $IfFalse
                    }
                }
            }
            $false {
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
