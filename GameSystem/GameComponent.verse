
using { ManagerSystem }
using { CommonSystem }

game_component<public> := class<final_super><abstract>(manager_component, has_fort_round_manager):

    OnSimulate<override>()<suspends>:void=
        Entity.SubscribeRoundStarted(Self)

game_element_component<public> := class<final_super><abstract>(manager_element_component):