using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

(Entity:entity).CanTrade<public>(Amount:int)<decides><transacts>:void=
    not Entity.GetCost[] or (Amount >= Entity.GetCost[])

(Entity:entity).GetCost<public>()<decides><transacts>:int=
    Entity.GetComponent[cost_component].Cost

cost_component<public> := class<final_super>(component):
    @editable
    Cost<public>:int = 0