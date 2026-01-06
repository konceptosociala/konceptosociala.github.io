module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Utils.Utils exposing (..)

view : Int -> Html msg
view year = div []
   [ alsoTry "jujumba.cc" "https://jujumba.cc/"
   , navbar
      [ navlink "Blog"        "blog"
      , navlink "Projects"    "projects"
      , navlink "GitHub"      "https://github.com/konceptosociala/"
      , navlink "SoundCloud"  "https://soundcloud.com/janesnote"
      ]
   , containerFluid
      [ homepageLabel "My favorite programming languages"
      , newline
      , icons
         [ icon "haskell-plain"  "Haskell"
         , icon "rust-plain"     "Rust"
         , icon "elm-plain"      "Elm"
         , icon "csharp-plain"   "C#"
         , icon "dart-plain"     "Dart"
         , icon "java-plain"     "Java"
         ]
      , homepageLabel "Technologies I use"
      , newline
      , subLabel "Frontend Development:"
      , icons
         [ icon "flutter-plain"    "Flutter"
         , icon "elm-plain"        "Elm"
         , icon "bootstrap-plain"  "Bootstrap"
         , icon "css3-plain"       "CSS3"
         ]
      , subLabel "Game Development & Graphics:"
      , icons
         [ icon "godot-plain"       "Godot"
         , icon "bevyengine-plain"  "Bevy"
         , icon "webgpu-plain"      "WGPU"
         , icon "libgdx-plain"      "LibGDX"
         , icon "opengl-plain"      "OpenGL"
         ]
      , subLabel "Other Tools:"
      , icons
         [ icon "linux-plain"       "GNU/Linux"
         , icon "blender-original"  "Blender"
         , icon "git-plain"         "Git"
         , icon "latex-plain"       "LaTeX"
         ]
      , copyright "Koncepto Sociala" year
      ]
   ]