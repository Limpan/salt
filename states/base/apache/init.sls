apache-server:
  pkg.installed:
    - pkgs:
      - apache2
      - libapache2-mod-fastcgi

apache2:
  service.running:
    - watch:
      - file: /etc/apache2/sites-enabled/*
    - require:
      - pkg: apache-server

/etc/apache2/conf-available/ssl.conf:
  file.managed:
    - source: salt://apache/files/ssl.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: apache2

apache-ssl-module:
  apache_module.enabled:
    - name: ssl
    - watch_in:
      - apache2

apache-socache_shmcb-module:
  apache_module.enabled:
    - name: socache_shmcb
    - watch_in:
      - apache2

apache-headers-module:
  apache_module.enabled:
    - name: headers
    - watch_in:
      - apache2

apache-fastcgi-module:
  apache_module.enabled:
    - name: fastcgi
    - watch_in:
      - apache2

apache-dav-module:
  apache_module.enabled:
    - name: dav
    - watch_in:
      - apache2

apache-dav_fs-module:
  apache_module.enabled:
    - name: dav_fs
    - watch_in:
      - apache2

apache-vhost_alias-module:
  apache_module.enabled:
    - name: vhost_alias
    - watch_in:
      - apache2

apache-rewrite-module:
  apache_module.enabled:
    - name: rewrite
    - watch_in:
      - apache2

/etc/apache2/sites-enabled/000-default.conf:
  file.absent

include:
  - .eksjoteknikprogram
  - .student-sites
