--1a

create table A6_LRS(
    GEOM SDO_GEOMETRY);
    
--1b

insert into A6_LRS
select sr.geom from streets_and_railroads sr, major_cities c
where sdo_relate(sr.geom,
    sdo_geom.sdo_buffer(c.geom, 10, 1, 'unit=km'),
    'MASK=ANYINTERACT') = 'TRUE'
and c.city_name = 'Koszalin';

--1c

select st_linestring(a.geom).st_numpoints() st_numpoints from A6_LRS a;

--1d
--skrot f5 do uruchomienia jako skrypt

update A6_lrs
set geom = sdo_lrs.convert_to_lrs_geom(geom, 0, 276.681);


select * from A6_LRS;

--1e

insert into user_sdo_geom_metadata
values ('A6_LRS', 'GEOM',
mdsys.sdo_dim_array(
    mdsys.sdo_dim_element('X', 12.603676, 26.369824, 1),
    mdsys.sdo_dim_element('Y', 45.8464, 58.0213, 1),
    mdsys.sdo_dim_element('M', 0, 300, 1)),
    8307);
    
--1f
create index lrs_routes_idx ON A6_LRS(geom) 
indextype is mdsys.spatial_index;

--2a
select sdo_lrs.valid_measure(geom, 500) valid_500 from A6_LRS;

--2b
select sdo_lrs.geom_segment_end_pt(geom) end_pt from A6_LRS;

--2c
select sdo_lrs.locate_pt(geom, 150, 0) km150 from A6_LRS;

--2d
select SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160) CLIPPED from A6_LRS;

--2e
select sdo_lrs.get_next_shape_pt(a6.geom, sdo_lrs.project_pt(a6.geom, c.geom)) from a6_lrs a6, major_cities c where c.city_name = 'Slupsk';

--2f
select 
sdo_geom.sdo_length(
SDO_LRS.OFFSET_GEOM_SEGMENT(A6.GEOM, M.DIMINFO, 50, 200, 50, 'unit=m arc_tolerance=0.05'), 1, 'unit=km') koszt
from A6_LRS A6, USER_SDO_GEOM_METADATA M
where M.TABLE_NAME = 'A6_LRS' and M.COLUMN_NAME = 'GEOM'