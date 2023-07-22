+++
title = "Material derive macro for Sonja"
+++

The Sonja crate contains a quite useful `Material` trait that allows the developer to create their own materials based on GLSL shaders. Its approximate implementation for the custom material `MyMaterial` initially looked like this:

```rust
// Typetag is used to serialize the collection of materials `Vec<Arc<dyn Material>>`
#[typetag::serde]
impl Material for MyMaterial {
    fn pipeline(renderer: &Renderer) -> Pipeline {      
        // Shader input attributes
        let instance_attributes = vec![
            ShaderInputAttribute{
                binding: 1,
                location: 3,
                offset: 0,
                format: ShaderInputFormat::R32G32B32_SFLOAT,
            },
            ShaderInputAttribute{
                binding: 1,
                location: 4,
                offset: 12,
                format: ShaderInputFormat::R8G8B8A8_UINT,
            },
            ...
        ];
        
        // Vertex shader creation
        let vertex_shader = vk::ShaderModuleCreateInfo::builder()
            .code(vk_shader_macros::include_glsl!(
                "./src/shaders/vertex_combined.glsl", 
                kind: vert,
            ));
        
        // Fragment shader creation
        let fragment_shader = vk::ShaderModuleCreateInfo::builder()
            .code(vk_shader_macros::include_glsl!(
                "./src/shaders/fragment_combined.glsl",
                kind: frag,
            ));
        
        // Manual graphics pipeline initialization
        Pipeline::init(
            &renderer,
            &vertex_shader,
            &fragment_shader,
            instance_attributes,
            40,
            ShaderTopology::TRIANGLE_LIST,
        ).expect("Cannot create pipeline")
    }
}
```

That is, the developer had to manually create shaders and graphic pipelines for each material, which would be quite inefficient, as it would be necessary to write a large amount of boilerplate and relatively low-level code. Thus, it is appropriate to split the `Material` trait into several methods:

```rust
#[typetag::serde(tag = "material")]
pub trait Material: AsAny + std::fmt::Debug + Send + Sync {
    fn vertex() -> &'static [u32]
    where 
        Self: Sized;

    fn fragment() -> &'static [u32]
    where 
        Self: Sized;

    fn input() -> ShaderInput
    where 
        Self: Sized;
}
```

, де `ShaderInput` буде структурою даних, що зберігатиме необхідні атрибути для створення графічного пайплайну:

```rust
pub struct ShaderInput {
    pub attributes: Vec<ShaderInputAttribute>,
    pub instance_size: usize,
    pub topology: ShaderTopology,
}
```

Все інше перемістимо до методу прив'язки кастомного матеріалу до рендерера:

```rust
pub fn bind_material<M: Material + Sync + Send>(&mut self){
    // Перевірка чи матеріал вже прив'язаний
    if self.material_pipelines.contains_key(&TypeId::of::<M>()) {
        log::error!("Material type '{}' is already bound!", std::any::type_name::<M>());
    } else {        
        // Створення шейдерів та ін.        
        let vertex_shader = vk::ShaderModuleCreateInfo::builder().code(M::vertex());
        let fragment_shader = vk::ShaderModuleCreateInfo::builder().code(M::fragment());
        let shader_input = M::input();
        
        // Створення пайплайну
        let pipeline = Pipeline::init(
            &self,
            &vertex_shader,
            &fragment_shader,
            &shader_input.attributes,
            shader_input.instance_size,
            shader_input.topology
        ).expect("Cannot create pipeline");

        self.material_pipelines.insert(TypeId::of::<M>(), pipeline);
    }
}
```

Наразі реалізація кастомних матеріалів стала більш простою, проте все ще залишаються невирішеними кілька проблем:
1. Необхідність описувати кожне поле матеріалу (наприклад, `roughness: f32`, `albedo: u32` тощо) вручну, включаючи тип поля, розмір у байтах та положення у вершинному шейдері;
2. Повторюване використання макросу `include_glsl!` для компіляції шейдерів у методах `vertex()` та `fragment()`.

Усі ці проблеми можна вирішити за допомогою написання власного derive-макросу `Material`.

## Структура макросу

Нехай оголошення нашого матеріалу буде таким: 

```rust
#[repr(C)]
#[derive(Material, Clone, Default, Debug, Serialize, Deserialize)]
pub struct MyMaterial {
    pub color: [f32; 3], // rgb-вектор для кольору
    pub albedo: u32, // індекс масиву текстур
    pub blank: i32, // знакове ціле число для тесту
}
```

Базовий функціонал макросу включатиме в себе створення атрибутів вхідних даних шейдерів на основі полів структури матеріалу і компіляцію самих шейдерів. Для цього додамо атрибут `material`, що буде включати шляхи до вершинного (`vertex`) та фрагментного (`fragment`) шейдерів. Також додамо опціональний параметр `topology`, щоб вказати топологію рендерінгу примітивів (список трикутників, ліній, точок тощо), що за замовчуванням буде дорівнювати `"triangle_list"`:

```rust
#[repr(C)]
#[derive(Material, Clone, Default, Debug, Serialize, Deserialize)]
#[material(
    vertex = "examples/shaders/my_material.vs",
    fragment = "examples/shaders/my_material.fs",
)]
pub struct MyMaterial {
    pub color: [f32; 3],
    pub albedo: u32,
    pub blank: i32,
}
```

Ще було б непогано додати автоматичну генерацію білдеру. Додамо параметри `#[color]` для поля `color` і `#[texture]` для поля `albedo`, що будуть вказувати макросу замінити параметри функцій білдеру на `Color<f32>` і `AssetHandle<'T'>` відповідно. Отже, кінцевий вид декларації нашого матеріалу буде таким:

```rust
#[repr(C)]
#[derive(Material, Clone, Default, Debug, Serialize, Deserialize)]
#[material(
    vertex = "examples/shaders/my_material.vs",
    fragment = "examples/shaders/my_material.fs",
)]
pub struct MyMaterial {
    #[color]
    pub color: [f32; 3],
    #[texture]
    pub albedo: u32,
    pub blank: i32,
}
```

Тепер перейдемо безпосередньо до реалізації макросу.

## Імплементація трейту Material для MyMaterial

Спочатку створимо новий крейт `macros` і в lib.rs одразу імпортуємо необхідні модулі та додамо основну derive-функцію з атрибутами material, texture та color:

```rust
use core::panic;

use darling::FromDeriveInput;
use proc_macro::{self, TokenStream};
use proc_macro2::{Ident, Span};
use quote::{quote, ToTokens};
use syn::{parse_macro_input, Data, DeriveInput, Type, Meta, DataStruct, Field};

#[proc_macro_derive(Material, attributes(material, texture, color))]
pub fn derive_material(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as DeriveInput);
    ...
}
```

Також додамо структуру `Opts`, де будуть зберігатися атрибути самого матеріалу:

```rust
#[derive(FromDeriveInput)]
#[darling(attributes(material))]
struct Opts {
    vertex: Option<String>,
    fragment: Option<String>,
    topology: Option<String>,
}
```

Отримаємо атрибути матеріалу за допомогою `Opts::from_derive_input`; збережемо його ідентифіактор у змінній `ident` й дані самої структури у змінній `data`, паралельно обмежуючи використання макроса на типах крім `struct` конструкцією `let ... else`:


```rust
let opts = Opts::from_derive_input(&input).expect("Wrong options");
let ident = input.ident;

let Data::Struct(data) = input.data else {
    panic!("Cannot make non-struct type into Material!")
};
```

Початковий output нашого макросу (без генерації білдера) виглядатиме так:

```rust
let output = quote! {
    #[::sonja::assets::typetag::serde]
    impl ::sonja::render::Material for #ident {
        #vertex
        #fragment
        #input
    }
}
```

Отже, для цього створимо три змінні: vertex, fragment та input, а також відповідні функції, що будуть повертати `TokenStream`:

```rust
let vertex = get_vertex_path(&opts);
let fragment = get_fragment_path(&opts);
let input = get_shader_input(&opts, &data);

...

fn get_vertex_path(opts: &Opts) -> proc_macro2::TokenStream {...}
fn get_fragment_path(opts: &Opts) -> proc_macro2::TokenStream {...}
fn get_shader_input(opts: &Opts, data: &DataStruct) -> proc_macro2::TokenStream {...}
```

За допомогою `match` отримуємо шлях до шейдера з атрибутів vertex та fragment, і використовуємо його в іншому процедурному макросі `include_glsl!` з крейту [`vk-shader-macros`](https://crates.io/crates/vk-shader-macros):

```rust
fn get_vertex_path(opts: &Opts) -> proc_macro2::TokenStream {
    match &opts.vertex {
        Some(path) => quote! {
            fn vertex() -> &'static [u32] {
                ::sonja::render::include_glsl!(
                    #path, 
                    kind: vert,
                )
            }
        },
        None => panic!("Use proc macro attribute #[material(vertex = \"path\")] to set vertex shader path"),
    }
}

fn get_fragment_path(opts: &Opts) -> proc_macro2::TokenStream {
    match &opts.fragment {
        Some(path) => quote! {
            fn fragment() -> &'static [u32] {
                ::sonja::render::include_glsl!(
                    #path, 
                    kind: frag,
                )
            }
        },
        None => panic!("Use proc macro attribute #[material(fragment = \"path\")] to set fragment shader path"),
    }
}
```

Для генерації атрибутів вхідних шейдерних даних алгоритм буде трохи складнішим. Для початку нам потрібно отримати топологію примітивів та перелік форматів (типів) полів структури, які будуть використані шейдером.


```rust
fn get_shader_input(
    opts: &Opts,
    data: &DataStruct,
) -> proc_macro2::TokenStream {
    let topology = ...;
    let format = ...;

    quote! {
        fn input() -> ::sonja::render::ShaderInput {
            ...
        }
    }
}
```

Одержуємо топологію способом аналогічним тому, як ми отримували шлях до шейдерів зі структури `Opts`:


```rust
let topology = match &opts.topology {
    Some(topology) => match topology.as_str() { // робимо перелік усіх можливих топологій Vulkan
        "point_list" => quote! { ::sonja::render::ShaderTopology::POINT_LIST },
        "line_list" => quote! { ::sonja::render::ShaderTopology::LINE_LIST },
        "line_strip" => quote! { ::sonja::render::ShaderTopology::LINE_STRIP },
        "triangle_list" => quote! { ::sonja::render::ShaderTopology::TRIANGLE_LIST },
        "triangle_strip" => quote! { ::sonja::render::ShaderTopology::TRIANGLE_STRIP },
        "triangle_fan" => quote! { ::sonja::render::ShaderTopology::TRIANGLE_FAN },
        "line_list_with_adjacency" => quote! { ::sonja::render::ShaderTopology::LINE_LIST_WITH_ADJACENCY },
        "line_strip_with_adjacency" => quote! { ::sonja::render::ShaderTopology::LINE_STRIP_WITH_ADJACENCY },
        "triangle_list_with_adjacency" => quote! { ::sonja::render::ShaderTopology::TRIANGLE_LIST_WITH_ADJACENCY },
        "triangle_strip_with_adjacency" => quote! { ::sonja::render::ShaderTopology::TRIANGLE_STRIP_WITH_ADJACENCY },
        _ => panic!("Unsupported topology \"{}\"", topology),
    },
    None => quote! { ::sonja::render::ShaderTopology::TRIANGLE_LIST }, // якщо атрибут відсутній, то використовувати список трикутників (рендерінг поверхні граней 3Д-моделей) за замовчуванням
};
```

Щоб отримати перелік форматів полів, проітеруємо структуру `data.fields` та повернемо `Map<...>`:

```rust
let format = data.fields.iter().map(|f| {
    let ty = &f.ty;
    match ty {
        ...
    }
});
```

Список типів, які можуть бути використані як шейдерні вхідна дані, невеликий: цілі числа, числа з рухомою комою та вектори - масиви типу [f32; 2], [f32; 3] та [f32; 4], отже кілька типів масиву та простих типів. Перевіримо тип поля `ty` на те, чи є він масивом або звичайним типом, та конвертуємо його у рядкову репрезентацію для подальшого матчінгу:

```rust
match ty {
    Type::Array(array) => { // чи масив
        match array.into_token_stream().to_string().as_str() { // конвертуємо тип у строку
            "[f32 ; 2]" => quote! { ::sonja::render::ShaderInputFormat::R32G32_SFLOAT },
            "[f32 ; 3]" => quote! { ::sonja::render::ShaderInputFormat::R32G32B32_SFLOAT },
            "[f32 ; 4]" => quote! { ::sonja::render::ShaderInputFormat::R32G32B32A32_SFLOAT },
            "[f32 ; 1]" => quote! { ::sonja::render::ShaderInputFormat::R32_SFLOAT }, // масив з одного елемента представляємо як звичайний `float`
            _ => panic!("Unsupported input format: \"{}\"", array.into_token_stream().to_string().as_str())
        }
    },
    Type::Path(path) => { // чи звичайний тип
        match path.into_token_stream().to_string().as_str() {
            "f32" => quote! { ::sonja::render::ShaderInputFormat::R32_SFLOAT },
            "u32" => quote! { ::sonja::render::ShaderInputFormat::R8G8B8A8_UINT },
            "i32" => quote! { ::sonja::render::ShaderInputFormat::R8G8B8A8_SINT },
            _ => panic!("Unsupported input format: \"{}\"", path.into_token_stream().to_string().as_str())
        }
    },
    _ => panic!("Unsupported input format"), // якщо формат поля інший - панікуємо!
}
```

Тепер розглянемо структуру `ShaderInput`:

```rust
pub struct ShaderInput {
    pub attributes: Vec<ShaderInputAttribute>,
    pub instance_size: usize,
    pub topology: ShaderTopology,
}
```

А також внутрішню структуру `ShaderInputAttribute`:

```rust
pub struct ShaderInputAttribute {
    pub location: u32,
    pub binding: u32,
    pub format: Format,
    pub offset: u32,
}
```

Якщо топологія та формат полів у нас є, `binding` є завжди сталим, то нам все ще потрібен зсув вхідних даних (offset), їх положення (location) та сумарний розмір даних матеріалу (instance_size). Ці всі значення ми можемо отримати вже при ітерації форматів полів:


```rust
quote! {
    fn input() -> ::sonja::render::ShaderInput {
        let mut location = 3; // положення першого параметра в шейдері починаючи з "0" (перші 3 зайняті параметрами самої 3Д-моделі)
        let mut offset = 0; // зсув першого параметра (оскільки параметр перший, отже зсув відсутній)
        let mut attributes = vec![];
        #(
            attributes.push(
                ::sonja::render::ShaderInputAttribute{
                    binding: 1,
                    location: location,
                    offset: offset,
                    format: #format,
                }
            );

            offset += match #format { // збільшуємо зсув наступного параметра на розмір поточного
                ::sonja::render::ShaderInputFormat::R8G8B8A8_UINT
                    | ::sonja::render::ShaderInputFormat::R8G8B8A8_SINT 
                    | ::sonja::render::ShaderInputFormat::R32_SFLOAT => 4,
                ::sonja::render::ShaderInputFormat::R32G32_SFLOAT => 8,
                ::sonja::render::ShaderInputFormat::R32G32B32_SFLOAT => 12,
                ::sonja::render::ShaderInputFormat::R32G32B32A32_SFLOAT => 16,
                _ => 0,
            };

            location += 1; // збільшуємо положення наступного параметра на 1
        )*
        let instance_size = offset as usize; // по завершенню ітерації встановлюємо загальний розмір даних 

        ::sonja::render::ShaderInput {
            attributes,
            instance_size,
            topology: #topology,
        }
    }
}
```

Отже, тепер реалізація трейту `Material` для власного типу буде виконуватися набагато простіше. Але не забуваємо про генерацію білдеру, що може ще більше полегшити створення кастомних матеріалів.

## Генерація MyMaterialBuilder

Розширимо output макросу і додамо реалізацію створення білдеру:

```rust
let output = quote! {
    #[::sonja::assets::typetag::serde]
    impl ::sonja::render::Material for #ident {
        #vertex
        #fragment
        #input
    }

    impl #ident {
        pub fn builder() -> #ident_builder { // додаємо функцію ініціалізації білдера в матеріал
            #ident_builder::new()
        }
    }

    #[derive(Clone, Default, Debug)]
    pub struct #ident_builder { // генеруємо саму структуру білдера
        #(#fields,)*
    }

    impl #ident_builder {
        pub fn new() -> Self { // ...шаблонна функція ініціалізації
            Self::default()
        }

        pub fn build(self) -> #ident { // ...метод, що створює екземпляр матеріалу з даних білдера
            #ident {
                #(#build_function)*
            }
        }

        #(#functions)* // і додаємо функції налаштування білдера
    }
};
```

Тепер йдемо по порядку. Треба створити ідентифікатор білдера. Це робиться просто: всього лиш додаємо суфікс "Builder" до ідентифікатора структури. Зробимо це за допомогою макроса `format!`:


```rust
let ident_builder = Ident::new(format!("{}Builder", ident.to_string()).as_str(), Span::call_site());
```

Далі треба скопіювати поля структури до білдера, щоб потім використовувати їх при його ініціалізації:

```rust
let fields = data.fields.iter().map(|f| {
    let name = &f.ident;
    let ty = &f.ty;

    quote! {
        #name: #ty
    }
});
```

Створимо функції за назвами полів структури (`color()`, `albedo()` тощо) для конфігурації білдера:

```rust
let functions = data.fields.iter().map(|f| {
    let name = &f.ident;
    let ty = &f.ty;
    let attr = match f.attrs.get(0) {
        Some(attr) => {
            ...
        },
        None => FieldAttribute::None,
    };

    ...
});
```

Давайте для зручності створимо перелік `FieldAttribute`, що визначатиме, який атрибут був застосований до даного поля (і чи був взагалі):

```rust
enum FieldAttribute {
    Texture,
    Color,
    None,
}
```

Тоді маємо:

```rust
let attr = match f.attrs.get(0) {
    Some(attr) => {
        if let Meta::Path(path) = &attr.meta {
            match path.into_token_stream().to_string().as_str() { // знову репрезентуємо токени як рядок тексту
                "color" => FieldAttribute::Color,
                "texture" => FieldAttribute::Texture,
                _ => panic!("Invalid field attribute: \"{}\"", attr.into_token_stream().to_string().as_str()),
            }
        } else {
            panic!("Invalid field attribute: \"{}\"", attr.into_token_stream().to_string().as_str());
        }
    },
    None => FieldAttribute::None,
    
    ...
};
```

А тепер перевіряємо атрибути для коректної генерації нашої функції:

```rust
match attr {
    FieldAttribute::Color => quote! {
        pub fn #name(mut self, value: ::sonja::render::Color<f32>) -> Self { 
            self.#name = value.into();
            self
        }
    },
    FieldAttribute::Texture => quote! {
        pub fn #name(mut self, value: ::sonja::assets::AssetHandle<'T'>) -> Self { 
            self.#name = value.into();
            self
        }
    },
    _ => quote! {
        pub fn #name(mut self, value: #ty) -> Self { 
            self.#name = value;
            self
        }
    },
}
```

І нарешті для функції `build()` згенеруємо "присвоєння" полям нового матеріалу значень полів білдера:

```rust
let build_function = data.fields.iter().map(|f| {
    let name = &f.ident;
    quote! {
        #name: self.#name,
    }
});
```

## Заключення

Таким чином, що ми маємо?

1. Створення атрибутів полів матеріалу для їх використання у шейдерах;
2. Автоматична генерація білдеру матеріалу для його швидкої ініціалізації.

Що можна ще зробити?

Як приклад, можна додати атрибут поля `#[default = ...]`, що буде задавати стандартні значення полів у білдері під час його створення.

Повний код макросу ви можете знайти [за посиланням](https://github.com/konceptosociala/sonja/blob/main/macros/src/lib.rs).