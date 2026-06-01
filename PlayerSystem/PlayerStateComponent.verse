using { /Verse.org/Simulation }

using { ManagerSystem }
using { CommonSystem }

player_state<public> := class<castable>:
    var IDs:[]string = array{}

player_state_component<public> := class<final_super><abstract>(player_manager_element_component):

player_session_state_component<public> := class<final_super>(player_state_component):

    var<private> PlayerState<public>:[player]player_state = map{}

    HasID<public><final>(Player:player, ID:string)<decides><transacts>:void=
        PlayerState[Player].IDs.Find[ID]

    AddID<public><final>(Player:player, ID:string):void=
        if:
            not HasID[Player, ID]
            CurrentState := PlayerState[Player]
        then:
            set CurrentState.IDs += array{ID}

    RemoveID<public><final>(Player:player, ID:string):void=
        if:
            HasID[Player, ID]
            CurrentState := PlayerState[Player]
        then:
            set CurrentState.IDs = CurrentState.IDs.RemoveAllElements(ID)

    Setup<public><final>(Player:player):void=
        if:
            not PlayerState[Player]
            set PlayerState[Player] = MakePlayerState()
        then:

    MakePlayerState<protected>()<transacts>:player_state=
        player_state:

    GetPlayerStateAs<public>(Player:player, state_type:castable_subtype(player_state))<reads><decides>:state_type=
        CurrentState := PlayerState[Player]
        state_type[CurrentState]

    OnPlay<override>(Player:player):void=
        Setup(Player)

    OnLeave<override>(Player:player):void=
        set PlayerState = PlayerState.RemoveKey(Player)

player_persistent_state_component<public> := class<final_super><abstract>(player_state_component):

    HasID<public>(Player:player, ID:string)<decides><transacts>:void
    AddID<public>(Player:player, ID:string):void
    RemoveID<public>(Player:player, ID:string):void
