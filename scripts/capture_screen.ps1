param(
  [Parameter(Mandatory = $true)]
  [string]$OutPath,
  [int]$DelayMs = 0
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if ($DelayMs -gt 0) {
  Start-Sleep -Milliseconds $DelayMs
}

$resolved = [System.IO.Path]::GetFullPath($OutPath)
$dir = [System.IO.Path]::GetDirectoryName($resolved)
if ($dir -and -not (Test-Path -LiteralPath $dir)) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
try {
  $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
  $bitmap.Save($resolved, [System.Drawing.Imaging.ImageFormat]::Png)
  Write-Output $resolved
}
finally {
  $graphics.Dispose()
  $bitmap.Dispose()
}
