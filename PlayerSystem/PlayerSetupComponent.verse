using { /Verse.org/Simulation }

player_setup_component<public> := class<final_super><abstract>(player_manager_element_component):

    Setup<public>(Player:player):void

    OnPlay<override><final>(Player:player):void=
        Setup(Player)