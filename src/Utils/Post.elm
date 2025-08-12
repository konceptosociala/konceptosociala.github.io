module Utils.Post exposing (..)

import Utils.Date exposing (Date)
import Utils.Date as Date
import Html.Styled exposing (Html)
import Parser exposing (Parser, succeed)
import Parser exposing (keyword, symbol, spaces, (|.), (|=))
import Utils.Utils exposing (parseMarkdown)

type alias Post msg =
   { name : String
   , date : Date
   , content : Html msg
   }

compare : (String, Post msg) -> (String, Post msg) -> Order
compare (_, p1) (_, p2) = Date.compare p1.date p2.date

title : Parser String
title =
   Parser.getChompedString 
      ( Parser.succeed ()
         |. symbol "\""
         |. Parser.chompWhile (\c -> c /= '"')
         |. symbol "\""
      )
      |> Parser.map (\s -> String.dropLeft 1 (String.dropRight 1 s))

parse : Parser (Post msg)
parse =
   succeed Post
      |. keyword "---"     |. spaces
      |. keyword "title"   |. spaces
      |. symbol ":"        |. spaces
      |= title             |. spaces
      |. keyword "date"    |. spaces
      |. symbol ":"        |. spaces
      |= Date.parse        |. spaces
      |. keyword "---"     |. spaces
      |= (Parser.getChompedString (Parser.chompUntilEndOr "\u{0000}#")
         |> Parser.map parseMarkdown)
