using { /Verse.org/Simulation }
using { /Verse.org/Random }

subsequence_select_mode<public> := enum<open>:
    Random

sequence_result<public> := class<castable><abstract>:
sequence_play_next_result<public> := class<castable>(sequence_result):
sequence_stop_result<public> := class<castable>(sequence_result):
sequence_reset_result<public> := class<castable>(sequence_result):

game_sequence_component<public> := class<final_super><abstract><castable>(game_element_component):
    @editable
    SelectMode<public>:subsequence_select_mode = subsequence_select_mode.Random

    Play<public><final>()<suspends>:void=
        SequenceResult := Sequence()

    Sequence<protected>()<suspends>:sequence_result

    GetNextSequence<public><final>()<decides><transacts>:game_sequence_component=
        Subsequence := GetSubsequence()
        case(SelectMode):
            subsequence_select_mode.Random =>
                Shuffle(Subsequence)[0]

    GetSubsequence<protected><final>()<transacts>:[]game_sequence_component=
        for:
            EntityElement : Entity.GetEntities()
            SequenceComponent := EntityElement.GetComponent[game_sequence_component]
        do:
            SequenceComponent