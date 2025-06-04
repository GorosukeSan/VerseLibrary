
(InMap:[t]u).RemoveKey<public>(InKey:t where t:subtype(comparable), u:type)<transacts>:[t]u=
    var Result:[t]u = map{}

    for:
        Key -> Value : InMap
        Key <> InKey
    do:
        set Result = ConcatenateMaps(Result, map{Key => Value})

    Result