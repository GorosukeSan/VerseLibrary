using { /Verse.org/Simulation }
using { /Verse.org/Random }

range_float<public> := struct<computes><concrete>:
    @editable
    Minimum:float = 0.0
    @editable
    Maximum:float = 0.0

(InRangeFloat:range_float).GetRandomFloat<public>()<transacts>:float=
    GetRandomFloat(InRangeFloat.Minimum, InRangeFloat.Maximum)