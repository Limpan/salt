php5-fpm:
  pkg.installed:
    - pkgs:
      - php7.0
      - libapache2-mod-php7.0
      - php7.0-mysql
      - php7.0-xml
  require:
    - sls: apache

