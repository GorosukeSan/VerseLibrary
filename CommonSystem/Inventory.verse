using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Itemization }

(Entity:entity).GetRootInventory<public>()<decides><transacts>:inventory_component=
    Result := 
        for:
            Component : Entity.FindDescendantComponents(inventory_component)
        do:
            Component
    Result[0]

(Entity:entity).GetRootAgent<public>()<decides><transacts>:agent=
    if(Agent := agent[Entity]):
        Agent
    else:
        Entity.GetParent[].GetRootAgent[]