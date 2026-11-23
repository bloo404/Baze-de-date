# Model 1: InvestYourStashMaster

## Descriere
Sunteți programator în backend la „InvestYourStashMaster“, o aplicație de investiții. În urma unei migrări greșite, baza de date a fost ștearsă, din fericire există un back-up al datelor, dar e nevoie de o bază de date care să le repună structurat ca utilizatorii să poată vedea ce dețin. Pe forumuri, utilizatorii deja scriu „F”, „RIP”, „not stonks”, dar fără baza de date nu mai au nimic vizibil. Trebuie să o reconstruiți.

**Investitorii** (nume, prenume, email) dețin acțiuni la diverse **companii** (denumire, simbol bursier, sector). **Portofoliul** unui investitor reține câte acțiuni deține din fiecare companie. Fiecare **tranzacție** (cumpărare sau vânzare) are o dată și oră (se va folosi un tip de dată pentru timp), o cantitate și un preț per acțiune, și este realizată de un investitor printr-un **broker** (nume, comision).

## Cerințe
1. Scrieți un script SQL care creează un model relațional pentru a reprezenta și stoca datele. Populați tabelele cu cel puțin 5 intrări.
2. Scrieți o procedură stocată care înregistrează o vânzare de acțiuni. Investitorul, compania și cantitatea vor fi parametrii procedurii. Dacă investitorul deține mai puține acțiuni decât cantitatea cerută, se va afișa „Investitorul [NUME] [PRENUME] nu are destule acțiuni [SIMBOL]. Diamond hands, dar portofel gol!“ și se va returna codul de eroare 1. În caz de succes, se scade cantitatea din portofoliu.
3. Creați un view care afișează pentru fiecare companie numărul de tranzacții efectuate, inclusiv pentru companiile la care nimeni nu a investit încă.

1 - 3.5 puncte
2 - 3 p
3 - 2 p

oficiu 1 p
prezentare 0.5 p
