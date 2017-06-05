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
    - target: {{ cachet.rootdir }}
    - user: {{ cachet.user }}
    - fetch_tags : True
    - require:
      - pkg: git

cachet-env:
  file.managed:
    - name: {{ cachet.rootdir }}/.env
    - user: {{ cachet.user }}
    - group: {{ cachet.group }}
    - template: jinja
    - source: salt://cachet/templates/env.jinja
    - context:
      config: {{ cachet.config }}
    - mode: 440

composer-cachet:
  composer.installed:
    - name: {{ cachet.rootdir }}
    - user: {{ cachet.user }}
    - no_dev: true
    - always_check: false
    - optimize: true
    - require:
      - file: cachet-env

cachet-app-install:
  cmd.run:
    - name: php artisan app:install
    - cwd: {{ cachet.rootdir }}
    - user: {{ cachet.user }}
    - group: {{ cachet.group }}
    - watch:
      - composer: composer-cachet
