using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

using { ManagerSystem }
using { CommonSystem }

player_event<public> := class<abstract>(scene_event):
    Player<public>:player

player_added_event<public> := class(player_event):
player_removed_event<public> := class(player_event):

player_manager_component<public> := class<final_super><abstract>(manager_component, has_fort_round_manager, has_playspace_event):

    OnBeginSimulation<override>():void=
        Entity.SubscribePlayspace(Self)

    OnRoundStarted<override>():void=
        Entity.SubscribePlayspace(Self)

    OnPlay<override>(Player:player):void=
        NewEvent := player_added_event:
            Player := Player
        Entity.SendDown(NewEvent)

    OnLeave<override>(Player:player):void=
        NewEvent := player_removed_event:
            Player := Player
        Entity.SendDown(NewEvent)