--1

create type samochod as object (
   marka varchar2(20),
   model varchar2(20),
   kilometry number,
   data_produkcji date,
   cena number(10, 2)
   );

desc samochod;

create table samochody of samochod;

insert into samochody values
(new samochod('FIAT', 'BRAVA', 60000, date '1999-11-30', 25000));

insert into samochody values
(new samochod('FORD', 'MONDEO', 80000, date '1997-05-10', 45000));

insert into samochody values
(new samochod('MAZDA', '323', 12000, date '2000-09-22', 52000));

select * from samochody;

--2

create table wlasciciele(
    imie varchar2(100),
    nazwisko varchar2(100),
    auto samochod);
    

desc wlasciciele;

insert into wlasciciele values
('JAN','KOWALSKI', new samochod('FIAT','SEICENTO', 30000, date '0010-12-02', 19500));

insert into wlasciciele values
('ADAM', 'NOWAK', new samochod('OPEL', 'ASTRA', 34000, date '0009-06-01', 33700));

select * from wlasciciele;

--3

create or replace type body samochod as
   member function wartosc return number is
       x number := cena;
   begin
       for i in 1..(extract(year from current_date)-extract(year from data_produkcji)) loop
           x := x - 0.1*x;
       end loop;
       return x;
   end;
end;
;

select s.marka, s.cena, s.wartosc() from samochody s;

--4

alter type samochod replace as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2),
    member function wartosc return number,
    map member function odwzoruj return number
);


create or replace type body samochod as
   member function wartosc return number is
       x number := cena;
   begin
       for i in 1..(extract(year from current_date)-extract(year from data_produkcji)) loop
           x := x - 0.1*x;
       end loop;
       return x;
   end wartosc;
   map member function odwzoruj return number is
   begin
       return kilometry + 10000*(extract(year from current_date)-extract(year from data_produkcji));
   end;
end;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

--5

create type wlasciciel as object (
   imie varchar2(100),
   nazwisko varchar2(100));
   
alter type samochod add attribute posiadacz wlasciciel cascade;

select * from samochody;

update samochody 
set posiadacz = new wlasciciel('WOJTEK', 'MARCINIAK');

--6 

DECLARE
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    moje_przedmioty.TRIM(2);
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    moje_przedmioty.DELETE();
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--7

DECLARE
    TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
    moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
    moje_ksiazki(1) := 'ROBINSON CRUZOE';
    moje_ksiazki.EXTEND(9);
    FOR i IN 2..10 LOOP
        moje_ksiazki(i) := 'KSIAZKA_NR_' || i;
    END LOOP;
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    moje_ksiazki.TRIM(2);
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    moje_ksiazki.EXTEND();
    moje_ksiazki(9) := 9;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    moje_ksiazki.DELETE();
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

--8

DECLARE
    TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
    moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
    moi_wykladowcy.EXTEND(2);
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    moi_wykladowcy.EXTEND(8);
    FOR i IN 3..10 LOOP
        moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
    END LOOP;
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    moi_wykladowcy.TRIM(2);
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    moi_wykladowcy.DELETE(5,7);
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--9

DECLARE
    TYPE t_miesiace IS TABLE OF VARCHAR2(20);
    moje_miesiace t_miesiace := t_miesiace();
BEGIN
    moje_miesiace.EXTEND(12);
    moje_miesiace(1) := 'STYCZEN';
    moje_miesiace(2) := 'LUTY';
    moje_miesiace(3) := 'MARZEC';
    moje_miesiace(4) := 'KWIECIEN';
    moje_miesiace(5) := 'MAJ';
    moje_miesiace(6) := 'CZERWIEC';
    moje_miesiace(7) := 'LIPIEC';
    moje_miesiace(8) := 'SIERPIEN';
    moje_miesiace(9) := 'WRZESIEN';
    moje_miesiace(10) := 'PAZDZIERNIK';
    moje_miesiace(11) := 'LISTOPAD';
    moje_miesiace(12) := 'GRUDZIEN';
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
    END LOOP;
    moje_miesiace.TRIM(2);
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
    END LOOP;
    moje_miesiace.DELETE(5,7);
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
    FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
        IF moje_miesiace.EXISTS(i) THEN
        DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        END IF;
    END LOOP;
END;

--

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
    nazwa VARCHAR2(50),
    kraj VARCHAR2(30),
    jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
    numer NUMBER,
    egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

--11

CREATE TYPE koszyk_produktow_t AS TABLE OF VARCHAR2(20);

CREATE TYPE zakup AS OBJECT (
    name VARCHAR2(20),
    koszyk_produktow koszyk_produktow_t
);

CREATE TABLE zakupy OF zakup
NESTED TABLE koszyk_produktow STORE AS tab_koszyk_produktow;

INSERT INTO zakupy VALUES
(zakup('Zakup1', koszyk_produktow_t('Klocki Lego', 'Pralka', 'Telewizor')));
INSERT INTO zakupy VALUES
(zakup('Zakup2', koszyk_produktow_t('Wędliny', 'Jajka', 'Majonez')));

SELECT z.name, k.*
FROM zakupy z, TABLE (z.koszyk_produktow) k;

SELECT k.*
FROM zakupy z, TABLE (z.koszyk_produktow) k;

SELECT * FROM TABLE 
(SELECT z.koszyk_produktow FROM zakupy z WHERE z.name LIKE 'Zakup2');

INSERT INTO TABLE 
(SELECT z.koszyk_produktow FROM zakupy z WHERE z.name LIKE 'Zakup1')
VALUES ('Kosiarka');

UPDATE TABLE ( SELECT z.koszyk_produktow FROM zakupy z WHERE z.name LIKE 'Zakup1') k
SET k.column_value = 'Radio'
WHERE k.column_value = 'Telewizor';

DELETE FROM TABLE ( SELECT k.koszyk_produktow FROM zakupy z WHERE z.name LIKE 'Zakup2' ) k
WHERE e.column_value = 'Wędliny';

--22

CREATE TYPE PISARZ AS OBJECT (
 ID_PISARZA NUMBER,
 NAZWISKO VARCHAR2(20),
 DATA_UR DATE,
 KSIAZKI KSIAZKI_T,
 MEMBER FUNCTION ILE_KSIAZEK RETURN NUMBER
);

CREATE TYPE KSIAZKA AS OBJECT (
 ID_KSIAZKI NUMBER,
 PISARZ REF PISARZ,
 TYTUL VARCHAR2(50),
 DATA_WYDANIE DATE,
 MEMBER FUNCTION WIEK RETURN NUMBER
);


CREATE OR REPLACE TYPE BODY PISARZ AS
 MEMBER FUNCTION ILE_KSIAZEK RETURN NUMBER IS
 BEGIN
    RETURN KSIAZKI.COUNT();
 END ILE_KSIAZEK;
END;

CREATE OR REPLACE TYPE BODY KSIAZKA AS
 MEMBER FUNCTION WIEK RETURN NUMBER IS
 BEGIN
 RETURN EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM DATA_WYDANIE);
 END WIEK;
END;

CREATE OR REPLACE VIEW KSIAZKI_V OF KSIAZKI
WITH OBJECT IDENTIFIER (ID_KSIAZKI)
AS SELECT ID_KSIAZKI, MAKE_REF(PISARZE_V, ID_PISARZA), TYTUL, DATA_WYDANIA
FROM KSIAZKA;

CREATE OR REPLACE VIEW PISARZE_V OF PISARZ
WITH OBJECT IDENTIFIER (ID_PISARZA)
AS SELECT ID_PISARZA, NAZWISKO, DATA_UR, 
    CAST(MULTISET(SELECT NEW KSIAZKA(
        ID_KSIAZKI, PISARZ, TYTUL, DATA_WYDANIE))) 
        FROM KSIAZKI WHERE PISARZ LIKE P AS KSIAZKI
FROM PISARZ P;

--23

CREATE TYPE AUTO AS OBJECT (
 MARKA VARCHAR2(20),
 MODEL VARCHAR2(20),
 KILOMETRY NUMBER,
 DATA_PRODUKCJI DATE,
 CENA NUMBER(10,2),
 MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE TYPE AUTO_OSOBOWE UNDER AUTO (
    LICZBA_MIEJSC NUMBER,
    KLIMATYZACJA BOOLEAN,
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE TYPE AUTO_CIEZAROWE UNDER AUTO (
    LADOWNOSC NUMBER,
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AUTO AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WIEK NUMBER;
 WARTOSC NUMBER;
 BEGIN
  WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
  WARTOSC := CENA - (WIEK * 0.1 * CENA);
  IF (WARTOSC < 0) THEN
   WARTOSC := 0;
  END IF;
  RETURN WARTOSC;
 END WARTOSC;
END;

CREATE OR REPLACE TYPE BODY AUTO_OSOBOWE AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WARTOSC NUMBER;
 BEGIN
  WARTOSC := (self AS AUTO).WARTOSC();
  IF (KLIMATYZACJA) THEN
   WARTOSC := WARTOSC * 1.5;
  END IF;
  RETURN WARTOSC;
 END WARTOSC;
END;

CREATE OR REPLACE TYPE BODY AUTO_CIEZAROWE AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WARTOSC NUMBER;
 BEGIN
  WARTOSC := (self AS AUTO).WARTOSC();
  IF (LADOWNOSC > 10) THEN
   WARTOSC := WARTOSC * 2;
  END IF;
  RETURN WARTOSC;
 END WARTOSC;
END;

CREATE TABLE AUTA OF AUTO;
INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));
INSERT INTO AUTA VALUES (AUTO_OSOBOWE('FIAT', 'PUNTO', 60000, DATE '1999-11-30', 25000, 2, TRUE));
INSERT INTO AUTA VALUES (AUTO_OSOBOWE('MAZDA', '324', 60000, DATE '1999-11-30', 25000, 4, FALSE));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('VOLVO', 'X', 60000, DATE '1999-11-30', 25000, 2));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('VOLVO', 'Y', 60000, DATE '1999-11-30', 25000, 12));


select s.marka, s.wartosc() from auta;