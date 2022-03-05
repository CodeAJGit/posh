<#PSScriptInfo

    .VERSION 1.0.1

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
            Position = 0,
            Mandatory
        )]
        [object]
        $IfTrue,

        [Parameter(
            Position = 1,
            Mandatory
        )]
        [object]
        $IfFalse,

        [switch]
        $ParseElements
    )

    ## FUNCTIONS AND SCRIPT VARIABLES #########################################
    begin {
        $InputObjects = New-Object -TypeName System.Collections.Generic.List[object]
    }

    ## EXECUTION ##############################################################
    process {
        $null = $InputObjects.Add($InputObject)
    }

    end {
        switch ($ParseElements) {
            $true {
                foreach ($Object in $InputObjects) {
                    if ($Object) {
                        $IfTrue
                    }
                    else {
                        $IfFalse
                    }
                }
            }
            $false {
                if ($InputObjects) {
                    $IfTrue
                }
                else {
                    $IfFalse
                }
            }
        }
        ## CLEAN UP ###############################################################
        [void]([System.GC]::GetTotalMemory($true))
    }
}

Set-Alias -Name ?: -Value Use-Ternary
Export-ModuleMember -Function Use-Ternary -Alias ?:
