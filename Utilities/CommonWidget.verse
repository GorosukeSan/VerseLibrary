using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }

common_widget_base<public> := class<abstract>:

    Player<public>:player

    var MaybeCanvas<private>:?canvas = false
    RemoveUIEvent<protected>:event() = event(){}

    AddGameplayUI<public>():void=
        if(PlayerUI := GetPlayerUI[Player], not MaybeCanvas?):
            NewCanvas := CreateCanvas()
            PlayerUI.AddWidget(NewCanvas)
            set MaybeCanvas = option{NewCanvas}

    AddInteractUI<public>():void=
        if(PlayerUI := GetPlayerUI[Player], not MaybeCanvas?):
            NewCanvas := CreateCanvas()
            PlayerUI.AddWidget(NewCanvas, player_ui_slot{InputMode := ui_input_mode.All})
            set MaybeCanvas = option{NewCanvas}

    RemoveUI<public>():void=
        if(PlayerUI := GetPlayerUI[Player], CurrentCanvas := MaybeCanvas?):
            PlayerUI.RemoveWidget(CurrentCanvas)
            set MaybeCanvas = false

    CreateCanvas<public>():canvas