module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html msg
view = 
   div
   []
   [ div 
      [ class "nbar"
      , class "flex-sm-column" 
      , class "flex-md-row"
      , class "flex-lg-row"
      , class "flex-column"
      ]
      [ a [ class "blog-link", href "blog" ] [ text "Blog" ]
      , a [ href "https://github.com/konceptosociala/" ] [ text "GitHub" ]
      , a [ href "https://soundcloud.com/janesnote" ] [ text "SoundCloud" ]
      ]
   ]

frameborder : Int -> Attribute msg
frameborder n =
   attribute "frameborder" (String.fromInt n)

scrolling : String -> Attribute msg
scrolling value =
   attribute "scrolling" value