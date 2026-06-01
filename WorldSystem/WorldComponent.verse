using { /Verse.org/SceneGraph }
using { /Verse.org/Random }

using { TreeSystem }
using { PlayerSystem }

spawn_event<public> := class(player_event):

world_component<public> := class<final_super><abstract>(tree_root_component):

    Spawn<public>(Target:entity):void=
        if:
            TargetPoint := Shuffle(FindSpawnPoints())[0]
        then:
            TargetPoint.Teleport(Target)

    FindSpawnPoints<protected><final>()<transacts>:[]world_spawn_point_component=
        for:
            Element : Entity.FindDescendantComponents(world_spawn_point_component)
        do:
            Element

    OnReceive<override>(SceneEvent:scene_event):logic=
        if:
            SpawnEvent := spawn_event[SceneEvent]
        then:
            Spawn(SpawnEvent.Player)

        false