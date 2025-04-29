Scriptname LUIIS_ItemSwapper extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LUIIS_IsIdentifiable auto
MiscObject Property _LUIIS_UnkWeapon auto


Form[] ThisContainerItems
int NThisContainerSingleIdentifiableItems ; Number of Identifiable Items in the current container
int property NTotalIdentifiableItemEntries auto ; Total number of SINGLE identifiable items = entries in db. Must persist bt saves. Determines the order of entries
form property CurrIdentifiableItem auto
int Property IdentifiableItemArray auto ; DEBUG temporal parallel db of forms
int property NPlayerUnkItems1 auto
bool Property DBBlock = TRUE auto ;  used for resetting the db when using the identification system
int CurrIdentifiableItemCount

function IdentifiableSwap() ;;  Gets identifiable items from current container and swaps them      

    ObjectReference ThisContainer = Game.GetCurrentCrosshairRef() ; target the container inventory with the crosshair. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1
    
    if((ThisContainer as Actor).IsDead() || (ThisContainer as Actor).GetActorBase() == None) ; only works if player is looting corpses/chests
        NThisContainerSingleIdentifiableItems = 0; reset

        ThisContainerItems = ThisContainer.GetContainerForms() ; Saves the current container whole content in array. No need to initialize, this function already does it

        IdentifiableItemArray = JArray.object() ; DEBUG, it creates/resets the array

        ;; Replacement ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        int j = 0
        while j < ThisContainerItems.Length ;; travel the whole content

            if ThisContainerItems[j].HasKeyword(_LUIIS_IsIdentifiable) ;; if its identifiable
                CurrIdentifiableItem = ThisContainerItems[j]
                CurrIdentifiableItemCount = ThisContainer.GetItemCount(CurrIdentifiableItem)
                JArray.addForm(IdentifiableItemArray,CurrIdentifiableItem) ; DEBUG
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

        ThisContainer.AddItem(_LUIIS_UnkWeapon, NThisContainerSingleIdentifiableItems) ;; Add as many Unidentified items to the container as Identifiable were in the same container
        Debug.Notification("NTotalIdentifiableItemEntries: " + NTotalIdentifiableItemEntries) ; DEBUG
    endif
endfunction









Event OnInit()

    Debug.Notification("Left Unknown Initialized")
    RegisterForMenu("containerMenu")
    RegisterForMenu("LootMenu")
EndEvent



Event OnMenuOpen(String MenuName) ;; When opening a container

    if (MenuName == "LootMenu" || MenuName == "containerMenu") ; for both vanilla and quickloot compat
        ;Debug.Notification("Opened a container")
        IdentifiableSwap()
        NPlayerUnkItems1 = PlayerRef.GetItemCount(_LUIIS_UnkWeapon)
    endIf

endEvent

