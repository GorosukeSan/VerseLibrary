using { /Fortnite.com/Game }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary }
using { /UnrealEngine.com/Temporary/SpatialMath }

# お互いのベクトルの差が0.0の場合に失敗する
MakeFacingRotation<public>(InBase:vector3, InTarget:vector3)<decides><transacts>:rotation=
    DirectionalVector := (InTarget - InBase).MakeUnitVector[]
    Yaw := RadiansToDegrees(ArcTan(DirectionalVector.Y, DirectionalVector.X))
    Pitch := RadiansToDegrees(ArcTan(DirectionalVector.Z, Sqrt(DirectionalVector.X * DirectionalVector.X + DirectionalVector.Y * DirectionalVector.Y)))
    Roll := 0.0
    MakeRotationFromYawPitchRollDegrees(Yaw, Pitch, Roll)

MakeFacingRotationIgnorePitch<public>(InBase:vector3, InTarget:vector3)<decides><transacts>:rotation=
    DirectionalVector := (InTarget - InBase).MakeUnitVector[]
    Yaw := RadiansToDegrees(ArcTan(DirectionalVector.Y, DirectionalVector.X))
    Pitch := 0.0
    Roll := 0.0
    MakeRotationFromYawPitchRollDegrees(Yaw, Pitch, Roll)

(InCreativeDeviceBase:creative_device_base).Rotate<public>(InRotation:rotation):void=
    if:
        InCreativeDeviceBase.TeleportTo[InCreativeDeviceBase.GetTransform().Translation, InRotation]

# GetTransform()関数はcomputes内で使えないためタプルをはさむ。
SortByHeight<public>(X:tuple(positional, vector3), Y:tuple(positional, vector3))<decides><computes>:void=
    X(1).Z > Y(1).Z

PositionalSortByHeight<public>(InPositionals:[]t where t:subtype(positional)):[]t=
    PositionalTuples := 
        for:
            PositionalElement : InPositionals
        do:
            (PositionalElement, PositionalElement.GetTransform().Translation)
    SortedTuples := SortBy(PositionalTuples, SortByHeight)
    for:
        SortedTupleElement : SortedTuples
    do:
        SortedTupleElement(0)