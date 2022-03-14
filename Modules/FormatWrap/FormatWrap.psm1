<#PSScriptInfo

    .VERSION 1.0.1

    .GUID 80339863-e3c5-4a1c-a995-bc344f339e46

    .AUTHOR Anthony J. Raymond

    .COMPANYNAME

    .COPYRIGHT (c) 2022 Anthony J. Raymond

    .TAGS word wrap wordwrap word-wrap string text format

    .LICENSEURI https://github.com/CodeAJGit/posh/blob/main/LICENSE

    .PROJECTURI https://github.com/CodeAJGit/posh

    .ICONURI

    .EXTERNALMODULEDEPENDENCIES

    .REQUIREDSCRIPTS

    .EXTERNALSCRIPTDEPENDENCIES

    .RELEASENOTES
        20220307-AJR: v1.0.0 - Initial Release
        20220314-AJR: v1.0.1 - Removed Hyphen from Naming

    .PRIVATEDATA

#>

<#

    .DESCRIPTION
        Formats the output as a text wrapping string.

    .PARAMETER InputObject
        Specifies the objects to be formatted.

    .PARAMETER Width
        Specifies the number of characters in the display.

    .PARAMETER AutoSize
        Adjusts the number of characters based on the width of the display.

    .PARAMETER Collapse
        Removes duplicate instances of white-space characters from the output.

#>
function Format-Wrap {
    [CmdletBinding(
        DefaultParameterSetName = "Width"
    )]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline
        )]
        [object]
        $InputObject,

        [Parameter(
            ParameterSetName = "Width"
        )]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Width = 128,

        [Parameter(
            ParameterSetName = "AutoSize"
        )]
        [switch]
        $AutoSize,

        [Parameter()]
        [ValidateSet(
            "None",
            "NewLine",
            "Space",
            "TabToSpace",
            "SpaceTab",
            "All"
        )]
        [string]
        $Collapse = "None"
    )

    ## EXECUTION ##############################################################
    Process {
        foreach ($Object in $InputObject) {
            $br = [System.Environment]::NewLine

            if ($AutoSize) {
                $Width = $Host.UI.RawUI.WindowSize.Width
            }

            $String = switch ($Collapse) {
                default {[string]$Object}
                "NewLine" {[string]$Object -replace "(\r?\n)+", "$br"}
                "Space" {[string]$Object -replace "\ +", " "}
                "TabToSpace" {[string]$Object -replace "\t", " "}
                "SpaceTab" {[string]$Object -replace "[^\S\r\n]+", " "}
                "All" {[string]$Object -replace "\s+", " "}
            }

            # regex based on answer from user557597 (anonymous)
            # https://stackoverflow.com/a/20434776
            ($String -replace "((?>.{1,$Width}(?:(?<=[^\S\r\n])[^\S\r\n]?|(?=\r?\n)|-|$|[^\S\r\n]))|.{1,$Width})", "`$1$br").TrimEnd($br)
        }
    }

    ## CLEAN UP ###############################################################
    End {
        $null = [System.GC]::GetTotalMemory($true)
    }
}

Set-Alias -Name Wrap -Value Format-Wrap
Export-ModuleMember -Function Format-Wrap -Alias Wrap
