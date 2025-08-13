 using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Assets }

SCREEN_SIZE_X<public>:float = 1920.0
SCREEN_SIZE_Y<public>:float = 1080.0

widget_part_interface<public> := interface:

    GetWidget<public>()<transacts>:widget

common_widget_base<public> := class<abstract>:

    Player<public>:player

    var<private> MaybeCanvas<public>:?canvas = false
    RemoveUIEvent<public>:event() = event(){}

    AddGameplayUI<public>():void=
        if(PlayerUI := GetPlayerUI[Player]):
            NewCanvas := CreateCanvas()
            PlayerUI.AddWidget(NewCanvas)
            set MaybeCanvas = option{NewCanvas}

    AddInteractUI<public>():void=
        if(PlayerUI := GetPlayerUI[Player]):
            NewCanvas := CreateCanvas()
            PlayerUI.AddWidget(NewCanvas, player_ui_slot{InputMode := ui_input_mode.All})
            set MaybeCanvas = option{NewCanvas}

    RemoveUI<public>():void=
        if(PlayerUI := GetPlayerUI[Player], CurrentCanvas := MaybeCanvas?):
            PlayerUI.RemoveWidget(CurrentCanvas)
            set MaybeCanvas = false
            RemoveUIEvent.Signal()

    CreateCanvas<protected>():canvas

normalized_vector2<public> := struct<concrete>:
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{1.0}
    X<public>:float = 0.0
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{1.0}
    Y<public>:float = 0.0

screen_size_vector2<public> := struct<concrete>:
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{SCREEN_SIZE_X}
    X<public>:float = 0.0
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{SCREEN_SIZE_Y}
    Y<public>:float = 0.0

ToVector2<public>(Normalized:normalized_vector2)<computes>:vector2=
    vector2:
        X := Normalized.X
        Y := Normalized.Y

ToVector2<public>(ScreenSize:screen_size_vector2)<computes>:vector2=
    vector2:
        X := ScreenSize.X
        Y := ScreenSize.Y

rank_system_anchors<public> := class:

    GetAnchors<public>():anchors=
        anchors:

rank_system_anchors_normalized<public> := class<final>(rank_system_anchors):
    @editable
    Position<public>:normalized_vector2 = normalized_vector2{}

    GetAnchors<override>():anchors=
        anchors:
            Minimum := ToVector2(Position)
            Maximum := ToVector2(Position)

rank_system_anchors_screen_size<public> := class<final>(rank_system_anchors):
    @editable
    Position<public>:screen_size_vector2 = screen_size_vector2{}

    GetAnchors<override>():anchors=
        anchors:
            Minimum := vector2:
                X := Position.X / SCREEN_SIZE_X
                Y := Position.Y / SCREEN_SIZE_Y
            Maximum := vector2:
                X := Position.X / SCREEN_SIZE_X
                Y := Position.Y / SCREEN_SIZE_Y

rank_system_offsets<public> := class:

    GetOffsets<public>():margin=
        margin:
            
rank_system_offsets_normalized<public> := class<final>(rank_system_offsets):
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{1.0}
    X<public>:float = 0.0
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{1.0}
    Y<public>:float = 0.0

    GetOffsets<override>():margin=
        margin:
            Left := X * SCREEN_SIZE_X
            Top := Y * SCREEN_SIZE_Y

rank_system_offsets_screen_size<public> := class<final>(rank_system_offsets):
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{SCREEN_SIZE_X}
    X<public>:float = 0.0
    @editable_slider(float):
        MinValue := option{0.0}
        MaxValue := option{SCREEN_SIZE_Y}
    Y<public>:float = 0.0

    GetOffsets<override>():margin=
        margin:
            Left := X
            Top := Y

rank_system_margin<public> := class:
    @editable
    Left<public>:float = 0.0
    @editable
    Top<public>:float = 0.0
    @editable
    Right<public>:float = 0.0
    @editable
    Bottom<public>:float = 0.0

    GetMargin<public>()<transacts>:margin=
        margin:
            Left := Left
            Top := Top
            Right := Right
            Bottom := Bottom

rank_system_icon<public> := class(widget_part_interface):
    @editable
    Size<public>:vector2 = vector2{X := 128.0, Y := 128.0}

    GetWidget<override>()<transacts>:widget=
        canvas:

rank_system_icon_color_block<public> := class<final>(rank_system_icon):
    @editable
    Color<public>:color = NamedColors.White
    @editable
    Opacity<public>:type {_X:float where 0.000000 <= _X, _X <= 1.000000} = 0.1

    GetWidget<override>()<transacts>:widget=
        color_block:
            DefaultDesiredSize := Size
            DefaultColor := Color
            DefaultOpacity := Opacity

rank_system_icon_texture_block<public> := class<final>(rank_system_icon):
    @editable
    Texture<public>:texture

    GetWidget<override>()<transacts>:widget=
        texture_block:
            DefaultDesiredSize := Size
            DefaultImage := Texture

rank_system_text_block<public> := class<final>(widget_part_interface):
    @editable
    TextSize<public>:float = 24.0
    @editable
    TextColor<public>:color = NamedColors.White
    @editable
    Justification<public>:text_justification = text_justification.Center

    GetWidget<override>()<transacts>:widget=
        text_block:
            DefaultTextSize := TextSize
            DefaultTextColor := TextColor
            DefaultJustification := Justification

rank_system_position<public> := class:
    @editable
    X<public>:float = 0.0
    @editable
    Y<public>:float = 0.0

    GetMargin<public>():margin=
        margin:
            Top := Y
            Left := X
    
rank_system_progress_bar<public> := class:
    @editable
    FrontColor<public>:color = NamedColors.Red
    @editable
    BackgroundColor<public>:color = NamedColors.Black
    @editable
    FrameColor<public>:color = NamedColors.White
    @editable
    Size<public>:screen_size_vector2 = screen_size_vector2{X := 200.0, Y := 50.0}
    @editable
    Position<public>:rank_system_position = rank_system_position{}
    @editable
    Padding<public>:rank_system_margin = rank_system_margin{Top := 5.0, Left := 5.0, Bottom := 5.0, Right := 5.0}