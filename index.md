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

* projects
	* [**carol**](https://github.com/konceptosociala/carol) - 2D RPG game made with libGDX 
    * [**wgsldoc**](https://github.com/konceptosociala/wgsldoc) - WGSL static web documentation generator
	* [**frago**](https://github.com/konceptosociala/frago) - mobile application for writing posts for GitHub Pages driven blog 

* literature
	* **Komunterio** ([UA](https://github.com/konceptosociala/Komunterio-UA), [EO](https://github.com/konceptosociala/Komunterio-EO))

---

| Koncepta Sociala © Licensed under CC0 |
