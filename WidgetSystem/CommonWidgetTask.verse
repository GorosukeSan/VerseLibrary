using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }

common_task_function<public> := class<abstract><internal>:

common_task_runnable_function<public> := class<final>(common_task_function):
    Task<public>:type{_(:player, :displayable_widget_base)<suspends>:void}
common_task_close_function<public> := class<final>(common_task_function):
    Task<public>:type{_(:player, :displayable_widget_base):void}

common_widget_task<public> := class<final>:
    Player<public>:player
    Widget<public>:displayable_widget_base
    CloseEvent<public>:event()

    var<private> CloseProcess<public>:[]type{_(:player, :displayable_widget_base):void} = array{}

    AddTasks<public>(NewTasks:[]common_task_function):void=
        for(TaskElement : NewTasks):
            if(RunnableTask := common_task_runnable_function[TaskElement]):
                AddTask(RunnableTask.Task)
            else if(CloseTask := common_task_close_function[TaskElement]):
                AddCloseProcess(CloseTask.Task)

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