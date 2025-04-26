Scriptname LUIIS_LootCheck extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
LUIIS_ItemSwapper Property ItemSwapper auto
MiscObject Property _LUIIS_UnkWeapon auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if(akNewContainer == PlayerRef) ;if player looted it
        
        ;Debug.Notification("Player Looted Unidentified Item(s)")
        
        int NPlayerUnkItems2 =  PlayerRef.GetItemCount(_LUIIS_UnkWeapon) ; current unknown items in player inventory
        int LootedUnkStackUnits = NPlayerUnkItems2 - ItemSwapper.NPlayerUnkItems1 ; size of the looted unidentified item stack
        int LootStartIndex = ItemSwapper.NTotalIdentifiableItemEntries - LootedUnkStackUnits
        ;Debug.Notification("NPlayerUnkItems1 (before looting): " + ItemSwapper.NPlayerUnkItems1)
        ;Debug.Notification("NPlayerUnkItems2 (after looting): " + NPlayerUnkItems2)
        ;Debug.Notification("LootedUnkStackUnits: " + LootedUnkStackUnits)
        String CurrIdentifiableItemEntryLootedPath
        Form LastIdentifiableItem = ItemSwapper.CurrIdentifiableItem
        if LootedUnkStackUnits == 1 ; looted one unit, not a stack of unidentified items
            ;Debug.Notification("Didnt loot a Stack") ; DEBUG
            CurrIdentifiableItemEntryLootedPath = "._LUIIS_IdentifiableItemEntry" + ItemSwapper.NTotalIdentifiableItemEntries + ".looted"
            JDB.solveIntSetter(CurrIdentifiableItemEntryLootedPath, 1, true) ; add "looted" to last identified item that was transformed.
            Debug.Notification("Last looted identifiable item: " + LastIdentifiableItem.GetName() + ", looted: " + JDB.SolveInt(CurrIdentifiableItemEntryLootedPath))
        elseif LootedUnkStackUnits > 1 ;looted a stack
            ;Debug.Notification("LOOTED a Stack") ; DEBUG
            int i = 0
            while i < LootedUnkStackUnits ; travel the whole looted stack
                LastIdentifiableItem = JArray.GetForm(ItemSwapper.IdentifiableItemArray,i) ; to each identifiable (now looted) item
                Debug.Notification("LootStartIndex + i: " + (LootStartIndex + i))
                CurrIdentifiableItemEntryLootedPath = "._LUIIS_IdentifiableItemEntry" + (LootStartIndex + i) + ".looted"
                JDB.solveIntSetter(CurrIdentifiableItemEntryLootedPath, 1, true) ; add "looted" to last identified item that was transformed.
                Debug.Notification("Last looted identifiable item entry: " + LastIdentifiableItem.GetName() + ", looted: " + JDB.SolveInt(CurrIdentifiableItemEntryLootedPath))
                i+=1
            endwhile
            
        endif

        ItemSwapper.DBBlock = FALSE

    endif
EndEvent