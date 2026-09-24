-- 1. Pokaż ID oraz tytuł zgłoszenia, które ma status "Odrzucone" i nie podano powodu odrzucenia.


SELECT id, title 
FROM tickets 
WHERE status = 'Odrzucone' AND rejection_reason IS NULL


-- 2. Dla każdej kategorii ticketów policz, ile jest w niej zgłoszeń. Pokaż nazwę kategorii i liczbę zgłoszeń. Posortuj wynik od kategorii z największą liczbą zgłoszeń do najmniejszej.

SELECT category, COUNT(*) AS liczba_ticketów
FROM tickets
GROUP BY category 
ORDER BY COUNT(id) DESC


-- 3. Pokaż tytuły zgłoszeń, które powtarzają się więcej niż raz. Wyświetl tytuł i liczbę jego wystąpień.

SELECT title, COUNT(*) AS liczba_wystąpień
FROM tickets
GROUP BY title
HAVING COUNT(*) > 1


-- 4. Pokaż tytuły zgłoszeń w statusie „W trakcie” razem z imieniem i nazwiskiem osoby, do której są przypisane. Posortuj wynik alfabetycznie po nazwisku.

SELECT t.title, p.first_name, p.last_name 
FROM tickets t
JOIN profiles p ON p.id = t.assignee_id 
WHERE status = 'W trakcie' -- bez określania roli, żeby ewentualnie wykryć nieprawdę
ORDER BY p.last_name


-- 5. Pokaż osoby, które mają przypisanych więcej niż 5 zgłoszeń. Wyświetl imię, nazwisko i liczbę przypisanych ticketów. Posortuj od osoby z największą liczbą zgłoszeń.

SELECT p.first_name, p.last_name, COUNT(t.assignee_id)
FROM profiles p
JOIN tickets t ON t.assignee_id = p.id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(assignee_id) > 5
ORDER BY COUNT(*) DESC


-- 6. Pokaż nazwy budynków, dla których nie powstało żadne zgłoszenie.

SELECT b.name
FROM buildings b
LEFT JOIN tickets t ON t.building_id = b.id 
WHERE t.id IS NULL


--  7. Pokaż tytuł, kategorię i status zgłoszeń z kategorii „Hydraulika” lub „Elektryka”, które nie są ani zakończone, ani odrzucone.

SELECT title, category, status
FROM tickets
WHERE category IN ('Hydraulika', 'Elektryka') AND status NOT IN ('Zakończone', 'Odrzucone')


-- 8. Pokaż osoby, które utworzyły co najmniej 3 zgłoszenia. Wyświetl imię, nazwisko i liczbę zgłoszeń. Posortuj od osoby z największą liczbą zgłoszeń.

SELECT p.first_name, p.last_name, COUNT(t.reporter_id) AS liczba_zgłoszeń
FROM profiles p
JOIN tickets t ON t.reporter_id = p.id 
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(t.reporter_id) >= 3
ORDER BY COUNT(t.reporter_id) DESC


-- 9. Pokaż imię, nazwisko i specjalizację osób przypisanych do zgłoszeń z kategorii „Elektryka” oraz tytuły tych zgłoszeń.

SELECT p.first_name, p.last_name, p.specialization, t.title 
FROM profiles p
JOIN tickets t ON t.assignee_id = p.id
WHERE category = 'Elektryka'


-- 10. Dla każdego budynku policz, ile utworzono w nim zgłoszeń, także jeśli nie ma ani jednego. Wyświetl nazwę budynku i liczbę zgłoszeń. Posortuj od budynku z najmniejszą liczbą zgłoszeń.

SELECT b.name, COUNT(t.building_id) AS Liczba_zgłoszeń
FROM buildings b
LEFT JOIN tickets t ON t.building_id = b.id 
GROUP BY b.id, b.name
ORDER BY COUNT(t.building_id) ASC


-- 11. Pokaż imiona i nazwiska wykonawców, którzy nie mają przypisanego żadnego zgłoszenia.

SELECT p.first_name, p.last_name
FROM profiles p
LEFT JOIN tickets t ON t.assignee_id = p.id
WHERE assignee_id IS NULL AND role = 'contractor'


-- 12. Pokaż zgłoszenia, które mają więcej niż 2 komentarze. Wyświetl tytuł zgłoszenia i liczbę komentarzy. Posortuj od zgłoszenia z największą liczbą komentarzy.

SELECT t.title, COUNT(tc.id) AS liczba_komentarzy
FROM tickets t
JOIN ticket_comments tc ON tc.ticket_id = t.id
GROUP BY t.id, t.title
HAVING COUNT(tc.id) > 2 
ORDER BY COUNT(tc.id) DESC


-- 13. Pokaż zgłoszenia, w których data ostatniej aktualizacji jest wcześniejsza niż data utworzenia lub jej równa. Wyświetl id zgłoszenia, datę utworzenia i datę aktualizacji.

SELECT id, created_at, updated_at 
FROM tickets
WHERE created_at >= updated_at 