+++
title = "Flatbox: Простота & Rust"
+++

{{ section(color="#3B3B3B") }}

<div class="container row">
    <div class="col-lg-6 col-12 order-lg-1 order-2 ps-lg-5 ps-md-5 pt-3 animate__animated animate__fadeIn">
        <h1 class="display-1 bold">Flatbox: Простота &amp; Rust</h1>
        <h5 class="mb-3 lh-base">Flatbox – ігровий двигун з відкритим початковим кодом, що підтримує PBR рендеринг, скрипти Lua та багато іншого</h5>
        <a class="btn btn-primary m-1" href="https://konceptosociala.eu.org/flatbox"><i class="fa fa-rocket" aria-hidden="true"></i> Почати знайомство</a>
        <a class="btn btn-outline-warning m-1" href="https://docs.rs/despero"><i class="fa fa-book" aria-hidden="true"></i> Документація</a>
        <a class="btn btn-outline-light m-1" href="https://github.com/konceptosociala/flatbox"><i class="fa fa-github" aria-hidden="true"></i> GitHub</a>
    </div>
    <div class="col-lg-6 col-12 order-lg-2 order-1 pt-3 animate__animated animate__fadeIn animate__delay-1s text-center">
        <img src="/img/flatbox_logo.png" class="w-75 p-lg-5 p-3 float-lg-end"/>
    </div>
</div>

{{ endsection(color="#3B3B3B", type="plain") }}
{{ section(color="#FF7B0F") }}

# Особливості
<hr class="big-hr">
<div class="row">
    {{
        pill(
            banner="/img/projects/flatbox/features/pbr.svg",
            title="PBR рендерінг",
            description="Flatbox пропонує сучасний PBR рендерер, написаний за допомогою Vulkan API.",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/physics.svg",
            title="Фізика",
            description="Швидкі 3D фізичні симуляції на основі фізичного двигуна Rapier3D.",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/extension.svg",
            title="Система розширень",
            description="Застосуйте власні розширення до додатку для власного графічного або логічного пайплайну",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/projects/flatbox/features/script.svg",
            title="Скрипти Lua",
            description="Пишіть свої сценарії за допомогою швидкої та елегантної мови Lua",
            circle=false
        )
    }}
</div>
{{ endsection(color="#FF7B0F", type="curve") }}
{{ section(color="#FF9B4E") }}

# Проєкти, створені за допомогою Flatbox
<hr class="big-hr">
<div class="row">
    {{ 
        project(
            banner="/img/projects/komunterio.svg"
            title="Komunterio", 
            subtitle="Відеогра", 
            description="Постапокаліптична антиутопічна гра, заснована на повісті 'Комунтерія'.",
            project_page="games/komunterio",
            github_page="https://github.com/konceptosociala/komunterio"
        ) 
    }}
</div>

{{ endsection(color="#FF9B4E", type="waves") }}