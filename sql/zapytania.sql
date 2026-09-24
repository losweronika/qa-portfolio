-- Zapytania do bazy FixEstate (Supabase, PostgreSQL) sprawdzające dane po testach.

-- 1. Odrzucone zgłoszenia bez powodu odrzucenia. Powód jest wymagany, więc wynik powinien być pusty.
-- Powiązane: FQ-T24, FQ-T25


SELECT id, title 
FROM tickets 
WHERE status = 'Odrzucone' AND rejection_reason IS NULL


-- 2. Liczba zgłoszeń w każdej kategorii - do porównania z filtrem kategorii na liście zgłoszeń.
-- Powiązane: FQ-T114, FQ-T115

SELECT category, COUNT(*) AS liczba_ticketów
FROM tickets
GROUP BY category 
ORDER BY COUNT(id) DESC


-- 3. Powtarzające się tytuły - czy przy tworzeniu zgłoszenia nie powstają duplikaty.
-- Powiązane: FQ-T19, FQ-T72

SELECT title, COUNT(*) AS liczba_wystąpień
FROM tickets
GROUP BY title
HAVING COUNT(*) > 1


-- 4. Zgłoszenia "W trakcie" z osobą przypisaną - każde powinno mieć wykonawcę.
-- Powiązane: FQ-T20, FQ-T21

SELECT t.title, p.first_name, p.last_name 
FROM tickets t
JOIN profiles p ON p.id = t.assignee_id 
WHERE status = 'W trakcie' -- bez określania roli, żeby ewentualnie wykryć nieprawdę
ORDER BY p.last_name


-- 5. Osoby z więcej niż 5 przypisanymi zgłoszeniami - jak rozkładają się przypisania.
-- Powiązane: FQ-T20 - FQ-T23

SELECT p.first_name, p.last_name, COUNT(t.assignee_id)
FROM profiles p
JOIN tickets t ON t.assignee_id = p.id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(assignee_id) > 5
ORDER BY COUNT(*) DESC


-- 6. Budynki bez żadnego zgłoszenia - do doboru danych przy testach zarządcy "danego budynku".
-- Powiązane: FQ-T25, FQ-T46

SELECT b.name
FROM buildings b
LEFT JOIN tickets t ON t.building_id = b.id 
WHERE t.id IS NULL


-- 7. Otwarte zgłoszenia z Hydrauliki i Elektryki - do porównania z filtrami kategorii i statusu.
-- Powiązane: FQ-T114 - FQ-T117

SELECT title, category, status
FROM tickets
WHERE category IN ('Hydraulika', 'Elektryka') AND status NOT IN ('Zakończone', 'Odrzucone')


-- 8. Osoby, które utworzyły co najmniej 3 zgłoszenia - czy reporter_id zapisuje się przy tworzeniu.
-- Powiązane: FQ-T19, FQ-T72

SELECT p.first_name, p.last_name, COUNT(t.reporter_id) AS liczba_zgłoszeń
FROM profiles p
JOIN tickets t ON t.reporter_id = p.id 
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(t.reporter_id) >= 3
ORDER BY COUNT(t.reporter_id) DESC


-- 9. Specjalizacja wykonawców przypisanych do zgłoszeń z Elektryki - czy pasuje do kategorii.
-- Powiązane: FQ-T79, defekt FQ-6

SELECT p.first_name, p.last_name, p.specialization, t.title 
FROM profiles p
JOIN tickets t ON t.assignee_id = p.id
WHERE category = 'Elektryka'


-- 10. Liczba zgłoszeń w każdym budynku, także zerowa.
-- Powiązane: FQ-T25, FQ-T46

SELECT b.name, COUNT(t.building_id) AS Liczba_zgłoszeń
FROM buildings b
LEFT JOIN tickets t ON t.building_id = b.id 
GROUP BY b.id, b.name
ORDER BY COUNT(t.building_id) ASC


-- 11. Wykonawcy bez przypisanego zgłoszenia, np. nowo dodane konta.
-- Powiązane: FQ-T120, FQ-T123

SELECT p.first_name, p.last_name
FROM profiles p
LEFT JOIN tickets t ON t.assignee_id = p.id
WHERE assignee_id IS NULL AND role = 'contractor'


-- 12. Zgłoszenia z więcej niż 2 komentarzami.
-- Powiązane: brak, komentarze były poza zakresem testów

SELECT t.title, COUNT(tc.id) AS liczba_komentarzy
FROM tickets t
JOIN ticket_comments tc ON tc.ticket_id = t.id
GROUP BY t.id, t.title
HAVING COUNT(tc.id) > 2 
ORDER BY COUNT(tc.id) DESC


-- 13. Data aktualizacji nie późniejsza niż data utworzenia - po zmianie stanu updated_at powinno się zmienić.
-- Powiązane: FQ-T24 - FQ-T35

SELECT id, created_at, updated_at 
FROM tickets
WHERE created_at >= updated_at 