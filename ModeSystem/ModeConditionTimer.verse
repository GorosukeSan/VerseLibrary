using { /Verse.org/Simulation }

mode_condition_global_timer<public> := class(mode_global_condition):
    @editable
    var<private> TargetTime<public>:float = 60.0

    var<private> StartTime<public>:?float = false
    var IsFailure<private>:logic = false

    SetTargetTime<public>(NewTime:float):void=
        set TargetTime = NewTime

    Start<public>():void=
        set StartTime = option:
            GetSimulationElapsedTime()

    Cancel<public>():void=
        set IsFailure = true

    Reset<public>():void=
        set StartTime = false
        set IsFailure = false

    GetResult<override>()<transacts>:mode_result=
        if(IsFailure?):
            mode_result.Failure
        else:
            if(Time := StartTime?):
                CurrentTime := GetSimulationElapsedTime()
                if(CurrentTime - Time >= TargetTime):
                    mode_result.Success
                else:
                    mode_result.OnGoing
            else:
                mode_result.NotReady