module Page.About exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Css exposing (..)
import Event exposing (Event)
import Html.Styled.Attributes exposing (href)

view : Html Event
view = 
   div []
   [ p 
      [ css 
         [ color (hex "#ff0000")
         , fontWeight bold
         ]
      ] [ text "sasi" ]
   , a 
      [ href "/about" 
      ] [ text "Goto shit" ]
   ]