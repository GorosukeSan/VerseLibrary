using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

(InMap:[t]u).RemoveKey<public>(InKey:t where t:subtype(comparable), u:type)<transacts>:[t]u=
    var Result:[t]u = map{}
    for:
        Key -> Value : InMap
        Key <> InKey
    do:
        set Result = ConcatenateMaps(Result, map{Key => Value})
    Result

(InArray:[]t where t:type).GetLastElement<public>()<computes><decides>:t=
    LastIndex := InArray.Length - 1
    InArray[LastIndex]

(VFXPowerup:visual_effect_powerup_device).Attach<public>(InPlayer:player):void=
    VFXPowerup.SetDuration(-1.0)
    VFXPowerup.Pickup(InPlayer)

(VFXPowerup:visual_effect_powerup_device).Dettach<public>(InPlayer:player):void=
    if(VFXPowerup.HasEffect[InPlayer]):
        VFXPowerup.SetDuration(0.1)
        VFXPowerup.Pickup(InPlayer)

ArrayRace(Array:[]t, Function(Element:t)<suspends>:u where t:type, u:type)<suspends>:u=

    if:
        Array.Length > 1
        Mid := Floor(Array.Length / 2)
        LeftArray := Array.Slice[0, Mid]
        RightArray := Array.Slice[Mid]
    then:
        race:
            ArrayRace(LeftArray, Function)
            ArrayRace(RightArray, Function)
    else if:
        First := Array[0]
    then:
        Function(First)
    else:
        Sleep(Inf)
        Err()