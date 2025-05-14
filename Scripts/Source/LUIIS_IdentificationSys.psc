Scriptname LUIIS_IdentificationSys extends activemagiceffect  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
MiscObject Property _LUIIS_UnkItem auto
LUIIS_ItemSwapper Property ItemSwapper auto
Scroll Property _LUIIS_IdScroll auto
GlobalVariable Property _LUIIS_Debug auto

form TargetIdentifiableItemEntry
int TargetIdentifiableItemEntryCount



Event OnEffectStart(Actor akTarget, Actor akCaster)
    if(akTarget == PlayerRef)
        if(ItemSwapper.DBBlock == FALSE)
            ItemSwapper.DropCheckBlock = TRUE ; stop removal check during identiification process
            PlayerRef.RemoveItem(_LUIIS_UnkItem, PlayerRef.GetItemCount(_LUIIS_UnkItem), TRUE) ; Remove all unidentified items
            int i = 0
            While (i < ItemSwapper.NTotalIdentifiableItemEntries)
                TargetIdentifiableItemEntry = JDB.SolveForm("._LUIIS_IdentifiableItemEntry" + i + ".form")
                TargetIdentifiableItemEntryCount = JDB.solveInt("._LUIIS_IdentifiableItemEntry" + i + ".count")

                TargetIdentifiableItemEntry = JDB.SolveForm("._LUIIS_IdentifiableItemEntry" + i + ".form")
                TargetIdentifiableItemEntryCount = JDB.solveInt("._LUIIS_IdentifiableItemEntry" + i + ".count")
                if(_LUIIS_Debug.GetValue() == 1)
                    Debug.Notification("Identifiying entry " + i + " " + TargetIdentifiableItemEntry.GetName() + ", count: " + TargetIdentifiableItemEntryCount)
                endif
                PlayerRef.AddItem(TargetIdentifiableItemEntry, TargetIdentifiableItemEntryCount)

                i+=1
            EndWhile
            ;; after returning all the identified items
            ItemSwapper.NTotalIdentifiableItemEntries = 0 ; resets the db index (will start to overwrite from 0)
            ItemSwapper.DBBlock = TRUE ; block the db until you loot again
            ItemSwapper.DropCheckBlock = FALSE ; reinits removal check after identiification process
        Else
            Debug.Notification("You already identified all pending Unidentified Items")
            PlayerRef.AddItem(_LUIIS_IdScroll,1,true) ; readds so you dont waste it
        endif
    endif
EndEvent