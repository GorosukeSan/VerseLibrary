using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }

common_widget_task<public> := class<final>:
    Player<public>:player
    Widget<public>:displayable_widget_base
    CloseEvent<public>:event()

    var<private> CloseProcess<public>:[]type{_(:player, :displayable_widget_base):void} = array{}

    AddTask<public>(NewTask:type{_(:player, :displayable_widget_base)<suspends>:void}):void=
        spawn{AwaitTask(NewTask)}
        
    AddCloseProcess<public>(NewProcess:type{_(:player, :displayable_widget_base):void}):void=
        set CloseProcess = array{NewProcess}

    CallCloseProcess<internal>():void=
        for(CloseProcessElement : CloseProcess):
            CloseProcessElement(Player, Widget)
        set CloseProcess = array{}

    AwaitTask<private>(Task:type{_(:player, :displayable_widget_base)<suspends>:void})<suspends>:void=
        race:
            Task(Player, Widget)
            CloseEvent.Await()