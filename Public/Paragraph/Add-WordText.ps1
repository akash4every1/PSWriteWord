﻿function Add-WordText {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.DocX]$WordDocument,
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.InsertBeforeOrAfter] $Paragraph,
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.Footer] $Footer,
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Xceed.Words.NET.Header] $Header,
        [alias ("T")] [String[]]$Text,
        [alias ("C")] [System.Drawing.Color[]]$Color = @(),
        [alias ("S")] [double[]] $FontSize = @(),
        [alias ("FontName")] [string[]] $FontFamily = @(),
        [alias ("B")] [nullable[bool][]] $Bold = @(),
        [alias ("I")] [nullable[bool][]] $Italic = @(),
        [alias ("U")] [Xceed.Words.NET.UnderlineStyle[]] $UnderlineStyle = @(),
        [alias ('UC')] [System.Drawing.Color[]]$UnderlineColor = @(),
        [alias ("SA")] [double[]] $SpacingAfter = @(),
        [alias ("SB")] [double[]] $SpacingBefore = @(),
        [alias ("SP")] [double[]] $Spacing = @(),
        [alias ("H")] [Xceed.Words.NET.Highlight[]] $Highlight = @(),
        [alias ("CA")] [Xceed.Words.NET.CapsStyle[]] $CapsStyle = @(),
        [alias ("ST")] [Xceed.Words.NET.StrikeThrough[]] $StrikeThrough = @(),
        [alias ("HT")] [Xceed.Words.NET.HeadingType[]] $HeadingType = @(),
        [int[]] $PercentageScale = @(), # "Value must be one of the following: 200, 150, 100, 90, 80, 66, 50 or 33"
        [Xceed.Words.NET.Misc[]] $Misc = @(),
        [string[]] $Language = @(),
        [int[]]$Kerning = @(), # "Value must be one of the following: 8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48 or 72"
        [nullable[bool][]]$Hidden = @(),
        [int[]]$Position = @(), #  "Value must be in the range -1585 - 1585"
        [nullable[bool][]]$NewLine = @(),
        # [switch] $KeepLinesTogether, # not done
        # [switch] $KeepWithNextParagraph, # not done
        [single[]] $IndentationFirstLine = @(),
        [single[]] $IndentationHanging = @(),
        [Xceed.Words.NET.Alignment[]] $Alignment = @(),
        [Xceed.Words.NET.Direction[]] $Direction = @(),
        [Xceed.Words.NET.ShadingType[]] $ShadingType = @(),
        [System.Drawing.Color[]]$ShadingColor = @(),
        [Xceed.Words.NET.Script[]] $Script = @(),
        [Switch] $ContinueFormatting,
        [alias ("Append")][Switch] $AppendToExistingParagraph,
        [bool] $Supress = $false
    )
    if ($Alignment -eq $null) { $Alignment = @() }
    if ($Text.Count -eq 0) { return }

    if ($Footer -or $Header) {
        if ($Paragraph -ne $null) {
            if (-not $AppendToExistingParagraph) {
                if ($Header) {
                    $NewParagraph = $Header.InsertParagraph()
                } else {
                    $NewParagraph = $Footer.InsertParagraph()
                }
                $Paragraph = $Paragraph.InsertParagraphAfterSelf($NewParagraph)
            }
        } else {
            if ($WordDocument -ne $null) {
                if ($Header) {
                    $Paragraph = $Header.InsertParagraph()
                } else {
                    $Paragraph = $Footer.InsertParagraph()
                }
            } else {
                throw 'Both Paragraph and WordDocument are null'
            }
        }
    } else {
        if ($Paragraph -ne $null) {
            if (-not $AppendToExistingParagraph) {
                $NewParagraph = $WordDocument.InsertParagraph()
                $Paragraph = $Paragraph.InsertParagraphAfterSelf($NewParagraph)
            }
        } else {
            if ($WordDocument -ne $null) {
                $Paragraph = $WordDocument.InsertParagraph()
            } else {
                throw 'Both Paragraph and WordDocument are null'
            }
        }
    }
    for ($i = 0; $i -lt $Text.Length; $i++) {
        if ($NewLine[$i] -ne $null -and $NewLine[$i] -eq $true) {
            if ($i -gt 0) {
                if ($Paragraph -ne $null) {
                    $Paragraph = $Paragraph.InsertParagraphAfterSelf($Paragraph)
                } else {
                    $Paragraph = $WordDocument.InsertParagraph()
                }
            }
            $Paragraph = $Paragraph.Append($Text[$i])
        } else {
            $Paragraph = $Paragraph.Append($Text[$i])
        }

        if ($ContinueFormatting -eq $true) {
            Write-Verbose "Add-WordText - ContinueFormatting: $ContinueFormatting Text Count: $($Text.Count)"
            $Formatting = Set-WordContinueFormatting -Count $Text.Count `
                -Color $Color `
                -FontSize $FontSize `
                -FontFamily $FontFamily `
                -Bold $Bold `
                -Italic $Italic `
                -UnderlineStyle $UnderlineStyle `
                -UnderlineColor $UnderlineColor `
                -SpacingAfter $SpacingAfter `
                -SpacingBefore $SpacingBefore `
                -Spacing $Spacing `
                -Highlight $Highlight `
                -CapsStyle $CapsStyle `
                -StrikeThrough $StrikeThrough `
                -HeadingType $HeadingType `
                -PercentageScale $PercentageScale `
                -Misc $Misc `
                -Language $Language `
                -Kerning $Kerning `
                -Hidden $Hidden `
                -Position $Position `
                -IndentationFirstLine $IndentationFirstLine `
                -IndentationHanging $IndentationHanging `
                -Alignment $Alignment `
                -ShadingType $ShadingType `
                -Script $Script

            $Color = $Formatting[0]
            $FontSize = $Formatting[1]
            $FontFamily = $Formatting[2]
            $Bold = $Formatting[3]
            $Italic = $Formatting[4]
            $UnderlineStyle = $Formatting[5]
            $UnderlineColor = $Formatting[6]
            $SpacingAfter = $Formatting[7]
            $SpacingBefore = $Formatting[8]
            $Spacing = $Formatting[9]
            $Highlight = $Formatting[10]
            $CapsStyle = $Formatting[11]
            $StrikeThrough = $Formatting[12]
            $HeadingType = $Formatting[13]
            $PercentageScale = $Formatting[14]
            $Misc = $Formatting[15]
            $Language = $Formatting[16]
            $Kerning = $Formatting[17]
            $Hidden = $Formatting[18]
            $Position = $Formatting[19]
            $IndentationFirstLine = $Formatting[20]
            $IndentationHanging = $Formatting[21]
            $Alignment = $Formatting[22]
            #$DirectionFormatting = $Formatting[23]
            $ShadingType = $Formatting[24]
            $Script = $Formatting[25]
        }

        $Paragraph = $Paragraph | Set-WordTextColor -Color $Color[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextFontSize -FontSize $FontSize[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextFontFamily -FontFamily $FontFamily[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextBold -Bold $Bold[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextItalic -Italic $Italic[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextUnderlineColor -UnderlineColor $UnderlineColor[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextUnderlineStyle -UnderlineStyle $UnderlineStyle[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextSpacingAfter -SpacingAfter $SpacingAfter[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextSpacingBefore -SpacingBefore $SpacingBefore[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextSpacing -Spacing $Spacing[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextHighlight -Highlight $Highlight[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextCapsStyle -CapsStyle $CapsStyle[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextStrikeThrough -StrikeThrough $StrikeThrough[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextPercentageScale -PercentageScale $PercentageScale[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextSpacing -Spacing $Spacing[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextLanguage -Language $Language[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextKerning -Kerning $Kerning[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextMisc -Misc $Misc[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextPosition -Position $Position[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextHidden -Hidden $Hidden[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextShadingType -ShadingColor $ShadingColor[$i] -ShadingType $ShadingType[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextScript -Script $Script[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextHeadingType -HeadingType $HeadingType[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextIndentationFirstLine -IndentationFirstLine $IndentationFirstLine[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextIndentationHanging -IndentationHanging $IndentationHanging[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextAlignment -Alignment $Alignment[$i] -Supress $false
        $Paragraph = $Paragraph | Set-WordTextDirection -Direction $Direction[$i] -Supress $false
    }

    if ($Supress) { return } else { return $Paragraph }
}