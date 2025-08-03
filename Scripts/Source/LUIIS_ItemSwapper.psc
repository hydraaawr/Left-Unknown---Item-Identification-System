Scriptname LUIIS_ItemSwapper extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LUIIS_IsIdentifiable auto
MiscObject Property _LUIIS_UnkItem auto
ObjectReference Property ThisContainer auto

Form[] ThisContainerItems
int NThisContainerSingleIdentifiableItems ; Number of Identifiable Items in the current container
int property NTotalIdentifiableItemEntries auto ; Total number of SINGLE identifiable items = entries in db. Must persist bt saves. Determines the order of entries
form property CurrIdentifiableItem auto
bool Property DropCheckBlock = FALSE auto  ; prevents removal from happening (in order not to collide identification and uk item drop check mechanic)
int CurrIdentifiableItemCount
int NThisContainerOrphanUnkItems

Keyword Property _LUIIS_AlreadyIdentified auto
GlobalVariable Property _LUIIS_Debug auto

import StorageUtil


function IdentifiableSwap() ;;  Gets identifiable items from current container and swaps them      

    ThisContainer = Game.GetCurrentCrosshairRef() ; target the container inventory with the crosshair. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1
    if((ThisContainer as Actor).IsDead() || (ThisContainer as Actor).GetActorBase() == None) ; only works if player is looting corpses/chests
        NThisContainerSingleIdentifiableItems = 0; reset

        ThisContainerItems = ThisContainer.GetContainerForms() ; Saves the current container whole content in array. No need to initialize, this function already does it


        ;; Replacement ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        int j = 0
        while j < ThisContainerItems.Length ;; travel the whole content
            CurrIdentifiableItem = ThisContainerItems[j]
            if CurrIdentifiableItem.HasKeyword(_LUIIS_IsIdentifiable) && !CurrIdentifiableItem.HasKeyword(_LUIIS_AlreadyIdentified) ;; if its identifiable and not already identified
                
                CurrIdentifiableItemCount = ThisContainer.GetItemCount(CurrIdentifiableItem)
                String CurrIdentifiableItemEntryNamePath = "._LUIIS_IdentifiableItemEntry" + NTotalIdentifiableItemEntries + ".name"
                String CurrIdentifiableItemEntryCountPath = "._LUIIS_IdentifiableItemEntry" + NTotalIdentifiableItemEntries + ".count"
                String CurrIdentifiableItemEntryFormPath = "._LUIIS_IdentifiableItemEntry" + NTotalIdentifiableItemEntries + ".form"
                ;Debug.Notification("Path: " + IdentifiableItemNamePath) ;;  DEBUG
    

                SetStringValue(_LUIIS_UnkItem,CurrIdentifiableItemEntryNamePath,CurrIdentifiableItem.GetName())
                SetIntValue(_LUIIS_UnkItem,CurrIdentifiableItemEntryCountPath,CurrIdentifiableItemCount)
                SetFormValue(_LUIIS_UnkItem,CurrIdentifiableItemEntryFormPath,CurrIdentifiableItem)
                if(_LUIIS_Debug.GetValue() == 1)
                    Debug.Notification("Current entry added: " + NTotalIdentifiableItemEntries + ", " + GetStringValue(_LUIIS_UnkItem,CurrIdentifiableItemEntryNamePath) +  ", count: " + GetIntValue(_LUIIS_UnkItem,CurrIdentifiableItemEntryCountPath))
                endif
                ThisContainer.RemoveItem(CurrIdentifiableItem,CurrIdentifiableItemCount) ;; Remove it
                NThisContainerSingleIdentifiableItems += 1
                NTotalIdentifiableItemEntries += 1

            endif

            j += 1
            

        endwhile

        ThisContainer.AddItem(_LUIIS_UnkItem, NThisContainerSingleIdentifiableItems) ;; Add as many Unidentified items to the container as Identifiable were in the same container
        
    endif
endfunction

function ReverseSwap() ; For orphan unk items that were left in container
    NThisContainerOrphanUnkItems = ThisContainer.GetItemCount(_LUIIS_UnkItem) ; unk items that were left in the container (werent looted or wereturned back)
        
    ;Debug.Notification("NThisContainerOrphans: " + NThisContainerOrphanUnkItems) ;DEBUG

    if NThisContainerOrphanUnkItems > 0 ; If anything
        int EntryIndex = NTotalIdentifiableItemEntries - NThisContainerOrphanUnkItems ; to start from the last items in the list
        int i = 0
        while i < NThisContainerOrphanUnkItems
            ;; Readd last items of the list to container

            Form OrphanToAdd = GetFormValue(_LUIIS_UnkItem,("._LUIIS_IdentifiableItemEntry" + (EntryIndex + i) + ".form"))
            Int OrphanCountToAdd = GetIntValue(_LUIIS_UnkItem,("._LUIIS_IdentifiableItemEntry" + (EntryIndex + i) + ".count"))
            ThisContainer.Additem(OrphanToAdd,OrphanCountToAdd)
            
        
            ;; Pluck last orphan entries from db
    
            String CurrPluckItemEntryNamePath = "._LUIIS_IdentifiableItemEntry" + (EntryIndex + i) + ".name"
            String CurrPluckItemEntryCountPath = "._LUIIS_IdentifiableItemEntry" + (EntryIndex + i) + ".count"
            String CurrPluckItemEntryFormPath = "._LUIIS_IdentifiableItemEntry" + (EntryIndex + i) + ".form"
            if(_LUIIS_Debug.GetValue() == 1)
                Debug.Notification("Current plucked entry: " + (EntryIndex + i) + ", " + GetStringValue(_LUIIS_UnkItem, CurrPluckItemEntryNamePath) + ", count: " + GetIntValue(_LUIIS_UnkItem, CurrPluckItemEntryCountPath))
            endif
            PluckStringValue(_LUIIS_UnkItem,CurrPluckItemEntryNamePath)
            PluckIntValue(_LUIIS_UnkItem,CurrPluckItemEntryCountPath)
            PluckFormValue(_LUIIS_UnkItem,CurrPluckItemEntryFormPath)
            i += 1
        endwhile

        ThisContainer.RemoveItem(_LUIIS_UnkItem, NThisContainerOrphanUnkItems) ; Remove Unk items from it
        NTotalIdentifiableItemEntries -= NThisContainerOrphanUnkItems ; Decrease the number of total entries to travel
    endif

    ;Debug.Notification("NTotalIdentifiable Entries left: " + NTotalIdentifiableItemEntries) ;DEBUG
endfunction



Event OnInit()

    Debug.Notification("Left Unknown Initialized")
    RegisterForMenu("containerMenu")
    RegisterForMenu("LootMenu")
    AddInventoryEventFilter(_LUIIS_UnkItem)
EndEvent



Event OnMenuOpen(String MenuName) ;; When opening a container

    if (MenuName == "LootMenu" || MenuName == "containerMenu") ; for both vanilla and quickloot compat
        ;Debug.Notification("Opened a container") ;DEBUG
        IdentifiableSwap()

    endIf

endEvent



Event OnMenuClose(String MenuName) ;; When closing a container

    if (MenuName == "LootMenu" || MenuName == "containerMenu") ; for both vanilla and quickloot compat
        ;Debug.Notification("Closed a container") ;DEBUG
        ReverseSwap()

        
        

    endIf

endEvent


Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemRef, ObjectReference akDestContainer) ; Prevents dropping of unidentified items
    
    
    if DropCheckBlock == FALSE && akDestContainer == None && akItemRef ; 1 prevents this from happening when performing identification and 2 checks if dropped to the world (akDestContainer == None)

        ;Debug.Notification("LUIIS: Removed Unidentified Item")
        akItemRef.Disable()  ; Disable the reference to prevent it from being used
        akItemRef.Delete()   ; Remove the reference from the world
        PlayerRef.AddItem(akBaseItem, aiItemCount) ; Add back to player's inventory
        Debug.Notification("Unidentified Items cannot be removed from your Inventory")

    endif
    
EndEvent
