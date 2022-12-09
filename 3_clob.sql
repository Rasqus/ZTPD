--1

create table dokumenty(
    id number(12) primary key,
    dokument clob)
  

--2

declare 
    buf nvarchar2(12);
    doc clob;
begin
    buf := 'Oto tekst. ';
    dbms_lob.createtemporary(doc, TRUE);
    for i in 1..10000 loop
        dbms_lob.writeappend(doc, 11, buf);
    end loop;
    --dbms_lob.write(doc, txt);
    insert into dokumenty
    values (1, doc);
    dbms_lob.freetemporary(doc);
end;
/

--3/6

select * from dokumenty;

select upper(dokument) from dokumenty;

select length(dokument) from dokumenty;

select dbms_lob.getlength(dokument) from dokumenty;

select substr(dokument, 5, 1000) from dokumenty;

select dbms_lob.substr(dokument, 1000, 5) from dokumenty;


--4

insert into dokumenty
values (2, empty_clob());


--5

insert into dokumenty
values(3, null);

commit;


--7

select directory_name, directory_path from all_directories;


--8

declare
    lob clob;
    fil bfile := bfilename('ZSBD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
begin
    select dokument into lob
    from dokumenty
    where id=2
    for update;
    DBMS_LOB.fileopen(fil, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lob, fil, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 0, langctx, warn); -- 873 to utf-8
    DBMS_LOB.FILECLOSE(fil);
    commit;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;
/


--9

update dokumenty
set dokument = to_clob(bfilename('ZSBD_DIR','dokument.txt'))
where id = 3;


--10

select * from dokumenty;


--11

select dbms_lob.getlength(dokument) from dokumenty;


--12

drop table dokumenty;


--13

create procedure clob_censor(
    clob_in in out clob, 
    txt_to_replace in varchar2
)
is
    position number := 0;
    txt_to_write varchar2(1) := '.'
begin
    position := INSTR(clob_in, txt_to_replace);
    while position > 0
    loop
        for i in 1..length(txt_to_replace)
        loop
            dbms_lob.write(clob_in, 1, position + i - 1, txt_to_write);
        end loop;
        position := instr(clob_in, txt_to_replace)
    end loop;
end;
    

--14

create table biographies as 
select * from zsbd_tools.biographies;

declare
    lob clob;
begin
    select bio 
    into lob
    from biographies
    for update;
    clob_censor(lob, 'Cimrman');
    commit;
end;

--15

drop table biographies;

