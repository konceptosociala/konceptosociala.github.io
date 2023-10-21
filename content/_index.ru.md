+++
title = "Ĉefpaĝo"
paginate_by = 3
sort_by = "date"
+++

{{ section(color="#393C44") }}

# Наши проекты
<hr class="big-hr mb-4">
<div class="row mt-3">
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
    {{ 
        project(
            banner="/img/projects/flatbox.jpg"
            title="Flatbox", 
            subtitle="3D игровой движок", 
            description="Написанный на Rust. Он поддерживает PBR-рендеринг, физику, скрипты Lua и характеризуется собственной системой расширений для реализации индивидуальной игровой логики.",
            project_page="software/flatbox",
            page_label="Страница проекта",
            github_page="https://github.com/konceptosociala/flatbox"
        ) 
    }}
    {{ 
        project(
            banner="/img/projects/flatbox_doryen.jpg",
            title="Flatbox Doryen", 
            subtitle="Roguelike игровой фреймворк", 
            description="Высокоуровневый фреймворк для Flatbox, который используется для создания двухмерных roguelike игр, на основе библиотеки doryen.",
            project_page="software/flatbox-doryen",
            page_label="Страница проекта",
            github_page="https://github.com/konceptosociala/flatbox-doryen"
        ) 
    }}
    {{ 
        project(
            banner="/img/projects/socio.svg",
            title="Socio", 
            subtitle="Тема Zola", 
            description="Современная, простая и высоконастраиваемая тема для веб-сайта Koncepto Sociala.",
            project_page="https://konceptosociala.eu.org/socio",
            page_label="Страница проекта",
            github_page="https://github.com/konceptosociala/socio"
        ) 
    }}
</div>

{{ endsection(color="#393C44", type="waves") }}
{{ section(color="#D62941") }}

# Технологии, которые мы используем
<hr class="big-hr">
<div class="row">
     {{
         pill(
             banner="/img/tech/rust.svg",
             title="Rust",
             description="Элегантный функциональный язык программирования, известный своей безопасностью, скоростью и параллельностью.",
             read_more="https://www.rust-lang.org/",
             circle=false
         )
     }}
     {{
         pill(
             banner="/img/tech/lua.svg",
             title="Lua",
             description="Легкий скриптовый язык, используемый для встраивания в приложения; популярный в разработке игр.",
             read_more="https://www.lua.org/",
             circle=false
         )
     }}
     {{
         pill(
             banner="/img/tech/zola.svg",
             title="Zola",
             description="Генератор статических сайтов, написанный на языке Rust, упрощающий создание веб-сайтов с помощью шаблонов и автоматической перезагрузки.",
             read_more="https://www.getzola.org/",
             circle=false
         )
     }}
     {{
         pill(
             banner="/img/tech/md.svg",
             title="Markdown",
             description="Простой язык разметки для легкого форматирования текста, обычно используемый для документации и веб-контента.",
             read_more="https://www.markdownguide.org/",
             circle=false
         )
     }}
</div>

{{ endsection(color="#D62941", type="curve") }}
{{ section(color="#4B1B7F") }}

# Лицензия
<hr class="big-hr">
<p class="lead">Все продукты (игры, программное обеспечение, музыка и т.д.), созданные Koncepto Sociala, лицензируются в соответствии с разрешительной лицензией Unlicense:</p>

<div class="row px-5">
    <div class="col-lg-6 col-md-6 col-sm-12">
        <p class="lead bold">Разрешения:</p>
        <ul>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Коммерческое использование</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Свободное распространение</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Модификация</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Частное пользование</li>
        </ul>
    </div>
    <div class="col-lg-6 col-md-6 col-sm-12">
        <p class="lead bold">Ограничения:</p>
        <ul>
            <li class="license-li"><i class="fa fa-circle text-danger" aria-hidden="true"></i> Никакой ответственности</li>
            <li class="license-li"><i class="fa fa-circle text-danger" aria-hidden="true"></i> Никакой гарантии</li>
        </ul>
    </div>
    <div class="w-100"></div>
    <div class="col-12">
        <hr class="big-hr mx-3">
    </div>
    <div class="w-100"></div>
    <div class="col-lg-7 col-md-12 col-sm-12 mx-auto">
        <div class="text-bg-dark font-monospace rounded mx-auto p-4 lh-base border-dark">
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