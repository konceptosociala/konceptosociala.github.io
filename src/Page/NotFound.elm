module Page.NotFound exposing (..)

import Html exposing (..)
import Event exposing (Event)
import Html.Attributes exposing (..)

view : String -> Html Event
view page = p [ class "service-text" ] [ text ("Page `" ++ page ++ "` not found") ]
   