# KoikatsuParty-JPLocalizer-Script
## 説明
Koikatsu Party(Steamにあるコイカツの英語版)を日本語にするスクリプトです。

<img width="1282" height="747" alt="image" src="https://github.com/user-attachments/assets/444c2ad8-3703-4336-a996-40efdf2069fb" />

## 使い方
リポジトリにあるPowerShellスクリプトを実行すれば自動で日本語にしてくれます。

もしスクリプトを実行できなかった場合は、Restrictedポリシーになっていることが考えられるので、[ここ](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_scripts)を参照してポリシーを変更してください。

一時ファイルをスクリプトと同じディレクトリに置きまくるので、スクリプト用のフォルダを作ったほうがいいかもしれません。

## 導入するパッチ / mod
 - Special Patch ([公式](https://koikatsuparty.illusion.rip/)が出していたパッチで、Koikatsu Partyから削られているストーリーモードを追加する)
 - [BepInEx](https://github.com/BepInEx/BepInEx) (下記のmodsのためのフレームワーク)
 - ExtensibleSaveFormat ([BepisPlugins](https://github.com/IllusionMods/BepisPlugins)の一部、IllusionModdingAPIの依存関係)
 - [IllusionModdingAPI](https://github.com/IllusionMods/IllusionModdingAPI) (IllusionFixesの依存関係)
 - RestoreMissingFunctions ([IllusionFixes](https://github.com/IllusionMods/IllusionFixes)の一部、このmodが日本語への切り替えを可能にしている)

## 留意点
Koikatsu Partyには日本語用のデフォルトキャラクターカードがないので、このスクリプトでは英語用のものをそのまま日本語用としてコピーします。

なのでデフォルトキャラクター達の名前が英語になります。

<img width="269" height="171" alt="image" src="https://github.com/user-attachments/assets/205d0afa-427c-4371-8292-124552810f25" />

## 余談
このスクリプトは、私みたいに今更コイカツを買って普通にバニラの状態で遊んでみたいというおそらく珍しい人のためのものです。~~(私は若いので最近までコイカツについてよく知りませんでした)~~

日本語にするだけならHF PatchでIllusionFixesだけ入れてもいけますが、ダウンロードとインストールともに死ぬほど遅いのできついです。

このスクリプトは本当に必要最低限のmodsしか導入しないので、すぐ終わりますし、限りなくバニラの状態に近いです。

BepInExやmodsを更新したいときは、このスクリプトをもう一回実行すれば更新されるはずです。
