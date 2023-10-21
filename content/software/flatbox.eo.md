+++
title = "Flatbox: Simpleco & Rust"
+++

{{ section(color="#3B3B3B") }}

<div class="container row">
    <div class="col-lg-6 col-12 order-lg-1 order-2 ps-lg-5 ps-md-5 pt-3 animate__animated animate__fadeIn">
        <h1 class="display-1 bold">Flatbox: Simpleco &amp; Rust</h1>
        <h5 class="mb-3 lh-base">Flatbox – malfermfonta ludmotoro kiu subtenas PBR-bildigon, Lua-skriptojn, kaj plu pli</h5>
        <a class="btn btn-primary m-1" href="https://konceptosociala.eu.org/flatbox"><i class="fa fa-rocket" aria-hidden="true"></i> Komencu konadon</a>
        <a class="btn btn-outline-warning m-1" href="https://docs.rs/despero"><i class="fa fa-book" aria-hidden="true"></i> Dokumentado</a>
        <a class="btn btn-outline-light m-1" href="https://github.com/konceptosociala/flatbox"><i class="fa fa-github" aria-hidden="true"></i> GitHub</a>
    </div>
    <div class="col-lg-6 col-12 order-lg-2 order-1 pt-3 animate__animated animate__fadeIn animate__delay-1s text-center">
        <img src="/img/flatbox_logo.png" class="w-75 p-lg-5 p-3 float-lg-end"/>
    </div>
</div>

{{ endsection(color="#3B3B3B", type="plain") }}
{{ section(color="#FF7B0F") }}

# Trajtoj
<hr class="big-hr">
<div class="row">
    {{
        pill(
            banner="/img/projects/flatbox/features/pbr.svg",
            title="PBR-bildigo",
            description="Flatbox proponas modernan PBR-bildigilon skribitan per moderna OpenGL.",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/physics.svg",
            title="Fiziko",
            description="Rapidaj 3D-fizikaj simuladoj bazitaj sur la fizika motoro Rapier3D.",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/extension.svg",
            title="Etendaĵa Sistemo",
            description="Apliku viajn proprajn etendaĵojn al la aplikaĵo por via propra grafika aŭ logika pajplajno",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/script.svg",
            title="Lua-Skriptoj",
            description="Skribu viajn skriptojn uzante la rapidan kaj elegantan Lua-lingvon",
            circle=false
        )
    }}
</div>
{{ endsection(color="#FF7B0F", type="curve") }}
{{ section(color="#FF9B4E") }}

# Projektoj, kreitaj per Flatbox
<hr class="big-hr">
<div class="row">
    {{ 
        project(
            banner="/img/projects/komunterio.svg"
            title="Komunterio", 
            subtitle="Videoludo", 
            description="Post-apokalipsa distopia ludo bazita sur la rakonto 'Komunterio'.",
            project_page="games/komunterio",
            page_label="Projekta paĝo",
            github_page="https://github.com/konceptosociala/komunterio"
        ) 
    }}
</div>

{{ endsection(color="#FF9B4E", type="waves") }}