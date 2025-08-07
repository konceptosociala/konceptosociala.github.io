module Utils.Post exposing (..)

import Utils.Date exposing (Date)
import Utils.Date as Date
import Html.Styled exposing (Html)

type alias Post msg =
   { name : String
   , date : Date
   , content : Html msg
   }

compare : (String, Post msg) -> (String, Post msg) -> Order
compare (_, p1) (_, p2) = Date.compare p1.date p2.date