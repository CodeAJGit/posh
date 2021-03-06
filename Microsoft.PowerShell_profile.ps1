function Set-PSAdminContext () {
    $WindowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $WindowsPrincipal = [Security.Principal.WindowsPrincipal] $WindowsIdentity

    $Global:PSAdminContext = $WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}


function Prompt {
    Set-PSAdminContext

    $PathArray = $ExecutionContext.SessionState.Path.CurrentLocation.Path.TrimEnd("\") -isplit '\\'
    $Host.UI.RawUI.WindowTitle = "Windows PowerShell {0} ~ {1}" -f $Host.Version.ToString(), (($PathArray | Select-Object -SkipLast 1) -join "\")

    Write-Host -NoNewline ("[{0}]: " -f $env:COMPUTERNAME.ToLower())

    switch ($null) {
        { $PSAdminContext } {
            Write-Host -NoNewline -ForegroundColor red "ADMIN "
        }
        { $PSDebugContext } {
            Write-Host -NoNewline -ForegroundColor magenta "DEBUG "
        }
        default {
            Write-Host -NoNewline "PS "
        }
    }
    Write-Host -NoNewline ("[{0}]" -f $PathArray[-1])
    Write-Host -NoNewline (">" * ($nestedPromptLevel + 1))

    return " "
}


function Out-Password ([int] $Length = 16) {
    # https://www.w3schools.com/charsets/ref_html_ascii.asp
    return -join (1..$Length | ForEach-Object { [char] (Get-Random -Minimum 33 -Maximum 127) })
}


# c# to redefine console color codes
Add-Type -Language CSharp -TypeDefinition (Get-Content -Path "$PSScriptRoot\Console.Color.cs" -Raw)
[Console.Color]::SetColors(@{ # GitHub Dark Default
        darkYellow  = "#c9d1d9" # Foreground
        red         = "#f85149" # Error
        yellow      = "#db6d28" # Warning
        magenta     = "#d2a8ff" # Debug
        cyan        = "#a5d6ff" # Verbose
        blue        = "#79c0ff" # Progress
        gray        = "#8b949e" # Comment
        darkCyan    = "#79c0ff" # Command
        darkMagenta = "#0d1117" # Background
    })

# c# to redefine console font
Add-Type -Language CSharp -TypeDefinition (Get-Content -Path "$PSScriptRoot\Console.Font.cs" -Raw)
[Console.Font]::SetFont("Consolas", 16)

# Host Foreground
$Host.PrivateData.ErrorForegroundColor = "red"
$Host.PrivateData.WarningForegroundColor = "yellow"
$Host.PrivateData.DebugForegroundColor = "magenta"
$Host.PrivateData.VerboseForegroundColor = "cyan"
$Host.PrivateData.ProgressForegroundColor = "darkMagenta"

# Host Background
$Host.PrivateData.ErrorBackgroundColor = "darkMagenta"
$Host.PrivateData.WarningBackgroundColor = "darkMagenta"
$Host.PrivateData.DebugBackgroundColor = "darkMagenta"
$Host.PrivateData.VerboseBackgroundColor = "darkMagenta"
$Host.PrivateData.ProgressBackgroundColor = "blue"

# PSReadLine Foreground
Set-PSReadLineOption -Colors @{
    ContinuationPrompt = "darkYellow"
    Default            = "darkYellow"
    Comment            = "gray"
    Keyword            = "red"
    String             = "cyan"
    Operator           = "red"
    Variable           = "darkYellow"
    Command            = "darkCyan"
    Parameter          = "darkYellow"
    Type               = "red"
    Number             = "darkCyan"
    Member             = "darkYellow"
    Emphasis           = "cyan"
    Error              = "red"
    Selection          = "cyan"
}

# Default Configurations
Set-PSReadLineOption -BellStyle None
$PSSessionOption = New-PSSessionOption -NoMachineProfile -OperationTimeout 30000 -OpenTimeout 30000 -CancelTimeout 30000
$PSDefaultParameterValues = @{
    "Get-Help:ShowWindow"             = $true
    "Format-Table:AutoSize"           = $true
    "Out-Default:OutVariable"         = "0"
    "Invoke-WebRequest:Verbose"       = $true
    "Export-Csv:NoTypeInformation"    = $true
    "ConvertTo-Csv:NoTypeInformation" = $true
    "*:Encoding"                      = "Utf8"
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not $Error) {
    Clear-Host
}

# https://artii.herokuapp.com/make?text=PowerShell&font=cyberlarge
@"
     _____   _____  _  _  _ _______  ______ _______ _     _ _______
    |_____] |     | |  |  | |______ |_____/ |______ |_____| |______ |      |
    |       |_____| |__|__| |______ |     \ ______| |     | |______ |_____ |_____
"@
