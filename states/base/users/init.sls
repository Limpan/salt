skeleton:
  file.recurse:
    - name: /etc/skel
    - source: salt://users/files/skel
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - include_empty: True

{% for user, data in pillar['students'].iteritems() %}
{{ user }}:
  user.present:
    - fullname: {{ data['fullname'] }}
    - shell: /bin/false
    - home: /home/{{ user }}
    - uid: {{ data['uid'] }}
    - gid: {{ data['gid'] }}
    - gid_from_name: True
    - password: {{ data['password'] }}
    - require:
      - skeleton
{% endfor %}
