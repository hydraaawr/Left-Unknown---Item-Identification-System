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
int property NPlayerUnkItems1 auto
bool Property DBBlock = TRUE auto ;  used for resetting the db when using the identification system
bool Property TradeBlock = FALSE auto ; prevents lootcheck activating when readding unk item after removal (drop,  turn back to container)
bool Property DropCheckBlock = FALSE auto  ; prevents removal from happening (in order not to collide identification and uk item drop check mechanic)
int CurrIdentifiableItemCount
int NThisContainerOrphanUnkItems1
int NThisContainerOrphanUnkItems2


function IdentifiableSwap() ;;  Gets identifiable items from current container and swaps them      

    ThisContainer = Game.GetCurrentCrosshairRef() ; target the container inventory with the crosshair. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1
    if((ThisContainer as Actor).IsDead() || (ThisContainer as Actor).GetActorBase() == None) ; only works if player is looting corpses/chests
        NThisContainerSingleIdentifiableItems = 0; reset

        ThisContainerItems = ThisContainer.GetContainerForms() ; Saves the current container whole content in array. No need to initialize, this function already does it


        ;; Replacement ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        int j = 0
        while j < ThisContainerItems.Length ;; travel the whole content

            if ThisContainerItems[j].HasKeyword(_LUIIS_IsIdentifiable) ;; if its identifiable
                CurrIdentifiableItem = ThisContainerItems[j]
                CurrIdentifiableItemCount = ThisContainer.GetItemCount(CurrIdentifiableItem)
                String CurrIdentifiableItemEntryNamePath = "._LUIIS_IdentifiableItemEntry" + NTotalIdentifiableItemEntries + ".name"
                String CurrIdentifiableItemEntryCountPath = "._LUIIS_IdentifiableItemEntry" + NTotalIdentifiableItemEntries + ".count"
                String CurrIdentifiableItemEntryFormPath = "._LUIIS_IdentifiableItemEntry" + NTotalIdentifiableItemEntries + ".form"
                ;Debug.Notification("Path: " + IdentifiableItemNamePath) ;;  DEBUG
                JDB.solveStrSetter(CurrIdentifiableItemEntryNamePath, CurrIdentifiableItem.GetName(), true) ;  its name
                JDB.solveIntSetter(CurrIdentifiableItemEntryCountPath,CurrIdentifiableItemCount , true) ; its count
                JDB.solveFormSetter(CurrIdentifiableItemEntryFormPath, CurrIdentifiableItem, true) ; its form
                ;Debug.Notification("Current identifiable item: " + JDB.SolveStr(IdentifiableItemNamePath) +  ", count: " + JDB.SolveInt(IdentifiableItemCountPath)) ;DEBUG
                ThisContainer.RemoveItem(CurrIdentifiableItem,CurrIdentifiableItemCount) ;; Remove it
                NThisContainerSingleIdentifiableItems += 1
                NTotalIdentifiableItemEntries += 1

            endif

            j += 1
            

        endwhile

        ThisContainer.AddItem(_LUIIS_UnkItem, NThisContainerSingleIdentifiableItems) ;; Add as many Unidentified items to the container as Identifiable were in the same container
        
    endif
endfunction



function OrphanClean() ; orphans are unk items that were left in container. They must be cleansed

    ThisContainer.RemoveItem(_LUIIS_UnkItem,NThisContainerOrphanUnkItems2)
    PlayerRef.AddItem(_LUIIS_UnkItem,NThisContainerOrphanUnkItems2,FALSE) ; readds them to player

endfunction




Event OnInit()

    Debug.Notification("Left Unknown Initialized")
    RegisterForMenu("containerMenu")
    RegisterForMenu("LootMenu")
    AddInventoryEventFilter(_LUIIS_UnkItem)
EndEvent



Event OnMenuOpen(String MenuName) ;; When opening a container

    if (MenuName == "LootMenu" || MenuName == "containerMenu") ; for both vanilla and quickloot compat
        ;Debug.Notification("Opened a container")
        IdentifiableSwap()
        NPlayerUnkItems1 = PlayerRef.GetItemCount(_LUIIS_UnkItem)
        NThisContainerOrphanUnkItems1 = ThisContainer.GetItemCount(_LUIIS_UnkItem)

    endIf

endEvent



Event OnMenuClose(String MenuName) ;; When opening a container

    if (MenuName == "LootMenu" || MenuName == "containerMenu") ; for both vanilla and quickloot compat
        
        NThisContainerOrphanUnkItems2 = ThisContainer.GetItemCount(_LUIIS_UnkItem)

        if(ThisContainer.GetItemCount(_LUIIS_UnkItem) > 0) ; if player left any unk item in container
            TradeBlock = TRUE ; just in case
            OrphanClean() ; cleans orphans
            TradeBlock = FALSE
        endif


    endIf

endEvent


Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemRef, ObjectReference akDestContainer)
    
    
    if DropCheckBlock == FALSE && akDestContainer == None && akItemRef ; 1 prevents this from happening when performing identification and 2 dropped to the world (akDestContainer == None)

        Debug.Notification("LUIIS: Removed Unidentified Item")
        TradeBlock = TRUE
        akItemRef.Disable()  ; Disable the reference to prevent it from being used
        akItemRef.Delete()   ; Remove the reference from the world
        PlayerRef.AddItem(akBaseItem, aiItemCount) ; Add back to player's inventory
        Debug.Notification("You cannot drop this item.")
        
        TradeBlock = FALSE
    endif
    
EndEvent
