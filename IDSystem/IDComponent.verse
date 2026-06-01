using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

id_component<public> := class<final_super><final>(component):
    @editable
    ID<public>:string

    Separater<private>:string = "."

    MakeID<public>()<transacts>:string=
        if:
            ParentEntity := Entity.GetParent[]
            ParentID := ParentEntity.GetComponent[id_component]
        then:
            "{ParentID.MakeID()}{Separater}{ID}"
        else:
            ID