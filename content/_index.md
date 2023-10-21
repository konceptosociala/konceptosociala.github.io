+++
title = "Homepage"
paginate_by = 3
sort_by = "date"
+++

{{ section(color="#393C44") }}

# Our projects
<hr class="big-hr mb-4">
<div class="row mt-3">
    {{ 
        project(
            banner="/img/projects/komunterio.svg"
            title="Komunterio", 
            subtitle="Videogame", 
            description="Post-apocalyptic dystopian game, based on Komunterio novel.",
            project_page="games/komunterio",
            page_label="Project page",
            github_page="https://github.com/konceptosociala/komunterio"
        ) 
    }}
    {{ 
        project(
            banner="img/projects/flatbox.jpg"
            title="Flatbox", 
            subtitle="3D game engine", 
            description="Written in Rust. It supports PBR rendering, physics, Lua scripting and features extension system in order to implement custom game logic.",
            project_page="software/flatbox",
            page_label="Project page",
            github_page="https://github.com/konceptosociala/flatbox"
        ) 
    }}
    {{ 
        project(
            banner="img/projects/flatbox_doryen.jpg",
            title="Flatbox Doryen", 
            subtitle="Roguelike game framework", 
            description="High-level Flatbox framework used for making 2D roguelike games, based on doryen library.",
            project_page="software/flatbox-doryen",
            page_label="Project page",
            github_page="https://github.com/konceptosociala/flatbox-doryen"
        ) 
    }}
    {{ 
        project(
            banner="img/projects/socio.svg",
            title="Socio", 
            subtitle="Zola Theme", 
            description="Modern, simple & highly configurable theme for Koncepto Sociala website.",
            project_page="https://konceptosociala.eu.org/socio",
            page_label="Project page",
            github_page="https://github.com/konceptosociala/socio"
        ) 
    }}
</div>

{{ endsection(color="#393C44", type="waves") }}
{{ section(color="#D62941") }}

# Technologies we use
<hr class="big-hr">
<div class="row">
    {{
        pill(
            banner="img/tech/rust.svg",
            title="Rust",
            description="Fancy functional programming language known for safety, speed, and concurrency.",
            read_more="https://www.rust-lang.org/",
            circle=false
        )
    }}
    {{
        pill(
            banner="img/tech/lua.svg",
            title="Lua",
            description="Lightweight scripting language used for embedding in applications, popular in game development.",
            read_more="https://www.lua.org/",
            circle=false
        )
    }}
    {{
        pill(
            banner="img/tech/zola.svg",
            title="Zola",
            description="Static site generator built in Rust, simplifying website creation with templates and automatic reloading.",
            read_more="https://www.getzola.org/",
            circle=false
        )
    }}
    {{
        pill(
            banner="img/tech/md.svg",
            title="Markdown",
            description="Simple markup language for easy formatting of plain text, commonly used for documentation and web content.",
            read_more="https://www.markdownguide.org/",
            circle=false
        )
    }}
</div>

{{ endsection(color="#D62941", type="curve") }}
{{ section(color="#4B1B7F") }}

# License
<hr class="big-hr">
<p class="lead">All products (games, software, music etc.) created by Koncepto Sociala are licensed under permissive Unlicense license:</p>

<div class="row px-5">
    <div class="col-lg-6 col-md-6 col-sm-12">
        <p class="lead bold">Permissions:</p>
        <ul>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Commercial use</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Distribution</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Modification</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Private use</li>
        </ul>
    </div>
    <div class="col-lg-6 col-md-6 col-sm-12">
        <p class="lead bold">Limitations:</p>
        <ul>
            <li class="license-li"><i class="fa fa-circle text-danger" aria-hidden="true"></i> No liability</li>
            <li class="license-li"><i class="fa fa-circle text-danger" aria-hidden="true"></i> No warranty</li>
        </ul>
    </div>
    <div class="w-100"></div>
    <div class="col-12">
        <hr class="big-hr mx-3">
    </div>
    <div class="w-100"></div>
    <div class="col-lg-7 col-md-12 col-sm-12 mx-auto">
        <div class="text-bg-dark font-monospace rounded mx-auto p-4 lh-base">
            This is free and unencumbered software released into the public domain.
            <br><br>
            Anyone is free to copy, modify, publish, use, compile, sell, or
            distribute this software, either in source code form or as a compiled
            binary, for any purpose, commercial or non-commercial, and by any
            means.
            <br><br>
            In jurisdictions that recognize copyright laws, the author or authors
            of this software dedicate any and all copyright interest in the
            software to the public domain. We make this dedication for the benefit
            of the public at large and to the detriment of our heirs and
            successors. We intend this dedication to be an overt act of
            relinquishment in perpetuity of all present and future rights to this
            software under copyright law.
            <br><br>
            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
            EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
            MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
            IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
            OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
            ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
            OTHER DEALINGS IN THE SOFTWARE.
            <br><br>
            For more information, please refer to &lt;<a class="font-monospace" href="https://konceptosociala.eu.org/unlicense">https://unlicense.org</a>&gt;
        </div>
    </div>
</div>

{{ endsection(color="#4B1B7F", type="plain") }}

<style>
    .license-li::marker {
        content: '';
    }
</style>