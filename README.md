# Weronika Łoś · Testerka oprogramowania

Przebranżawiam się i szukam pierwszej pracy jako testerka manualna. Żeby sprawdzić się w praktyce, przetestowałam od początku do końca FixEstate – system do zgłaszania usterek w budynkach, z panelem webowym i aplikacją mobilną dla czterech ról. Poniżej jest wszystko, co przy tym powstało.

W testowaniu najbardziej lubię szukać miejsc, w których system działa inaczej, niż obiecuje dokumentacja. Dlatego sprawdzam nie tylko interfejs, ale też API i dane w bazie. Kiedy zgłaszam błąd, piszę kroki tak, żeby programista mógł go odtworzyć bez dopytywania.

Podczas nauki pracowałam z Jirą, Zephyr Scale, Postmanem, SQL, Chrome DevTools i GitHubem.

## Projekt w liczbach

| Przypadki testowe | Techniki projektowania | Wykonania | Defekty w Jirze | Requesty API |
|---|---|---|---|---|
| 129 (95 manualnych, 34 API) | 4 | 128: 121 Pass, 7 Fail | 8 | 45 |

## Testowana aplikacja: FixEstate

FixEstate służy do zgłaszania i obsługi usterek w budynkach. Mieszkaniec zgłasza usterkę w aplikacji mobilnej, zarządca albo administrator przypisuje ją wykonawcy w panelu webowym, a wykonawca oddaje wykonaną pracę do oceny. Zgłoszenie przechodzi przez stany Nowe, W trakcie, W ocenie, Zakończone lub Odrzucone, a to, kto może zmienić stan, zależy od roli. Backend działa na Supabase (PostgreSQL), więc oprócz interfejsu testowałam też REST API i dane w bazie.

## Najważniejsze znaleziska

- **FQ-2:** nieudana próba logowania w drugiej karcie przeglądarki kończy aktywną sesję w pierwszej, więc użytkownik zostaje wylogowany.
- **FQ-6:** do zgłoszenia z kategorii Hydraulika można przypisać wykonawcę ze specjalizacją Elektryka.
- **FQ-1:** poprawny adres e-mail o maksymalnej dozwolonej długości jest odrzucany przy logowaniu. Wyszło to przy teście maksymalnej długości adresu.

## Plan testów

Plan obejmuje panel webowy, aplikację mobilną i API dla czterech ról: logowanie, cykl życia zgłoszenia, przypisywanie użytkowników i budynki. Oprócz testów funkcjonalnych zaplanowałam sprawdzenie niedozwolonych przejść stanów dla każdej roli oraz testy na trzech przeglądarkach i dwóch telefonach.

▶️ [**Plan testów FixEstate**](https://drive.google.com/file/d/1xM69pZqQ9NfXSO0WnfI_b2_ewvQq8hno/view?usp=sharing)
