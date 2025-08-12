module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html msg
view = 
   a [ href "blog" ] [ text "Blog" ]