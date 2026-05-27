using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Verse.org/SceneGraph }
using { /Fortnite.com/Characters }

(Agent:agent).GetIcon<public>()<decides><transacts>:texture=
    FortCharacter := Agent.GetFortCharacter[]
    CharacterEntity := FortCharacter.GetEntity[]
    IconComponent := CharacterEntity.GetComponent[icon_component]
    IconComponent.Icon

GetName<public><localizes>(Agent:agent):message="{Agent}"