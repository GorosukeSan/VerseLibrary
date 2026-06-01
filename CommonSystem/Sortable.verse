using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary }

(Entities:[]entity).SortableSort<public>()<transacts>:[]entity=
    Result := 
        for:
            EntityElement : Entities
            SortValue := 
                if(Sortable := EntityElement.GetComponent[sortable_component]):
                    Sortable.Sort
                else:
                    1000000000.0
        do:
            (EntityElement, SortValue)

    SortedResult := SortBy(Result, SortableCompare)

    for:
        ResultElement : SortedResult
    do:
        ResultElement(0)

SortableCompare<internal>(X:tuple(entity, float), Y:tuple(entity, float))<decides><computes>:void=
    X(1) < Y(1)

sortable_component<public> := class<final_super>(component):
    @editable
    Sort<public>:float = 0.0