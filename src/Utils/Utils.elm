module Utils.Utils exposing (..)

import Html exposing (..)
import Route exposing (Route(..))
import Markdown.Parser as Markdown
import Markdown.Renderer
import Css exposing (..)
import Parser exposing (DeadEnd, Problem)
import Html.Attributes exposing (..)

copyright : String -> Int -> Html msg
copyright name year =
   div 
      [ class "text-center lead text-light mt-5 mb-3" ]
      [ text (name ++ " © " ++ String.fromInt year) ]

homepageLabel : String -> Html msg
homepageLabel title = h1 [ class "text-light mt-5 display-4" ] [ text title ]

subLabel : String -> Html msg
subLabel title = h3 [ class "text-light ms-2 mb-3" ] [ text title ]

newline : Html msg
newline = br [] []

containerFluid : List (Html msg) -> Html msg
containerFluid children =
   div [ class "container-fluid" ] children

icons : List (Html msg) -> Html msg
icons children =
   div 
      [ class "d-flex flex-wrap" 
      , class "justify-content-center"
      , class "justify-content-md-start"
      , class "justify-content-lg-start"
      , class "justify-content-sm-center"
      ] 
      children

icon : String -> String -> Html msg
icon name tooltip =
   i [ class ("devicon devicon-" ++ name), dataTip tooltip ] []

dataTip : String -> Attribute msg
dataTip tip =
   attribute "data-tip" tip

frameborder : Int -> Attribute msg
frameborder n =
   attribute "frameborder" (String.fromInt n)

scrolling : String -> Attribute msg
scrolling value =
   attribute "scrolling" value

navlink : String -> String -> Html msg
navlink label url =
   a [ href url] [ text label ]

navbar : (List (Html msg)) -> Html msg
navbar links =
   div 
      [ class "nbar"
      , class "flex-sm-column" 
      , class "flex-md-row"
      , class "flex-lg-row"
      , class "flex-column"
      ]
      links

alsoTry : String -> String -> Html msg
alsoTry name url =
   i [ class "also-try" ] 
      [ text "also try "
      , a [ href url ] [ text name ]
      ]

pageLayout : Route -> String -> Html msg -> Html msg
pageLayout route title view = 
   row
      [ pageColumn
         [ case route of
            Home -> 
               text ""

            _ -> 
               a 
                  [ href "/"
                  , class "blog-post-link" 
                  , class "no-print"
                  ] 
                  [ text "⟵ Back to Home" ]
         , h1 
            [ class "page-title" ] 
            [ text title ]
         , div 
            [ class "mb-5" ] 
            [view]
         ]
      ]

row : List (Html msg) -> Html msg
row children =
   div [ class "row"] children

pageColumn : List (Html msg) -> Html msg
pageColumn children =
   div 
      [ class "col-lg-8"
      , class "col-11"
      , class "mx-auto"
      , class "mt-5"
      ]
      children

pageTitle : Route -> String
pageTitle page =
   case page of
      Home -> "Home"
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
         div [] rendered

      Err error ->
         text ("Error rendering markdown: " ++ error)