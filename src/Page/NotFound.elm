module Page.NotFound exposing (..)

import Html.Styled exposing (..)
import Event exposing (Event)

view : String -> Html Event
view page = text ("Page `" ++ page ++ "` not found")