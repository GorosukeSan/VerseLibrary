using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary }
using { /Verse.org/Simulation }

rank_system_device<public> := class<final>(creative_device):
    @editable
    var<private> RankInfo<public>:[]rank_info = array{}
    @editable
    Design<public>:rank_design = rank_design{}
    @editable
    Scores<public>:[]rank_system_score = array{}
    @editable
    EnableDeviceConnect<public>:logic = true
    @editable
    EnableLimitless<public>:logic = true

    var<private> WidgetPerPlayer<public>:[player]rank_system_widget = map{}
    var<private> LastAttachedVFXPerPlayer<public>:[player]tuple(visual_effect_powerup_device, int) = map{}

    OnBegin<override>()<suspends>:void=
        # 不正値の対策
        set RankInfo = SortBy(RankInfo, SortByThreshold)
        if(not RankInfo.IsContainsDefaultRank[]):
            Print("error: Thresholdを0に持つRankInfoが用意されていません。どのRankにも達していない場合のデフォルト値として使用されるため、ゲームを終了して設定しなおして下しさい。", ?Duration :=60.0)

        # 入退出処理
        for:
            PlayerElement : GetPlayspace().GetPlayers()
        do:
            OnPlay(PlayerElement)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlay)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnLeave)

        AwaitActivateScore()

    AwaitActivateScore<private>()<suspends>:void=
        loop:
            Result := ArrayRace(Scores, AwaitTriggeredScore)
            if:
                Agent := Result(0)?
                Player := player[Agent]
            then:
                case(Result(1).Type):
                    score_type.Add=> AddScore(Player, Result(1).Score)
                    score_type.Subtract=> SubtractScore(Player, Result(1).Score)
                    score_type.Set=> SetScore(Player, Result(1).Score)

    SetScore<public>(InPlayer:player, InScore:int):void=
        NewScore := 
            if(EnableLimitless?):
                InScore
            else if(LastElement := RankInfo.GetLastElement[]):
                Min(InScore, LastElement.Threshold)
            else:
                InScore
        SetScoreToSaveData(InPlayer, Max(NewScore, 0))
        UpdateWidget(InPlayer)
        UpdateDeviceState(InPlayer)

    AddScore<public>(InPlayer:player, InScore:int):void=
        SetScore(InPlayer, GetScore(InPlayer) + InScore)

    SubtractScore<public>(InPlayer:player, InScore:int):void=
        SetScore(InPlayer, GetScore(InPlayer) - InScore)

    UpdateWidget<public>(InPlayer:player):void=
        if:
            Widget := WidgetPerPlayer[InPlayer]
            CurrentScore := RankSystemSaveData[InPlayer].Score
        then:
            if(CurrentRank := RankInfo.FindCurrentRank[CurrentScore]):
                Widget.UpdateIcon(CurrentRank.Icon)
                Widget.UpdateText(CurrentRank.Name)
                NextScore := option:
                    RankInfo.FindNextRank[CurrentScore].Threshold
                Widget.UpdateProgress(CurrentScore, CurrentRank.Threshold, NextScore)
           
    OnPlay<private>(InPlayer:player):void=
        if:
            not RankSystemSaveData[InPlayer]
            set RankSystemSaveData[InPlayer] = rank_system_save_data{}
        NewWidget := MakeRankSystemWidget(InPlayer, Design)
        NewWidget.AddGameplayUI()
        if(set WidgetPerPlayer[InPlayer] = NewWidget):
            UpdateWidget(InPlayer)
            UpdateDeviceState(InPlayer)

    OnLeave<private>(InPlayer:player):void=
        if(Widget := WidgetPerPlayer[InPlayer]):
            Widget.RemoveUI()
            set WidgetPerPlayer = WidgetPerPlayer.RemoveKey(InPlayer)
        set LastAttachedVFXPerPlayer = LastAttachedVFXPerPlayer.RemoveKey(InPlayer)

    UpdateDeviceState<public>(InPlayer:player):void=
        if:
            EnableDeviceConnect?
            CurrentData := RankSystemSaveData[InPlayer]
        then:
            var AttachableVFX:tuple(visual_effect_powerup_device, int) = (visual_effect_powerup_device{}, -1)
            for:
                Index -> Info : RankInfo
            do:
                if(CurrentData.Score >= Info.Threshold):
                    set AttachableVFX = (Info.AttachVFX, Index)
                    Info.IsReached.SetState(InPlayer, true)
                    if(CurrentData.LastReachedIndex < Index):
                        Info.ReachedEvent.Transmit(option{InPlayer})
                        SetLastReachedIndex(InPlayer, Index)
                else:
                    Info.IsReached.SetState(InPlayer, false)

            if:
                not LastAttachedVFXPerPlayer[InPlayer]
            then:
                AttachableVFX(0).Attach(InPlayer)
            else if:
                CurrentVFX := LastAttachedVFXPerPlayer[InPlayer]
                CurrentVFX(1) <> AttachableVFX(1)
            then:
                CurrentVFX(0).Dettach(InPlayer)
                AttachableVFX(0).Attach(InPlayer)

            if(set LastAttachedVFXPerPlayer[InPlayer] = AttachableVFX){}