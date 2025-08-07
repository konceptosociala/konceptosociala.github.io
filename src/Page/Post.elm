module Page.Post exposing (..)
import Event exposing (Event)
import Utils.Post exposing (Post)
import Html.Styled exposing (Html)
import Html.Styled exposing (text)

view : Maybe (Post Event) -> Html Event
view post =
   case post of
      Just p ->
         p.content

      Nothing ->
         text "Fuck you"