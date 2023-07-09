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
            banner="https://dummyimage.com/1024x460/000/fff.gif"
            title="Komunterio", 
            subtitle="Videogame", 
            description="Post-apocalyptic dystopian game, based on Komunterio novel.",
            project_page="games/komunterio",
            github_page="https://github.com/konceptosociala/komunterio"
        ) 
    }}
    {{ 
        project(
            banner="img/projects/sonja.svg"
            title="Sonja", 
            subtitle="3D game engine", 
            description="Written in Rust. It supports PBR rendering, physics, Lua scripting and features extension system in order to implement custom game logic.",
            project_page="software/sonja",
            github_page="https://github.com/konceptosociala/sonja"
        ) 
    }}
    {{ 
        project(
            banner="https://dummyimage.com/1024x460/000/fff.gif",
            title="Sonja Doryen", 
            subtitle="Roguelike game framework", 
            description="High-level sonja framework used for making 2D roguelike games, based on doryen library.",
            project_page="software/sonja-doryen",
            github_page="https://github.com/konceptosociala/sonja-doryen"
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

{{ section(color="#A5026D") }}

# Third section

{{ endsection(color="#A5026D", type="plain") }}