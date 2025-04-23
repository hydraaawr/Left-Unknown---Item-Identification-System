Scriptname LUIIS_IdentificationSys extends activemagiceffect  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
MiscObject Property _LUIIS_UnkWeapon auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if(akTarget == PlayerRef)
        PlayerRef.RemoveItem(_LUIIS_UnkWeapon, PlayerRef.GetItemCount(_LUIIS_UnkWeapon)) ; Remove all unidentified items
    endif
EndEvent