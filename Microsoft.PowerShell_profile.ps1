function Set-PSAdminContext () {
    # function: sets the PSAdminContext variable
    $WindowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $WindowsPrincipal = [Security.Principal.WindowsPrincipal] $WindowsIdentity

    $Global:PSAdminContext = $WindowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}


function Prompt {
    # function: changes the PowerShell prompt
    Set-PSAdminContext

    $PathArray = $executionContext.SessionState.Path.CurrentLocation.Path.TrimEnd("\", "/") -split "\\|\/"
    $Host.UI.RawUI.WindowTitle = "Windows PowerShell {0} ~ {1}" -f $Host.Version.ToString(), (($PathArray | Select-Object -SkipLast 1) -join "\")

    Write-Host -NoNewline ("[{0}]: " -f $env:COMPUTERNAME.ToLower())

    switch ($null) {
        {$PSAdminContext} {
            Write-Host -NoNewline -ForegroundColor red "ADMIN "
        }
        {$PSDebugContext} {
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


# function: c# to redefine console color codes
Add-Type -ReferencedAssemblies System.Drawing -Language CSharp -TypeDefinition @'
// The MIT License (MIT) ~ Copyright (c) 2015 Tom Akita
// Modified ColorMapper.cs from Colorful.Console (https://github.com/tomakita/Colorful.Console)
// Based on code that was originally written by Alex Shvedov, and that was then modified by MercuryP.

using System;
using System.Drawing;
using System.Runtime.InteropServices;

namespace Colorful {
    public sealed class ColorMapper {
        [StructLayout(LayoutKind.Sequential)]
        private struct COORD {
            internal short X;
            internal short Y;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct SMALL_RECT {
            internal short Left;
            internal short Top;
            internal short Right;
            internal short Bottom;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct COLORREF {
            internal uint DWORD;
            internal COLORREF(System.Drawing.Color color) {
                DWORD = ((uint) color.R) + (((uint) color.G) << 8) + (((uint) color.B) << 16);
            }
            internal COLORREF(uint R, uint G, uint B) {
                DWORD = R + (G << 8) + (B << 16);
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct CONSOLE_SCREEN_BUFFER_INFO_EX {
            internal int cbSize;
            internal COORD dwSize;
            internal COORD dwCursorPosition;
            internal ushort wAttributes;
            internal SMALL_RECT srWindow;
            internal COORD dwMaximumWindowSize;
            internal ushort wPopupAttributes;
            internal bool bFullscreenSupported;
            internal COLORREF black;
            internal COLORREF darkBlue;
            internal COLORREF darkGreen;
            internal COLORREF darkCyan;
            internal COLORREF darkRed;
            internal COLORREF darkMagenta;
            internal COLORREF darkYellow;
            internal COLORREF gray;
            internal COLORREF darkGray;
            internal COLORREF blue;
            internal COLORREF green;
            internal COLORREF cyan;
            internal COLORREF red;
            internal COLORREF magenta;
            internal COLORREF yellow;
            internal COLORREF white;
        }

        private const int STD_OUTPUT_HANDLE = -11;
        private static readonly IntPtr INVALID_HANDLE_VALUE = new IntPtr(-1);

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern IntPtr GetStdHandle(int nStdHandle);

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool GetConsoleScreenBufferInfoEx(IntPtr hConsoleOutput, ref CONSOLE_SCREEN_BUFFER_INFO_EX csbe);

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool SetConsoleScreenBufferInfoEx(IntPtr hConsoleOutput, ref CONSOLE_SCREEN_BUFFER_INFO_EX csbe);

        public static void SetColors() {
            IntPtr hConsoleOutput = GetStdHandle(STD_OUTPUT_HANDLE);
            CONSOLE_SCREEN_BUFFER_INFO_EX csbe = GetBufferInfo(hConsoleOutput);

            // Colors based on GitHub Dark Default
            csbe.darkYellow = new COLORREF(201, 209, 217); // #c9d1d9
            csbe.red = new COLORREF(255, 123, 114); // #ff7b72
            csbe.yellow = new COLORREF(255, 166, 87); // #ffa657
            csbe.magenta = new COLORREF(210, 168, 255); // #d2a8ff
            csbe.cyan = new COLORREF(165, 214, 255); // #a5d6ff
            csbe.gray = new COLORREF(139, 148, 158); // #8b949e
            csbe.darkMagenta = new COLORREF(13, 17, 23); // #0d1117
            csbe.darkCyan = new COLORREF(121, 192, 255); // #79c0ff

            SetBufferInfo(hConsoleOutput, csbe);
        }

        private static CONSOLE_SCREEN_BUFFER_INFO_EX GetBufferInfo(IntPtr hConsoleOutput) {
            CONSOLE_SCREEN_BUFFER_INFO_EX csbe = new CONSOLE_SCREEN_BUFFER_INFO_EX();
            csbe.cbSize = (int)Marshal.SizeOf(csbe);

            GetConsoleScreenBufferInfoEx(hConsoleOutput, ref csbe);

            return csbe;
        }

        private static void SetBufferInfo(IntPtr hConsoleOutput, CONSOLE_SCREEN_BUFFER_INFO_EX csbe) {
            csbe.srWindow.Bottom++;
            csbe.srWindow.Right++;

            SetConsoleScreenBufferInfoEx(hConsoleOutput, ref csbe);
        }
    }
}
'@
[Colorful.ColorMapper]::SetColors()

# Host Foreground
$Host.PrivateData.ErrorForegroundColor = "red"
$Host.PrivateData.WarningForegroundColor = "yellow"
$Host.PrivateData.DebugForegroundColor = "magenta"
$Host.PrivateData.VerboseForegroundColor = "cyan"
$Host.PrivateData.ProgressForegroundColor = "darkMagenta"

# Host Background
$Host.PrivateData.ErrorBackgroundColor  = "darkMagenta"
$Host.PrivateData.WarningBackgroundColor  = "darkMagenta"
$Host.PrivateData.DebugBackgroundColor  = "darkMagenta"
$Host.PrivateData.VerboseBackgroundColor  = "darkMagenta"
$Host.PrivateData.ProgressBackgroundColor  = "darkCyan"

# PSReadLine Foreground
Set-PSReadLineOption -Colors @{
    ContinuationPrompt = "darkYellow"
    Default = "darkYellow"
    Comment = "gray"
    Keyword = "red"
    String = "cyan"
    Operator = "red"
    Variable = "darkCyan"
    Command = "darkCyan"
    Parameter = "darkYellow"
    Type = "red"
    Number = "darkCyan"
    Member = "darkYellow"
    Emphasis = "cyan"
    Error = "red"
    Selection = "cyan"
}

# Default Configurations
Set-PSReadlineOption -BellStyle None
$PSSessionOption = New-PSSessionOption -NoMachineProfile -OperationTimeout 30000 -OpenTimeout 30000 -CancelTimeout 30000
$PSDefaultParameterValues = @{
    "Get-Help:ShowWindow" = $true
    "Format-Table:AutoSize" = $true
    "Out-Default:OutVariable" = "0"
    "Invoke-WebRequest:Verbose" = $true
    "Export-Csv:NoTypeInformation" = $true
    "*:Encoding" = "Utf8"
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Set-Location ([System.IO.DriveInfo]::GetDrives() | Where-Object DriveType -eq "Fixed")[0].RootDirectory

Clear-Host

# https://artii.herokuapp.com/make?text=PowerShell&font=cyberlarge
@"
     _____   _____  _  _  _ _______  ______ _______ _     _ _______
    |_____] |     | |  |  | |______ |_____/ |______ |_____| |______ |      |
    |       |_____| |__|__| |______ |     \ ______| |     | |______ |_____ |_____

"@
