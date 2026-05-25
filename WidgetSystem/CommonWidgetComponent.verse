using { /Verse.org/SceneGraph }
using { /Verse.org/Simulation }

using { CommonSystem }

common_widget_component<public> := class<final_super><abstract>(component):

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