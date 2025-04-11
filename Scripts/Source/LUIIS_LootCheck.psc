Scriptname LUIIS_LootCheck extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
LUIIS_ItemSwapper Property ItemSwapper auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if(akNewContainer == PlayerRef) ;if player looted it
        
        Debug.Notification("Player Looted Unidentified Item")

        int NPlayerUnkItems =  PlayerRef.GetItemCount(self) ; current unknown items in player inventory
        int LootedIndex = NPlayerUnkItems - 1; -1 because NTotalIdentifiable items starts with 0 index
        Form LastIdentifiableItem = ItemSwapper.IdentifiableItem
        JFormDB.solveIntSetter(LastIdentifiableItem,"._LUIIS_IdentifiableItems.looted", 1, true) ; add "looted" to last identified item that was transformed.
        Debug.Notification("Last looted identifiable item: " + LastIdentifiableItem.GetName() + ", .looted: " + JFormDB.Getint(LastIdentifiableItem, "._LUIIS_IdentifiableItems.looted"))
        ;; TODO: If there was 2 items in container, itll pick the last one. Maybe randomize the pick could be good
    endif
EndEvent