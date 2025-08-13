using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

score_type<public> := enum:
    Add
    Subtract
    Set

rank_system_score<public> := class<final>:
    @editable
    Score<public>:int = 1
    @editable
    Type<public>:score_type = score_type.Add
    @editable
    Activate<public>:channel_device = channel_device{}

AwaitTriggeredScore<public>(InScore:rank_system_score)<suspends>:tuple(?agent, rank_system_score)=
    (InScore.Activate.ReceivedTransmitEvent.Await(), InScore)