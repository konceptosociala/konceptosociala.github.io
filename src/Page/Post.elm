module Page.Post exposing (..)

import Utils.Post exposing (Post)
import Html.Styled exposing (Html)

view : Post msg -> Html msg
view post =
   post.content