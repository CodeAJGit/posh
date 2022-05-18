function Set-PSAdminContext () {
    # function: sets the PSAdminContext variable
    $WindowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $WindowsPrincipal = [Security.Principal.WindowsPrincipal] $WindowsIdentity

    $Global:PSAdminContext = $WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}


function Prompt {
    # function: changes the PowerShell prompt
    Set-PSAdminContext

    $PathArray = $executionContext.SessionState.Path.CurrentLocation.Path.TrimEnd("\") -isplit '\\'
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
    # function: outputs a randomly generated password
    # https://www.w3schools.com/charsets/ref_html_ascii.asp
    return -join (1..$Length | ForEach-Object { [char] (Get-Random -Minimum 33 -Maximum 127) })
}


function ConvertTo-Base64String ([string] $Path, [string] $Destination = "$Path.txt") {
    $splitPath = $Path -isplit "\\|\/", 2
    $splitDest = $Destination -isplit "\\|\/", 2

    $FullPath = (Resolve-Path -Path $splitPath[0]).ProviderPath.TrimEnd("/") + "/" + $splitPath[1]
    $FullDest = (Resolve-Path -Path $splitDest[0]).ProviderPath.TrimEnd("/") + "/" + $splitDest[1]

    $Byte = Get-Content -LiteralPath $FullPath -Encoding Byte
    $String = [System.Convert]::ToBase64String($Byte)

    Set-Content -LiteralPath $FullDest -Value $String -Encoding UTF8
}


function ConvertFrom-Base64String ([string] $Path, [string] $Destination = ($Path -ireplace "\.txt$")) {
    $splitPath = $Path -isplit "\\|\/", 2
    $splitDest = $Destination -isplit "\\|\/", 2

    $FullPath = (Resolve-Path -Path $splitPath[0]).ProviderPath.TrimEnd("/") + "/" + $splitPath[1]
    $FullDest = (Resolve-Path -Path $splitDest[0]).ProviderPath.TrimEnd("/") + "/" + $splitDest[1]

    $String = Get-Content -LiteralPath $FullPath -Encoding UTF8
    $Byte = [System.Convert]::FromBase64String($String)

    Set-Content -LiteralPath $FullDest -Value $Byte -Encoding Byte
}


# method: c# to redefine console color codes
Add-Type -Language CSharp -TypeDefinition (Get-Content -Path "$PSScriptRoot\Colorful.Console.cs" -Raw)
[Colorful.Console]::SetColors(@{ # GitHub Dark Default
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

# method: c# to redefine console font
Add-Type -Language CSharp -TypeDefinition (Get-Content -Path "$PSScriptRoot\Fontful.Console.cs" -Raw)
[Fontful.Console]::SetFont("Consolas", 16)

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
