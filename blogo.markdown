---
layout: page
title: Blogo
permalink: /blogo/
---

{% for post in site.posts %}
<li>
	{{post.date | date: "%-d-%-m-%Y"}}
	<a href="{{ post.url }}">{{ post.title }}</a>
	{{ post.excerpt }}
</li>
{% endfor %}
