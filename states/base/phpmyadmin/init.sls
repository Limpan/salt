/etc/apache2/sites-available/003-phpmyadmin.conf:
  file.managed:
    - source: salt://phpmyadmin/files/003-phpmyadmin.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: apache2

/etc/apache2/sites-enabled/003-phpmyadmin.conf:
  file.symlink:
    - target: ../sites-available/003-phpmyadmin.conf

phpmyadmin.eksjoteknikprogram.se:
  git.latest:
    - name: https://github.com/phpmyadmin/phpmyadmin.git
    - rev: RELEASE_4_8_0
    - target: /srv/www/phpmyadmin.eksjoteknikprogram.se 

/srv/www/phpmyadmin.eksjoteknikprogram.se/config.inc.php:
  file.managed:
    - source: salt://phpmyadmin/files/config.inc.php.jinja
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 600
    - require:
      - git: phpmyadmin.eksjoteknikprogram.se

/srv/www/phpmyadmin.eksjoteknikprogram.se:
  file.directory:
    - user: www-data
    - group: www-data
    - recurse:
      - user
      - group
    - onchanges:
      -  phpmyadmin.eksjoteknikprogram.se


/opt/composer:
  file.directory:
    - user: root
    - group: root
    - require_in:
      - cmd: get-composer

get-composer:
  cmd.run:
    - name: '/usr/bin/curl -sS https://getcomposer.org/installer | php'
    - unless: test -f /opt/composer/composer
    - cwd: /tmp
    - env:
      - COMPOSER_HOME: '/opt/composer'

install-composer:
  cmd.wait:
    - name: mv /tmp/composer.phar /opt/composer/composer
    - watch:
      - cmd: get-composer

composer-install-packages:
  composer.installed:
    - composer: /opt/composer/composer
    - php: /usr/bin/php
    - name: /srv/www/phpmyadmin.eksjoteknikprogram.se
    - no_dev: true
    - require:
      - cmd: get-composer
