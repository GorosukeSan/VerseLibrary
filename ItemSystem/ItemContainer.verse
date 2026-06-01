using { /Verse.org/SceneGraph }

using { ManagerSystem }
using { CommonSystem  }

item_container_component<public> := class<final_super>(manager_component):

    GetItems<public><final>()<transacts>:[]entity=
        for:
            Component : Entity.FindDescendantComponents(item_container_element_component)
        do:
            Component.Entity

    GetSortedItems<public><final>()<transacts>:[]entity=
        GetItems().SortableSort()