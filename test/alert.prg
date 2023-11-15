// FiveWin Clipper Alert replacement

#include "FiveWin.ch"

//-----------------------------------------------------------------//

function Main()

   local nOption
   ? IsExe64()
   nOption = Alert( "take an option",;
                    { "&One", "&Two", "T&hree" },;
                    "Please, select" )

   MsgInfo( nOption )

return nil

//-----------------------------------------------------------------//

