Scriptname LUIIS_LootCheck extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
LUIIS_ItemSwapper Property ItemSwapper auto
MiscObject Property _LUIIS_UnkWeapon auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if(akOldContainer != PlayerRef && akNewContainer == PlayerRef && ItemSwapper.TradeBlock == FALSE) ;if player looted it and you are not dropping and readding an item
        
        ;Debug.Notification("Player Looted Unidentified Item(s)")
        
        int NPlayerUnkItems2 =  PlayerRef.GetItemCount(_LUIIS_UnkWeapon) ; current unknown items in player inventory
        int LootedUnkStackUnits = NPlayerUnkItems2 - ItemSwapper.NPlayerUnkItems1 ; size of the looted unidentified item stack
        int LootStartIndex = ItemSwapper.NTotalIdentifiableItemEntries - LootedUnkStackUnits
        ;Debug.Notification("NPlayerUnkItems1 (before looting): " + ItemSwapper.NPlayerUnkItems1)
        ;Debug.Notification("NPlayerUnkItems2 (after looting): " + NPlayerUnkItems2)
        ;Debug.Notification("LootedUnkStackUnits: " + LootedUnkStackUnits)
        String CurrIdentifiableItemEntryCountPath
        Form LastIdentifiableItem = ItemSwapper.CurrIdentifiableItem
        
        int i = 0
        while i < LootedUnkStackUnits ; travel the whole looted stack
            LastIdentifiableItem = JArray.GetForm(ItemSwapper.IdentifiableItemArray,i) ; to each identifiable (now looted) item
            Debug.Notification("Last looted item entry index: " + (LootStartIndex + i))
            CurrIdentifiableItemEntryCountPath = "._LUIIS_IdentifiableItemEntry" + (LootStartIndex + i) + ".count"
            Debug.Notification("Last looted identifiable item entry: " + LastIdentifiableItem.GetName() + ", count: " + JDB.SolveInt(CurrIdentifiableItemEntryCountPath))
            i+=1
        endwhile
            


        ItemSwapper.DBBlock = FALSE ; lets identification mechanic work again (because you have now pending loot to be identified)
    endif
EndEvent