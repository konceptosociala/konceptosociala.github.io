module Utils.Utils exposing (..)

import Html.Styled exposing (..)
import Route exposing (Route(..))
import Markdown.Parser as Markdown
import Markdown.Renderer
import Html.Styled.Attributes exposing (css)
import Css exposing (..)

pageLayout : String -> Html msg -> Html msg
pageLayout title view = 
   div 
      [ css 
         [ width (vw 75)
         , marginLeft auto
         , marginRight auto
         ] 
      ]
   [ h1 
      [ css
         [ fontFamilies ["Montserrat Underline"]
         , fontSize (px 128)
         ]
      ] 
      [ text title ]
   , div [] [view]
   ]

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