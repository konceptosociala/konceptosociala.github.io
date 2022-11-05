---
layout: page
title: Blogo
permalink: /blogo/
---

<input type="text" id="search-input" placeholder="Serĉi publikaĵojn">
<ul id="results-container"></ul>

<script src="https://unpkg.com/simple-jekyll-search@latest/dest/simple-jekyll-search.min.js"></script>
<script>
	var sjs = SimpleJekyllSearch({
		searchInput: document.getElementById('search-input'),
		resultsContainer: document.getElementById('results-container'),
		json: '/search.json'
	})
</script>

{% for post in site.posts %}
<li>
	{{post.date | date: "%-d-%-m-%Y"}}
	<a href="{{ post.url }}">{{ post.title }}</a>
	{{ post.excerpt }}
</li>
{% endfor %}
