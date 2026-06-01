using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Verse.org/SceneGraph }

game_sequence_event<public> := class<abstract>(scene_event):
game_sequence_play_event<public> := class(game_sequence_event):
    SequenceType<public>:castable_subtype(game_sequence_component)

game_sequence_component<public> := class<final_super><abstract><castable>(game_element_component):

    Play<public><final>()<suspends>:void=
        Sequence()
        if(NextSequence := FindNextSequence[]):
            spawn:
                NextSequence.Play()

    Sequence<protected>()<suspends>:void
    NextSequenceType<protected>()<decides><reads>:castable_subtype(game_sequence_component)

    FindNextSequence<private>()<decides><transacts>:game_sequence_component=
        ParentEntity := Entity.GetParent[]
        next_sequence_type := NextSequenceType[]
        Result := 
            for:
                Component : ParentEntity.FindDescendantComponents(next_sequence_type)
            do:
                Component
        Result[0]

    OnReceive<override>(SceneEvent:scene_event):logic=
        if:
            SequenceEvent := game_sequence_play_event[SceneEvent]
            SequenceEvent.SequenceType[Self]
        then:
            spawn{Play()}
            return true
        return false