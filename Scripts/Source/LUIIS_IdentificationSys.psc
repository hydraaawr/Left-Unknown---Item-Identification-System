Scriptname LUIIS_IdentificationSys extends activemagiceffect  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
MiscObject Property _LUIIS_UnkWeapon auto
LUIIS_ItemSwapper Property ItemSwapper auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if(akTarget == PlayerRef)
        PlayerRef.RemoveItem(_LUIIS_UnkWeapon, PlayerRef.GetItemCount(_LUIIS_UnkWeapon)) ; Remove all unidentified items
        int i = 0
        While (i < ItemSwapper.NTotalLootedItems)
            form TargetIdentifiableItem = JDB.SolveForm("._LUIIS_IdentifiableItem" + i + ".form")
            PlayerRef.AddItem(TargetIdentifiableItem)
            i+=1
        EndWhile
    endif
EndEvent