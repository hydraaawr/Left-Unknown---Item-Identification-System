Scriptname LUIIS_LootCheck extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
LUIIS_ItemSwapper Property ItemSwapper auto
MiscObject Property _LUIIS_UnkWeapon auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if(akNewContainer == PlayerRef) ;if player looted it
        
        Debug.Notification("Player Looted Unidentified Item")
        Utility.Wait(2)
        Form LastIdentifiableItem = ItemSwapper.IdentifiableItem
        int NPlayerUnkItems2 =  PlayerRef.GetItemCount(_LUIIS_UnkWeapon) ; current unknown items in player inventory
        int LootedStackUnits = NPlayerUnkItems2 - ItemSwapper.NPlayerUnkItems1
        Debug.Notification("NPlayerUnkItems1 (before looting): " + ItemSwapper.NPlayerUnkItems1)
        Debug.Notification("NPlayerUnkItems2 (after looting): " + NPlayerUnkItems2)
        Debug.Notification("LootedStackUnits: " + LootedStackUnits)

        if LootedStackUnits == 1 ; looted one unit, not a stack
            Debug.Notification("Didnt loot a Stack") ; DEBUG
            JFormDB.solveIntSetter(LastIdentifiableItem,"._LUIIS_IdentifiableItems.looted", 1, true) ; add "looted" to last identified item that was transformed.
        elseif LootedStackUnits > 1 ;looted a stack
            Debug.Notification("LOOTED a Stack") ; DEBUG
            int i = 0
            while i < LootedStackUnits
                JFormDB.solveIntSetter(JArray.GetForm(ItemSwapper.IdentifiableItemArray,i),"._LUIIS_IdentifiableItems.looted", 1, true) ; add "looted" to last identified item that was transformed.
                i+=1
            endwhile
        endif



        int preindex = 0 ;DEBUG

        Debug.Notification("PRELast looted identifiable item: " + JArray.GetForm(ItemSwapper.IdentifiableItemArray,preindex).GetName() + ", .looted: " + JFormDB.Getint(JArray.GetForm(ItemSwapper.IdentifiableItemArray,preindex), "._LUIIS_IdentifiableItems.looted")) ; DEBUG
        Debug.Notification("Last looted identifiable item: " + LastIdentifiableItem.GetName() + ", .looted: " + JFormDB.Getint(LastIdentifiableItem, "._LUIIS_IdentifiableItems.looted")) ; DEBUG


    endif
EndEvent