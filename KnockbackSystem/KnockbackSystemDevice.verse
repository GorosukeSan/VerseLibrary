using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }

knockback_system_device := class(creative_device):

    @editable
    KnockbackMovementDevice<private>:knockback_movement_device = knockback_movement_device{}

    OnBegin<override>()<suspends>:void=
        for(PlayerElement : GetPlayspace().GetPlayers()):
            OnPlay(PlayerElement)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlay)

    OnPlay<private>(InAgent:agent):void=
        if(FortChar := InAgent.GetFortCharacter[]):
            FortChar.DamagedEvent().Subscribe(OnDamaged)

    OnDamaged(DamageResult:damage_result):void=
        if:
            TargetFortChar := fort_character[DamageResult.Target]
            TargetAgent := TargetFortChar.GetAgent[]

            InstigatorAgent := DamageResult.Instigator?.GetInstigatorAgent[]
            InstigatorFortChar := InstigatorAgent.GetFortCharacter[]

            KnockbackRotation := MakeFacingRotationIgnorePitch[InstigatorFortChar.GetTransform().Translation, TargetFortChar.GetTransform().Translation]
        then:
            # DamageResult.Amountの入っているInPowerはゲームに合わせて調整する
            KnockbackMovementDevice.Activate(TargetAgent, KnockbackRotation, DamageResult.Amount)