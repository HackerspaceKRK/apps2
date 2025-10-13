# Configi nowej infry HS-u


## Czego używamy

1. [`docker compose`](https://docs.docker.com/compose/) - Do uruchamiania kontenerów
2. [ansible](https://docs.ansible.com/) - do zmiany ustawień na hoście, tworzenia unixowych userów na hoście
3. [git](https://git-scm.com/) - do utrzymania względnego porządku i historii infry
4. [Debian Trixie](https://www.debian.org/) - system operacyjny na serwerze


## Gdzie to jest odpalone?

`flatsun.at.hskrk.pl` / `10.12.20.5`

To repozytorium jest zcheckoutowane pod `/opt/apps2`.

## Opis repozytorium

- w [`ansible/`](./ansible/) znajdują się playbooki do konfiguracji sytemu operacyjnego hosta.

- Pozostałe katalogi zawierają konfigurację usług uruchamianych w dockerze. W każdym z nich jest `compose.inc.yml`, który jest includowany w [`compose.yml`](./compose.yml) aby stworzyć jeden wielki stack na wszystkie usługi w HS.

## Chcę zmienić konfigurację jakiejś usługi uruchomionej, jak to zrobić?

1. Logujemy się przez SSH na `flatsun.at.hskrk.pl` (można też użyć [sshfs](https://github.com/libfuse/sshfs), [pluginu do VS Code](https://code.visualstudio.com/docs/remote/ssh))
2. Przchodzimy do `/opt/apps2`
2. Edytujemy wybrany config swoim [ulubionym edytorem](https://www.gnu.org/software/ed/ed.html)
3. Restartujemy wybraną usługę `docker compose restart <nazwa usługi>` lub jeżeli zmienialiśmy pliki compose, to podnosimy od nowa: `docker compose up -d`
4. Testujemy nasze zmiany. (Oglądamy logi: `docker compose logs --tail=100 -f <nazwa usługi>`)
5. `git add <zmienione pliki>` (Uwaga żeby nie dodać secretów!)
6. `git commit -m "<opis>"`
7. `git push` (Klucz ssh powinien być już skonfigurowany żeby pushować na to repozytorium)


Alternatywnie można zacząć od wprowadzenia zmian na swoim komputerze, pushnięciu na repozytorium, a nastepnie `git pull` i  `docker compose restart <nazwa usługi>` / `docker compose up -d`.

## Chcę dodać nową usługę do dockerze

1. Tworzymy plik `<nazwa uslugi>/compose.inc.yml` (bądź edytujemy istniejący jeżeli kontener będzie blisko spokrewniony z czymś co już istnieje).
2. W pliku `compose.inc.yml` dodajemy sobie odpowiednie serwisy, volumy, etc.
3. Ewentualne sekrety wrzucamy jako pliki do `/opt/secrets/`
4. Możemy dodać nasz kontener do m. in. następujących sieci:
    - `services-monitoring` - Daje dostęp prometheusowi do naszego kontenera (see [`prometheus.yml`](./services-monitoring/prometheus-config/prometheus.yml)). Przydatne jeżeli wystawiamy metryki.
    - `asterisk` - Daje dostęp do kontenera z asteriskiem. Na  `http://asterisk:8088` działa [ARI](https://docs.asterisk.org/Configuration/Interfaces/Asterisk-REST-Interface-ARI).
    - `mqtt` - broker MQTT
5. Includujemy go w głównym [`compose.yml`](./compose.yml)
6. Podnosimy nowo dodane kontenery: `docker compose up -d`
7. Testujemy nasze zmiany. (Oglądamy logi: `docker compose logs --tail=100 -f <nazwa usługi>`)
9. Tworzymy/edytujemy `.gitignore`, aby nie wrzucać syfu do repo. Wrzucamy tam np. pliki baz danych etc. 
8. `git add <zmienione pliki>` (Uwaga żeby nie dodać secretów!)
9. `git commit -m "<opis>"`
10. `git push` (Klucz ssh powinien być już skonfigurowany żeby pushować na to repozytorium)

## TODO

- [ ] Dodać możliwie najwięcej z ciscofon-server/tftp-root to Gita (jak będzie  autogenerowanie configów do ciscofonów, zrobić coś z firmwarami)
- [ ] Oczyścić i dodać dźwięki z asteriska do Git-a

