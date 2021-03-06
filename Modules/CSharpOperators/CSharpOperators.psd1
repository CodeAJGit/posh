@{

    # RootModule = ""

    ModuleVersion     = "1.0.2"

    # CompatiblePSEditions = @()

    GUID              = "de1e452b-50ea-4646-b0dd-a87b69997f6f"

    Author            = "Anthony J. Raymond"

    # CompanyName = ""

    Copyright         = "(c) 2022 Anthony J. Raymond"

    Description       = "Impliments the Ternary (?:) and Null-coalescing (??) operators using the pipeline."

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

    NestedModules     = @(
        "UseTernary"
        "UseNullCoalescing"
    )

    FunctionsToExport = @(
        "Use-Ternary"
        "Use-NullCoalescing"
    )

    CmdletsToExport   = @()

    VariablesToExport = ""

    AliasesToExport   = @(
        "?:"
        "??"
    )

    # DscResourcesToExport = @()

    # ModuleList = @()

    # FileList = @()

    PrivateData       = @{

        PSData = @{

            Tags         = @(
                "operators"
                "ternary"
                "?:"
                "null-coalescing"
                "??"
                "c#"
                "csharp"
            )

            LicenseUri   = "https://github.com/CodeAJGit/posh/blob/main/LICENSE"

            ProjectUri   = "https://github.com/CodeAJGit/posh"

            # IconUri = ""

            ReleaseNotes =
            @"
    20220303-AJR: v1.0.0 - Initial Release
    20220305-AJR: v1.0.1 - Updated Metadata
    20220314-AJR: v1.0.2 - Removed Hyphen from Naming
"@

        }

    }

    # HelpInfoURI = ""

    # DefaultCommandPrefix = ""

}
