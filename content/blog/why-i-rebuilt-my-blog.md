+++
title = "What I have made during the summer"
date = 2026-07-12
description = "Rust, Vala, Java, Kotlin and Haskell projects: ..."

[taxonomies]
tags = ["devlog"]

[extra]
read_time = 4
+++

**Xide (Java, Kotlin)**: I've decided to replace RSyntaxTextArea completely (it takes much more time, but I guess it worth it), because it was primarily developed for conservative old school IDEs like eclipse, not really suitable for LSPs or tree sitter, so I am making editor from scratch, using Piece Table optimization. The next step will be text selection and syntax highlighting. I also added Kotlin support to my project and now all the plugins are or will be written in Kotlin. I am also still fighting with the style, I think that the previous version is too dark for every monitor, so I am sticking to GitHub Dark FlatLaf theme, looks nice (but not for ever :))

**XastC (Haskell)**: Xast programming language compiler, now I am on semantic analysis stage – name resolution, import resolution, Hindley Milner type inference are implemented almost, but the hardest part is going further – many optimizations (CoW, unique types, compile time expressions, and so on, and so on....) as well as desugaring and maybe even more syntax sugar to make the language usable for big projects. Semantics are still in development.

**XastGE (Rust)**: I fully replaced my half-OOP libGDX-like architecture with World storage, with fully ECS based approach - Flecs modules, systems and sometimes compiled queries. I also added simple UI (text rendering with automatic layout and tweening hover animations) and C Flecs shared .so plugins support, so I could later write my game logic in Xast, compiling it to C and using it as plugins for my engine. Now it is being developed and scaled much more naturally and easily!

**Carol (former Java, now Vala)**: Yes, it is really strange idea to fully migrate from feature rich and big ecosystem language like Java, with libGDX framework to a language, which was made for GTK (Linux GUI toolkit) apps and has literally no game engines and frameworks... But it is really fun, because this language looks a lot like Java/C#, but is compiled to C, so, without GC (but sometimes with reference counting), VM, very fast compilation and near C performance. And it just looks fun. And also libGDX just broke my X11 WM because of, idk really what, but maybe old LWJGL version, used because of Nifty GUI (cool lib though). But nevertheless, I am not sure, when I'll continue developing this concrete game (I almost fully transferred it from Java to Vala), because I don't really know, what it must become, and what the story should be about, so... We'll see :)
