virtualenv:
  pkg.installed:
    - require_in:
      - letsencrypt

python-pip:
  pkg.installed:
    - require_in:
      - letsencrypt

/etc/opt/letsencrypt/credentials.ini:
  file.managed:
    - source: salt://letsencrypt/credentials.ini
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - require_in:
      - letsencrypt

letsencrypt:
  virtualenv.managed:
    - name: /opt/letsencrypt
    - requirements: salt://letsencrypt/requirements.txt
  pip.installed:
    - bin_env: /opt/letsencrypt
    - require:
      - virtualenv: letsencrypt
