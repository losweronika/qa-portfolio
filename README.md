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

## Projektowanie testów

Zaczęłam od listy 28 funkcjonalności z rolami i priorytetami, a przypadki testowe projektowałam czterema technikami.

▶️ [**Tabela funkcjonalności**](https://docs.google.com/spreadsheets/d/1ZBEVpusr97HAykrFTHNTkKAJr0z6eqFASLBhdONNSSU/edit?usp=sharing)

### Klasy równoważności

Pola formularza zgłoszenia (tytuł, kategoria, opis, załącznik) podzieliłam na klasy poprawnych i niepoprawnych wartości, np. puste pole, same spacje albo film zamiast zdjęcia. Tak samo podeszłam do pól logowania i filtrów listy zgłoszeń.

▶️ [**Klasy równoważności i wartości brzegowe formularza zgłoszenia**](https://docs.google.com/spreadsheets/d/19vDMaDgVBxw_zOtTflUvH2lqdR9jJlaSOcmG2PtXmQA/edit?usp=sharing)

### Wartości brzegowe

W tytule (do 100 znaków), opisie (do 1000 znaków) i załączniku (do 3 zdjęć) sprawdzałam wartości tuż przed granicą, na niej i tuż za nią. Razem z klasami równoważności dało to 26 przypadków dla formularza, a test opisu z 1001 znakami znalazł defekt FQ-5. Obie techniki są w tym samym arkuszu co wyżej.

### Tablica decyzyjna

Dla uprawnień zestawiłam 7 akcji na zgłoszeniu z 7 wariantami ról, np. zarządca przypisany do budynku i obcy, mieszkaniec zgłaszający i obcy. Z 49 kombinacji wyszły 22 przypadki. Osobno rozpisałam odrzucenie zgłoszenia: 3 warunki dają 8 kombinacji, które zamknęłam w 4 regułach i 4 przypadkach.

▶️ [**Tablica decyzyjna uprawnień do zgłoszeń**](https://docs.google.com/spreadsheets/d/17Atxk25Z4c-bw4njBK-ek4VWR8GlwUyi8Y-1a9cIr0w/edit?usp=sharing)

▶️ [**Tablica decyzyjna odrzucenia zgłoszenia**](https://docs.google.com/spreadsheets/d/13y-rTcozLjYQItBXbev9K7pQfNeGmc2ZHzfktaYH8wY/edit?usp=sharing)

### Przejścia stanów

Zgłoszenie ma 5 stanów i 7 akcji. Rozpisałam 9 przejść dozwolonych i 22 niedozwolone, z których powstało 41 przypadków. W API sprawdzałam, czy przejście niedozwolone w danym stanie kończy się kodem 422, a akcja spoza uprawnień roli kodem 403. Tą techniką testowałam też logowanie (stan zalogowany i niezalogowany).

▶️ [**Tabela przejść stanów zgłoszenia**](https://docs.google.com/spreadsheets/d/1EJl-A8l-beYo0OW2_BjEGqfwKR2pyT6zI6FYMVZIswM/edit?usp=sharing)
