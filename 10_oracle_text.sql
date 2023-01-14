create table cytaty as select * from zsbd_tools.cytaty;


select * from cytaty;


select autor, tekst from cytaty
where upper(tekst) like '%OPTYMISTA%' and upper(tekst) like '%PESYMISTA%';

create index cytaty_idx on cytaty(tekst)
indextype is ctxsys.context;


select autor, tekst from cytaty
where contains(tekst, 'optymista and pesymista')>0;


select autor, tekst from cytaty
where contains(tekst, 'pesymista not optymista')>0;


select autor, tekst from cytaty
where contains(tekst, 'near((optymista, pesymista), 3)')>0;

select autor, tekst from cytaty
where contains(tekst, 'near((optymista, pesymista), 10)')>0;


select autor, tekst from cytaty
where contains(tekst, 'życi%')>0;


select autor, tekst, score(1) as dopasowanie from cytaty
where contains(tekst, 'życi%', 1)>0;


select autor, tekst, score(1) as dopasowanie from cytaty
where contains(tekst, 'życi%', 1)>0
order by score(1) desc
fetch first row only;

select autor, tekst from cytaty
where contains(tekst, '!probelm')>0;

insert into cytaty
values (39, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');

select autor, tekst from cytaty
where contains(tekst, 'głupcy')>0;


select * from dr$cytaty_idx$i where token_text='GŁUPCY';

drop index cytaty_idx;

create index cytaty_idx on cytaty(tekst)
indextype is ctxsys.context;

select * from dr$cytaty_idx$i where token_text='GŁUPCY';

select autor, tekst from cytaty
where contains(tekst, 'głupcy')>0;

drop index cytaty_idx;

drop table cytaty;

---

create table quotes as select * from zsbd_tools.quotes;

create index quotes_idx on quotes(text)
indextype is ctxsys.context;

select * from quotes
where contains(text, 'work')>0;

select * from quotes
where contains(text, '$work')>0;

select * from quotes
where contains(text, 'working')>0;

select * from quotes
where contains(text, '$working')>0;

select * from quotes
where contains(text, 'it')>0;

select * from ctx_stoplists;

select * from ctx_stopwords;

drop index quotes_idx;

create index quotes_idx on quotes(text)
indextype is ctxsys.context
parameters ('stoplist ctxsys.empty_stoplist');

select * from quotes
where contains(text, 'it')>0;

select * from quotes
where contains(text, 'fool and humans')>0;

select * from quotes
where contains(text, 'fool and computer')>0;


select * from quotes
where contains(text, '(fool and humans) within SENTENCE')>0;

drop index quotes_idx;

begin
ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;
/

create index quotes_idx on quotes(text)
indextype is ctxsys.context
parameters ('stoplist ctxsys.empty_stoplist
             section group nullgroup');

select * from quotes
where contains(text, '(fool and humans) within SENTENCE')>0;

select * from quotes
where contains(text, '(fool and computer) within SENTENCE')>0;

select * from quotes
where contains(text, 'humans')>0;

drop index quotes_idx;

begin
ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
ctx_ddl.set_attribute('lex_z_m',
'printjoins', '-');
ctx_ddl.set_attribute ('lex_z_m',
'index_text', 'YES');
end;
/

create index quotes_idx on quotes(text)
indextype is ctxsys.context
parameters ('stoplist ctxsys.empty_stoplist
             section group nullgroup
             LEXER lex_z_m');

select * from quotes
where contains(text, 'humans')>0;


select * from quotes
where contains(text, 'non\-humans')>0;


drop table quotes;



