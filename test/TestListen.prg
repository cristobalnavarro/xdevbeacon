#include "Fivewin.ch"

#define WM_MYMESSAGE 0xBEEE

Static oWnd
Static oPanel1
Static nRow
Static lServer
Static oTm

Function Main()

   local oMen
   lServer        := .F.
   //SetCurDir( "D:\Harbour\Harbour7\contrib\hbhttpd\tests\" )
   MENU oMen
       MENUITEM "Server"
       MENU
           MENUITEM "Server ON" ACTION ServerON()
           SEPARATOR
           MENUITEM "Server OFF" ACTION ServerOFF() //+ CHR( 9 ) + "ALT-F4"
           SEPARATOR
           MENUITEM "Exit" ACTION oWnd:End()
       ENDMENU
   ENDMENU

   nRow  := 2
   DEFINE WINDOW oWnd TITLE "Tests Server Hbhttpd " MENU oMen
   
   oPanel1  := TPanel():New( 1, 1, 220, 280, oWnd )
   oPanel1:SetColor( , CLR_GRAY )


   ACTIVATE WINDOW oWnd ;
      VALID ( if( lServer, ServerOFF(), ), .T. ) ;
      ON INIT ( Fw_SayText( oPanel1, "Server OFF", { nRow, 2, 16, 80 }, , , CLR_BLUE ) )

Return nil

//----------------------------------------------------------------------------//

Function ServerON()

   local cStdIn   := ""
   local cCommand := "D:\Harbour\Harbour7\contrib\hbhttpd\tests\eShop.exe"
   local cStdOut  := Space( 512 )
   local cStdErr  := Space( 512 )
   local lDetach  := .T.
   local nRet     := 0
   
   lServer        := .T.
   
   if File( cCommand )

      DEFINE TIMER oTm OF oWnd INTERVAL 300 ACTION Pinta( cStdOut )
      oTm:Activate()
      //WinExec( cCommand, 0 )
      nRet           := hb_ProcessRun( cCommand, cStdIn, @cStdOut, @cStdErr, lDetach )
      //? cStdOut
      oWnd:SetFocus()
   
   else
      ? "Not Found server"
   endif

Return nil

//----------------------------------------------------------------------------//

Function Pinta( cMsg )

   Fw_SayText( oPanel1, cMsg, { nRow, 2, 16, 180 }, , , CLR_GRAY )
   nRow += 20
   if nRow > 388
      nRow := 2
   endif
   Fw_SayText( oPanel1, cMsg, { nRow, 2, 16, 180 }, , , CLR_BLUE )

Return nil

//----------------------------------------------------------------------------//

Function ServerOFF()

   local cStdIn   := ""
   local cCommand := "D:\Harbour\Harbour7\contrib\hbhttpd\tests\eShop.exe //stop"
   local cStdOut  := Space( 512 )
   local cStdErr  := Space( 512 )
   local lDetach  := .T.
   local nRet     := 0
   if !Empty( oTm )
      oTm:End()
   endif
   //WinExec( cCommand, 0 )
   if lServer
      nRet           := hb_ProcessRun( cCommand, cStdIn, @cStdOut, @cStdErr, lDetach )
   endif
   lServer  := .F.

Return nil

//----------------------------------------------------------------------------//
