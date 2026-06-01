using { /Verse.org/SceneGraph }

using { TreeSystem }

(Entity:entity).GetManager<public>(manager_type:castable_subtype(manager_component))<decides><transacts>:manager_type=
    SimulationEntity := Entity.GetSimulationEntity[]
    Result := 
        for:
            Component : SimulationEntity.FindDescendantComponents(manager_type)
        do:
            Component
    Result[0]

manager_component<public> := class<final_super><abstract>(tree_root_component):