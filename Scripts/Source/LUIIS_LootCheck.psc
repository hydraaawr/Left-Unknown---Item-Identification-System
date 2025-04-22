Scriptname LUIIS_LootCheck extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
LUIIS_ItemSwapper Property ItemSwapper auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if(akNewContainer == PlayerRef) ;if player looted it
        
        Debug.Notification("Player Looted Unidentified Item")

        int NPlayerUnkItems =  PlayerRef.GetItemCount(self) ; current unknown items in player inventory
        Form LastIdentifiableItem = ItemSwapper.IdentifiableItem
        JFormDB.solveIntSetter(LastIdentifiableItem,"._LUIIS_IdentifiableItems.looted", 1, true) ; add "looted" to last identified item that was transformed.

        int preindex = 0 ;DEBUG

        Debug.Notification("PRELast looted identifiable item: " + JArray.GetForm(ItemSwapper.IdentifiableItemArray,preindex).GetName() + ", .looted: " + JFormDB.Getint(JArray.GetForm(ItemSwapper.IdentifiableItemArray,preindex), "._LUIIS_IdentifiableItems.looted")) ; DEBUG
        Debug.Notification("Last looted identifiable item: " + LastIdentifiableItem.GetName() + ", .looted: " + JFormDB.Getint(LastIdentifiableItem, "._LUIIS_IdentifiableItems.looted")) ; DEBUG

    endif
EndEvent