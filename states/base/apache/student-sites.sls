/etc/apache2/sites-available/002-students.eksjoteknikprogram.conf:
  file.managed:
    - source: salt://apache/files/002-students.eksjoteknikprogram.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/apache2/sites-enabled/002-students.eksjoteknikprogram.conf:
  file.symlink:
    - target: ../sites-available/002-students.eksjoteknikprogram.conf

{% for user, data in pillar['students'].iteritems() %}
/srv/www/students.eksjoteknikprogram.se/sites/{{ user }}:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True

{{ user }}-dav:
  webutil.user_exists:
    - name: {{ user }}
    - password: {{ data['password'] }}
    - htpasswd_file: /srv/www/students.eksjoteknikprogram.se/.htpasswd
    - options: d
    - force: True
{% endfor %}
