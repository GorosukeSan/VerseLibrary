using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/Devices }

rank_info<public> := class<unique>:
    @editable
    Icon<public>:texture
    @editable
    Name<public>:string
    @editable
    Threshold<public>:int = 0
    @editable
    ReachedEvent<public>:channel_device = channel_device{}
    @editable
    IsReached<public>:switch_device = switch_device{}
    @editable
    AttachVFX<public>:visual_effect_powerup_device = visual_effect_powerup_device{}

(RankInfo:[]rank_info).FindCurrentRank<public>(InScore:int)<decides><transacts>:rank_info=
    var Result:?rank_info = false
    for:
        RankElement : RankInfo
        RankElement.Threshold <= InScore
    do:
        set Result = option{RankElement}
    Result?

(RankInfo:[]rank_info).FindNextRank<public>(InScore:int)<decides><transacts>:rank_info=
    (
        for:
            RankElement : RankInfo
            RankElement.Threshold > InScore
        do:
            RankElement
    )[0]

(RankInfo:[]rank_info).IsContainsDefaultRank<public>()<decides><transacts>:void=
    (
        for:
            RankElement : RankInfo
            RankElement.Threshold = 0
        do:
            RankElement
    )[0]

SortByThreshold<public>(X:rank_info, Y:rank_info)<decides><computes>:void=
    X.Threshold < Y.Threshold