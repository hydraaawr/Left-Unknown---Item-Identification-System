Scriptname LUIIS_IdentificationSys extends activemagiceffect  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
MiscObject Property _LUIIS_UnkWeapon auto
LUIIS_ItemSwapper Property ItemSwapper auto
Scroll Property _LUIIS_IdScroll auto

form TargetIdentifiableItemEntry
int TargetIdentifiableItemEntryCount



Event OnEffectStart(Actor akTarget, Actor akCaster)
    if(akTarget == PlayerRef)
        if(ItemSwapper.DBBlock == FALSE)
            ItemSwapper.RemovalCheckBlock = TRUE ; stop removal check during identiification process
            PlayerRef.RemoveItem(_LUIIS_UnkWeapon, PlayerRef.GetItemCount(_LUIIS_UnkWeapon)) ; Remove all unidentified items
            int i = 0
            While (i < ItemSwapper.NTotalIdentifiableItemEntries)
                TargetIdentifiableItemEntry = JDB.SolveForm("._LUIIS_IdentifiableItemEntry" + i + ".form")
                TargetIdentifiableItemEntryCount = JDB.solveInt("._LUIIS_IdentifiableItemEntry" + i + ".count")

                TargetIdentifiableItemEntry = JDB.SolveForm("._LUIIS_IdentifiableItemEntry" + i + ".form")
                TargetIdentifiableItemEntryCount = JDB.solveInt("._LUIIS_IdentifiableItemEntry" + i + ".count")
                Debug.Notification("Identifiying entry " + i + " " + TargetIdentifiableItemEntry.GetName() + ", count: " + TargetIdentifiableItemEntryCount)
                PlayerRef.AddItem(TargetIdentifiableItemEntry, TargetIdentifiableItemEntryCount)

                i+=1
            EndWhile
            ;; after returning all the identified items
            ItemSwapper.NTotalIdentifiableItemEntries = 0 ; resets the db index (will start to overwrite from 0)
            ItemSwapper.DBBlock = TRUE ; block the db until you loot again
            ItemSwapper.RemovalCheckBlock = FALSE ; reinits removal check after identiification process
        Else
            Debug.Notification("You already identified all pending items")
            PlayerRef.AddItem(_LUIIS_IdScroll,1,true) ; readds so you dont waste it
        endif
    endif
EndEvent