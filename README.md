# Weronika Łoś · Testerka oprogramowania

Przebranżawiam się i szukam pierwszej pracy jako testerka manualna. Żeby sprawdzić się w praktyce, przetestowałam od początku do końca FixEstate – system do zgłaszania usterek w budynkach, z panelem webowym i aplikacją mobilną dla czterech ról. Poniżej jest wszystko, co przy tym powstało.

W testowaniu najbardziej lubię szukać miejsc, w których system działa inaczej, niż obiecuje dokumentacja. Dlatego sprawdzam nie tylko interfejs, ale też API i dane w bazie. Kiedy zgłaszam błąd, piszę kroki tak, żeby programista mógł go odtworzyć bez dopytywania.

Podczas nauki pracowałam z Jirą, Zephyr Scale, Postmanem, SQL, Chrome DevTools i GitHubem.

## Spis treści

- [Projekt w liczbach](#projekt-w-liczbach)
- [Testowana aplikacja](#testowana-aplikacja-fixestate)
- [Najważniejsze znaleziska](#najważniejsze-znaleziska)
- [Plan testów](#plan-testów)
- [Projektowanie testów](#projektowanie-testów)
- [Scenariusze i przypadki testowe](#scenariusze-i-przypadki-testowe)
- [Wykonanie testów](#wykonanie-testów)
- [Defekty](#defekty)
- [Testy API](#testy-api)
- [Weryfikacja w SQL](#weryfikacja-w-sql)
- [Raport z testów](#raport-z-testów)
- [Narzędzia](#narzędzia)
- [Poza zakresem](#poza-zakresem)
- [Kontakt](#kontakt)

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

## Scenariusze i przypadki testowe

Przepływy opisałam w 15 scenariuszach i przy każdym zaznaczyłam ryzyko biznesowe, np. dostęp do konta przez niewłaściwą osobę. Scenariusze realizuje 129 przypadków testowych z Zephyr Scale: 95 manualnych w panelu webowym i aplikacji mobilnej oraz 34 w REST API.

▶️ [**Scenariusze testowe (15)**](https://docs.google.com/spreadsheets/d/130nwioql5t7UpcQyUr_UG3sKlfgZu73JyxiLWtDEmD4/edit?usp=sharing)

▶️ [**Przypadki testowe (129)**](https://docs.google.com/spreadsheets/d/1OI4bGF_G4yJsM5NOPPo1-oZeNVuifn-gcXWxnuZyBPI/edit?usp=sharing)

## Wykonanie testów

Przypadki wykonałam w 15 cyklach testowych w Zephyr Scale, podzielonych według obszarów, np. logowanie, przejścia zgłoszeń w API i formularz zgłoszeniowy. Z 128 wykonań 121 zakończyło się wynikiem Pass, a 7 wynikiem Fail. Jeden przypadek, FQ-T131, nie został wykonany.

▶️ [**Wyniki wykonania testów**](https://docs.google.com/spreadsheets/d/1yp6PzmxJfz70vLOpDBUtgsdvVdm0ulEVqisT-p2T2zg/edit?usp=sharing)

## Defekty

Znalezione błędy zgłosiłam w Jirze. Jest ich 8 i każdy ma kroki do odtworzenia, oczekiwany i rzeczywisty rezultat oraz priorytet, a w Jirze także zrzut ekranu albo nagranie. Jeden ma priorytet High, cztery Medium, trzy Low lub Lowest. Żaden nie został jeszcze naprawiony, więc nie było retestów.

▶️ [**Defekty z Jiry (8)**](https://docs.google.com/spreadsheets/d/10fU4rPRZm4miCbfZ12zDqLwOfS3mRHsaKm3EMHixh30/edit?usp=sharing)

## Testy API

Przejścia zgłoszeń sprawdzałam też bezpośrednio w API, bo brak przycisku w interfejsie nie oznacza, że dana rola nie może wykonać akcji. Kolekcja Postmana ma 45 requestów: logowanie każdej roli z zapisem tokena do zmiennych, 17 przejść dozwolonych, 5 niedozwolonych w danym stanie (oczekiwany kod 422), 8 niedozwolonych dla roli (403) i 6 requestów do modułu budynków. Tokeny, klucz API i hasła są w kolekcji tylko jako zmienne `{{…}}`, a plik środowiska nie jest publiczny.

▶️ [**Kolekcja Postmana**](api-postman/)

## Weryfikacja w SQL

Po testach sprawdzałam dane bezpośrednio w bazie (Supabase, PostgreSQL): czy liczby zgłoszeń zgadzają się z filtrami w interfejsie, czy odrzucone zgłoszenia mają powód i czy po zmianie stanu zmienia się data aktualizacji. Przygotowałam 13 zapytań na tabelach zgłoszeń, użytkowników, budynków i komentarzy. Przy każdym jest opis i powiązany przypadek testowy.

▶️ [**Zapytania SQL**](sql/)

## Raport z testów

Raport końcowy podsumowuje wykonanie testów, znalezione defekty, spełnienie kryteriów wyjścia i rekomendacje przed wdrożeniem.

▶️ [**Raport z testów FixEstate**](https://drive.google.com/file/d/1EJfVxU_SGup_vtudo1HNzeq-JxAH9-7b/view?usp=sharing)

## Narzędzia

- **Jira:** zgłaszanie i opisywanie defektów.
- **Zephyr Scale:** przypadki testowe, cykle testowe i zapisywanie wyników.
- **Postman:** testy REST API, zmienne środowiska i skrypty zapisujące tokeny.
- **SQL (edytor Supabase):** sprawdzanie danych w bazie.
- **Chrome DevTools:** konsola z błędami i zakładka Network do sprawdzania kodów odpowiedzi.
- **Excel i Arkusze Google:** tabele technik projektowania i scenariusze.
- **GitHub:** publikacja portfolio.

## Poza zakresem

Nie testowałam komentarzy do zgłoszeń, bo zabrakło na nie czasu. Poza zakresem były też testy wydajności i bezpieczeństwa wykraczające poza uprawnienia ról, np. SQL injection czy testy penetracyjne. Nie pisałam testów automatycznych ani jednostkowych: projekt skupiał się na testach manualnych, a testy jednostkowe są po stronie programistów.

## Kontakt

losweronika122@gmail.com
