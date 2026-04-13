Write-Host "Koikatsu Party 日本語化スクリプト"
Write-Host

$ErrorActionPreference = 'Stop'
$gameInstalledPath = "C:\Program Files (x86)\Steam\steamapps\common\Koikatsu Party"
$setupXmlPath = Join-Path -Path $gameInstalledPath -ChildPath "UserData", "setup.xml"
$pluginsFolderPath = Join-Path -Path $gameInstalledPath -ChildPath "BepInEx", "plugins"
$patchersFolderPath = Join-Path -Path $gameInstalledPath -ChildPath "BepInEx", "patchers"

Write-Host "Special Patchをインストール中"
Invoke-WebRequest -Uri "https://aidl1.illusion.rip/download/dlexe/koikatsuparty_sp0409.exe" -OutFile "koikatsuparty_sp0409.exe"
Start-Process -FilePath "koikatsuparty_sp0409.exe" -ArgumentList "-y" -Wait
Copy-Item -Path ".\Koikatsu Party Special Patch_0409\*" -Destination $gameInstalledPath -Recurse -Force

Write-Host "BepInExをインストール中"
$bepInExReleaseAssets = (Invoke-RestMethod -Uri "https://api.github.com/repos/BepInEx/BepInEx/releases/latest").assets
foreach ( $asset in $bepInExReleaseAssets )
{
    if ( $asset.name.Contains( "win_x64" ) )
    {
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "BepInEx.zip"
        break
    }
}
Expand-Archive -Path "BepInEx.zip" -DestinationPath $gameInstalledPath -Force

Write-Host "必要なフォルダを作成中"
New-Item -Path $pluginsFolderPath -ItemType Directory -Force
New-Item -Path $patchersFolderPath -ItemType Directory -Force

Write-Host "BepisPluginsのExtensibleSaveFormatをインストール中"
$bepisPluginsReleaseAssets = (Invoke-RestMethod -Uri "https://api.github.com/repos/IllusionMods/BepisPlugins/releases/latest").assets
foreach ( $asset in $bepisPluginsReleaseAssets )
{
    if ( $asset.name.Contains( "KK_BepisPlugins" ) )
    {
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "BepisPlugins.zip"
        break
    }
}
Expand-Archive -Path "BepisPlugins.zip"
Copy-Item -Path ".\BepisPlugins\BepInEx\patchers\*.dll" -Destination $patchersFolderPath
$bepisPluginsFolderPath = Join-Path -Path $pluginsFolderPath -ChildPath "KK_BepisPlugins"
New-Item -Path $bepisPluginsFolderPath -ItemType Directory -Force
Copy-Item -Path ".\BepisPlugins\BepInEx\plugins\KK_BepisPlugins\ExtensibleSaveFormat.dll" -Destination $bepisPluginsFolderPath
Copy-Item -Path ".\BepisPlugins\BepInEx\plugins\KK_BepisPlugins\LICENSE" -Destination $bepisPluginsFolderPath

Write-Host "IllusionModdingAPIをインストール中"
$moddingApiReleaseAssets = (Invoke-RestMethod -Uri "https://api.github.com/repos/IllusionMods/IllusionModdingAPI/releases/latest").assets
foreach ( $asset in $moddingApiReleaseAssets )
{
    if ( $asset.name.Contains( "KK_ModdingAPI" ) )
    {
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "ModdingAPI.zip"
        break
    }
}
Expand-Archive -Path "ModdingAPI.zip"
Copy-Item -Path ".\ModdingAPI\BepInEx\plugins\*.dll" -Destination $pluginsFolderPath

Write-Host "IllusionFixesのRestoreMissingFunctionsをインストール中"
$illusionFixesReleaseAssets = (Invoke-RestMethod -Uri "https://api.github.com/repos/IllusionMods/IllusionFixes/releases/latest").assets
foreach ( $asset in $illusionFixesReleaseAssets )
{
    if ( $asset.name.Contains( "_Koikatsu_" ) )
    {
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "IllusionFixes.zip"
        break
    }
}
Expand-Archive -Path "IllusionFixes.zip"
$illusionFixesFolderPath = Join-Path -Path $pluginsFolderPath -ChildPath "IllusionFixes"
New-Item -Path $illusionFixesFolderPath -ItemType Directory -Force
Copy-Item -Path ".\IllusionFixes\BepInEx\plugins\IllusionFixes\KK_Fix_RestoreMissingFunctions.dll" -Destination $illusionFixesFolderPath
Copy-Item -Path ".\IllusionFixes\BepInEx\plugins\IllusionFixes\LICENSE" -Destination $illusionFixesFolderPath

Write-Host "IllusionLaunchersをインストール中"
$illusionLaunchersReleaseAssets = (Invoke-RestMethod -Uri "https://api.github.com/repos/IllusionMods/IllusionLaunchers/releases/latest").assets
foreach ( $asset in $illusionLaunchersReleaseAssets )
{
    if ( $asset.name.Contains( "Koikatsu-Steam" ) )
    {
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "IllusionLaunchers.zip"
        break
    }
}
Expand-Archive -Path "IllusionLaunchers.zip" -DestinationPath $gameInstalledPath -Force

Write-Host "英語用のデフォルトキャラクターカードを日本語用としてコピー中"
Copy-Item -Path $(Join-Path -Path $gameInstalledPath -ChildPath "DefaultData", "1") -Destination $(Join-Path -Path $gameInstalledPath -ChildPath "DefaultData", "0") -Recurse -Force

Write-Host "言語を日本語に変更中"
$setupXml = [xml]::new()
$setupXml.Load($setupXmlPath)
$setupXml.Setting.Language = 0
$setupXml.Save($setupXmlPath)

Write-Host "完了"