param(
  [string]$ProcessName = "msedge",
  [string]$TitlePattern = "",
  [int]$MaxDepth = 5,
  [int]$MaxItems = 250,
  [string]$Filter = "",
  [string]$OutPath = ""
)

Add-Type -AssemblyName UIAutomationClient

$processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue |
  Where-Object { $_.MainWindowHandle -ne 0 }
if ($TitlePattern) {
  $processes = $processes | Where-Object { $_.MainWindowTitle -match $TitlePattern }
}
$process = $processes | Select-Object -First 1
if (-not $process) {
  throw "No window found for process '$ProcessName'."
}

$root = [System.Windows.Automation.AutomationElement]::FromHandle($process.MainWindowHandle)
$walker = [System.Windows.Automation.TreeWalker]::ControlViewWalker
$results = New-Object System.Collections.Generic.List[object]

function Convert-BoundValue {
  param([double]$Value)
  if ([double]::IsNaN($Value) -or [double]::IsInfinity($Value)) {
    return $null
  }
  if ($Value -gt [int]::MaxValue -or $Value -lt [int]::MinValue) {
    return $null
  }
  return [int]$Value
}

function Add-Element {
  param(
    [System.Windows.Automation.AutomationElement]$Element,
    [int]$Depth
  )
  if (-not $Element -or $results.Count -ge $MaxItems -or $Depth -gt $MaxDepth) {
    return
  }

  $rect = $Element.Current.BoundingRectangle
  $item = [pscustomobject]@{
    Depth = $Depth
    Name = $Element.Current.Name
    AutomationId = $Element.Current.AutomationId
    ControlType = $Element.Current.ControlType.ProgrammaticName
    ClassName = $Element.Current.ClassName
    IsEnabled = $Element.Current.IsEnabled
    IsOffscreen = $Element.Current.IsOffscreen
    Bounds = [pscustomobject]@{
      X = Convert-BoundValue $rect.X
      Y = Convert-BoundValue $rect.Y
      Width = Convert-BoundValue $rect.Width
      Height = Convert-BoundValue $rect.Height
    }
  }

  $text = (($item.Name, $item.AutomationId, $item.ControlType, $item.ClassName) -join " ")
  if (-not $Filter -or $text -match $Filter) {
    $results.Add($item) | Out-Null
  }

  $child = $walker.GetFirstChild($Element)
  while ($child -and $results.Count -lt $MaxItems) {
    Add-Element -Element $child -Depth ($Depth + 1)
    $child = $walker.GetNextSibling($child)
  }
}

Add-Element -Element $root -Depth 0
$json = $results | ConvertTo-Json -Depth 6
if ($OutPath) {
  $resolved = [System.IO.Path]::GetFullPath($OutPath)
  $dir = [System.IO.Path]::GetDirectoryName($resolved)
  if ($dir -and -not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }
  $json | Set-Content -LiteralPath $resolved -Encoding UTF8
  Write-Output $resolved
} else {
  $json
}
