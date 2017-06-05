{% from "cachet/map.jinja" import cachet with context %}

include:
  - composer

cachet-php5-memcached:
  pkg.installed:
    - name: php5-memcached

cachet-memcached:
  pkg.installed:
    - name: memcached

git-cachet:
  pkg.installed:
    - name: git
  git.latest:
    - name: https://github.com/cachethq/Cachet.git
    - rev: v2.0.4
    - target: {{ rootdir }}
    - user: {{ cachet.user }}
    - group: {{ cachet.group }}
    - fetch_tags : True
    - require:
      - pkg: git

{{ cachet.rootdir }}/.env:
  file.managed:
    - user: {{ cachet.user }}
    - group: {{ cachet.group }}
    - template: jinja
    - source: salt://cachet/templates/env.jinja
    - mode: 440

composer-cachet:
  composer.installed:
    - name: {{ rootdir }}
    - user: {{ cachet.user }}
    - no_dev: true
    - always_check: false
    - optimize: true
    - require:
      - file: {{ rootdir }}/.env

cachet-app-install:
  cmd.run:
    - name: php artisan app:install
    - cwd: {{ rootdir }}
    - user: {{ cachet.user }}
    - group: {{ cachet.group }}
    - watch:
      - composer: composer-cachet
