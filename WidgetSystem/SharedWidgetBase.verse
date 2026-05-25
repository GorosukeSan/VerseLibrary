using { /UnrealEngine.com/Temporary/UI }

shared_widget_base<public> := class<abstract>(common_widget_base):

    var WidgetInstance<private>:?widget = false

    Show<override><final>():void=
        TargetWidget := GetWidget()
        TargetWidget.SetVisibility(widget_visibility.Visible)

    Hide<override><final>():void=
        TargetWidget := GetWidget()
        TargetWidget.SetVisibility(widget_visibility.Collapsed)

    GetWidget<public><final>():widget=
        if(TargetWidget := WidgetInstance?):
            TargetWidget
        else:
            NewWidget := CreateWidget()
            set WidgetInstance = option{NewWidget}
            NewWidget