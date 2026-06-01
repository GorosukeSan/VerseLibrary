using { /Verse.org/Simulation }

mode_condition_global_counter<public> := class(mode_global_condition):
    @editable
    var<private> TargetCount<public>:int = 10

    var<private> CurrentCount<public>:int = 0
    CountUpdatedEvent<public>:event() = event(){}

    Count<public>():void=
        set CurrentCount += 1
        CountUpdatedEvent.Signal()

    Reset<public>():void=
        set CurrentCount = 0

    GetResult<override>()<transacts>:mode_result=
        if(CurrentCount >= TargetCount):
            mode_result.Success
        else:
            mode_result.OnGoing

# mode_condition_player_counter<public> := class(mode_player_condition):