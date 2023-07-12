+++
title = "Головна"
paginate_by = 3
sort_by = "date"
+++

<style>
    .license-li::marker {
        content: '';
    }
</style>

{{ section(color="#393C44") }}

# Наші проєкти
<hr class="big-hr mb-4">
<div class="row mt-3">
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
    {{ 
        project(
            banner="/img/projects/sonja.svg"
            title="Sonja", 
            subtitle="3D ігровий двигун", 
            description="Написаний на Rust. Він підтримує PBR-рендеринг, фізику, скрипти Lua та характеризується власною системою розширень для реалізації індивідуальної ігрової логіки.",
            project_page="software/sonja",
            github_page="https://github.com/konceptosociala/sonja"
        ) 
    }}
    {{ 
        project(
            banner="/img/projects/sonja_doryen.svg",
            title="Sonja Doryen", 
            subtitle="Roguelike ігровий фреймворк", 
            description="Високорівневий фреймворк для Sonja, що використовується для створення двовимірних roguelike ігор, на основі бібліотеки doryen.",
            project_page="software/sonja-doryen",
            github_page="https://github.com/konceptosociala/sonja-doryen"
        ) 
    }}
    {{ 
        project(
            banner="/img/projects/socio.svg",
            title="Socio", 
            subtitle="Тема Zola", 
            description="Сучасна, проста та високоналаштовувана тема для веб-сайту Koncepto Sociala.",
            project_page="https://konceptosociala.eu.org/socio",
            github_page="https://github.com/konceptosociala/socio"
        ) 
    }}
</div>

{{ endsection(color="#393C44", type="waves") }}
{{ section(color="#D62941") }}

# Технології, що ми використовуємо
<hr class="big-hr">
<div class="row">
    {{
        pill(
            banner="/img/tech/rust.svg",
            title="Rust",
            description="Файна функціональна мова програмування, відома своєю безпекою, швидкістю та паралельністю.",
            read_more="https://www.rust-lang.org/",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/tech/lua.svg",
            title="Lua",
            description="Легка скриптова мова, яка використовується для вбудовування у додатки; популярна у розробці ігор.",
            read_more="https://www.lua.org/",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/tech/zola.svg",
            title="Zola",
            description="Генератор статичних сайтів, написаний мовою Rust, що спрощує створення веб-сайтів за допомогою шаблонів і автоматичного перезавантаження.",
            read_more="https://www.getzola.org/",
            circle=false
        )
    }}
    {{
        pill(
            banner="/img/tech/md.svg",
            title="Markdown",
            description="Проста мова розмітки для легкого форматування тексту, яка зазвичай використовується для документації та веб-контенту.",
            read_more="https://www.markdownguide.org/",
            circle=false
        )
    }}
</div>

{{ endsection(color="#D62941", type="curve") }}
{{ section(color="#4B1B7F") }}

# Ліцензія
<hr class="big-hr">
<p class="lead">Усі продукти (ігри, програмне забезпечення, музика тощо), створені Koncepto Sociala, ліцензуються згідно з дозвільною ліцензією Unlicense:</p>

<div class="row px-5">
    <div class="col-lg-6 col-md-6 col-sm-12">
        <p class="lead bold">Дозволи:</p>
        <ul>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Комерційне використання</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Вільне поширення</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Модифікація</li>
            <li class="license-li"><i class="fa fa-circle text-success" aria-hidden="true"></i> Приватне користування</li>
        </ul>
    </div>
    <div class="col-lg-6 col-md-6 col-sm-12">
        <p class="lead bold">Обмеження:</p>
        <ul>
            <li class="license-li"><i class="fa fa-circle text-danger" aria-hidden="true"></i> Жодної відповідальності</li>
            <li class="license-li"><i class="fa fa-circle text-danger" aria-hidden="true"></i> Жодної гарантії</li>
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
            For more information, please refer to &lt;<a class="font-monospace" href="https://unlicense.org">https://unlicense.org</a>&gt;
        </div>
    </div>
</div>

{{ endsection(color="#4B1B7F", type="plain") }}