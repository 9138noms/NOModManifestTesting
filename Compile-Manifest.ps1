param($inputPath = ".\modManifests",$outputPath = ".\manifest")
$pluginManifests = (Get-ChildItem $inputPath -Filter "*.json").FullName

[System.Collections.ArrayList]$manifest = @()

foreach ($manifest_ in $pluginManifests)
{
    $manifestItem = $null
    try
    {
        $manifestItem = Get-Content $manifest_ | ConvertFrom-Json
        $manifest.Add($manifestItem)
    }
    catch
    {
        $errorString = $_ | Out-String
        Write-Error $errorString
        Exit 1
    }
    Clear-Variable manifestItem
}

if ($manifest.Count -ne $pluginManifests.Count)
{
    $errorString = "There are $($pluginManifests.Count), but only $($manifest.Count) made it to the manifest!"
    Write-Error $errorString
    Exit 1
}

$manifest | ConvertTo-Json -Depth 100 | Out-File $([IO.Path]::Combine($outputPath,"manifest.json"))
