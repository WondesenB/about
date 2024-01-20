---
layout: archive
title: "Projects"
permalink: /projects/
author_profile: true
---
{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>https://scholar.google.com/citations?user=LxyDFboAAAAJ&hl=en</u>
{% endif %}

{% include base_path %}

{% for post in site.projects reversed %}
  {% include archive-single.html %}
{% endfor %}