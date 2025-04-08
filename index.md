---
layout: home
---

| [blog](blog) | [github](https://github.com/konceptosociala/) | [tg@channel](https://t.me/hnutov) | [about](about) |

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
    * [**konn**](https://github.com/konceptosociala/konn) - cross-platform web 
	browser and protocol for fast and elegant Internet sites
    * [**flatbox**](https://github.com/konceptosociala/flatbox) - rusty ECS-driven 
	game engine, being developed for Komunterio

* literature
	* [**Komunterio** (esperanto)](https://github.com/konceptosociala/Komunterio-EO)
	* [**Комунтерія** (українською)](https://github.com/konceptosociala/Komunterio-UA)

---

| Koncepta Sociala © Licensed under CC0 |
