#include "fivewin.ch"

REQUEST DBFCDX

static oCn

//----------------------------------------------------------------------------//

function Main()

   local aTables
   local cDataBase   := "xbrtest.mdb"

   FW_SetUnicode( .t. )
   SetGetColorFocus()
   SET DATE GERMAN
   SET CENTURY ON
   FWNumFormat( "E", .t. )

   if !( Right( cFilePath( ExeName() ), 9 ) .XEQ. "\samples\" )
      ? "Build this program in fwh\samples\ folder"
      QUIT
   endif

   cDataBase   := cFileSetExt( cDataBase, "mdb" )
   if !File( cDataBase)
      FW_CreateMDB( cDataBase )
   endif
   oCn   := FW_OpenAdoConnection( cDataBase, .t. )
   if oCn == nil
      ? "Connection fail"
      QUIT
   endif
   ? "connected"

   ImportDBF()

   ListTables()

   oCn:Close()

return nil

//----------------------------------------------------------------------------//

static function ImportDBF()

   local aTables  := { "states", "customer", "wwonders" }
   local cTable, cDbf

   for each cTable in aTables
      cDBF     := cTable + ".dbf"
      if !FW_AdoTableExists( cTable, oCn ) .or. ;
         MsgNoYes( "Re-Create table " + cTable + " ?"  )
         TRY
            oCn:Execute( "DROP TABLE " + cTable )
         CATCH
         END
         FW_AdoImportFromDBF( oCn, cDBF )
      endif
   next

return nil

//----------------------------------------------------------------------------//

static function ListTables()

   local aTables, oRs
   local oDlg, oBar, oBrw, oFont

   DEFINE FONT oFont NAME "TAHOMA" SIZE 0,-14
   DEFINE DIALOG oDlg SIZE 400,400 PIXEL TRUEPIXEL ;
      FONT oFont RESIZABLE TITLE "Tables"
   DEFINE BUTTONBAR oBar OF oDlg SIZE 100,32 2010
   @ 42,20 XBROWSE oBrw SIZE -20,-20 PIXEL OF oDlg ;
      DATASOURCE FW_AdoTables( oCn ) COLUMNS 1 ;
      HEADERS "Table" CELL LINES NOBORDER FOOTERS

   WITH OBJECT oBrw
      :nStretchCol   := 1
      :lHScroll      := .f.
      :RecSelShowKeyNo()
      :CreateFromCode()
   END

   DEFINE BUTTON OF oBar PROMPT "Browse" CENTER ACTION ;
      BrowseTable( oBrw:aCols[ 1 ]:Value )
   DEFINE BUTTON OF oBar PROMPT "Edit" CENTER ACTION ;
      ( oRs := FW_OpenRecordSet( oCn, oBrw:aCols[ 1 ]:Value ), ;
        XEdit( oRs ), oRs:Close() )

   ACTIVATE DIALOG oDlg CENTERED
   RELEASE FONT oFont

return nil

//----------------------------------------------------------------------------//

static function BrowseTable( cTable )

   local oDlg, oBar, oFont, oBrw, oRs

   oRs   := FW_OpenRecordSet( oCn, cTable )

   DEFINE FONT oFont NAME "TAHOMA" SIZE 0,-14
   DEFINE DIALOG oDlg SIZE 800,400 PIXEL TRUEPIXEL ;
      FONT oFont RESIZABLE TITLE cTable
   DEFINE BUTTONBAR oBar OF oDlg SIZE 100,32 2010

   @ 42,20 XBROWSE oBrw SIZE -20,-20 PIXEL OF oDlg ;
      DATASOURCE oRs AUTOCOLS ;
      FASTEDIT FOOTERS CELL LINES NOBORDER

   WITH OBJECT oBrw
      :nEditTypes    := EDIT_GET
      :SetChecks()
      :AutoFit()
      :RecSelShowKeyNo()
      :CreateFromCode()
   END

   DEFINE BUTTON OF oBar PROMPT "Add"    CENTER ACTION oBrw:EditSource( .t. )
   DEFINE BUTTON OF oBar PROMPT "Edit"   CENTER ACTION oBrw:EditSource()
   DEFINE BUTTON OF oBar PROMPT "Delete" CENTER ACTION oBrw:Delete( .t. )

   ACTIVATE DIALOG oDlg CENTERED
   RELEASE FONT oFont

   oRs:Close()

return nil


