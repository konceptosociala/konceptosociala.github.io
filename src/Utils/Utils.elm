module Utils.Utils exposing (pageLayout, pageTitle, parsingErrors, parseMarkdown)

import Html.Styled exposing (..)
import Route exposing (Route(..))
import Markdown.Parser as Markdown
import Markdown.Renderer
import Html.Styled.Attributes exposing (css)
import Css exposing (..)
import Parser exposing (DeadEnd)
import Parser exposing (Problem)

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

pageTitle : Route -> String
pageTitle page =
   case page of
      Home -> "Home"
      About -> "About"
      Blog -> "Blog"
      Post _ -> "Post"
      NotFound _ -> "404 | Page Not Found"

parsingErrors : List DeadEnd -> String
parsingErrors errors =
   errors
      |> List.map deadendToString
      |> String.join "\n"

problemToString : Problem -> String
problemToString p =
   case p of
      Parser.Expecting str ->
         "Expecting: \"" ++ str ++ "\""

      Parser.ExpectingInt ->
         "Expecting an Int"

      Parser.ExpectingHex ->
         "Expecting a Hex value"

      Parser.ExpectingOctal ->
         "Expecting an Octal value"

      Parser.ExpectingBinary ->
         "Expecting a Binary value"

      Parser.ExpectingFloat ->
         "Expecting a Float"

      Parser.ExpectingNumber ->
         "Expecting a Number"

      Parser.ExpectingVariable ->
         "Expecting a Variable"

      Parser.ExpectingSymbol str ->
         "Expecting Symbol: \"" ++ str ++ "\""

      Parser.ExpectingKeyword str ->
         "Expecting Keyword: \"" ++ str ++ "\""

      Parser.ExpectingEnd ->
         "Expecting End"

      Parser.UnexpectedChar ->
         "Unexpected Character"

      Parser.Problem str ->
         "Problem: \"" ++ str ++ "\""

      Parser.BadRepeat ->
         "Bad Repeat"

deadendToString : DeadEnd -> String
deadendToString e
   = String.fromInt e.row 
   ++ ":" 
   ++ String.fromInt e.col
   ++ ": " 
   ++ problemToString e.problem

parseMarkdown : String -> Html msg
parseMarkdown markdownInput =
   let result = markdownInput
         |> Markdown.parse
         |> Result.mapError (\_ -> "Error parsing markdown")
         |> Result.andThen (\ast -> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer ast)
   in

   case result of
      Ok rendered ->
         div [] <| List.map fromUnstyled rendered

      Err error ->
         text error