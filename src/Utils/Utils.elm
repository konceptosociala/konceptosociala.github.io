module Utils.Utils exposing (..)

import Html.Styled exposing (..)
import Route exposing (Route(..))
import Html.Styled exposing (Html, div, text)
import Markdown.Parser as Markdown
import Markdown.Renderer

parseMarkdown : String -> Html msg
parseMarkdown markdownInput =
   case
      markdownInput
         |> Markdown.parse
         |> Result.mapError (\_ -> "Error parsing markdown")
         |> Result.andThen (\ast -> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer ast)
      of
      Ok rendered ->
         div [] <| List.map fromUnstyled rendered

      Err error ->
         text error

pageTitle : Route -> String
pageTitle page =
   case page of
      Home -> "Home"
      About -> "About"
      Blog -> "Blog"
      Post _ -> "Post"
      NotFound _ -> "404 | Page Not Found"