module Page.Post exposing (..)

import Utils.Post exposing (Post)
import Html exposing (..)
import Html.Attributes exposing (class)
import Utils.Date as Date

view : Post msg -> Html msg
view post =
   div [ class "post" ]
      [ p   [ class "post-date" ] [ text (Date.toString post.date) ]
      , div [ class "post-content" ] [ post.content ]
      ]