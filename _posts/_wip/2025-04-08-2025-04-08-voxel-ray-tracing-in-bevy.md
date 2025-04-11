---
layout: post
title: 'Voxel Ray Tracing in Bevy (part 1)'
permalink: /blog/voxel-ray-tracing-in-bevy
---

Modern computers, especially their GPUs, can process more and more data in less time, 
which opens doors for new possibilities in computer graphics. However, most games and 
graphics applications still use a performant, but not very physically accurate way to 
render objects on a scene - rasterization, instead of more resource-expensive ray 
tracing technology. 

Rasterization is a process of transformation of vector data (mostly triangles) into 
raster data, which can be displayed on a screen pixel by pixel. On the other hand, 
ray tracing is a process of getting information about rendered objects by casting a 
ray from each pixel to their surface. These two ways are different both in visual and 
performance aspects, but in this post we're going to combine them to get a golden ratio 
in the rendering process.

# Basics of Ray Tracing 

In simple words, **ray tracing** is a process of tracing a path from an imaginary 
eye (camera) through each pixel in a screen (viewport), and calculating the color 
of the visible (hit by a ray) object, taking into account the environment, light 
sources, physical properties of the object's material etc.

| ![ray_tracing_demonstration](/assets/blog/voxel-ray-tracing/ray_trace_diagram.svg) | 
|:--:| 
| *Common ray tracing demonstration* |


In an ordinary sense, a ray tracer casts a ray from each pixel, which traverses 
through each object on a scene in a single render pass, and then displays the 
result on a screen-sized plain (i.e. combination of 2 triangles). However, as 
we are going to use this approach together with regular rasterization, we'll 
split rendering into **2 stages**:

1. Basic volume ray tracing of each object to the surface of the corresponding 
box (not a plain)
2. Deferred rendering of light as a post-processing effect, using ray tracing 
of a global voxel volume and baked maps (normals, depth etc.)

A similar approach is used in the Teardown game, and now we'll implement it. 
In this post only the first stage of the process will be covered.

# Rendering voxel volume as a 3D mesh material
