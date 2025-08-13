using { /Verse.org/Simulation }

var RankSystemSaveData<public>:weak_map(player, rank_system_save_data) = map{}

MakeRankSystemSaveData<public><constructor>(InData:rank_system_save_data)<transacts> := rank_system_save_data:
    Score := InData.Score
    LastReachedIndex := InData.LastReachedIndex

rank_system_save_data<public> := class<final><persistable>:
    Score<public>:int = 0
    LastReachedIndex<public>:int = 0

SetScoreToSaveData<public>(InPlayer:player, InScore:int)<transacts>:void=
    if:
        CurrentData := RankSystemSaveData[InPlayer]
        set RankSystemSaveData[InPlayer] = rank_system_save_data:
            MakeRankSystemSaveData<constructor>(CurrentData)
            Score := Max(InScore, 0)

GetScore<public>(InPlayer:player)<transacts>:int=
    if:
        CurrentData := RankSystemSaveData[InPlayer]
    then:
        CurrentData.Score
    else:
        0

SetLastReachedIndex<public>(InPlayer:player, InIndex:int)<transacts>:void=
    if:
        CurrentData := RankSystemSaveData[InPlayer]
        set RankSystemSaveData[InPlayer] = rank_system_save_data:
            MakeRankSystemSaveData<constructor>(CurrentData)
            LastReachedIndex := InIndex