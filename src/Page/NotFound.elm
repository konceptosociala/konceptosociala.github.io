module Page.NotFound exposing (..)

import Html exposing (..)
import Event exposing (Event)

view : String -> Html Event
view page = text ("Page `" ++ page ++ "` not found")