module Page.Projects exposing (..)

import Html exposing (..)
import Utils.Utils exposing (..)

view : Html msg
view =
   row
      [ project 
         "Xast" 
         "The immutable functional ECS programming language made for games." 
         ["Haskell", "Rust"]
         "https://github.com/konceptosociala/xast" 
         "xast"

      , project 
         "Frago" 
         "Mobile application for writing posts for GitHub Pages driven blog." 
         ["Flutter", "Dart"]
         "https://github.com/konceptosociala/frago"
         "frago"

      , project 
         "Wgsldoc" 
         "Documentation generator for WGSL (WebGPU Shading Language) shader modules."
         ["Rust"]
         "https://github.com/konceptosociala/wgsldoc"
         "wgsldoc"
      ]