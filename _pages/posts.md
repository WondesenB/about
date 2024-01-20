---
layout: archive
title: "Posts"
permalink: /posts/
author_profile: true
---
{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>https://scholar.google.com/citations?user=LxyDFboAAAAJ&hl=en</u>
{% endif %}

{% include base_path %}

{% for post in site.posts reversed %}
  {% include archive-single.html %}
{% endfor %}