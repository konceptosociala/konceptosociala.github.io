+++
title = "Flatbox: Simplicity & Rust"
+++

{{ section(color="#3B3B3B") }}

<div class="container row">
    <div class="col-lg-6 col-12 order-lg-1 order-2 ps-lg-5 ps-md-5 pt-3 animate__animated animate__fadeIn">
        <h1 class="display-1 bold">Flatbox: Simplicity &amp; Rust</h1>
        <h5 class="mb-3 lh-base">Flatbox is an open source engine, which supports PBR rendering, physics, Lua scripting and much more</h5>
        <a class="btn btn-primary m-1" href="https://konceptosociala.eu.org/flatbox"><i class="fa fa-rocket" aria-hidden="true"></i> Get started</a>
        <a class="btn btn-outline-warning m-1" href="https://docs.rs/despero"><i class="fa fa-book" aria-hidden="true"></i> Documentation</a>
        <a class="btn btn-outline-light m-1" href="https://github.com/konceptosociala/flatbox"><i class="fa fa-github" aria-hidden="true"></i> GitHub</a>
    </div>
    <div class="col-lg-6 col-12 order-lg-2 order-1 pt-3 animate__animated animate__fadeIn animate__delay-1s text-center">
        <img src="/img/flatbox_logo.png" class="w-75 p-lg-5 p-3 float-lg-end"/>
    </div>
</div>

{{ endsection(color="#3B3B3B", type="plain") }}
{{ section(color="#FF7B0F") }}

# Features
<hr class="big-hr">
<div class="row">
    {{
        pill(
            banner="/img/projects/flatbox/features/pbr.svg",
            title="PBR rendering",
            description="Flatbox provides modern PBR renderer written with modern OpenGL.",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/physics.svg",
            title="Physics",
            description="Fast 3D physics simulations driven by Rapier3D physics engine.",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/extension.svg",
            title="Extension system",
            description="Apply custom extensions to the application for custom rendering or logic pipeline",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/script.svg",
            title="Lua scripting",
            description="Write your runtime scripts with fast and elegant Lua language",
            circle=false
        )
    }}
</div>
{{ endsection(color="#FF7B0F", type="curve") }}
{{ section(color="#FF9B4E") }}

# Projects made with Flatbox
<hr class="big-hr">
<div class="row">
    {{ 
        project(
            banner="/img/projects/komunterio.svg"
            title="Komunterio", 
            subtitle="Videogame", 
            description="Post-apocalyptic dystopian game, based on Komunterio novel.",
            project_page="/games/komunterio",
            page_label="Project page",
            github_page="https://github.com/konceptosociala/komunterio"
        ) 
    }}
</div>

{{ endsection(color="#FF9B4E", type="waves") }}