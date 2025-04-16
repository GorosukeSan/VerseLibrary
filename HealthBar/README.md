# 使い方

## HPBarDamageInfo
「+プラス」ボタンを押してエレメントを追加していきます。DamageTriggerにはトリガーの仕掛けを入れて、起動すると体力の値が増減します。Amountが実際の減少量です。-100とすると逆に回復させることもできます。

## MaxHealth
体力の最大値です。ゲージの割合とUI上の数字で確認できます。

## InitialHealthPercent
体力の初期値です。50とするとMaxHealthの50%の量で値が決定します。

## HPBarDesginInfo
HPバーの色、位置、サイズ、ゲージの方向を決定する項目です。

## ShowTrigger
起動するとHPバーを表示します。

## HideTrigger
起動するとHPバーを非表示にします。

## EliminatedEvent
トリガーを参照し、体力が0%になると起動します。

## MaxHealthEvent
トリガーを参照し、体力が100%になると起動します。

## IsEliminated
スイッチの仕掛けを参照し、体力が0%の時にはオン、以外の時はオフとなります。

## IsMax
スイッチの仕掛けを参照し、体力が100%の時にはオン、以外の時にはオフとなります。