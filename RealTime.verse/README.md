
# API

## GetCurrentRealTime
現在の時刻をreal_time型で取得します。引数にはtime_zone型のインスタンスを渡す必要があり、戻り値はその時差を配慮した時刻の結果が返ってきます。

```
CurrentTime := GetCurrentRealTime(time_zone_tokyo{})
```

## MakeRealTime
float型をreal_time型に変換する関数です。引数には時間を表すfloat, 時差を表すtime_zone, その時間がエポック秒かを示すlogic型を渡せます。
時刻の四則演算を行う場合にはIsEpochTimeをfalseにする必要があります。

```
Result := MakeRealTime(GetSecondsSinceEpoch(), time_zone_tokyo{}, ?IsEpochTime := true)
```

## ToFloat
real_time型をfloat型に変換する関数です。real_time型内で時差を設定していたとしても、時差をなくした状態の数値が返ってきます。

```
TimeFloat := CurrentTime.ToFloat()
```

## Adjust
外部からの計算の結果、例えば日にちに32以上の数値が入っている場合などに再計算をして正しいフォーマットに直す関数です。

## ToTimeZoneFloat
real_time型をtime_zoneの時差を足し合わせてfloatとして返す関数です。

## IsEqual
real_time型同士を比較し、一致する場合に成功する関数です。

## GreaterThan
real_time型同士を比較し、より大きな場合に成功する関数です。

## EqualOrGreaterThan
real_time型同士を比較し、以上の場合に成功する関数です。

## LessThan
real_time型同士を比較し、より小さな場合に成功する関数です。

## EqualOrLessThan
real_time型同士を比較し、以下の場合に成功する関数です。

## Distance
real_time型同士の差を取得する関数です。

## operator`+`
real_time型同士は足し算を行えます。

## operator`-`
real_time型同士は引き算を行えます。

# タイムゾーンを増やす
```
time_zone_tokyo<public> := class<computes>(time_zone):
    Time<override>:float = 32400.0
```
time_zoneクラスを継承し、Time変数をoverrideすることで新たなタイムゾーンを作ることができます。