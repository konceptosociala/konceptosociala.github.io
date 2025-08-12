module Page.About exposing (..)

import Html exposing (..)
import Css exposing (..)
import Event exposing (Event)
import Html.Attributes exposing (href)

view : Html Event
view = 
   div []
   [ a 
      [ href "/" 
      ] [ text "Goto shit" ]
   ]