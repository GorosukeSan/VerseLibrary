using { /Verse.org/Simulation }
using { /Verse.org/SceneGraph }
using { /Verse.org/Presentation }

using { ManagerSystem }

item_container_element_component<public> := class<final_super>(manager_element_component):
    @editable
    ItemEntity<public>:?concrete_subtype(entity) = false

    OnBeginSimulation<override>():void=
        if:
            not Entity.GetComponent[icon_component]
            item_entity := ItemEntity?
            ItemIcon := item_entity{}.GetComponent[icon_component]
        then:
            NewIconComponent := icon_component:
                Entity := Entity
                Icon := ItemIcon.Icon
            Entity.AddComponents(array{NewIconComponent})

        if:
            not Entity.GetComponent[description_component]
            item_entity := ItemEntity?
            ItemName := item_entity{}.GetComponent[description_component]
        then:
            NewDescriptionComponent := description_component:
                Entity := Entity
                Name := ItemName.Name
                Description := ItemName.Description
            Entity.AddComponents(array{NewDescriptionComponent})