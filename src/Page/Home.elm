module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html msg
view = 
   div
   []
   [ a [ href "blog" ] [ text "Blog" ]
   , br [] []
   , iframe 
      [ width 110
      , height 200
      , src "https://www.myinstants.com/instant/khui-griu-8473/embed/"
      , frameborder 0
      , scrolling "no"
      ] []
   ]

frameborder : Int -> Attribute msg
frameborder n =
  attribute "frameborder" (String.fromInt n)

scrolling : String -> Attribute msg
scrolling value =
  attribute "scrolling" value