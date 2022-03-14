@{

    RootModule = "FormatWrap.psm1"

    ModuleVersion = "1.0.1"

    # CompatiblePSEditions = @()

    GUID = "082f979c-9d10-4fbe-ae4b-30afa75987c3"

    Author = "Anthony J. Raymond"

    # CompanyName = ""

    Copyright = "(c) 2022 Anthony J. Raymond"

    Description = "Formats the output as a text wrapping string."

    # PowerShellVersion = ""

    # PowerShellHostName = ""

    # PowerShellHostVersion = ""

    # DotNetFrameworkVersion = ""

    # CLRVersion = ""

    # ProcessorArchitecture = ""

    # RequiredModules = @()

    # RequiredAssemblies = @()

    # ScriptsToProcess = @()

    # TypesToProcess = @()

    # FormatsToProcess = @()

    # NestedModules = @()

    FunctionsToExport = @(
        "Format-Wrap"
    )

    CmdletsToExport = @()

    VariablesToExport = ""

    AliasesToExport = @(
        "Wrap"
    )

    # DscResourcesToExport = @()

    # ModuleList = @()

    # FileList = @()

    PrivateData = @{

        PSData = @{

            Tags = @(
                "word"
                "wrap"
                "wordwrap"
                "word-wrap"
                "string"
                "text"
                "format"
            )

            LicenseUri = "https://github.com/CodeAJGit/posh/blob/main/LICENSE"

            ProjectUri = "https://github.com/CodeAJGit/posh"

            # IconUri = ""

            ReleaseNotes =
@"
    20220307-AJR: v1.0.0 - Initial Release
    20220314-AJR: v1.0.1 - Removed Hyphen from Naming
"@

        }

    }

    # HelpInfoURI = ""

    # DefaultCommandPrefix = ""

}
