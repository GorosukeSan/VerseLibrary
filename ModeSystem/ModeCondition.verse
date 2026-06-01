using { /Verse.org/Simulation }

mode_result<public> := enum:
    NotReady
    OnGoing
    Success
    Failure
    Unknown

mode_condition<public> := class<abstract>:

mode_global_condition<public> := class<abstract>(mode_condition):

    GetResult<public>()<transacts>:mode_result
    
mode_player_condition<public> := class<abstract>(mode_condition):

    GetResult<public>(Player:player)<transacts>:mode_result