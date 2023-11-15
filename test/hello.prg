#include "fivewin.ch"

Function Main()

   local oWnd
   local aVal  := { 1, 2 , 3 }
   //XBrowse( aDays() )
   //XBrowse( aVal )
   DEFINE WINDOW oWnd MENU MiMenu()

   ACTIVATE WINDOW oWnd

Return nil

Function MiMenu()

   local oMnu
   MENU oMnu

      MENUITEM "Primero"
      MENUITEM "Segundo"
      MENUITEM "Salir"
   ENDMENU
Return oMnu
