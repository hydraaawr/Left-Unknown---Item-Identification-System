Scriptname LUIIS_LootCheck extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
FormList Property _LUIIS_PendingIdentifiableLootedItemsFLST auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if(akNewContainer == PlayerRef) ;if player looted it
        Debug.Notification("Player Looted Unidentified Item")
        ;; Add them to the total formlist of identifiable looted items pending to be identified
      
        _LUIIS_PendingIdentifiableLootedItemsFLST.AddForm(self) ;; add to pending looted list

    endif
EndEvent