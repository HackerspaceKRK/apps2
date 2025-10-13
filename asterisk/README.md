Asterisk notatki
=============

Asterisk odpalony w dockerze bez network_mode: host.


Żeby działało audio to musi być ustawione takie coś w `pjsip_transport.com`:

```

external_signaling_address = 10.12.20.5
external_media_address = 10.12.20.5
tos = cs3
cos = 3
local_net=172.22.0.1/16

```

Wtedy Asterisk wie że jest za NAT-em i dobrze bridguje RTP.
