Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$configDir = Join-Path $HOME '.config' 'chezmoi'
$configFile = Join-Path $configDir 'chezmoi.toml'

New-Item -ItemType Directory -Force -Path $configDir | Out-Null

# 获取当前目录并转换反斜杠为正斜杠
$currentDir = (Get-Location).Path -replace '\\', '/'

# 写入配置（覆盖已有文件）
"sourceDir = `"$currentDir`"" | Set-Content -Path $configFile -Force

Write-Host "✓ Set chezmoi sourceDir 为: $currentDir"