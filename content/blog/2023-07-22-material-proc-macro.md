+++
title = "Material derive macro for Flatbox"
+++

The Flatbox crate contains a quite useful `Material` trait that allows the developer to create their own materials based on GLSL shaders. Its approximate implementation for the custom material `MyMaterial` initially looked like this:

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

That is, the developer had to manually create shaders and graphic pipelines for each material, which would be quite inefficient, as it would be necessary to write a large amount of boilerplate and relatively low-level code. Thus, it is appropriate to split `Material` trait into several methods:

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

, where `ShaderInput` will be a data structure that will hold the necessary attributes to create a graphics pipeline:

```rust
pub struct ShaderInput {
    pub attributes: Vec<ShaderInputAttribute>,
    pub instance_size: usize,
    pub topology: ShaderTopology,
}
```

Let's move everything else to the method of binding the custom material to the renderer:

```rust
pub fn bind_material<M: Material + Sync + Send>(&mut self){
    // Checking if the material is already attached
    if self.material_pipelines.contains_key(&TypeId::of::<M>()) {
        log::error!("Material type '{}' is already bound!", std::any::type_name::<M>());
    } else {        
        // Creating shaders, etc.    
        let vertex_shader = vk::ShaderModuleCreateInfo::builder().code(M::vertex());
        let fragment_shader = vk::ShaderModuleCreateInfo::builder().code(M::fragment());
        let shader_input = M::input();
        
        // Creating a pipeline
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

Currently, the implementation of custom materials has become easier, but several problems still remain unsolved:
1. The need to describe each material field (`roughness: f32`, `albedo: u32`, etc.) manually, including field type, size in bytes, and location in the vertex shader;
2. Repetitive using `include_glsl!` macro to compile shaders in `vertex()` and `fragment()` methods.

All these problems can be solved by writing your own `Material` derive macro.

## Macro structue

Let the declaration of our material be like:

```rust
#[repr(C)]
#[derive(Material, Clone, Default, Debug, Serialize, Deserialize)]
pub struct MyMaterial {
    pub color: [f32; 3], // rgb-vector for color
    pub albedo: u32, // texture array index
    pub blank: i32, // just-for-test integer
}
```

The basic functionality of the macro will include the creating input attributes for shaders based on the fields of the material structure, and the compilation of the shaders themselves. For this, we will add `material` attribute, which will include the paths to the vertex and fragment shaders. We will also add an optional parameter `topology` to specify the topology of rendering primitives (a list of triangles, lines, points, etc.), which will be equal to `"triangle_list"` by default:

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

Also it would be nice to add automatic generation of Builder. Let's add parameters `#[color]` for the `color` field and `#[texture]` for the `albedo` field, which will tell the macro to replace the parameters of the builder functions with `Color<f32>` and `AssetHandle<'T'>` respectively. So, the final form of the declaration of our material will be as follows:

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

Now let's go directly to the macro implementation.

## Implementation of Material trait for MyMaterial

First, let's create a new crate `macros` and import the necessary modules into lib.rs, adding main derive function with the attributes material, texture and color:

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

We will also add the `Opts` structure, where the material attributes will be stored:

```rust
#[derive(FromDeriveInput)]
#[darling(attributes(material))]
struct Opts {
    vertex: Option<String>,
    fragment: Option<String>,
    topology: Option<String>,
}
```

Let us get the attributes of the material using `Opts::from_derive_input`; save its identifier in the `ident` variable and the data of the structure in the `data` variable, while restricting the use of the macro on types other than `struct` with the `let ... else` construction:

```rust
let opts = Opts::from_derive_input(&input).expect("Wrong options");
let ident = input.ident;

let Data::Struct(data) = input.data else {
    panic!("Cannot make non-struct type into Material!")
};
```

Initial output of our macro (without builder generating) will look like this:

```rust
let output = quote! {
    #[::flatbox::assets::typetag::serde]
    impl ::flatbox::render::Material for #ident {
        #vertex
        #fragment
        #input
    }
}
```

So, for this, create three variables: vertex, fragment and input, as well as the corresponding functions that will return `TokenStream`:

```rust
let vertex = get_vertex_path(&opts);
let fragment = get_fragment_path(&opts);
let input = get_shader_input(&opts, &data);

...

fn get_vertex_path(opts: &Opts) -> proc_macro2::TokenStream {...}
fn get_fragment_path(opts: &Opts) -> proc_macro2::TokenStream {...}
fn get_shader_input(opts: &Opts, data: &DataStruct) -> proc_macro2::TokenStream {...}
```

With the help of `match` we get the path to the shader from the `vertex` and `fragment` attributes, and use it in another procedural macro `include_glsl!` from the crate [`vk-shader-macros`](https://crates.io/crates/vk-shader-macros):

```rust
fn get_vertex_path(opts: &Opts) -> proc_macro2::TokenStream {
    match &opts.vertex {
        Some(path) => quote! {
            fn vertex() -> &'static [u32] {
                ::flatbox::render::include_glsl!(
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
                ::flatbox::render::include_glsl!(
                    #path, 
                    kind: frag,
                )
            }
        },
        None => panic!("Use proc macro attribute #[material(fragment = \"path\")] to set fragment shader path"),
    }
}
```

The algorithm for generating shader input attributes will be a bit more complicated. To begin with, we need to get the topology of the primitives and the list of formats (types) of the structure fields that will be used by the shader.

```rust
fn get_shader_input(
    opts: &Opts,
    data: &DataStruct,
) -> proc_macro2::TokenStream {
    let topology = ...;
    let format = ...;

    quote! {
        fn input() -> ::flatbox::render::ShaderInput {
            ...
        }
    }
}
```

Get the topology in a way similar to how we got the path to shaders from the `Opts` structure:

```rust
let topology = match &opts.topology {
    Some(topology) => match topology.as_str() { // list all possible Vulkan topologies
        "point_list" => quote! { ::flatbox::render::ShaderTopology::POINT_LIST },
        "line_list" => quote! { ::flatbox::render::ShaderTopology::LINE_LIST },
        "line_strip" => quote! { ::flatbox::render::ShaderTopology::LINE_STRIP },
        "triangle_list" => quote! { ::flatbox::render::ShaderTopology::TRIANGLE_LIST },
        "triangle_strip" => quote! { ::flatbox::render::ShaderTopology::TRIANGLE_STRIP },
        "triangle_fan" => quote! { ::flatbox::render::ShaderTopology::TRIANGLE_FAN },
        "line_list_with_adjacency" => quote! { ::flatbox::render::ShaderTopology::LINE_LIST_WITH_ADJACENCY },
        "line_strip_with_adjacency" => quote! { ::flatbox::render::ShaderTopology::LINE_STRIP_WITH_ADJACENCY },
        "triangle_list_with_adjacency" => quote! { ::flatbox::render::ShaderTopology::TRIANGLE_LIST_WITH_ADJACENCY },
        "triangle_strip_with_adjacency" => quote! { ::flatbox::render::ShaderTopology::TRIANGLE_STRIP_WITH_ADJACENCY },
        _ => panic!("Unsupported topology \"{}\"", topology),
    },
    None => quote! { ::flatbox::render::ShaderTopology::TRIANGLE_LIST }, // if the attribute is missing, then use the list of triangles (rendering of 3D models' faces' surface) by default
};
```

To get a list of field formats, iterate over the `data.fields` structure and return `Map<...>`:

```rust
let format = data.fields.iter().map(|f| {
    let ty = &f.ty;
    match ty {
        ...
    }
});
```

The list of types that can be used as shader input data is quite small: integers, floating-point numbers, and vectors - arrays of type [f32; 2], [f32; 3] and [f32; 4], i.e. several array types and simple types. Let's check the type of the `ty` field to see if it is an array or a regular type, and convert it to a string representation for further matching:

```rust
match ty {
    Type::Array(array) => { // whether array
        match array.into_token_stream().to_string().as_str() { // converting type to string
            "[f32 ; 2]" => quote! { ::flatbox::render::ShaderInputFormat::R32G32_SFLOAT },
            "[f32 ; 3]" => quote! { ::flatbox::render::ShaderInputFormat::R32G32B32_SFLOAT },
            "[f32 ; 4]" => quote! { ::flatbox::render::ShaderInputFormat::R32G32B32A32_SFLOAT },
            "[f32 ; 1]" => quote! { ::flatbox::render::ShaderInputFormat::R32_SFLOAT }, // array of one element is represented as an ordinary `float`
            _ => panic!("Unsupported input format: \"{}\"", array.into_token_stream().to_string().as_str())
        }
    },
    Type::Path(path) => { // whether regular type
        match path.into_token_stream().to_string().as_str() {
            "f32" => quote! { ::flatbox::render::ShaderInputFormat::R32_SFLOAT },
            "u32" => quote! { ::flatbox::render::ShaderInputFormat::R8G8B8A8_UINT },
            "i32" => quote! { ::flatbox::render::ShaderInputFormat::R8G8B8A8_SINT },
            _ => panic!("Unsupported input format: \"{}\"", path.into_token_stream().to_string().as_str())
        }
    },
    _ => panic!("Unsupported input format"), // if the format of the field is different - panic!
}
```

Now consider the `ShaderInput` structure:

```rust
pub struct ShaderInput {
    pub attributes: Vec<ShaderInputAttribute>,
    pub instance_size: usize,
    pub topology: ShaderTopology,
}
```

And also the internal `ShaderInputAttribute` structure:

```rust
pub struct ShaderInputAttribute {
    pub location: u32,
    pub binding: u32,
    pub format: Format,
    pub offset: u32,
}
```

If we have the topology and format of the fields, the `binding` is always constant, then we still need the offset of the input data, its location and the total size in bytes (instance_size). We can get all these values when iterating the field formats:

```rust
quote! {
    fn input() -> ::flatbox::render::ShaderInput {
        let mut location = 3; // location of the first parameter in the shader starting from "0" (the first 3 are occupied by the parameters of the 3D model itself)
        let mut offset = 0; // offset of the first parameter (since the parameter is the first, therefore there is no offset)
        let mut attributes = vec![];
        #(
            attributes.push(
                ::flatbox::render::ShaderInputAttribute{
                    binding: 1,
                    location: location,
                    offset: offset,
                    format: #format,
                }
            );

            offset += match #format { // increase the offset of the next parameter by the size of the current one
                ::flatbox::render::ShaderInputFormat::R8G8B8A8_UINT
                    | ::flatbox::render::ShaderInputFormat::R8G8B8A8_SINT 
                    | ::flatbox::render::ShaderInputFormat::R32_SFLOAT => 4,
                ::flatbox::render::ShaderInputFormat::R32G32_SFLOAT => 8,
                ::flatbox::render::ShaderInputFormat::R32G32B32_SFLOAT => 12,
                ::flatbox::render::ShaderInputFormat::R32G32B32A32_SFLOAT => 16,
                _ => 0,
            };

            location += 1; // increase the location of the next parameter by 1
        )*
        let instance_size = offset as usize; // at the end of the iterations, we set the total size of the data

        ::flatbox::render::ShaderInput {
            attributes,
            instance_size,
            topology: #topology,
        }
    }
}
```

Well, now implementation of `Material` trait for your own type will be much easier. But do not forget about generation of the builder, which can make it even easier to create our custom materials.

## MyMaterialBuilder generating

Let's expand the output of our macro and add an implementation of builder creation:

```rust
let output = quote! {
    #[::flatbox::assets::typetag::serde]
    impl ::flatbox::render::Material for #ident {
        #vertex
        #fragment
        #input
    }

    impl #ident {
        pub fn builder() -> #ident_builder { // add builder initialization function to the material
            #ident_builder::new()
        }
    }

    #[derive(Clone, Default, Debug)]
    pub struct #ident_builder { // generate builder struct
        #(#fields,)*
    }

    impl #ident_builder {
        pub fn new() -> Self { // ...typical init function
            Self::default()
        }

        pub fn build(self) -> #ident { // ...method that creates an instance of a material from builder data
            #ident {
                #(#build_function)*
            }
        }

        #(#functions)* // and add builder configuration functions
    }
};
```

Now let's go seriatim. We need to create a builder ident. It's easy: just add the suffix "Builder" to the identifier of the structure. Let's do this using default `format!` macro:

```rust
let ident_builder = Ident::new(format!("{}Builder", ident.to_string()).as_str(), Span::call_site());
```

Next, we need to copy fields of the structure to the builder in order to use them during its initialization:

```rust
let fields = data.fields.iter().map(|f| {
    let name = &f.ident;
    let ty = &f.ty;

    quote! {
        #name: #ty
    }
});
```

Create functions based on the names of the structure fields (`color()`, `albedo()`, etc.) for the builder configuration:

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

For our convenience, let's create a enum `FieldAttribute`, which will determine which attribute was applied to current field (and whether it was):

```rust
enum FieldAttribute {
    Texture,
    Color,
    None,
}
```

Then we are having:

```rust
let attr = match f.attrs.get(0) {
    Some(attr) => {
        if let Meta::Path(path) = &attr.meta {
            match path.into_token_stream().to_string().as_str() { // again we represent the tokens as a string
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

And now we check the attributes for the precise generation of our function:

```rust
match attr {
    FieldAttribute::Color => quote! {
        pub fn #name(mut self, value: ::flatbox::render::Color<f32>) -> Self { 
            self.#name = value.into();
            self
        }
    },
    FieldAttribute::Texture => quote! {
        pub fn #name(mut self, value: ::flatbox::assets::AssetHandle<'T'>) -> Self { 
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

And finally, for the `build()` function, we will generate the "assignment" of the values of the builder fields to the fields of our new material:

```rust
let build_function = data.fields.iter().map(|f| {
    let name = &f.ident;
    quote! {
        #name: self.#name,
    }
});
```

## Conclusion

So what do we have?

1. Easy creating material field attributes for their use in shaders;
2. Automatic generation of the material builder for its quick initialization.

What else can be done?

As an example, you can add the `#[default = ...]` field attribute, which will set the default field values in the builder when it is created.

You can find the complete macro code [at the link](https://github.com/konceptosociala/flatbox/blob/main/macros/src/lib.rs).