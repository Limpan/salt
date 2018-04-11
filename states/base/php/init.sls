php5-fpm:
  pkg.installed:
    - pkgs:
      - php7.0
      - libapache2-mod-php7.0
  require:
    - sls: apache
