using { /Verse.org/Simulation }
using { /Verse.org/SceneGraph }

using { ManagerSystem }

player_manager_element_component<public> := class<final_super><abstract>(manager_element_component):

    OnPlay<protected>(Player:player):void=
        return

    OnLeave<protected>(Player:player):void=
        return

    OnReceive<override>(SceneEvent:scene_event):logic=
        if:
            PlayerAddedEvent := player_added_event[SceneEvent]
        then:
            OnPlay(PlayerAddedEvent.Player)
        else if:
            PlayerRemovedEvent := player_removed_event[SceneEvent]
        then:
            OnLeave(PlayerRemovedEvent.Player)

        false