Scriptname LUIIS_LootCheck extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
LUIIS_ItemSwapper Property ItemSwapper auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if(akNewContainer == PlayerRef) ;if player looted it
        
        Debug.Notification("Player Looted Unidentified Item")
        ItemSwapper.NPlayerUnkItems += 1 ;; add to the count
        


    endif
EndEvent