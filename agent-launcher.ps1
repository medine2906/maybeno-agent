<#
.SYNOPSIS
    maybeno-agent ajanlari icin gorsel baslatici. Her ajan kartina tiklayinca
    o ajanin klasorunde secilen AI CLI (Claude Code / Gemini / Codex / Grok / Qwen)
    ile yeni bir terminal sohbeti acar.

.NOTES
    Calistirmak icin:  powershell -ExecutionPolicy Bypass -File .\agent-launcher.ps1
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$RepoRoot = $PSScriptRoot

# ---------------------------------------------------------------------------
# 1) Ajanlari otomatik kesfet: kok altinda dogrudan KIMLIK.md barindiran klasorler
# ---------------------------------------------------------------------------
function Get-Agents {
    $agents = @()
    Get-ChildItem -Path $RepoRoot -Directory | ForEach-Object {
        $kimlikPath = Join-Path $_.FullName 'KIMLIK.md'
        if (Test-Path $kimlikPath) {
            $lines = Get-Content -Path $kimlikPath -Encoding UTF8
            $title = $_.Name
            $desc  = ''

            $titleLine = $lines | Where-Object { $_ -match '^#\s' } | Select-Object -First 1
            if ($titleLine -and $titleLine -match '—\s*(.+)$') {
                $title = $Matches[1].Trim()
            }

            $kimimIdx = ($lines | Select-String -Pattern '\*\*Kimim:\*\*').LineNumber
            if ($kimimIdx) {
                $chunk = @()
                for ($i = $kimimIdx - 1; $i -lt $lines.Count; $i++) {
                    if ($i -gt $kimimIdx - 1 -and $lines[$i].Trim() -eq '') { break }
                    $chunk += $lines[$i]
                }
                $desc = ($chunk -join ' ') -replace '\*\*Kimim:\*\*\s*', ''
                $desc = $desc.Trim()
                if ($desc.Length -gt 160) { $desc = $desc.Substring(0, 157) + '...' }
            }

            $agents += [PSCustomObject]@{
                FolderName  = $_.Name
                Title       = $title
                Description = $desc
                Path        = $_.FullName
            }
        }
    }
    return $agents | Sort-Object FolderName
}

# ---------------------------------------------------------------------------
# 2) Sistemde hangi AI CLI'lari kurulu, tespit et (PATH + bilinen ozel konumlar)
# ---------------------------------------------------------------------------
function Resolve-Cli {
    param([string]$Name, [string[]]$ExtraNames = @())

    $candidates = @($Name) + $ExtraNames
    foreach ($c in $candidates) {
        $cmd = Get-Command $c -ErrorAction SilentlyContinue
        if ($cmd) { return @{ Found = $true; Exec = $cmd.Source; IsShell = $false } }
    }

    if ($Name -eq 'claude') {
        $extDirs = @(
            "$env:USERPROFILE\.vscode\extensions",
            "$env:USERPROFILE\.cursor\extensions",
            "$env:USERPROFILE\.antigravity-ide\extensions"
        )
        $found = @()
        foreach ($d in $extDirs) {
            if (Test-Path $d) {
                $found += Get-ChildItem -Path $d -Directory -Filter 'anthropic.claude-code-*' -ErrorAction SilentlyContinue |
                    ForEach-Object {
                        $exe = Join-Path $_.FullName 'resources\native-binary\claude.exe'
                        if (Test-Path $exe) { Get-Item $exe }
                    }
            }
        }
        $best = $found | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($best) { return @{ Found = $true; Exec = $best.FullName; IsShell = $false } }
    }

    return @{ Found = $false; Exec = $null; IsShell = $false }
}

$CliMap = @{
    'Claude' = Resolve-Cli -Name 'claude'
    'Gemini' = Resolve-Cli -Name 'gemini'
    'Codex'  = Resolve-Cli -Name 'codex' -ExtraNames @('openai')
    'Grok'   = Resolve-Cli -Name 'grok'
    'Qwen'   = Resolve-Cli -Name 'qwen'
}

# ---------------------------------------------------------------------------
# 3) Secilen CLI'yi, secilen ajanin klasorunde yeni bir terminalde baslat
# ---------------------------------------------------------------------------
function Start-AgentChat {
    param([string]$AgentPath, [string]$CliLabel)

    $cli = $CliMap[$CliLabel]
    if (-not $cli.Found) {
        [System.Windows.Forms.MessageBox]::Show(
            "$CliLabel bu bilgisayarda kurulu degil (PATH'te bulunamadi).",
            'CLI bulunamadi', 'OK', 'Warning') | Out-Null
        return
    }

    $exec = $cli.Exec
    $wt = Get-Command wt.exe -ErrorAction SilentlyContinue

    if ($wt) {
        Start-Process -FilePath $wt.Source -ArgumentList @(
            '-d', "`"$AgentPath`"",
            'powershell', '-NoExit', '-Command', "& `"$exec`""
        )
    } else {
        Start-Process -FilePath 'powershell' -ArgumentList @(
            '-NoExit', '-Command', "Set-Location -Path `"$AgentPath`"; & `"$exec`""
        )
    }
}

# ---------------------------------------------------------------------------
# 4) Arayuz
# ---------------------------------------------------------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text = 'maybeno-agent Baslatici'
$form.Size = New-Object System.Drawing.Size(760, 640)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(245, 246, 248)

$header = New-Object System.Windows.Forms.Label
$header.Text = 'Bir ajan sec ve bir AI ile sohbeti baslat'
$header.Font = New-Object System.Drawing.Font('Segoe UI', 14, [System.Drawing.FontStyle]::Bold)
$header.AutoSize = $true
$header.Location = New-Object System.Drawing.Point(20, 15)
$form.Controls.Add($header)

$cliStatus = ($CliMap.Keys | Sort-Object | ForEach-Object {
    $mark = if ($CliMap[$_].Found) { 'v' } else { 'x' }
    "$_[$mark]"
}) -join '   '
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Kurulu CLI'lar: $cliStatus"
$statusLabel.Font = New-Object System.Drawing.Font('Segoe UI', 8)
$statusLabel.ForeColor = [System.Drawing.Color]::DimGray
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(20, 48)
$form.Controls.Add($statusLabel)

$panel = New-Object System.Windows.Forms.FlowLayoutPanel
$panel.FlowDirection = 'TopDown'
$panel.WrapContents = $false
$panel.AutoScroll = $true
$panel.Location = New-Object System.Drawing.Point(15, 75)
$panel.Size = New-Object System.Drawing.Size(715, 530)
$panel.Anchor = 'Top,Bottom,Left,Right'
$form.Controls.Add($panel)

$agents = Get-Agents

foreach ($agent in $agents) {
    $card = New-Object System.Windows.Forms.Panel
    $card.Size = New-Object System.Drawing.Size(685, 110)
    $card.BackColor = [System.Drawing.Color]::White
    $card.Margin = New-Object System.Windows.Forms.Padding(0, 0, 0, 10)
    $card.BorderStyle = 'FixedSingle'

    $titleLbl = New-Object System.Windows.Forms.Label
    $titleLbl.Text = $agent.Title
    $titleLbl.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
    $titleLbl.AutoSize = $true
    $titleLbl.Location = New-Object System.Drawing.Point(12, 8)
    $card.Controls.Add($titleLbl)

    $folderLbl = New-Object System.Windows.Forms.Label
    $folderLbl.Text = $agent.FolderName
    $folderLbl.Font = New-Object System.Drawing.Font('Consolas', 8)
    $folderLbl.ForeColor = [System.Drawing.Color]::Gray
    $folderLbl.AutoSize = $true
    $folderLbl.Location = New-Object System.Drawing.Point(12, 30)
    $card.Controls.Add($folderLbl)

    $descLbl = New-Object System.Windows.Forms.Label
    $descLbl.Text = $agent.Description
    $descLbl.Font = New-Object System.Drawing.Font('Segoe UI', 8.5)
    $descLbl.Size = New-Object System.Drawing.Size(420, 48)
    $descLbl.Location = New-Object System.Drawing.Point(12, 48)
    $card.Controls.Add($descLbl)

    $mainBtn = New-Object System.Windows.Forms.Button
    $mainBtn.Text = 'Claude ile ac'
    $mainBtn.Size = New-Object System.Drawing.Size(120, 34)
    $mainBtn.Location = New-Object System.Drawing.Point(445, 12)
    $mainBtn.BackColor = [System.Drawing.Color]::FromArgb(217, 119, 87)
    $mainBtn.ForeColor = [System.Drawing.Color]::White
    $mainBtn.FlatStyle = 'Flat'
    $mainAgentPath = $agent.Path
    $mainBtn.Add_Click({ Start-AgentChat -AgentPath $mainAgentPath -CliLabel 'Claude' }.GetNewClosure())
    $card.Controls.Add($mainBtn)

    $x = 445
    foreach ($cliName in @('Gemini', 'Codex', 'Grok', 'Qwen')) {
        $b = New-Object System.Windows.Forms.Button
        $b.Text = $cliName
        $b.Size = New-Object System.Drawing.Size(58, 26)
        $b.Location = New-Object System.Drawing.Point($x, 55)
        $b.Font = New-Object System.Drawing.Font('Segoe UI', 7.5)
        if ($CliMap[$cliName].Found) {
            $b.BackColor = [System.Drawing.Color]::FromArgb(230, 236, 240)
        } else {
            $b.Enabled = $false
            $b.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
        }
        $b.FlatStyle = 'Flat'
        $capturedPath = $agent.Path
        $capturedCli = $cliName
        $b.Add_Click({ Start-AgentChat -AgentPath $capturedPath -CliLabel $capturedCli }.GetNewClosure())
        $card.Controls.Add($b)
        $x += 64
    }

    $panel.Controls.Add($card)
}

if ($agents.Count -eq 0) {
    $empty = New-Object System.Windows.Forms.Label
    $empty.Text = "Hicbir ajan bulunamadi (KIMLIK.md iceren klasor yok)."
    $empty.AutoSize = $true
    $panel.Controls.Add($empty)
}

[void]$form.ShowDialog()
