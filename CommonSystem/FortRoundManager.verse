using { /Verse.org/SceneGraph }
using { /Fortnite.com/Game }

has_fort_round_manager<public> := interface:

    OnRoundStarted<public>()<suspends>:void = {}
    OnRoundEnded<public>():void = {}

(Component:component).SubscribeRoundStarted<public>(Target:has_fort_round_manager):void=
    if:
        FortRoundManager := Component.Entity.GetFortRoundManager[]
    then:
        FortRoundManager.SubscribeRoundStarted(Target.OnRoundEnded)
        FortRoundManager.SubscribeRoundEnded(Target.OnRoundEnded)
        