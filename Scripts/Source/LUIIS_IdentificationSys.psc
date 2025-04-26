Scriptname LUIIS_IdentificationSys extends activemagiceffect  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
MiscObject Property _LUIIS_UnkWeapon auto
LUIIS_ItemSwapper Property ItemSwapper auto
Scroll Property _LUIIS_IdScroll auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if(akTarget == PlayerRef)
        if(ItemSwapper.DBBlock == FALSE)
            PlayerRef.RemoveItem(_LUIIS_UnkWeapon, PlayerRef.GetItemCount(_LUIIS_UnkWeapon)) ; Remove all unidentified items
            int i = 0
            While (i < ItemSwapper.NTotalLootedItems)
                form TargetIdentifiableItem = JDB.SolveForm("._LUIIS_IdentifiableItem" + i + ".form")
                int TargetIdentifiableItemCount = JDB.solveInt("._LUIIS_IdentifiableItem" + i + ".count")
                PlayerRef.AddItem(TargetIdentifiableItem, TargetIdentifiableItemCount)
                i+=1
            EndWhile
            ;; after returning all the identified items
            ItemSwapper.NTotaldentifiableItemEntries = 0 ; resets the db index (will start to overwrite from 0)
            ItemSwapper.NTotalLootedItems = 0 
            ItemSwapper.DBBlock = TRUE ; block the db until you loot again
        Else
            Debug.Notification("You already identified all pending items")
            PlayerRef.AddItem(_LUIIS_IdScroll,1,true) ; readds so you dont waste it
        endif
    endif
EndEvent