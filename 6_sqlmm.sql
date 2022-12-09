--1a

select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;


--1b

select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;


--1c

create table myst_major_cities(
    fips_cntry varchar2(2),
    city_name varchar2(40),
    stgeom st_point);


--1d

insert into myst_major_cities
select fips_cntry, city_name, st_point(geom)
from major_cities;


--2a

insert into myst_major_cities
values('PL', 'Szczyrk', 
    st_point(sdo_geometry('POINT(19.036107 49.718655)', 8307)));


--2b

select name, geom.get_wkt() as wkt
from rivers;


--2c

select sdo_util.to_gmlgeometry(st_point.get_sdo_geom(stgeom)) gml
from myst_major_cities
where city_name = 'SZCZYRK';


--3a

create or replace table myst_country_boundaries(
    fips_cntry varchar2(2),
    cntry_name varchar2(40),
    stgeom st_multipolygon);


--3b

insert into myst_country_boundaries
select fips_cntry, cntry_name, st_multipolygon(geom)
from country_boundaries;


--3c

select b.stgeom.st_geometrytype() typ_obiektu, count(*) ile
from myst_country_boundaries b
group by b.stgeom.st_geometrytype();


--3d

select b.stgeom.st_issimple()
from myst_country_boundaries b;


--4a

select b.cntry_name, count(*)
from myst_country_boundaries b, myst_major_cities c
where b.stgeom.st_contains(c.stgeom) = 1
group by b.cntry_name;


--4b

select a.cntry_name as a_name, b.name as b_name
from myst_country_boundaries a, rivers b
where a.cntry_name = 'Czech Republic'
    and a.stgeom.st_touches((b.stgeom)) = 1;


--4c
select a.cntry_name, b.name
from myst_country_boundaries a, rivers b
where a.cntry_name = 'Czech Republic'
    and a.stgeom.st_intersects(st_linestring(b.geom)) = 1;


--4d

select sum(b.stgeom.st_area()) powierzchnia
from myst_country_boundaries b
where b.cntry_name = 'Czech Republic' or
    b.cntry_name = 'Slovakia';


--4e

select b.stgeom obiekt, 
    b.stgeom.st_difference(st_geometry(wb.geom))
        .st_geometrytype() wegry_bez
from water_bodies wb, myst_country_boundaries b
where b.cntry_name = 'Hungary' and wb.name = 'Balaton';


--5a/5d

explain plan for
select b.cntry_name a_name, count(*)
from myst_country_boundaries b, myst_major_cities c
where sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE'
    and b.cntry_name = 'Poland'
group by b.cntry_name

select plan_table_output from table(dbms_xplan.display);


--5b

insert into user_sdo_geom_metadata
select 'MYST_MAJOR_CITIES', 'STGEOM', t.diminfo, t.srid
from all_sdo_geom_metadata t
where t.table_name = 'MAJOR_CITIES';


--5c

create or replace index myst_major_cities_idx
on myst_major_cities(stgeom)
indextype is mdsys.spatial_index;

create or replace index myst_country_boundaries_idx
on myst_country_boundaries(stgeom)
indextype is mdsys.spatial_index;