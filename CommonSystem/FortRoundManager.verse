using { /Verse.org/SceneGraph }
using { /Fortnite.com/Game }

has_fort_round_manager<public> := interface:

    OnRoundStarted<public>()<suspends>:void = {}
    OnRoundEnded<public>():void = {}

(Entity:entity).SubscribeRoundManager<public>(Target:has_fort_round_manager):void=
    if:
        FortRoundManager := Entity.GetFortRoundManager[]
    then:
        FortRoundManager.SubscribeRoundStarted(Target.OnRoundStarted)
        FortRoundManager.SubscribeRoundEnded(Target.OnRoundEnded)
        