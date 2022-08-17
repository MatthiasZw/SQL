-- Magic Abfragen von:https://dataedo.com/kb/query/sql-server


--1. Foreign keys: row per column

select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
    '>-' as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table,
    fk_cols.constraint_column_id as no, 
    fk_col.name as fk_column_name,
    ' = ' as [join],
    pk_col.name as pk_column_name,
    fk.name as fk_constraint_name
from sys.foreign_keys fk
    inner join sys.tables fk_tab
        on fk_tab.object_id = fk.parent_object_id
    inner join sys.tables pk_tab
        on pk_tab.object_id = fk.referenced_object_id
    inner join sys.foreign_key_columns fk_cols
        on fk_cols.constraint_object_id = fk.object_id
    inner join sys.columns fk_col
        on fk_col.column_id = fk_cols.parent_column_id
        and fk_col.object_id = fk_tab.object_id
    inner join sys.columns pk_col
        on pk_col.column_id = fk_cols.referenced_column_id
        and pk_col.object_id = pk_tab.object_id
order by schema_name(fk_tab.schema_id) + '.' + fk_tab.name,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name, 
    fk_cols.constraint_column_id

--2. Foreign keys: row per key

	select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
    '>-' as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table,
    substring(column_names, 1, len(column_names)-1) as [fk_columns],
    fk.name as fk_constraint_name
from sys.foreign_keys fk
    inner join sys.tables fk_tab
        on fk_tab.object_id = fk.parent_object_id
    inner join sys.tables pk_tab
        on pk_tab.object_id = fk.referenced_object_id
    cross apply (select col.[name] + ', '
                    from sys.foreign_key_columns fk_c
                        inner join sys.columns col
                            on fk_c.parent_object_id = col.object_id
                            and fk_c.parent_column_id = col.column_id
                    where fk_c.parent_object_id = fk_tab.object_id
                      and fk_c.constraint_object_id = fk.object_id
                            order by col.column_id
                            for xml path ('') ) D (column_names)
order by schema_name(fk_tab.schema_id) + '.' + fk_tab.name,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name

	--3. All columns and their FKs (if present)

	select schema_name(tab.schema_id) + '.' + tab.name as [table],
    col.column_id,
    col.name as column_name,
    case when fk.object_id is not null then '>-' else null end as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table,
    pk_col.name as pk_column_name,
    fk_cols.constraint_column_id as no,
    fk.name as fk_constraint_name
from sys.tables tab
    inner join sys.columns col 
        on col.object_id = tab.object_id
    left outer join sys.foreign_key_columns fk_cols
        on fk_cols.parent_object_id = tab.object_id
        and fk_cols.parent_column_id = col.column_id
    left outer join sys.foreign_keys fk
        on fk.object_id = fk_cols.constraint_object_id
    left outer join sys.tables pk_tab
        on pk_tab.object_id = fk_cols.referenced_object_id
    left outer join sys.columns pk_col
        on pk_col.column_id = fk_cols.referenced_column_id
        and pk_col.object_id = fk_cols.referenced_object_id
order by schema_name(tab.schema_id) + '.' + tab.name,
    col.column_id

	--4. All tables referenced by specific table

	select distinct 
    schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
    '>-' as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table
from sys.foreign_keys fk
    inner join sys.tables fk_tab
        on fk_tab.object_id = fk.parent_object_id
    inner join sys.tables pk_tab
        on pk_tab.object_id = fk.referenced_object_id
where fk_tab.[name] = 'Your table' -- enter table name here
--  and schema_name(fk_tab.schema_id) = 'Your table schema name'
order by schema_name(fk_tab.schema_id) + '.' + fk_tab.name,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name


--5. All tables referencing specific table

	select distinct 
    schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
    '>-' as rel,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table
from sys.foreign_keys fk
    inner join sys.tables fk_tab
        on fk_tab.object_id = fk.parent_object_id
    inner join sys.tables pk_tab
        on pk_tab.object_id = fk.referenced_object_id
where pk_tab.[name] = 'Your table' -- enter table name here
--  and schema_name(pk_tab.schema_id) = 'Your table schema name'
order by schema_name(fk_tab.schema_id) + '.' + fk_tab.name,
    schema_name(pk_tab.schema_id) + '.' + pk_tab.name

	
	--List all primary keys (PKs) in SQL Server database

	select schema_name(tab.schema_id) as [schema_name], 
    pk.[name] as pk_name,
    substring(column_names, 1, len(column_names)-1) as [columns],
    tab.[name] as table_name
from sys.tables tab
    inner join sys.indexes pk
        on tab.object_id = pk.object_id 
        and pk.is_primary_key = 1
   cross apply (select col.[name] + ', '
                    from sys.index_columns ic
                        inner join sys.columns col
                            on ic.object_id = col.object_id
                            and ic.column_id = col.column_id
                    where ic.object_id = tab.object_id
                        and ic.index_id = pk.index_id
                            order by col.column_id
                            for xml path ('') ) D (column_names)
order by schema_name(tab.schema_id),
    pk.[name]

	--List all primary keys (PKs) and their columns in SQL Server database

	select schema_name(tab.schema_id) as [schema_name], 
    pk.[name] as pk_name,
    ic.index_column_id as column_id,
    col.[name] as column_name, 
    tab.[name] as table_name
from sys.tables tab
    inner join sys.indexes pk
        on tab.object_id = pk.object_id 
        and pk.is_primary_key = 1
    inner join sys.index_columns ic
        on ic.object_id = pk.object_id
        and ic.index_id = pk.index_id
    inner join sys.columns col
        on pk.object_id = col.object_id
        and col.column_id = ic.column_id
order by schema_name(tab.schema_id),
    pk.[name],
    ic.index_column_id

--List tables with their primary keys (PKs) in SQL Server database

	select schema_name(tab.schema_id) as [schema_name], 
    tab.[name] as table_name, 
    pk.[name] as pk_name,
    substring(column_names, 1, len(column_names)-1) as [columns]
from sys.tables tab
    left outer join sys.indexes pk
        on tab.object_id = pk.object_id 
        and pk.is_primary_key = 1
   cross apply (select col.[name] + ', '
                    from sys.index_columns ic
                        inner join sys.columns col
                            on ic.object_id = col.object_id
                            and ic.column_id = col.column_id
                    where ic.object_id = tab.object_id
                        and ic.index_id = pk.index_id
                            order by col.column_id
                            for xml path ('') ) D (column_names)
order by schema_name(tab.schema_id),
    tab.[name]

	--Find tables without primary keys (PKs) in SQL Server database 

	select schema_name(tab.schema_id) as [schema_name], 
    tab.[name] as table_name
from sys.tables tab
    left outer join sys.indexes pk
        on tab.object_id = pk.object_id 
        and pk.is_primary_key = 1
where pk.object_id is null
order by schema_name(tab.schema_id),
    tab.[name]

	
	--List tables with most relationships in SQL Server database

select tab as [table],
    count(distinct rel_name) as relationships,
    count(distinct fk_name) as foreign_keys,
    count(distinct ref_name) as [references],
    count(distinct rel_object_id) as related_tables,
    count(distinct referenced_object_id) as referenced_tables,
    count(distinct parent_object_id) as referencing_tables
from 
    (select schema_name(tab.schema_id) + '.' + tab.name as tab,
        fk.name as rel_name,
        fk.referenced_object_id as rel_object_id,
        fk.name as fk_name,
        fk.referenced_object_id,
        null as ref_name,
        null as parent_object_id
    from sys.tables as tab
        left join sys.foreign_keys as fk
            on tab.object_id = fk.parent_object_id
    union all
    select schema_name(tab.schema_id) + '.' + tab.name as tab,
        fk.name as rel_name,
        fk.parent_object_id as rel_object_id,
        null as fk_name,
        null as referenced_object_id,
        fk.name as ref_name,
        fk.parent_object_id
    from sys.tables as tab
        left join sys.foreign_keys as fk
            on tab.object_id = fk.referenced_object_id) q
group by tab
order by count(distinct rel_name) desc

-- Find tables without foreign keys in SQL Server database

select schema_name(fk_tab.schema_id) as schema_name,
    fk_tab.name as table_name,
    '>- no FKs' foreign_keys
from sys.tables fk_tab
    left outer join sys.foreign_keys fk
        on fk_tab.object_id = fk.parent_object_id
where fk.object_id is null
order by schema_name(fk_tab.schema_id),
    fk_tab.name

	--Find tables that are not referenced by the foreign keys in SQL Server database

	select 'No FKs >-' foreign_keys,
    schema_name(fk_tab.schema_id) as schema_name,
    fk_tab.name as table_name
from sys.tables fk_tab
    left outer join sys.foreign_keys fk
        on fk_tab.object_id = fk.referenced_object_id
where fk.object_id is null
order by schema_name(fk_tab.schema_id),
    fk_tab.name


	--Find tables without relationships - Loner Tables - in SQL Server database 

select 'No FKs >-' refs,
    fks.tab as [table],
    '>- no FKs' fks
 from
    (select schema_name(tab.schema_id) + '.' + tab.name as tab,
        count(fk.name) as fk_cnt
    from sys.tables as tab
        left join sys.foreign_keys as fk
            on tab.object_id = fk.parent_object_id
    group by schema_name(tab.schema_id), tab.name) fks
    inner join 
    (select schema_name(tab.schema_id) + '.' + tab.name as tab,
        count(fk.name) ref_cnt
    from sys.tables as tab
        left join sys.foreign_keys as fk
            on tab.object_id = fk.referenced_object_id
    group by schema_name(tab.schema_id), tab.name) refs
    on fks.tab = refs.tab
where fks.fk_cnt + refs.ref_cnt = 0

--List objects that use specific object in SQL Server database

select schema_name(obj.schema_id) +  '.' + obj.name
        + case when referenced_minor_id = 0 then ''
               else '.' + col.name end as referenced_object,
       'referenced by' as 'ref',
       schema_name(ref_obj.schema_id) as referencing_schema,
       ref_obj.name as referencing_object_name,
       case when ref_obj.type_desc = 'USER_TABLE' 
                 and dep.referencing_minor_id != 0
            then 'COLUMN'
            else ref_obj.type_desc end as referencing_object_type,
       ref_col.name as referencing_column
from sys.sql_expression_dependencies dep
join sys.objects obj
     on obj.object_id = dep.referenced_id
left join sys.columns col
     on col.object_id = dep.referenced_id
     and col.column_id = dep.referenced_minor_id
join sys.objects ref_obj
     on ref_obj.object_id = dep.referencing_id
left join sys.columns ref_col
     on ref_col.object_id = dep.referencing_id
     and ref_col.column_id = dep.referencing_minor_id
where schema_name(obj.schema_id) = 'Sales'  -- put object schema name here
      and obj.name = 'SalesOrderHeader'     -- put object name here
order by referencing_schema,
         referencing_object_name;


--Find objects used by specific function in SQL Server database

		 select schema_name(obj.schema_id) as schema_name,
       obj.name as function_name,
       schema_name(dep_obj.schema_id) as referenced_object_schema,
       dep_obj.name as referenced_object_name,
       dep_obj.type_desc as object_type
FROM sys.objects obj
left join sys.sql_expression_dependencies dep
     on dep.referencing_id = obj.object_id
left join sys.objects dep_obj
     on dep_obj.object_id = dep.referenced_id
where obj.type in ('AF', 'FN', 'FS', 'FT', 'IF', 'TF')
     -- and obj.name = 'function_name'  -- put function name here
order by schema_name,
         function_name;


--- Find objects used by specific stored procedure in SQL Server database


select schema_name(obj.schema_id) as schema_name,
       obj.name as procedure_name,
       schema_name(dep_obj.schema_id) as referenced_object_schema,
       dep_obj.name as referenced_object_name,
       dep_obj.type_desc as object_type
from sys.objects obj
left join sys.sql_expression_dependencies dep
          on dep.referencing_id = obj.object_id
left join sys.objects dep_obj
          on dep_obj.object_id = dep.referenced_id
where obj.type in ('P', 'X', 'PC', 'RF')
    --  and obj.name = 'procedure_name'  -- put procedure name here
order by schema_name,
         procedure_name;

		 
---		 Find where specific table or view is used in SQL Server database


select schema_name(o.schema_id) + '.' + o.name as [table],
       'is used by' as ref,
       schema_name(ref_o.schema_id) + '.' + ref_o.name as [object],
       ref_o.type_desc as object_type
from sys.objects o
join sys.sql_expression_dependencies dep
     on o.object_id = dep.referenced_id
join sys.objects ref_o
     on dep.referencing_id = ref_o.object_id
where o.type in ('V', 'U')
      and schema_name(o.schema_id) = 'Person'  -- put schema name here
      and o.name = 'Person'   -- put table/view name here
order by [object]



--- Find where specific function is used in SQL Server database


select schema_name(o.schema_id) + '.' + o.name as [function],
       'is used by' as ref,
       schema_name(ref_o.schema_id) + '.' + ref_o.name as [object],
       ref_o.type_desc as object_type
from sys.objects o
join sys.sql_expression_dependencies dep
     on o.object_id = dep.referenced_id
join sys.objects ref_o
     on dep.referencing_id = ref_o.object_id
where o.type in ('FN', 'TF', 'IF')
      and schema_name(o.schema_id) = 'dbo'  -- put schema name here
      and o.name = 'ufnLeadingZeros'  -- put function name here
order by [object];



--- Find where specific stored procedure is used in SQL Server database


select schema_name(o.schema_id) + '.' + o.name as [procedure],
       'is used by' as ref,
       schema_name(ref_o.schema_id) + '.' + ref_o.name as [object],
       ref_o.type_desc as object_type
from sys.objects o
join sys.sql_expression_dependencies dep
     on o.object_id = dep.referenced_id
join sys.objects ref_o
     on dep.referencing_id = ref_o.object_id
where o.type in ('P', 'X')
      and schema_name(o.schema_id) = 'dbo'  -- put schema name here
      and o.name = 'uspPrintError'  -- put procedure name here
order by [object];


---Find tables with specific word in name in SQL Server database

select schema_name(t.schema_id) as schema_name,
       t.name as table_name
from sys.tables t
where t.name like '%product%'
order by table_name,
         schema_name;

		 
		 ---Find tables with digits in names in SQL Server database


select schema_name(t.schema_id) as schema_name,
       t.name as table_name
from sys.tables t
where t.name like '%[0-9]%'
order by schema_name,
         table_name;


  
		---Find tables with specific column name in SQL Server database


select schema_name(t.schema_id) as schema_name,
       t.name as table_name
from sys.tables t
where t.object_id in 
    (select c.object_id 
      from sys.columns c
     where c.name = 'ProductID')
order by schema_name,
         table_name;