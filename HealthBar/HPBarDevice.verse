using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Fortnite.com/UI }

hp_bar_damage_info<public> := class<concrete>:
    @editable
    DamageTrigger<public>:trigger_device = trigger_device{}

    @editable
    Amount<public>:float = 10.0

hp_bar_design_info<public> := class<concrete>:
    @editable
    BaseColor:color = NamedColors.Red

    @editable
    OutlineColor:color = NamedColors.White

    @editable
    BackgroundColor:color = NamedColors.Black

    @editable
    Position:vector2 = vector2:
        X := 0.5
        Y := 0.1

    @editable
    Size:vector2 = vector2:
        X := 1000.0
        Y := 100.0

    @editable
    OutlineSize:float = 5.0
    
    @editable
    Orientation:orientation = orientation.Horizontal

hp_bar_damage_device<public> := class(creative_device):

    @editable
    HPBarDamageInfo:[]hp_bar_damage_info = array{}

    @editable
    MaxHealth:float = 1000.0

    @editable
    InitialHealthPercent:type{_X:float where _X >= 0.0, _X <= 100.0} = 100.0

    @editable
    HPBarDesignInfo:hp_bar_design_info = hp_bar_design_info{}

    @editable
    ShowTrigger:trigger_device = trigger_device{}

    @editable
    HideTrigger:trigger_device = trigger_device{}

    @editable
    ResetTrigger:trigger_device = trigger_device{}

    @editable
    EliminatedEvent:trigger_device = trigger_device{}

    @editable
    MaxHealthEvent:trigger_device = trigger_device{}

    @editable
    IsEliminated:switch_device = switch_device{}

    @editable
    IsMax:switch_device = switch_device{}

    var Health:float = 0.0
    var WidgetPerAgent:[agent]hp_bar_widget = map{}

    OnBegin<override>()<suspends>:void=
        Reset()
        for(Info : HPBarDamageInfo):
            spawn{AwaitDamageEvent(Info)}
        race:
            loop:
                MaybeAgent := ShowTrigger.TriggeredEvent.Await()
                if:
                    Agent := MaybeAgent?
                    Player := player[Agent]
                then:
                    NewWidget := hp_bar_widget:
                        Player := Player
                        HPBarDesignInfo := HPBarDesignInfo
                    NewWidget.AddGameplayUI()

                    if:
                        set WidgetPerAgent[Agent] = NewWidget
                    then:
                        Update(Agent)

            loop:
                MaybeAgent := HideTrigger.TriggeredEvent.Await()
                if:
                    Agent := MaybeAgent?
                    Player := player[Agent]
                    OldWidget := WidgetPerAgent[Agent]
                then:
                    OldWidget.RemoveUI()
                    set WidgetPerAgent = WidgetPerAgent.RemoveKey(Agent)
            loop:
                MaybeAgent := ResetTrigger.TriggeredEvent.Await()
                Reset()

    Reset<public>():void=
        set Health = MaxHealth * (InitialHealthPercent / 100.0)
        for(PlayerElement : GetPlayspace().GetPlayers()):
            IsEliminated.TurnOff(PlayerElement)
            IsMax.TurnOff(PlayerElement)
            
            if(Health <= 0.0):
                EliminatedEvent.Trigger()
                IsEliminated.TurnOn(PlayerElement)
            else if(Health >= MaxHealth):
                IsMax.TurnOn(PlayerElement)

        UpdateForAll()

    Update(InAgent:agent):void=
        if(Widget := WidgetPerAgent[InAgent]):
            Widget.Update(Health, MaxHealth)

    UpdateForAll():void=
        for(Agent -> Widget : WidgetPerAgent):
            Widget.Update(Health, MaxHealth)

    AwaitDamageEvent(Info:hp_bar_damage_info)<suspends>:void=
        loop:
            MaybeAgent := Info.DamageTrigger.TriggeredEvent.Await()
            set Health = Clamp(Health - Info.Amount, 0.0 , MaxHealth)
            UpdateForAll()
            if(Health <= 0.0):
                EliminatedEvent.Trigger()

                if(Agent := MaybeAgent?):
                    IsEliminated.TurnOn(Agent)
                    IsMax.TurnOff(Agent)
            else if(Health >= MaxHealth):
                MaxHealthEvent.Trigger()

                if(Agent := MaybeAgent?):
                    IsMax.TurnOn(Agent)
                    IsEliminated.TurnOff(Agent)
            else:
                if(Agent := MaybeAgent?):
                    IsEliminated.TurnOff(Agent)
                    IsMax.TurnOff(Agent)
                    
    (InMap:[t]u where t:subtype(comparable), u:type).RemoveKey(InKey:t)<transacts>:[t]u=
        var ResultMap:[t]u = map{}
        for:
            Key -> Value : InMap
            Key <> InKey
        do:
            set ResultMap = ConcatenateMaps(ResultMap, map{Key => Value})

        ResultMap

hp_bar_widget<public> := class:

    Player<public>:player
    HPBarDesignInfo<public>:hp_bar_design_info

    OutlineColorBlock:color_block = color_block{}
    BaseColorBlock:color_block = color_block{}
    BackgroundColorBlock:color_block = color_block{}
    HealthTextBlock:text_block = text_block:
        DefaultTextColor := NamedColors.White
        DefaultShadowOffset := option{vector2{X := 2.5, Y := 2.5}}
        DefaultShadowOpacity := 1.0

    var MaybeCanvas:?canvas = false
    HealthToMessage<localizes>(InCurrentHealth:int, InMaxHealth:int):message="{InCurrentHealth} / {InMaxHealth}"

    AddGameplayUI<public>():void=
        if:
            PlayerUI := GetPlayerUI[Player]
            not MaybeCanvas?
        then:
            NewCanvas := CreateCanvas()
            PlayerUI.AddWidget(NewCanvas)
            set MaybeCanvas = option{NewCanvas}

    RemoveUI<public>():void=
        if:
            PlayerUI := GetPlayerUI[Player]
            OldCanvas := MaybeCanvas?
        then:
            PlayerUI.RemoveWidget(OldCanvas)
            set MaybeCanvas = false

    Update(CurrentHealth:float, MaxHealth:float):void=
        Percent := CurrentHealth / MaxHealth
        case(HPBarDesignInfo.Orientation):
            orientation.Horizontal=>
                PercentX := Percent * HPBarDesignInfo.Size.X
                BaseColorBlock.SetDesiredSize(vector2{X := PercentX, Y := HPBarDesignInfo.Size.Y})
            orientation.Vertical=>
                PercentY := Percent * HPBarDesignInfo.Size.Y
                BaseColorBlock.SetDesiredSize(vector2{X := HPBarDesignInfo.Size.X, Y := PercentY})
        if:
            CurrentHealthInt := Int[CurrentHealth]
            MaxHealthInt := Int[MaxHealth]
        then:
            HealthTextBlock.SetText(HealthToMessage(CurrentHealthInt, MaxHealthInt))

    CreateCanvas():canvas=
        OutlineColorBlock.SetColor(HPBarDesignInfo.OutlineColor)
        BaseColorBlock.SetColor(HPBarDesignInfo.BaseColor)
        BackgroundColorBlock.SetColor(HPBarDesignInfo.BackgroundColor)
        BackgroundColorBlock.SetDesiredSize(HPBarDesignInfo.Size)
        OutlineColorBlock.SetDesiredSize(HPBarDesignInfo.Size + vector2{X := HPBarDesignInfo.OutlineSize, Y := HPBarDesignInfo.OutlineSize})

        canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors:
                        Minimum := HPBarDesignInfo.Position
                        Maximum := HPBarDesignInfo.Position
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                Widget := OutlineColorBlock
                                HorizontalAlignment := horizontal_alignment.Center
                                VerticalAlignment := vertical_alignment.Center
                            overlay_slot:
                                Padding := margin:
                                    Left := HPBarDesignInfo.OutlineSize
                                    Right := HPBarDesignInfo.OutlineSize
                                    Top := HPBarDesignInfo.OutlineSize
                                    Bottom := HPBarDesignInfo.OutlineSize
                                Widget := BackgroundColorBlock
                                HorizontalAlignment := horizontal_alignment.Center
                                VerticalAlignment := vertical_alignment.Center
                            overlay_slot:
                                Padding := margin:
                                    Left := HPBarDesignInfo.OutlineSize
                                    Right := HPBarDesignInfo.OutlineSize
                                    Top := HPBarDesignInfo.OutlineSize
                                    Bottom := HPBarDesignInfo.OutlineSize
                                Widget := BaseColorBlock
                                HorizontalAlignment := 
                                    case(HPBarDesignInfo.Orientation):
                                        orientation.Horizontal => horizontal_alignment.Left
                                        orientation.Vertical => horizontal_alignment.Center
                                VerticalAlignment := 
                                    case(HPBarDesignInfo.Orientation):
                                        orientation.Horizontal => vertical_alignment.Center
                                        orientation.Vertical => vertical_alignment.Bottom
                            overlay_slot:
                                Widget := HealthTextBlock
                                HorizontalAlignment := horizontal_alignment.Center
                                VerticalAlignment := vertical_alignment.Center