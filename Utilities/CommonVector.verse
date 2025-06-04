using { /UnrealEngine.com/Temporary/SpatialMath }

Max<public>(X:vector3, Y:vector3)<reads>:vector3=
    vector3:
        X := Max(X.X, Y.X)
        Y := Max(X.Y, Y.Y)
        Z := Max(X.Z, Y.Z)

Min<public>(X:vector3, Y:vector3)<reads>:vector3=
    vector3:
        X := Min(X.X, Y.X)
        Y := Min(X.Y, Y.Y)
        Z := Min(X.Z, Y.Z)