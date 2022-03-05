function Out-Password ([int]$Length = 16) {
    # function: outputs a randomly generated password
    # https://www.w3schools.com/charsets/ref_html_ascii.asp
    return -join (1..$Length | ForEach-Object { [char](Get-Random -Minimum 33 -Maximum 127) })
}


# function: fancy c# to redefine color codes
Add-Type -ReferencedAssemblies System.Drawing -Language CSharp -TypeDefinition @"
// Modified from ColorMapper.cs found at https://github.com/tomakita/Colorful.Console by AJR.
// Based on code that was originally written by Alex Shvedov, and that was then modified by MercuryP.

using System;
using System.Drawing;
using System.Runtime.InteropServices;

namespace Colorful
{
    public class Console
    {
        [StructLayout(LayoutKind.Sequential)]
        internal struct COORD
        {
            internal short X;
            internal short Y;
        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct SMALL_RECT
        {
            internal short Left;
            internal short Top;
            internal short Right;
            internal short Bottom;
        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct COLORREF
        {
            internal uint ColorDWORD;

            internal COLORREF(Color color)
            {
                ColorDWORD = (uint) color.R + (((uint) color.G) << 8) + (((uint) color.B) << 16);
            }

            internal COLORREF(uint r, uint g, uint b)
            {
                ColorDWORD = r + (g << 8) + (b << 16);
            }

            internal Color GetColor()
            {
                return Color.FromArgb((int) (0x000000FFU & ColorDWORD), (int) (0x0000FF00U & ColorDWORD) >> 8, (int) (0x00FF0000U & ColorDWORD) >> 16);
            }

            internal void SetColor(Color color)
            {
                ColorDWORD = (uint) color.R + (((uint) color.G) << 8) + (((uint) color.B) << 16);
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct CONSOLE_SCREEN_BUFFER_INFO_EX
        {
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

        const int STD_OUTPUT_HANDLE = -11;

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern IntPtr GetStdHandle(int nStdHandle);

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool GetConsoleScreenBufferInfoEx(IntPtr hConsoleOutput, ref CONSOLE_SCREEN_BUFFER_INFO_EX csbe);

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool SetConsoleScreenBufferInfoEx(IntPtr hConsoleOutput, ref CONSOLE_SCREEN_BUFFER_INFO_EX csbe);

        public static void SetColors()
        {
            CONSOLE_SCREEN_BUFFER_INFO_EX csbe = new CONSOLE_SCREEN_BUFFER_INFO_EX();
            csbe.cbSize = (int)Marshal.SizeOf(csbe);
            IntPtr hConsoleOutput = GetStdHandle(STD_OUTPUT_HANDLE);

            GetConsoleScreenBufferInfoEx(hConsoleOutput, ref csbe);

            csbe.darkMagenta = new COLORREF(30, 30, 30); // #1E1E1E
            csbe.darkYellow = new COLORREF(212, 212, 212); // #D4D4D4

            SetConsoleScreenBufferInfoEx(hConsoleOutput, ref csbe);
        }
    }
}
"@

# Set Default Colors
[Colorful.Console]::SetColors()

# Host Background
$Host.PrivateData.ErrorBackgroundColor  = 'DarkMagenta'
$Host.PrivateData.WarningBackgroundColor  = 'DarkMagenta'
$Host.PrivateData.VerboseBackgroundColor  = 'DarkMagenta'
$Host.PrivateData.DebugBackgroundColor  = 'DarkMagenta'
$Host.PrivateData.ProgressBackgroundColor  = 'DarkCyan'

# Host Foreground
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.WarningForegroundColor = 'Yellow'
$Host.PrivateData.VerboseForegroundColor = 'Cyan'
$Host.PrivateData.DebugForegroundColor = 'DarkCyan'
$Host.PrivateData.ProgressForegroundColor = 'Yellow'

# some default configurations
$PSSessionOption = New-PSSessionOption -NoMachineProfile -OperationTimeout 30000 -OpenTimeout 30000 -CancelTimeout 30000
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Set-Location ([System.IO.DriveInfo]::GetDrives() | Where-Object DriveType -eq "Fixed")[0].RootDirectory