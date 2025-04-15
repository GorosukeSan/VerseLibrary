using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/SpatialMath }

knockback_movement_modulators_tag := class(tag){}
KnockbackToolTipMessage_MovementDevice_SortMethod<localizes>:message="タグで取得すると順番がランダムになってしまうため基準を決めてソートします。タグを使用しない場合は配列に追加した順番がそのまま使用されるため、Unsortedにします。"

knockback_sort_method<public> := enum:
    Unsorted
    Height

knockback_movement_device := class(creative_device):

    @editable
    var MovementModulators<private>:[]movement_modulator_device = array{}

    @editable:
        ToolTip := KnockbackToolTipMessage_MovementDevice_SortMethod
    SortMethod<private>:knockback_sort_method = knockback_sort_method.Unsorted

    @editable
    MaxPower<private>:float = 5000.0

    OnBegin<override>()<suspends>:void=
        set MovementModulators += 
            for:
                ActorElement : FindCreativeObjectsWithTag(knockback_movement_modulators_tag{})
                MovementModulatorDevice := movement_modulator_device[ActorElement]
            do:
                MovementModulatorDevice

        set MovementModulators = 
            case(SortMethod):
                knockback_sort_method.Unsorted=>
                    MovementModulators
                knockback_sort_method.Height=>
                    PositionalSortByHeight(MovementModulators)

    Activate<public>(InTarget:agent, InDirection:rotation, InPower:float):void=
        TargetIndex := 
            if(Result := Int[(InPower / MaxPower) * MovementModulators.Length]):
                Result
            else:
                0

        if(TargetMovementModulator := MovementModulators[TargetIndex]):
            TargetMovementModulator.Rotate(InDirection)
            TargetMovementModulator.Activate(InTarget)