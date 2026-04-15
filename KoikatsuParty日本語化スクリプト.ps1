function Get-LatestReleaseAssetFromGitHub {
    param ([string]$Owner, [string]$Repo, [string]$FilterString, [string]$DownloadFileName)
    $releaseAssets = (Invoke-RestMethod -Uri "https://api.github.com/repos/${Owner}/${Repo}/releases/latest").assets
    foreach ( $asset in $releaseAssets )
    {
        if ( $asset.name.Contains( $FilterString ) )
        {
            Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $DownloadFileName
            break
        }
    }
}

Write-Host "Koikatsu Party 日本語化スクリプト"
Write-Host

$ErrorActionPreference = 'Stop'
$gameInstalledPath = "C:\Program Files (x86)\Steam\steamapps\common\Koikatsu Party"
$setupXmlPath = Join-Path -Path $gameInstalledPath -ChildPath "UserData", "setup.xml"
$pluginsFolderPath = Join-Path -Path $gameInstalledPath -ChildPath "BepInEx", "plugins"
$patchersFolderPath = Join-Path -Path $gameInstalledPath -ChildPath "BepInEx", "patchers"

Write-Host "tempフォルダを作成中"
New-Item -Name "temp" -ItemType Directory -Force
Set-Location -Path ".\temp"

Write-Host "Special Patchをインストール中"
Invoke-WebRequest -Uri "https://aidl1.illusion.rip/download/dlexe/koikatsuparty_sp0409.exe" -OutFile "koikatsuparty_sp0409.exe"
Start-Process -FilePath "koikatsuparty_sp0409.exe" -ArgumentList "-y" -Wait
Copy-Item -Path ".\Koikatsu Party Special Patch_0409\*" -Destination $gameInstalledPath -Recurse -Force

Write-Host "BepInExをインストール中"
Get-LatestReleaseAssetFromGitHub -Owner "BepInEx" -Repo "BepInEx" -FilterString "win_x64" -DownloadFileName "BepInEx.zip"
Expand-Archive -Path ".\BepInEx.zip" -DestinationPath $gameInstalledPath -Force

Write-Host "必要なフォルダを作成中"
New-Item -Path $pluginsFolderPath -ItemType Directory -Force
New-Item -Path $patchersFolderPath -ItemType Directory -Force

Write-Host "BepisPluginsのExtensibleSaveFormatをインストール中"
Get-LatestReleaseAssetFromGitHub -Owner "IllusionMods" -Repo "BepisPlugins" -FilterString "KK_BepisPlugins" -DownloadFileName "BepisPlugins.zip"
Expand-Archive -Path ".\BepisPlugins.zip"
Copy-Item -Path ".\BepisPlugins\BepInEx\patchers\*.dll" -Destination $patchersFolderPath
$bepisPluginsFolderPath = Join-Path -Path $pluginsFolderPath -ChildPath "KK_BepisPlugins"
New-Item -Path $bepisPluginsFolderPath -ItemType Directory -Force
Copy-Item -Path ".\BepisPlugins\BepInEx\plugins\KK_BepisPlugins\ExtensibleSaveFormat.dll" -Destination $bepisPluginsFolderPath
Copy-Item -Path ".\BepisPlugins\BepInEx\plugins\KK_BepisPlugins\LICENSE" -Destination $bepisPluginsFolderPath

Write-Host "IllusionModdingAPIをインストール中"
Get-LatestReleaseAssetFromGitHub -Owner "IllusionMods" -Repo "IllusionModdingAPI" -FilterString "KK_ModdingAPI" -DownloadFileName "ModdingAPI.zip"
Expand-Archive -Path ".\ModdingAPI.zip"
Copy-Item -Path ".\ModdingAPI\BepInEx\plugins\*.dll" -Destination $pluginsFolderPath

Write-Host "IllusionFixesのRestoreMissingFunctionsをインストール中"
Get-LatestReleaseAssetFromGitHub -Owner "IllusionMods" -Repo "IllusionFixes" -FilterString "_Koikatsu_" -DownloadFileName "IllusionFixes.zip"
Expand-Archive -Path ".\IllusionFixes.zip"
$illusionFixesFolderPath = Join-Path -Path $pluginsFolderPath -ChildPath "IllusionFixes"
New-Item -Path $illusionFixesFolderPath -ItemType Directory -Force
Copy-Item -Path ".\IllusionFixes\BepInEx\plugins\IllusionFixes\KK_Fix_RestoreMissingFunctions.dll" -Destination $illusionFixesFolderPath
Copy-Item -Path ".\IllusionFixes\BepInEx\plugins\IllusionFixes\LICENSE" -Destination $illusionFixesFolderPath

Write-Host "IllusionLaunchersをインストール中"
Get-LatestReleaseAssetFromGitHub -Owner "IllusionMods" -Repo "IllusionLaunchers" -FilterString "Koikatsu-Steam" -DownloadFileName "IllusionLaunchers.zip"
Expand-Archive -Path ".\IllusionLaunchers.zip" -DestinationPath $gameInstalledPath -Force

Write-Host "英語用のデフォルトキャラクターカードを日本語用としてコピー中"
Copy-Item -Path $(Join-Path -Path $gameInstalledPath -ChildPath "DefaultData", "1") -Destination $(Join-Path -Path $gameInstalledPath -ChildPath "DefaultData", "0") -Recurse -Force

if ( Test-Path -Path $setupXmlPath )
{
    Write-Host "言語を日本語に変更中"
    $setupXml = [xml]::new()
    $setupXml.Load($setupXmlPath)
    $setupXml.Setting.Language = 0
    $setupXml.Save($setupXmlPath)
} else {
    Write-Host "setup.xmlが存在しなかったため、言語の変更をスキップしました。" -ForegroundColor Cyan
    Write-Host "IllusionLaunchersで言語を変更することができます。" -ForegroundColor Cyan
}

Write-Host "tempフォルダを削除中"
Set-Location -Path ".."
Remove-Item -Path ".\temp" -Recurse -Force

Write-Host "完了"