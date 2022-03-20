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
        Packaged in FormatWrap Module

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

    .PARAMETER Trim
        <Optional> Removes specified white-space characters from the output.

#>
function Format-Wrap {
    [CmdletBinding(
        DefaultParameterSetName = "Width"
    )]
    [OutputType([object])]

    ## PARAMETERS #############################################################
    param (
        [Parameter(
            Mandatory,
            Position = 0,
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
        $Trim = "None"
    )

    ## BEGIN ##################################################################
    begin {
        Write-Verbose "start begin block"
        $br = [System.Environment]::NewLine

        if ($AutoSize) {
            $Width = $Host.UI.RawUI.WindowSize.Width
        }

        $Pattern = "((?>.{1,$Width}(?:(?<=[^\S\r\n])[^\S\r\n]?|(?=\r?\n)|-|$|[^\S\r\n]))|.{1,$Width})"

        ## TRAP ###############################################################
        trap {
            Write-Verbose "throw unhandled exceptions"
            throw $_
        }
    }

    ## PROCESS ################################################################
    process {
        Write-Verbose "start process block"
        foreach ($Object in $InputObject) {

            $String = switch ($Trim) {
                default { [string] $Object }
                "NewLine" { $Object -ireplace "(\r?\n)+", "$br" }
                "Space" { $Object -ireplace "\ +", " " }
                "TabToSpace" { $Object -ireplace "\t", " " }
                "SpaceTab" { $Object -ireplace "[^\S\r\n]+", " " }
                "All" { $Object -ireplace "\s+", " " }
            }

            # regex based on answer from user557597 (anonymous)
            # https://stackoverflow.com/a/20434776
            ($String -ireplace $Pattern, "`$1$br").TrimEnd($br)
        }
    }

    ## END ####################################################################
    end {
        Write-Verbose "start end block"
        $null = [System.GC]::GetTotalMemory($true)
    }
}


Set-Alias -Name Wrap -Value Format-Wrap
Export-ModuleMember -Function Format-Wrap -Alias Wrap
