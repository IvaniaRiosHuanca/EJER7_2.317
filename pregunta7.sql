set identity_insert colegio.dbo.EstudianteS ON

-- cada vez que se inserte se debe notificar
-- flujo -- como colegio es el esclavo
insert into colegio.dbo.Estudiantes(EstudianteID, Nombre, Apellido, Email)
select EstudianteID, Nombre, Apellido, Email
from Academia.dbo.Estudiantes
where EstudianteID not in(select EstudianteID from colegio.dbo.Estudiantes)

set identity_insert colegio.dbo.Estudiantes OFF
-- hasta aca queda la copia sencilla
-- donde no hay problemas de id


-- que pasa si hay cambios en los datos menos en el id
update Academia.dbo.Estudiantes set Nombre = 'pruebgedit' where EstudianteID = 12;
update Academia.dbo.Estudiantes set Nombre = 'pruebFedit' where EstudianteID = 11;

insert into Academia.dbo.Estudiantes(EstudianteID, Nombre, Apellido, Email)
values(12, 'pruebg', 'pruebg', 'pg@g.com')

-- podemos declarar un procedimiento
declare @sql nvarchar(2000)
set @sql = 'select * from Academia.dbo.Estudiantes'
exec sp_executesql @sql

-- pasamos a la declaracion
declare 
	@sql nvarchar(2000),
	@cantidad int,
	@id1 int,
	@id2 int,
	@nombre1 varchar(50),
	@nombre2 varchar(50),
	@maximo int, 
	@pos int


DECLARE @cantidad INT;
DECLARE @pos INT = 0;
DECLARE @id1 INT, @id2 INT;
DECLARE @nombre1 NVARCHAR(100), @nombre2 NVARCHAR(100);
DECLARE @sql NVARCHAR(2000);

SELECT @cantidad = MAX(EstudianteID) FROM Academia.dbo.Estudiantes;

WHILE @pos <= @cantidad
BEGIN
    SELECT @id1 = EstudianteID, @nombre1 = nombre FROM colegio.dbo.Estudiantes WHERE EstudianteID = @pos;
    SELECT @id2 = EstudianteID, @nombre2 = nombre FROM Academia.dbo.Estudiantes WHERE EstudianteID = @pos;

    IF @nombre1 <> @nombre2 AND @id1 = @pos
    BEGIN
        SET @sql = 'UPDATE colegio.dbo.Estudiantes SET Nombre = ''' + @nombre2 + ''' WHERE EstudianteID = ' + CAST(@pos AS NVARCHAR(5)) + ';';
        EXEC sp_executesql @sql;
    END
    
    SET @pos = @pos + 1;
END;


-- master
select * from Academia.dbo.Estudiantes

--slave
select * from colegio.dbo.Estudiantes



-- OTRA FORMA
/*
	DECLARE @sql NVARCHAR(MAX);

-- Construir la consulta din�mica para actualizar los nombres en la tabla esclava
SET @sql = '
    UPDATE colegio.dbo.Estudiantes
    SET Nombre = a.Nombre
    FROM Academia.dbo.Estudiantes a
    WHERE colegio.dbo.Estudiantes.EstudianteID = a.EstudianteID
    AND colegio.dbo.Estudiantes.Nombre <> a.Nombre;
';

-- Ejecutar la consulta din�mica
EXEC sp_executesql @sql;

*/




/* POSTGRESQL
DO $$
DECLARE
    sql_query TEXT;
BEGIN
    sql_query := 'SELECT * FROM Academia.Estudiantes;';
    EXECUTE sql_query;
END $$;
*/