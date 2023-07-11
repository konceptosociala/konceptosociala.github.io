+++
title = "Головна"
paginate_by = 3
sort_by = "date"
+++

{{ section(color="#393C44") }}

# Наші проєкти
<hr class="big-hr mb-4">
<div class="row mt-3">
    {{ 
        project(
            banner="https://dummyimage.com/1024x460/000/fff.gif"
            title="Komunterio", 
            subtitle="Відеогра", 
            description="Постапокаліптична антиутопічна гра, заснована на повісті 'Комунтерія'.",
            project_page="ua/games/komunterio",
            github_page="https://github.com/konceptosociala/komunterio"
        ) 
    }}
    {{ 
        project(
            banner="/img/projects/sonja.svg"
            title="Sonja", 
            subtitle="3D ігровий двигун", 
            description="Написаний на Rust. Він підтримує PBR-рендеринг, фізику, скрипти Lua та характеризується власною системою розширень для реалізації індивідуальної ігрової логіки.",
            project_page="ua/software/sonja",
            github_page="https://github.com/konceptosociala/sonja"
        ) 
    }}
    {{ 
        project(
            banner="/img/projects/sonja_doryen.svg",
            title="Sonja Doryen", 
            subtitle="Roguelike ігровий фреймворк", 
            description="Високорівневий фреймворк для sonja, що використовується для створення двовимірних roguelike ігор, на основі бібліотеки doryen.",
            project_page="ua/software/sonja-doryen",
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

{{ section(color="#A5026D") }}

# Third section

{{ endsection(color="#A5026D", type="plain") }}