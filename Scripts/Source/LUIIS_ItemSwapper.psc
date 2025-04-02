Scriptname LUIIS_ItemSwapper extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LUIIS_IsIdentifiable auto
FormList Property _LUIIS_IdentifiedItemsFLST auto
Weapon Property _LUIIS_UnkWeapon auto

function ReplaceByUnknown(FormList tFLST) ;; Replaces the content of container by the Unidentified generic item. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1     
    Actor ThisContainer = Game.GetCurrentCrosshairRef() as Actor ;target the container inventory with the crosshair
    int i = 0
    while i <= tFLST.GetSize() ;; travel the whole target flist looking for items with the Identifiable Keyword
        Form CurrIdItem = tFLST.GetAt(i) ;; Current Identifiable item from formlist
        if ThisContainer.IsEquipped(CurrIdItem) ;; if target container contains it
            Debug.Notification("Found identifiable item")
            ThisContainer.RemoveItem(CurrIdItem)  ;; remove it
            ThisContainer.Additem(_LUIIS_UnkWeapon)
        
        else
            Debug.Notification("Identifiable item NOT FOUND")
        endif
    endwhile
     
endfunction


Event OnInit()

    Debug.Notification("Left Unknown Initialized")
    RegisterForMenu("containerMenu")
    RegisterForModEvent("AddToIdentifiedList", "OnAddToIdentifiedList")
    
EndEvent



Event OnMenuOpen(String MenuName) ;; When opening a container
    if MenuName == "containerMenu"
        Debug.Notification("Opened a container")
        SendModEvent("AddToIdentifiedList") ; For FLM to add them to the identifieditemsflst
        ReplaceByUnknown(_LUIIS_IdentifiedItemsFLST)
    endIf
endEvent