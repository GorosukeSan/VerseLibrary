using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }

world_spawn_point_component<public> := class<final_super>(world_object_component):

    Teleport<public>(Target:entity):void=
        if:
            Agent := agent[Target]
            FortCharacter := Agent.GetFortCharacter[]
            CharacterEntity := FortCharacter.GetEntity[]
        then:
            Teleport(CharacterEntity)
        else:
            Target.SetGlobalTransform(Entity.GetGlobalTransform())