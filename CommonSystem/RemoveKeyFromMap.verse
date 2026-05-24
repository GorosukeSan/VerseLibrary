
(Map:[key]value).RemoveKey<public>(Target:key where key:subtype(comparable), value:type)<transacts>:[key]value=
    var Result:[key]value = map{}

    for:
        Key -> Value : Map
        Key <> Target
        set Result[Key] = Value
    do:

    Result