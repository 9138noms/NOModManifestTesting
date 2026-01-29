$currentManifest = (get-content ".\manifest\manifest.json" | ConvertFrom-Json -Depth 1000) | Group-Object id -AsHashTable

$modManifestFiles = Get-ChildItem ".\modManifests" -Filter "*.json"


foreach ($mod in $modManifestFiles)
{
    try
    {
        .\Validate-JsonSchema.ps1 -JsonPath $mod.FullName -SchemaPath .\ValidationSchema.json
        .\Validate-JsonContent.ps1 -Path $mod.FullName -ModManifestHashTable $currentManifest
    } catch
    {
        Exit 1
    }

}
Exit 0