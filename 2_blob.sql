--1

create table movies(
    id number(12) primary key,
    title varchar2(400) not null, 
    category varchar2(50),
    year char(4),
    cast varchar2(4000),
    director varchar2(4000),
    story varchar2(4000),
    price number(5, 2),
    cover blob,
    mime_type varchar2(50));
    
    
--2

insert into movies(id, title, category, year, cast, story, price, cover, mime_type)
(select id, title, category, substr(year, 0, 4), cast, story, price, image, mime_type
from descriptions left outer join covers on descriptions.id = covers.movie_id);


--3 

select id, title from movies where cover is null;

    
--4   

select id, title, DBMS_LOB.getlength(cover) as filesize from movies
where cover is not null;


--5

select id, title, DBMS_LOB.getlength(cover) as filesize from movies
where cover is null;


--6

select directory_name, directory_path from all_directories;


--7

update movies
set cover = EMPTY_BLOB()
where id = 66;

update movies
set mime_type = 'image/jpeg'
where id = 66;


--8

select id, title, DBMS_LOB.getlength(cover) as filesize from movies
where id = 65 or id = 66;


--9

DECLARE
    lob blob;
    fil BFILE := bfilename('ZSBD_DIR','escape.jpg');
BEGIN
    dbms_lob.fileopen(fil);
    select cover into lob
    from movies
    where id = 66
    for update;
    dbms_lob.loadfromfile(lob, fil, dbms_lob.getlength(fil));
    dbms_lob.fileclose(fil);
    commit;
END;
/

select dbms_lob.getlength(cover) from movies where id=66;


--10

create table temp_covers(
    movie_id number(12),
    image bfile,
    mime_type varchar2(50));
    

--11

insert into temp_covers
values(65, bfilename('ZSBD_DIR', 'eagles.jpg'), 'image/jpeg');


--12

select movie_id, dbms_lob.getlength(image) from temp_covers;


--13

DECLARE
    lob blob;
    mimetype varchar2(50);
    fil bfile;
BEGIN
    select image into fil
    from temp_covers
    where movie_id=65
    for update;
    select mime_type into mimetype
    from temp_covers
    where movie_id=65
    for update;
    
    dbms_lob.createtemporary(lob, TRUE);
    
    DBMS_LOB.fileopen(fil, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lob,fil,DBMS_LOB.GETLENGTH(fil));
    DBMS_LOB.FILECLOSE(fil);
    
    update movies
    set cover = lob
    where id=65;
    update movies
    set mime_type = mimetype
    where id=65;
    
    dbms_lob.freetemporary(lob);
    COMMIT;
END;
/


--14

select id, DBMS_LOB.getlength(cover) as filesize from movies
where id = 65 or id = 66;


--15

drop table temp_covers;
drop table movies;
















