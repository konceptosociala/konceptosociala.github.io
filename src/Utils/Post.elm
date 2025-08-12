module Utils.Post exposing (..)

import Utils.Date exposing (Date)
import Utils.Date as Date
import Html exposing (Html)
import Parser exposing (Parser, succeed)
import Parser exposing (keyword, symbol, spaces, (|.), (|=))
import Utils.Utils exposing (parseMarkdown)
import Json.Decode as D

type alias PostData =
   { title : String
   , date : Date
   , link : String
   }

postListDecoder : D.Decoder (List PostData)
postListDecoder =
   D.list postDataDecoder

postDataDecoder : D.Decoder PostData
postDataDecoder =
   D.map3 PostData
      (D.field "title" D.string)
      (D.field "date" Date.decoder)
      (D.field "link" D.string)

type alias Post msg =
   { name : String
   , date : Date
   , content : Html msg
   }

comparePostDataDesc : PostData -> PostData -> Order
comparePostDataDesc p1 p2 =
   Date.compare p2.date p1.date 

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
