module Page.Post exposing (..)
import Event exposing (Event)
import Utils.Post exposing (Post)
import Html.Styled exposing (Html)

view : Post Event -> Html Event
view post =
   post.content