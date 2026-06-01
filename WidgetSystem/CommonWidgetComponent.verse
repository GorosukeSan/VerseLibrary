using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

using { CommonSystem }
using { TreeSystem }

widget_event<public> := class<abstract>(scene_event):
    Player<public>:player
widget_show_event<public> := class<final>(widget_event):
widget_hide_event<public> := class<final>(widget_event):

widget_called_show_event<public> := class<final>(widget_event):
widget_called_hide_event<public> := class<final>(widget_event):
    
common_widget_component<public> := class<final_super><abstract>(tree_element_component):

    var<private> WidgetPerPlayer<public>:[player]displayable_widget_base = map{}

    CreateWidget<protected>(Player:player):result(displayable_widget_base, void)

    GetWidgetAs<public>(Player:player, widget_type:subtype(displayable_widget_base))<decides><transacts>:widget_type=
        widget_type[WidgetPerPlayer[Player]]

    ShowUI<public><final>(Player:player):void=
        if(not WidgetPerPlayer[Player]):
            CreateWidgetResult := CreateWidget(Player)
            if:
                NewWidget := CreateWidgetResult.GetSuccess[]
                set WidgetPerPlayer[Player] = NewWidget
            then:
                NewWidget.Show()

                Task := NewWidget.GetTask()
                Task.AddTasks(InitialTasks())

                Entity.SendUp(widget_called_show_event{Player := Player})

    HideUI<public><final>(Player:player):void=
        if:
            TargetWidget := WidgetPerPlayer[Player]
        then:
            TargetWidget.Hide()
            set WidgetPerPlayer = WidgetPerPlayer.RemoveKey(Player)

            Entity.SendUp(widget_called_hide_event{Player := Player})

    InitialTasks<protected>():[]common_task_function=
        array{}

    GetWidgetTask<public><final>(Player:player)<decides><transacts>:common_widget_task=
        TargetWidget := WidgetPerPlayer[Player]
        TargetWidget.GetTask()

    AddTask<public><final>(Player:player, Task:type{_(:player, :displayable_widget_base)<suspends>:void}):result(void, void)=
        if(WidgetTask := GetWidgetTask[Player]):
            WidgetTask.AddTask(Task)
            MakeSuccess()
        else:
            MakeError()

    AddCloseProcess<public><final>(Player:player, Task:type{_(:player, :displayable_widget_base):void}):result(void, void)=
        if(WidgetTask := GetWidgetTask[Player]):
            WidgetTask.AddCloseProcess(Task)
            MakeSuccess()
        else:
            MakeError()

    OnReceive<override>(SceneEvent:scene_event):logic=
        if:
            WidgetEvent := widget_event[SceneEvent]
        then:
            if(ShowEvent := widget_show_event[SceneEvent]):
                ShowUI(ShowEvent.Player)
            else if(HideEvent := widget_hide_event[SceneEvent]):
                HideUI(HideEvent.Player)

        false