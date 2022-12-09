-- Metadane, indeksowanie, przetwarzanie

--1a

insert into user_sdo_geom_metadata
values ('figury', 'ksztalt',
    mdsys.sdo_dim_array(
        mdsys.sdo_dim_element('X', 0, 10, 0.01),
        mdsys.sdo_dim_element('Y', 0, 10, 0.01)),
        null);

delete from user_sdo_geom_metadata
where user_sdo_geom_metadata.table_name = 'FIGURY';

select * from user_sdo_geom_metadata;


--1b

select sdo_tune.estimate_rtree_index_size(3000000, 8192, 10, 2, 0) FROM FIGURY;


--1c

create index figura_idx
on figury(ksztalt)
indextype is mdsys.spatial_index_v2;

drop index figura_idx;


--1d

select id from figury
where sdo_filter(ksztalt,
    sdo_geometry(2001, null, sdo_point_type(3, 3, null),
    null, null)) = 'TRUE';


--1e

select id from figury
where sdo_relate(ksztalt,
    sdo_geometry(2001, null, sdo_point_type(3, 3, null),
    null, null), 'mask=ANYINTERACT') = 'TRUE';


--2a

select city_name as miasto, sdo_nn_distance(1) as odl
from major_cities
where city_name != 'Warsaw' and
    sdo_nn(geom, 
        (select geom from major_cities
        where city_name = 'Warsaw'),
        'sdo_num_res=10 unit=km', 1) = 'TRUE';


--2b

select city_name as miasto
from major_cities
where city_name != 'Warsaw' and 
    sdo_within_distance(geom,
        (select geom from major_cities
        where city_name = 'Warsaw'),
        'distance=100 unit=km') = 'TRUE';


--2c

select cntry_name as kraj, city_name as miasto
from major_cities
where sdo_relate(geom,
    (select geom from country_boundaries
    where cntry_name = "Slovakia"),
    'mask=ANYINTERACT') = 'TRUE';


--2d

select cntry_name as panstwo, sdo_nn_distance(1) as odl
from country_boundaries
where cntry_name not like 'Poland' and
    sdo_nn(geom,
        (select geom from country_boundaries
        where cntry_name = 'Poland'),
        'unit=km', 1) = 'TRUE' and
    sdo_relate(geom,
        (select geom from country_boundaries
        where cntry_name = 'Poland'),
        'mask=TOUCH') = 'FALSE';


--3a

select cntry_name as panstwo, sdo_geom.sdo_area(geom, 1, 'unit=SQ_KM')
from country_boundaries
where cntry_name not like 'Poland' and
    sdo_relate(geom,
        (select geom from country_boundaries
        where cntry_name = 'Poland'),
        'mask=TOUCH') = 'TRUE';


--3b

select cntry_name as panstwo, sdo_geom.sdo_area(geom, 1, 'unit=SQ_KM')
from country_boundaries
where cntry_name not like 'Poland' and
    sdo_relate(geom,
        (select geom from country_boundaries
        where cntry_name = 'Poland'),
        'mask=TOUCH') = 'TRUE'
order by 2 desc
fetch next 1 rows only;


--3c

select sdo_geom.sdo_area(
    sdo_geom.sdo_mbr(
        sdo_geom.sdo_union(
            a.geom, b.geom, 0.01
        )
    ), 1, 'unit=SQ_KM'
) SQ_KM
from major_cities a, major_cities b
where a.city_name = 'Warsaw' and b.city_name = 'Lodz';


--3d

select sdo_geom.sdo_union(a.geom, b.geom, 0.01).get_dims() ||
    sdo_geom.sdo_union(a.geom, b.geom, 0.01).get_lrs_dim() ||
    lpad(sdo_geom.sdo_union(a.geom, b.geom, 0.01).get_gtype(), 2, '0') gtype
from country_boundaries a, major_cities b
where a.cntry_name = 'Poland' and b.city_name = 'Prague';


--3e

select b.city_name, a.cntry_name
from country_boundaries a, major_cities b
where a.city_name = b.city_name and 
    sdo_geom.sdo_distance(
        sdo_geom.sdo_centroid(a.geom, 1), b.geom, 1) = 
            (select min(sdo_geom.sdo_distance(
                sdo_geom.sdo_centroid(a.geom, 1), b.geom, 1))
            from country_boundaries a, major_cities b
            where a.cntry_name = b.cntry_name);


--3f

select name, round(sum(river_length), 2) dlugosc
from 
    (select b.name, sdo_geom.sdo_length(
        sdo_geom.sdo_intersection(a.geom, b.geom, 1),
         1, 'unit=KM') river_length
    from country_boundaries a, rivers b
    where sdo_relate(
        a.geom,
        sdo_geometry(
            2001,
            8307,
            b.geom.sdo_point,
            b.geom.sdo_elem_info,
            b.geom.sdo_ordinates), 
        'mask=ANYINTERACT') = 'TRUE' 
    and a.cntry_name = 'Poland')
group by name;