/etc/apache2/sites-available/001-eksjoteknikprogram.conf:
  file.managed:
    - source: salt://apache/files/001-eksjoteknikprogram.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: letsencrypt-eksjoteknikprogram.se
    - watch_in:
      - service: apache2

/etc/apache2/sites-enabled/001-eksjoteknikprogram.conf:
  file.symlink:
    - target: ../sites-available/001-eksjoteknikprogram.conf

/srv/www/eksjoteknikprogram.se:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
    - onchanges:
      - eksjoteknikprogram.se

eksjoteknikprogram.se:
  git.latest:
    - name: https://github.com/teknik-eksjo/website.git
    - rev: master
    - target: /srv/www/eksjoteknikprogram.se

letsencrypt-eksjoteknikprogram.se:
  cmd.run:
    - name: >
             /opt/letsencrypt/bin/letsencrypt certonly --agree-tos
             --server https://acme-v02.api.letsencrypt.org/directory 
             --preferred-challenges dns -m linus.torngren@eksjo.se 
             --certbot-loopia:auth-credentials /etc/opt/letsencrypt/credentials.ini 
             -d eksjoteknikprogram.se 
             -d *.eksjoteknikprogram.se
             -d *.students.eksjoteknikprogram.se

    - creates: /etc/letsencrypt/live/eksjoteknikprogram.se/fullchain.pem
    - require:
      - pip: letsencrypt

renew-cert-for-eksjoteknikprogram.se:
  cron.present:
    - name: >
             /opt/letsencrypt/bin/letsencrypt certonly --renew
             --server https://acme-v02.api.letsencrypt.org/directory 
             --preferred-challenges dns
             --certbot-loopia:auth-credentials /etc/opt/letsencrypt/credentials.ini 
             -d eksjoteknikprogram.se 
             -d *.eksjoteknikprogram.se
             -d *.students.eksjoteknikprogram.se

    - identifier: renew-cert-for-eksjoteknikprogram.se
    - daymonth: 1
    - hour: 10
    - minute: 0
    - require:
      - cmd: letsencrypt-eksjoteknikprogram.se
