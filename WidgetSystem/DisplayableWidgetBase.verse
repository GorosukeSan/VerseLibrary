using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Simulation }

displayable_widget_base<public> := class<abstract>(common_widget_base):

    Player<public>:player

    var<private> WidgetInstance<public>:?widget = false
    var<private> TaskInstance<public>:?common_widget_task = false

    HideUIEvent<public>:event() = event(){}

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

            HideUIEvent.Signal()
            if(TargetTask := TaskInstance?):
                TargetTask.CallCloseProcess()
            set TaskInstance = false

    GetTask<public><final>()<transacts>:common_widget_task=
        if(TargetTask := TaskInstance?):
            TargetTask
        else:
            NewTask := common_widget_task:
                Player := Player
                Widget := Self
                CloseEvent := HideUIEvent
            set TaskInstance = option{NewTask}
            NewTask

    InputMode<protected>()<reads>:ui_input_mode

displayable_gameplay_widget_base<public> := class<abstract>(displayable_widget_base):
    InputMode<override><final>()<reads>:ui_input_mode=
        ui_input_mode.None

displayable_interactable_widget_base<public> := class<abstract>(displayable_widget_base):
    InputMode<override><final>()<reads>:ui_input_mode=
        ui_input_mode.All