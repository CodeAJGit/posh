<#

    .DESCRIPTION
        White-space is irrelevant to PowerShell, but its proper use is key to writing easily readable code.
        Cast operators should be followed by a space for consistency and improved readability.

    .EXAMPLE
        Measure-SpaceAfterCastOperator -ScriptBlockAst $ScriptBlockAst

    .PARAMETER ScriptBlockAst
        Specifies the ScriptBlockAst.

#>
function Measure-SpaceAfterCastOperator {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    ## BEGIN ##################################################################
    begin {
        $Results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]] @()

        $Predicate = {
            param ([System.Management.Automation.Language.Ast] $Ast)

            if ($Ast -is [System.Management.Automation.Language.ConvertExpressionAst] -or
                $Ast -is [System.Management.Automation.Language.PropertyMemberAst] -or
                $Ast -is [System.Management.Automation.Language.ParameterAst]) {
                # exceptions: (?=\]) for nested brackets like [int[]] and :: for constants like [int]::MaxValue
                $Pattern = "^([^\[\]]|(?<bracket>\[)|(?<-bracket>\]( |\r?\n|(?=\])|::|$)))*(?(bracket)(?!))$"

                return ($Ast.Extent.Text -inotmatch $Pattern)
            } else {
                return $false
            }
        }

        ## TRAP ###############################################################
        trap {
            throw $_
        }
    }

    ## PROCESS ################################################################
    process {
        $Violations = $ScriptBlockAst.FindAll($Predicate, $true)

        if ($Violations.Count -ne 0) {
            foreach ($Violation in $Violations) {
                $Result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord] @{
                    "Message"           = (Get-Help $MyInvocation.MyCommand.Name).Description.Text
                    "Extent"            = $Violation.Extent
                    "RuleName"          = "CUseSpaceAfterCastOperator"
                    "Severity"          = "Information"
                    "RuleSuppressionID" = $null
                }

                $null = $Results.Add($Result)
            }
        }

        return $Results.ToArray()
    }

    ## END ####################################################################
    end {
        $null = [System.GC]::GetTotalMemory($true)
    }
}


<#

    .DESCRIPTION
        PowerShell is not case sensitive, but we follow capitalization conventions to make code easy to read.
        Binary Operators should be explicit and have the correct casing for consistency and improved readability.

    .EXAMPLE
        Measure-ExplicitBinaryOperatorCorrectCasing -Token $Token

    .PARAMETER Token
        Specifies the Token.

    .LINK
        https://poshcode.gitbook.io/powershell-practice-and-style/style-guide/code-layout-and-formatting#capitalization-conventions

#>
function Measure-ExplicitBinaryOperatorCorrectCasing {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.Token[]]
        $Token
    )

    ## BEGIN ##################################################################
    begin {
        $Results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]] @()

        $Predicate = {
            param ([System.Management.Automation.Language.Token] $Token)

            if ($Token.TokenFlags.HasFlag([System.Management.Automation.Language.TokenFlags]::BinaryOperator)) {
                $Text = [System.Management.Automation.Language.TokenTraits]::Text($Token.Kind)

                return ($Token.Extent.Text -cne $Text)
            } else {
                return $false
            }
        }

        ## TRAP ###############################################################
        trap {
            throw $_
        }
    }

    ## PROCESS ################################################################
    process {
        $Violations = $Token.Where({ & $Predicate $_ })

        if ($Violations.Count -ne 0) {
            foreach ($Violation in $Violations) {
                $Text = [System.Management.Automation.Language.TokenTraits]::Text($Violation.Kind)

                $Result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord] @{
                    "Message"           = "Expected Binary Operator '$( $Violation.Extent.Text )' to be '$Text'."
                    "Extent"            = $Violation.Extent
                    "RuleName"          = "CUseExplicitBinaryOperatorCorrectCasing"
                    "Severity"          = "Information"
                    "RuleSuppressionID" = $null
                }

                $null = $Results.Add($Result)
            }
        }

        return $Results.ToArray()
    }

    ## END ####################################################################
    end {
        $null = [System.GC]::GetTotalMemory($true)
    }
}


<#

    .DESCRIPTION
        PowerShell is not case sensitive, but we follow capitalization conventions to make code easy to read.
        Keywords should have the correct casing for consistency and improved readability.

    .EXAMPLE
        Measure-ExplicitKeywordCorrectCasing -Token $Token

    .PARAMETER Token
        Specifies the Token.

    .LINK
        https://poshcode.gitbook.io/powershell-practice-and-style/style-guide/code-layout-and-formatting#capitalization-conventions

#>
function Measure-ExplicitKeywordCorrectCasing {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.Token[]]
        $Token
    )

    ## BEGIN ##################################################################
    begin {
        $Results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]] @()

        $Predicate = {
            param ([System.Management.Automation.Language.Token] $Token)

            if ($Token.TokenFlags.HasFlag([System.Management.Automation.Language.TokenFlags]::Keyword)) {
                $Text = [System.Management.Automation.Language.TokenTraits]::Text($Token.Kind)

                return ($Token.Extent.Text -cne $Text)
            } else {
                return $false
            }
        }

        ## TRAP ###############################################################
        trap {
            throw $_
        }
    }

    ## PROCESS ################################################################
    process {
        $Violations = $Token.Where({ & $Predicate $_ })

        if ($Violations.Count -ne 0) {
            foreach ($Violation in $Violations) {
                $Text = [System.Management.Automation.Language.TokenTraits]::Text($Violation.Kind)

                $Result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord] @{
                    "Message"           = "Expected Keyword '$( $Violation.Extent.Text )' to be '$Text'."
                    "Extent"            = $Violation.Extent
                    "RuleName"          = "CUseExplicitKeywordCorrectCasing"
                    "Severity"          = "Information"
                    "RuleSuppressionID" = $null
                }

                $null = $Results.Add($Result)
            }
        }

        return $Results.ToArray()
    }

    ## END ####################################################################
    end {
        $null = [System.GC]::GetTotalMemory($true)
    }
}


<#

    .DESCRIPTION
        White-space is irrelevant to PowerShell, but its proper use is key to writing easily readable code.
        Functions should be surrounded with two blank lines for consistency and improved readability.

    .EXAMPLE
        Measure-NewLineAroundFunction -ScriptBlockAst $ScriptBlockAst

    .PARAMETER ScriptBlockAst
        Specifies the ScriptBlockAst.

    .LINK
        https://poshcode.gitbook.io/powershell-practice-and-style/style-guide/code-layout-and-formatting#blank-lines-and-whitespace

#>
function Measure-NewLineAroundFunction {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.Powershell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    ## BEGIN ##################################################################
    begin {
        $Results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]] @()

        $Predicate = {
            param ([System.Management.Automation.Language.Ast] $Ast)

            if ($Ast -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                $Ast.Parent -isnot [System.Management.Automation.Language.FunctionMemberAst]) {
                $Tokenize = [System.Management.Automation.PSParser]::Tokenize($Ast.Parent, [ref] $null)
                $Comment = $Tokenize.Where({ $_.Type -eq [System.Management.Automation.PSTokenType]::Comment })
                $Replace = ($Comment.Content | Select-Object -Unique | ForEach-Object { [regex]::Escape($_ + "`r`n") }) -join "|"

                $Parent = $Ast.Parent.Extent.Text -ireplace $Replace
                $Self = $Ast.Extent.Text -ireplace $Replace

                # exceptions: (^(\r?\n){0,2} for start of code, (\r?\n){0,2}$) for end of code and [^\S\r\n]* for indented lines
                $Pattern = "(^(\r?\n){0,2}|(\r?\n){3})[^\S\r\n]*$( [regex]::Escape($Self) )((\r?\n){3}|(\r?\n){0,2}$)"

                return ($Parent -inotmatch $Pattern)
            } else {
                return $false
            }
        }

        ## TRAP ###############################################################
        trap {
            throw $_
        }
    }

    ## PROCESS ################################################################
    process {
        $Violations = $ScriptBlockAst.FindAll($Predicate, $true)

        if ($Violations.Count -ne 0) {
            foreach ($Violation in $Violations) {
                $Result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord] @{
                    "Message"           = (Get-Help $MyInvocation.MyCommand.Name).Description.Text
                    "Extent"            = $Violation.Extent
                    "RuleName"          = "CUseNewLineAroundFunction"
                    "Severity"          = "Information"
                    "RuleSuppressionID" = $null
                }

                $null = $Results.Add($Result)
            }
        }

        return $Results.ToArray()
    }

    ## END ####################################################################
    end {
        $null = [System.GC]::GetTotalMemory($true)
    }
}


Export-ModuleMember -Function Measure-*
