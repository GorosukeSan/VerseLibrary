using { /Verse.org/Simulation }
using { /Verse.org/SceneGraph }
using { /Fortnite.com/Playspaces }

has_playspace_event<public> := interface:

    OnPlay<public>(Player:player):void = {}
    OnJoin<public>(Player:player):void = {}
    OnLeave<public>(Player:player):void = {}

(Entity:entity).SubscribePlayspace<public>(Target:has_playspace_event):void=
    if:
        FortPlayspace := Entity.GetPlayspaceForEntity[]
    then:
        for:
            PlayerElement : FortPlayspace.GetPlayers()
        do:
            Target.OnPlay(PlayerElement)

        FortPlayspace.PlayerAddedEvent().Subscribe(Target.OnPlay)
        FortPlayspace.PlayerAddedEvent().Subscribe(Target.OnJoin)
        FortPlayspace.PlayerRemovedEvent().Subscribe(Target.OnLeave)