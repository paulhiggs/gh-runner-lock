param([switch]$NoPause = $false)

# Exit this script.
function Exit-Script([string] $Message = "")
{
    if ($Message -ne "") {
        Write-Host "ERROR: $Message"
    }
    if (-not $NoPause) {
        pause
    }
    exit
}

# Find MSBuild. Try fast path first.
$MSBuild = Get-ChildItem "C:\Program Files\Microsoft Visual Studio\*\*\MSBuild\Current\Bin\MSBuild.exe" | Select-Object -Last 1
if ($MSBuild -ne $null) {
    $MSBuild = $MSBuild.FullName
}
else {
    # Fallback: search everywhere
    $MSRoots = @("C:\Program Files*\MSBuild", "C:\Program Files*\Microsoft Visual Studio")
    $MSBuild = Get-ChildItem -Recurse -Path $MSRoots -Include MSBuild.exe -ErrorAction Ignore |
               ForEach-Object { (Get-Command $_).FileVersionInfo } |
               Sort-Object -Unique -Property FileVersion |
               ForEach-Object { $_.FileName} |
               Select-Object -Last 1
}
if (-not $MSBuild) {
    Exit-Script "MSBuild not found"
}

Write-Output "MSBuild = $MSBuild"

# Build the exe
& $MSBuild $PSScriptRoot\test.sln /nologo

Exit-Script
