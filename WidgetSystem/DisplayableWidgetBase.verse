using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }

displayable_widget_base<public> := class<abstract>(common_widget_base):

    Player<public>:player

    var<private> WidgetInstance<public>:?widget = false

    Show<override><final>():void=
        if:
            PlayerUI := GetPlayerUI[Player]
        then:
            NewWidget := CreateWidget()
            PlayerUI.AddWidget(NewWidget, player_ui_slot{InputMode := InputMode()})
            set WidgetInstance = option{NewWidget}

    Hide<override><final>():void=
        if:
            PlayerUI := GetPlayerUI[Player]
            TargetWidget := WidgetInstance?
        then:
            PlayerUI.RemoveWidget(TargetWidget)
            set WidgetInstance = false

    InputMode<protected>()<reads>:ui_input_mode

displayable_gameplay_widget_base<public> := class<abstract>(displayable_widget_base):
    InputMode<override><final>()<reads>:ui_input_mode=
        ui_input_mode.None

displayable_interactable_widget_base<public> := class<abstract>(displayable_widget_base):
    InputMode<override><final>()<reads>:ui_input_mode=
        ui_input_mode.All