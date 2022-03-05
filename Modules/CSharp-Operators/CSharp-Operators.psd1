@{
    ModuleVersion = '1.0.0'

    GUID = 'de1e452b-50ea-4646-b0dd-a87b69997f6f'

    Author = 'Anthony J. Raymond'

    CompanyName = ''

    Copyright = '(c) 2022 Anthony J. Raymond'

    Description = 'Impliments the Ternary (?:) and Null-coalescing (??) operators using the pipeline.'

    PowerShellVersion = '5.1'

    NestedModules = @(
        "Use-Ternary"
        "Use-NullCoalescing"
    )

    FunctionsToExport = @(
        "Use-Ternary"
        "Use-NullCoalescing"
    )

    CmdletsToExport = @()

    VariablesToExport = ''

    AliasesToExport = @(
        "?:"
        "??"
    )

    PrivateData = @{

        PSData = @{

            Tags = @(
                "operators"
                "ternary"
                "?:"
                "if-true"
                "if-false"
                "iftrue"
                "iffalse"
                "null-coalescing"
                "??"
                "if-null"
                "ifnull"
                "c#"
                "csharp"
            )

            LicenseUri = 'https://choosealicense.com/licenses/mit/'

            ProjectUri = 'https://www.powershellgallery.com/profiles/CodeAJ'

            ReleaseNotes = '
                20220303-AJR: v1.0.0 - Initial Release
            '

        }

    }

}
