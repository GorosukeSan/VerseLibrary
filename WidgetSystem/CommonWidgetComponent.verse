using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

using { CommonSystem }
using { TreeSystem }

widget_event<public> := class<abstract>(scene_event):
    

common_widget_component<public> := class<final_super><abstract>(tree_element_component):

    var<private> WidgetPerPlayer<public>:[player]displayable_widget_base = map{}

    CreateWidget<protected>(Player:player):displayable_widget_base

    ShowUI<public><final>(Player:player):void=
        if(not WidgetPerPlayer[Player]):
            NewWidget := CreateWidget(Player)
            if(set WidgetPerPlayer[Player] = NewWidget):
                NewWidget.Show()

    HideUI<public><final>(Player:player):void=
        if:
            TargetWidget := WidgetPerPlayer[Player]
        then:
            TargetWidget.Hide()
            set WidgetPerPlayer = WidgetPerPlayer.RemoveKey(Player)

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