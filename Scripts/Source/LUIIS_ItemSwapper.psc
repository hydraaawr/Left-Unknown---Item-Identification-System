Scriptname LUIIS_ItemSwapper extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LUIIS_IsIdentifiable auto
FormList Property _LUIIS_CurrContainerIdentifiableItemsFLST auto
FormList Property _LUIIS_PendingIdentifiableItemsFLST auto
Weapon Property _LUIIS_UnkWeapon auto


Form[] CurrContainerItems

function IdentifiableSwap() ;;  Gets identifiable items from current container and swaps them      
    
    ObjectReference CurrContainer = Game.GetCurrentCrosshairRef() ; target the container inventory with the crosshair. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1
    
    ;; Getting the Identifiable items in the container ;;;;;;;;;;;;;;;;;;;;;;;;;;;

    CurrContainerItems = CurrContainer.GetContainerForms() ; Saves the its whole content in array. No need to initialize, this function already does it
    Debug.Notification("Length of the container items array: " + CurrContainerItems.Length)
    int i = 0
    while i < CurrContainerItems.Length ;; travel the whole content

        if CurrContainerItems[i].HasKeyword(_LUIIS_IsIdentifiable) ;; if its identifiable
            _LUIIS_CurrContainerIdentifiableItemsFLST.AddForm(CurrContainerItems[i]) ;; Add it to the Identifiable Formlist. This is not an array because its size has to be variable 
        endif

        i += 1

    endwhile

    int NCurrContainerIdentifiableItems = _LUIIS_CurrContainerIdentifiableItemsFLST.GetSize()
    Debug.Notification("Length of the container identifiable items formlist: " + NCurrContainerIdentifiableItems)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Add them to the total formlist of identifiable items pending to be identified
    _LUIIS_PendingIdentifiableItemsFLST.AddForms(_LUIIS_CurrContainerIdentifiableItemsFLST.ToArray()) ;; add to pending list the current ones

    ;; Replacement ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    int j = 0
    while j < CurrContainerItems.Length ;; travel the whole content

        if CurrContainerItems[j].HasKeyword(_LUIIS_IsIdentifiable) ;; if its identifiable
            CurrContainer.RemoveItem(CurrContainerItems[j]) ;; Remove it
        endif

        j += 1

    endwhile

    CurrContainer.AddItem(_LUIIS_UnkWeapon, NCurrContainerIdentifiableItems) ;; Add as many Unidentified items as Identifiable where

    ;; Clean Current Formlist
    
    _LUIIS_CurrContainerIdentifiableItemsFLST.Revert()


endfunction


Event OnInit()

    Debug.Notification("Left Unknown Initialized")
    RegisterForMenu("containerMenu")
EndEvent



Event OnMenuOpen(String MenuName) ;; When opening a container

    if MenuName == "containerMenu"
        Debug.Notification("Opened a container")
        IdentifiableSwap()
    endIf

endEvent