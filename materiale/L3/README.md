# Referinte proceduri stocate si versionare

## Săptămâna 5
### 1. Proceduri stocate (stored procedures)
#### SQL Stored procedures:
- [Microsoft](https://learn.microsoft.com/en-us/sql/relational-databases/stored-procedures/create-a-stored-procedure?view=sql-server-ver17)
- [W3 schools](https://www.w3schools.com/sql/sql_stored_procedures.asp)
#### SQL Loops
- [Microsoft](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-loops)
- [W3schools](https://www.geeksforgeeks.org/plsql/plsql-loops/)
### 2. Versioning
- [Microsoft](https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal/create?view=sql-server-ver17)
- [exemplu](./L3_exemplu_versionare.txt)

## Săptămâna 6

| Criteriu | Tabel | (materialized) VIEW | Temporary VIEW | Common Table Expression | Synonym
| - | - | - | - | - | - |
| Ce este? | Structura de date care retine inregistrarile | Tabel virtual, rezultat pre-calculat | Tabela virtuala stocata temporar | Set de rezultate | Pointer (Soft link)|
| Stochează date? | Da | Da | Nu, doar interogarea | Nu | Indirect
| Cât timp persistă datele? | Tot timpul până fie se dă DROP sau discul este distrus | Snapshot, persistă ca și tabelul | Doar pe durata conexiunii |  - | - |
| Când sunt extrase datele? | Citire de pe disc / la un select | Doar in momentul crearii sau reimprospatarii | On-the-fly - la interogarea view-ului | Calculat doar in momentul extragerii datelor | Indirect de la tabel |
| Dacă modificăm schema, se modifică? | Se modifică direct | Necesită modificare manuală | Reflectă datele la zi, dar trebuie actualizată schema | Nu | Redirecționat spre tabel
| Când e util? | Aplicații tranzacționale | Rapoarte, dashboards, replicarea datelor, optimizare eficienta (server) | ETL processes, acces clienți |Nested queries, interogări recursive, refolosire |Migrări, refactoring, interogari cross-database, linked servers, securitate, abstractizare, acces |