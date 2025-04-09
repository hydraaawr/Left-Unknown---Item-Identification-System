Scriptname LUIIS_ItemSwapper extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LUIIS_IsIdentifiable auto
MiscObject Property _LUIIS_UnkWeapon auto


Form[] CurrContainerItems
int NCurrContainerIdentifiableItems

function IdentifiableSwap() ;;  Gets identifiable items from current container and swaps them      

    ObjectReference CurrContainer = Game.GetCurrentCrosshairRef() ; target the container inventory with the crosshair. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1
    
    NCurrContainerIdentifiableItems = 0; reset

    CurrContainerItems = CurrContainer.GetContainerForms() ; Saves the current container whole content in array. No need to initialize, this function already does it

    ;; Replacement ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    int j = 0
    while j < CurrContainerItems.Length ;; travel the whole content

        if CurrContainerItems[j].HasKeyword(_LUIIS_IsIdentifiable) ;; if its identifiable
            Form IdentifiableItem = CurrContainerItems[j]
            JFormDB.setInt(IdentifiableItem, "._LUIIS_IdentifiableItems.IdentifiableItem1", CurrContainer.GetItemCount(CurrContainerItems[j])) ; update persistent db WIP CYCLE THROUGH KEYS
            Debug.Notification("Current identifiable items count (DB access):" + JFormDB.GetInt(IdentifiableItem,"._LUIIS_IdentifiableItems.IdentifiableItem1")) 
            CurrContainer.RemoveItem(IdentifiableItem) ;; Remove it
            NCurrContainerIdentifiableItems += 1
        endif

        j += 1

    endwhile

    CurrContainer.AddItem(_LUIIS_UnkWeapon, NCurrContainerIdentifiableItems) ;; Add as many Unidentified items as Identifiable were to the container


endfunction





; function UpdatePendingIdentifiableLists()
;     NPendingIdentifiableItems = _LUIIS_PendingIdentifiableItemsFLST.GetSize()
;     Debug.Notification("Total Pending Identifiable Items: " + NPendingIdentifiableItems)

;     int i = 0
;     int CurrLootedCount = 0 ; Counter for looted items

;     ; Update the number of unidentified items for the player
;     NPlayerUnkItems = PlayerRef.GetItemCount(_LUIIS_UnkWeapon)  ; Ensure this is updated before checking
;     Debug.Notification("Updated Player Unidentified Items: " + NPlayerUnkItems)
    
;     ; Calculate the difference between current and last count of unidentified items
;     int UnkLootedItems = NPlayerUnkItems - LastNPlayerUnkItems
;     Debug.Notification("Difference in Unidentified Items: " + UnkLootedItems)

;     while i < NPendingIdentifiableItems
;         Form currentItem = _LUIIS_PendingIdentifiableItemsFLST.GetAt(i) ; Get item from pending list

;         ; If player has looted new unidentified items, counts as looted
;         if UnkLootedItems > 0 ; This means the player has looted at least one unidentified item
;             ;_LUIIS_PendingIdentifiableLootedItemsFLST.AddForm(currentItem) ; Add to looted list
;             ;PendingIdentifiableLootedUnitsArray[i] = UnkLootedItems ; Store the number of looted items
;             CurrLootedCount += UnkLootedItems ; Increase count by the number of looted items
;             Debug.Notification("Looted identifiable item: " + currentItem.GetName() + " x " + UnkLootedItems)

;             ; Update the last known unidentified items after processing
;             LastNPlayerUnkItems = NPlayerUnkItems
;         endif
        
;         i += 1 ; Move to the next item
;     endwhile

;     NPendingIdentifiableLootedItems = _LUIIS_PendingIdentifiableLootedItemsFLST.GetSize()
;     Debug.Notification("Looted identifiable items from last interaction: " + CurrLootedCount)
;     Debug.Notification("Looted Pending Identifiable Items in its formlist: " + NPendingIdentifiableLootedItems)
; endfunction




Event OnInit()

    Debug.Notification("Left Unknown Initialized")
    RegisterForMenu("containerMenu")
    RegisterForMenu("LootMenu")
EndEvent



Event OnMenuOpen(String MenuName) ;; When opening a container

    if (MenuName == "LootMenu" || MenuName == "containerMenu") ; for both vanilla and quickloot compat
        ;Debug.Notification("Opened a container")
        IdentifiableSwap()
    endIf

endEvent


; Event OnMenuClose(String MenuName) ;; When closing a container
;     ;Debug.Notification("Closed a container")


;     UpdatePendingIdentifiableLists()

;     ; Clean Current container Formlist
;     _LUIIS_CurrContainerIdentifiableItemsFLST.Revert()

; Endevent