using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }

height_meter_device<public> := class(creative_device):

    @editable
    HeightOffset<private>:float = 0.0

    @editable
    UpdateRate<private>:float = 0.0

    var WidgetPerAgent:[agent]height_meter_widget = map{}

    OnBegin<override>()<suspends>:void=
        for(PlayerElement : GetPlayspace().GetPlayers()):
            OnPlay(PlayerElement)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlay)

    OnPlay(InPlayer:player):void=
        NewWidget := height_meter_widget:
            Player := InPlayer

        NewWidget.AddGameplayUI()
        if:
            set WidgetPerAgent[InPlayer] = NewWidget
        then:
            spawn{UpdateMeter(InPlayer, NewWidget)}

    UpdateMeter<private>(InPlayer:player, InWidget:height_meter_widget)<suspends>:void=
        race:
            loop:
                Result := GetPlayspace().PlayerRemovedEvent().Await()
                if(InPlayer = Result):
                    break
            loop:
                Sleep(UpdateRate)
                if(FortChar := InPlayer.GetFortCharacter[]):
                    Height := 
                        if(Result := Int[(FortChar.GetTransform().Translation.Z - HeightOffset) / 100.0]):
                            Result
                        else:
                            0
                    InWidget.UpdateMeter(Height)

height_meter_widget<public> := class:

    Player<public>:player

    MeterTextBlock<private>:text_block = text_block:
        DefaultTextColor := NamedColors.White
        DefaultShadowOffset := option{vector2{X := 1.0, Y := 1.0}}
        DefaultShadowOpacity := 1.0

    var MaybeCurrentCanvas:?canvas = false

    HeightMessage<localizes>(InHeight:int):message="{InHeight}m"

    AddGameplayUI<public>():void=
        if:
            PlayerUI := GetPlayerUI[Player]
            not MaybeCurrentCanvas?
        then:
            NewCanvas := CreateCanvas()
            PlayerUI.AddWidget(NewCanvas)
            set MaybeCurrentCanvas = option{NewCanvas}

    RemoteGameplayUI<public>():void=
        if:
            PlayerUI := GetPlayerUI[Player]
            CurrentCanvas := MaybeCurrentCanvas?
        then:
            PlayerUI.RemoveWidget(CurrentCanvas)
            set MaybeCurrentCanvas = false

    UpdateMeter<public>(InHeight:int):void=
        MeterTextBlock.SetText(HeightMessage(InHeight))

    CreateCanvas<protected>():canvas=
        canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2:
                            X := 0.5
                            Y := 0.9
                        Maximum := vector2:
                            X := 0.5
                            Y := 0.9
                    Alignment := vector2:
                        X := 0.5
                        Y := 1.0
                    Widget := MeterTextBlock