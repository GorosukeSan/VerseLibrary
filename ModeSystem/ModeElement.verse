using { /Verse.org/Simulation }

using { ManagerSystem }

mode_element_component<public> := class<final_super><abstract>(manager_element_component):

    var<private> CurrentParticipants<public>:[]player = array{}

    Setup<public>():void
    Play<public>(Participants:[]player):void