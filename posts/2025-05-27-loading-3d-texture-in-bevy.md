---
layout: post
title: 'Loading 3D texture in Bevy'
permalink: /blog/loading-3d-texture-in-bevy
---

To load an image into our app Bevy provides us with a custom `Image` type. However, `AssetServer`
in Bevy (as of version 0.15) only supports 2D image loading for now, so we need to perhaps
implement a custom 3D image asset loader. For our tutorial we will use `png` and `jpeg` raster image
types, but you can also try to implement importing of raw MagicaVoxel data, e.g. using `dot_vox` crate.

### Implementing Image3dLoader

First, we'll define our voxel texture format, Bevy plugin and loader struct itself:

```rust
// RGB for color, A - 1 for `active`, 0 for `inactive`.
//
// As optimization in ray tracing you can consider using 1 byte
// texture format like R8Uint and use 0 value for `inactive` 
// and 1-255 values as color palette indices.
pub const IMAGE_3D_FORMAT: TextureFormat = TextureFormat::Rgba8Uint;

pub struct Image3dPlugin;

// Use a plugin to register our asset loader
impl Plugin for Image3dPlugin {
    fn build(&self, app: &mut App) {
        app.init_asset_loader::<Image3dLoader>();
    }
}

#[derive(Default)]
pub struct Image3dLoader;
```

To store a 3D image in 2D `png` and `jpeg` formats, we will store our Z coordinate as layers,
aligned by columns and rows like this:

| ![slice](/assets/blog/voxel-ray-tracing/slice.jpg) | 
|:--:| 
| 15x3 image slice | 

So our loader settings will look like this:

```rust
#[derive(Serialize, Deserialize, Debug)]
pub struct Image3dLoaderSettings {
    pub format: ImageFormatSetting,
    pub columns: u32,
    pub rows: u32,
}
```

It's important to note, that Bevy `AssetServer` supports only 1 loader per file extension
(or a bundle of extensions), but we need to use `png` and `jpeg` formats, which are already
bound by default loader. The easiest approach is to add an extension prefix, e.g. `.3d`.

We'd also like to define image column and row count in a filename for quick import, like 
(NxM). So our filename template will be: `<image_name>.(<N>x<M>).3d.png`. Now getting our loading
settings from a file path is straightforward:

```rust
impl Image3dLoaderSettings {
    pub fn from_path(path: impl AsRef<Path>) -> Result<Self, Image3dLoaderError> {
        // get "<image_name>.(<N>x<M>).3d" part from path
        let stem = format!("{:?}", path.as_ref().file_stem().unwrap_or_default());
        
        Image3dLoaderSettings::from_str(&stem)
    }
}

// And implement `from_str`
impl FromStr for Image3dLoaderSettings {
    type Err = Image3dLoaderError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let cols_rows = s
            // "(<cols>x<rows>)"
            .trim_matches('"')
            .trim_end_matches(".3d")
            .split('.')
            .next_back()
            .ok_or(Image3dLoaderError::FromStrError(s.to_owned()))?
            // "<cols>x<rows>"
            .trim_start_matches('(')
            .trim_end_matches(')')
            // ("<cols>", "<rows>")
            .split_once("x")
            .ok_or(Image3dLoaderError::FromStrError(s.to_owned()))?;

        let columns = cols_rows.0.parse::<u32>()
            .map_err(|_| Image3dLoaderError::FromStrError(s.to_owned()))?;

        let rows = cols_rows.1.parse::<u32>()
            .map_err(|_| Image3dLoaderError::FromStrError(s.to_owned()))?;

        Ok(Image3dLoaderSettings {
            columns,
            rows,
            ..Default::default()
        })
    }
}
```

The last thing to consider before implementing `Image3dLoader` is a custom
error type which will handle all possible problems while loading our 3D image.
We'll use `thiserror` crate for simplicity:

```rust
#[non_exhaustive]
#[derive(Debug, Error)]
pub enum Image3dLoaderError {
    #[error("Invalid columns number: {0}")]
    InvalidColumnsNumber(u32),
    #[error("Invalid rows number: {0}")]
    InvalidRowsNumber(u32),
    #[error("Guessed format is unknown and cannot be determined")]
    UnknownFormat,
    #[error("Unsupported native format: {0:?}")]
    InvalidNativeFormat(bevy::image::ImageFormat),
    #[error("Invalid extension: {0:?}")]
    InvalidExtension(Option<OsString>),
    #[error("Cannot load 3D image: {0}")]
    ImageError(#[from] image::ImageError),
    #[error("I/O error: {0} ({0:?})")]
    IoError(#[from] io::Error),
    #[error("Cannot convert path to 3D image settings: invalid string format {0}; expected <name>.(<columns>x<rows>).3d")]
    FromStrError(String),
}
```

Finally, fill our `AssetLoader` trait implementation with required types and functions:

```rust
impl AssetLoader for Image3dLoader {
    type Asset = Image;
    type Settings = Option<Image3dLoaderSettings>;
    type Error = Image3dLoaderError;

    fn extensions(&self) -> &[&str] { 
        &[
            "3d.png",
            "3d.jpg",
            "3d.jpeg",
            // Other image types if needed
        ]
    }

    async fn load(
        &self,
        reader: &mut dyn Reader,
        settings: &Self::Settings,
        load_context: &mut LoadContext<'_>,
    ) -> Result<Self::Asset, Self::Error> {
        // implementation later
    }
}
```

At first place, retrieve all loader settings:

```rust
use ImageFormatSetting::*;

// If settings are not provided, retrieve them from our file path
let settings = match settings {
    Some(s) => s.clone(),
    None => Image3dLoaderSettings::from_path(load_context.path())?,
};

// Check whether our row and column count is correct
if settings.columns == 0 {
    return Err(Image3dLoaderError::InvalidColumnsNumber(settings.columns));
}

if settings.rows == 0 {
    return Err(Image3dLoaderError::InvalidRowsNumber(settings.rows));
}

// Read asset file to `Vec`
let mut bytes = vec![];
reader.read_to_end(&mut bytes).await?;

let ext = load_context.path()
    .extension()
    .map(|ext| ext.to_owned())
    .ok_or(Image3dLoaderError::InvalidExtension(None))?;

// Get image format to load: by extension, manually or by `magic guessing`
let format = match settings.format {
    FromExtension => ImageFormat::from_extension(ext.clone())
        .ok_or(Image3dLoaderError::InvalidExtension(Some(ext)))?,

    Format(f) => f
        .as_image_crate_format()
        .ok_or(Image3dLoaderError::InvalidNativeFormat(f))?,

    Guess => image::guess_format(&bytes)
        .map_err(|_| Image3dLoaderError::UnknownFormat)?,
};
```

Now we need to store our 3D data, retrieved from row-column aligned 2D image, to 1d bytes array,
because all data is transfered to GPU bit-by-bit. This may sound complicated, but we can calculate each
next pixel, pushed to 1d array, with a following simple formula:

$$ P(x, y, c, r) = \begin{pmatrix}
x + c \times w \\ y + r \times h
\end{pmatrix}, $$ 

where `c` and `r` are current column and row accordingly, `x` and `y` are current tile coordinates and
`w` and `h` are single tile width and height. The algorithm will look like this:

```rust
// Load image with `image` crate using previously determined format
let img = image::load_from_memory_with_format(&bytes, format)?
    .to_rgba8();

let bw = img.width();
let bh = img.height();
// Calculate single tile dimensions using previously determined
// column and row size
let w = bw / settings.columns;
let h = bh / settings.rows;

let mut data = vec![];

// Calculate each next pixel position
for r in 0..settings.rows {
    for c in 0..settings.columns {
        for y in 0..h {
            for x in 0..w {
                let pixel = img.get_pixel(x + c * w, y + r * h);
                data.extend(pixel.0);
            }
        }
    }
}
```

And finally we create an `Image` instance using a GPU texture descriptor:

```rust
// Define image dimensions
let size = Extent3d {
    width: w,
    height: h,
    depth_or_array_layers: settings.columns * settings.rows,
};

let img = Image {
    texture_descriptor: TextureDescriptor { 
        label: Some("image 3d"), 
        size, 
        // Change it, if you need mip-map optimizations
        mip_level_count: 1,
        sample_count: 1,
        dimension: TextureDimension::D3,
        format: IMAGE_3D_FORMAT, 
        // Add other usages if needed
        usage: TextureUsages::TEXTURE_BINDING 
            | TextureUsages::COPY_DST 
            | TextureUsages::STORAGE_BINDING,
        view_formats: &[IMAGE_3D_FORMAT],
    },
    data,
    asset_usage: RenderAssetUsages::all(),
    ..Default::default()
};

// Return our loaded 3D image
Ok(img)
```

Let's test it! Just add an asset server to our system and load our image as an asset:

```rust
fn system(asset_server: Res<AssetServer>) {
    let handle: Handle<Image> = asset_server.load("my_image.(5x2).3d.png");
}
```

### Conclusion

In this post, we explored how to implement a custom 3D texture loader for Bevy by leveraging the asset pipeline and extending it to support 3D data stored in standard 2D image formats. By organizing our 3D data as tiled slices and parsing loader settings from filenames, we can efficiently import and use 3D textures in our Bevy projects. This approach opens up new possibilities for voxel rendering, volumetric effects, and custom texture workflows, even before native 3D texture support lands in Bevy. Happy experimenting!