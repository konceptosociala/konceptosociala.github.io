---
layout: home
---

| [blog](blog) | [github](https://github.com/konceptosociala/) | [soundcloud](https://soundcloud.com/janesnote) | [about](about) |

<br>

* latest posts
	<ul>
		{% for post in site.posts limit:4 %}
		<li>
			{{post.date | date: "%-d-%-m-%Y"}}
			<a href="{{ post.url }}">{{ post.title }}</a>
		</li>
		{% endfor %}
	</ul>

* software
    * [**wgsldoc**](https://github.com/konceptosociala/wgsldoc) - WGSL static web documentation generator
    * [**termgpu**](https://github.com/konceptosociala/termgpu) - GPU-driven terminal rendering library
	* [**frago**](https://github.com/konceptosociala/frago) - mobile application for writing posts for GitHub Pages driven blog 

* literature
	* [**Komunterio** (esperanto)](https://github.com/konceptosociala/Komunterio-EO)
	* [**Комунтерія** (українською)](https://github.com/konceptosociala/Komunterio-UA)

---

| Koncepta Sociala © Licensed under CC0 |
