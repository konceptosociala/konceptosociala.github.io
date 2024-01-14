+++
title = "Flatbox: Простота & Rust"
+++

{{ section(color="#3B3B3B") }}

<div class="container row">
     <div class="col-lg-6 col-12 order-lg-1 order-2 ps-lg-5 ps-md-5 pt-3 animate__animated animate__fadeIn">
         <h1 class="display-1 bold">Flatbox: Простота &amp; Rust</h1>
         <h5 class="mb-3 lh-base">Flatbox – игровой движок с открытым исходным кодом, поддерживающий PBR рендеринг, скрипты Lua и многое другое</h5>
         <a class="btn btn-primary m-1" href="https://konceptosociala.eu.org/flatbox"><i class="fa fa-rocket" aria-hidden="true"></i> Начать знакомство</a>
         <a class="btn btn-outline-warning m-1" href="https://docs.rs/despero"><i class="fa fa-book" aria-hidden="true"></i> Документация</a>
         <a class="btn btn-outline-light m-1" href="https://github.com/konceptosociala/flatbox"><i class="fa fa-github" aria-hidden="true"></i> GitHub</a>
     </div>
     <div class="col-lg-6 col-12 order-lg-2 order-1 pt-3 animate__animated animate__fadeIn animate__delay-1s text-center">
         <img src="/img/flatbox_logo.png" class="w-75 p-lg-5 p-3 float-lg-end"/>
     </div>
</div>

{{ endsection(color="#3B3B3B", type="plain") }}
{{ section(color="#FF7B0F") }}

# Особенности
<hr class="big-hr">
<div class="row">
     {{
         pill(
             banner="/img/projects/flatbox/features/pbr.svg",
             title="PBR рендеринг",
             description="Flatbox предлагает современный PBR рендерер, написанный с помощью современного OpenGL.",
             circle=false
         )
     }}
     {{
         pill(
             banner="/img/projects/flatbox/features/physics.svg",
             title="Физика",
             description="Быстрые 3D физические симуляции на основе физического движка Rapier3D.",
             circle=false
         )
     }}
     {{
         pill(
             banner="/img/projects/flatbox/features/extension.svg",
             title="Система расшире ний",
             description="Используйте расширения для приложений для создания собственного графического или логического пайплайна",
             circle=false
         )
     }}
     {{
         pill(
             banner="/img/projects/flatbox/features/script.svg",
             title="Скрипты Lua",
             description="Пишите свои сценарии с помощью быстрого и элегантного языка Lua",
             circle=false
         )
     }}
</div>
{{ endsection(color="#FF7B0F", type="curve") }}
{{ section(color="#FF9B4E") }}

# Проекты, созданные с помощью Flatbox
<hr class="big-hr">
<div class="row">
     {{
         project(
             banner="/img/projects/komunterio.svg"
             title="Komunterio",
             subtitle="Видеоигра",
             description="Постапокалиптическая антиутопическая игра, основанная на повести 'Коммунтерия'.",
             project_page="games/komunterio",
             page_label="Страница проекта",
             github_page="https://github.com/konceptosociala/komunterio"
         )
     }}
</div>

{{ endsection(color="#FF9B4E", type="waves") }}