Scriptname LUIIS_ItemSwapper extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LUIIS_IsIdentifiable auto
FormList Property _LUIIS_CurrContainerIdentifiableItemsFLST auto
FormList Property _LUIIS_PendingIdentifiableItemsFLST auto
Weapon Property _LUIIS_UnkWeapon auto


Form[] CurrContainerItems

function GetCurrContainerIdentifiableItems() ;;  Gets identifiable items from current container      
    
    ObjectReference CurrContainer = Game.GetCurrentCrosshairRef() ; target the container inventory with the crosshair. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1
    CurrContainerItems = CurrContainer.GetContainerForms() ; Saves the its whole content in array. No need to initialize, this function already does it
    Debug.Notification("Length of the container items array: " + CurrContainerItems.Length)
    int i = 0
    while i < CurrContainerItems.Length ;; travel the whole content

        if CurrContainerItems[i].HasKeyword(_LUIIS_IsIdentifiable) ;; if its identifiable
            _LUIIS_CurrContainerIdentifiableItemsFLST.AddForm(CurrContainerItems[i]) ;; Add it to the Identifiable Formlist. This is not an array because its size has to be variable 
        endif

        i += 1

    endwhile
    Debug.Notification("Length of the container identifiable items formlist: " + _LUIIS_CurrContainerIdentifiableItemsFLST.GetSize())

    ;; Clean Current Formlist
    _LUIIS_CurrContainerIdentifiableItemsFLST.Revert()
endfunction


Event OnInit()

    Debug.Notification("Left Unknown Initialized")
    RegisterForMenu("containerMenu")
    ; RegisterForModEvent("AddToCurrContainerList", "OnAddToCurrContainerList")
    ; RegisterForModEvent("AddToIdentifiedList", "OnAddToIdentifiedList")
EndEvent



Event OnMenuOpen(String MenuName) ;; When opening a container
    if MenuName == "containerMenu"
        Debug.Notification("Opened a container")
        GetCurrContainerIdentifiableItems()
        ; SendModEvent("AddToIdentifiedList") ; For FLM to add them to the identifieditemsflst
        ; ReplaceByUnknown(_LUIIS_IdentifiedItemsFLST)
    endIf
endEvent