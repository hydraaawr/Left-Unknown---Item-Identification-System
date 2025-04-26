Scriptname LUIIS_ItemSwapper extends ReferenceAlias  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LUIIS_IsIdentifiable auto
MiscObject Property _LUIIS_UnkWeapon auto


Form[] CurrContainerItems
int NCurrcontainerSingleIdentifiableItems ; Number of Identifiable Items in the current container
int property NTotaldentifiableItemEntries auto ; Total number of SINGLE identifiable items = entries in db. Must persist bt saves. Determines the order of entries
String property NOrderIdentifiableItem auto 
form property IdentifiableItem auto
int Property IdentifiableItemArray auto
int property NPlayerUnkItems1 auto
int Property LootedUnkStackUnits = 0 auto
int Property NTotalLootedItems = 0 auto
bool Property DBBlock = TRUE auto ;  used for resetting the db when using the identification system
int IdentifiableItemCount

function IdentifiableSwap() ;;  Gets identifiable items from current container and swaps them      

    ObjectReference CurrContainer = Game.GetCurrentCrosshairRef() ; target the container inventory with the crosshair. Inspired by Nerapharu's comment at: https://www.nexusmods.com/skyrimspecialedition/mods/120152?tab=posts&BH=1
    
    if((CurrContainer as Actor).IsDead() || (CurrContainer as Actor).GetActorBase() == None) ; only works if player is looting corpses/chests
        NCurrcontainerSingleIdentifiableItems = 0; reset

        CurrContainerItems = CurrContainer.GetContainerForms() ; Saves the current container whole content in array. No need to initialize, this function already does it

        IdentifiableItemArray = JArray.object() ;temporal parallel db of forms

        ;; Replacement ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        int j = 0
        while j < CurrContainerItems.Length ;; travel the whole content

            if CurrContainerItems[j].HasKeyword(_LUIIS_IsIdentifiable) ;; if its identifiable
                IdentifiableItem = CurrContainerItems[j]
                IdentifiableItemCount = CurrContainer.GetItemCount(IdentifiableItem)
                JArray.addForm(IdentifiableItemArray,IdentifiableItem)
                NTotaldentifiableItemEntries += 1
                String IdentifiableItemNamePath = "._LUIIS_IdentifiableItem" + NTotaldentifiableItemEntries + ".name"
                String IdentifiableItemCountPath = "._LUIIS_IdentifiableItem" + NTotaldentifiableItemEntries + ".count"
                String IdentifiableItemFormPath = "._LUIIS_IdentifiableItem" + NTotaldentifiableItemEntries + ".form"
                ;Debug.Notification("Path: " + IdentifiableItemNamePath) ;;  DEBUG
                JDB.solveStrSetter(IdentifiableItemNamePath, IdentifiableItem.GetName(), true) ;  its name
                JDB.solveIntSetter(IdentifiableItemCountPath,IdentifiableItemCount , true) ; its count
                JDB.solveFormSetter(IdentifiableItemFormPath, IdentifiableItem, true) ; its form
                ;Debug.Notification("Current identifiable item: " + JDB.SolveStr(IdentifiableItemNamePath) +  ", count: " + JDB.SolveInt(IdentifiableItemCountPath)) ;DEBUG
                CurrContainer.RemoveItem(IdentifiableItem,IdentifiableItemCount) ;; Remove it
                NCurrcontainerSingleIdentifiableItems += 1

            endif

            j += 1
            

        endwhile

        CurrContainer.AddItem(_LUIIS_UnkWeapon, NCurrcontainerSingleIdentifiableItems) ;; Add as many Unidentified items to the container as Identifiable were in the same container
        Debug.Notification("NTotaldentifiableItemEntries: " + NTotaldentifiableItemEntries) ; DEBUG
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


Event OnMenuClose(String MenuName) ;; When closing a container DEBUG
    ;Debug.Notification("Closed a container")

    Utility.Wait(2)
    JArray.clear(IdentifiableItemArray) ; reset


Endevent