create procedure SOPROAUTPRO(
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/************************************************************************************
**	Autor: Héctor Silva López										***
**	Fecha: 02/03/2015												***
**	Descripción: Agregamos condición en select a SOTMPMAT   	***
**  Requisición: 	739123											***
*************************************************************************************/
/************************************************************************************
**	Autor: Héctor Silva López										***
**	Fecha: 13/02/2015												***
**	Descripción: Agregamos truncate a SOPRORES para no duplicar información   	***
**  Requisición: 	739123											***
*************************************************************************************/
/************************************************************************************
**	Autor: Héctor Silva López										***
**	Fecha: 06/02/2015												***
**	Descripción: Modificación de Stored Para guardar Bitácora   	***
**  Requisición: 739123												***
*************************************************************************************/
/************************************************************************************
**	Autor: Héctor Silva López										***
**	Fecha: 13/05/2014												***
**	Descripción: Stored Procedure que ejecuta los procesos matutinos 	***
**				 que requiere Soporte Aplicaciones para seguimiento	***
**  Requisición: 721650												***
*************************************************************************************/

/*Declaración de Variables */
declare	@FecAct			varchar(8),
		@Contador		integer,
		@Contador2		integer,
		@Sta_Activa 	integer,
		@Proceso		varchar(11),
		@Vacio			char(1),
		@cadena			varchar(200),
		@Par1			varchar(20),
		@Par2			varchar(20),
		@Par3			varchar(20),
		@Par4			varchar(20),
		@Par5			varchar(20),
		@Par6			varchar(20),
		@Par7			varchar(20),
		@Parametros 	varchar(255),
		@Fecha			smalldatetime,
		@Fecha1			varchar(8),
		@Fecha2			varchar(8),
		@FechaMesAnt	varchar(8),
		@FecAnt			varchar(8),
		@FecCor			varchar(8),
		@FechaStr   	varchar(5),
		@FechaAnt		varchar(8),	
		@FechaCor		varchar(8),
		@NumDia 		integer,
		@FinSem 		char(1),
		@Salida_Fox 	char(1),
		@Reporte		char(7),
		@TipoD			char(1),
		@EntUno			integer,
		@Status			int,
		@Texto			Varchar(8000),
		@Longitud		int,
		@Posicion		int,
		@NoCampo		int ,
		@RegIni 		int,
		@RegIni2 		int,
		@RegFin 		int,
		@Procedimiento 	varchar(11),
		@NoCampo2		int ,
		@Campos 		varchar(11),
		@Texto2			varchar(8000),
		@Longitud2		int,
		@Posicion2		int,
		@Sucursal		varchar(8),
		@Todas			varchar(3),
		@Mes			varchar(2),
		@MesAnt			varchar(6),
		@Corte7			int,
		@Corte14		int,
		@Corte19		int,
		@Corte21		int,
		@Corte25		int,
		@Corte31		int,
		@FecCorte7		varchar(2),
		@FecCorte14		varchar(2),
		@FecCorte19		varchar(2),
		@FecCorte21		varchar(2),
		@FecCorte25		varchar(2),
		@FecCorte31		varchar(2),
		@ActFecha		smalldatetime,
		@IntTran		int

select 	@Sta_Activa = 1,
		@Contador 	= 0,
		@Vacio		= '',
		@FechaStr	= 'Fecha',
		@FechaAnt	= 'FechaAnt',
		@Reporte	= 'Reporte',
		@Sucursal	= 'Sucursal',
		@FechaCor	= 'FechaCor',
		@Todas		= 'TOD',
		@TipoD		= 'D',
		@EntUno		= 1,
		@Posicion	= 0,
		@Posicion2	= 0,
		@NoCampo	= 1,
		@NoCampo2	= 1,
		@RegIni		= 1,
		@RegIni2	= 1,
		@Corte7		= 7,
		@Corte14	= 14,
		@Corte19	= 19,
		@Corte21	= 21,
		@Corte25	= 25,
		@Corte31	= 31,
		@FecCorte7	= '07',
		@FecCorte14	= '14',
		@FecCorte19	= '19',
		@FecCorte21	= '21',
		@FecCorte25	= '25',
		@IntTran	= 1000000000
		
select 	@Fecha		= convert(varchar(8),@FechaSis,112)
select 	@Fecha1		= convert(varchar(8),@FechaSis,112)
select 	@Fecha2 	= 	convert(varchar(8),getdate(),112)


select @Mes = case 	when datepart(mm,@Fecha2) = 1 then '01'
					when datepart(mm,@Fecha2) = 2 then '02'
					when datepart(mm,@Fecha2) = 3 then '03'
					when datepart(mm,@Fecha2) = 4 then '04'
					when datepart(mm,@Fecha2) = 5 then '05'
					when datepart(mm,@Fecha2) = 6 then '06'
					when datepart(mm,@Fecha2) = 7 then '07'	
					when datepart(mm,@Fecha2) = 8 then '08'
					when datepart(mm,@Fecha2) = 9 then '09'		
				else convert(varchar(2),datepart(mm,@Fecha2))
		end 	
		
select @MesAnt = substring(convert(varchar(8),dateadd(mm,-1,@Fecha2),112),1,6)

select 
	@FecCor = case when convert(int,datepart(dd,@Fecha2))< @Corte7 then convert(varchar(8), @MesAnt + @FecCorte25)
		 when convert(int,datepart(dd,@Fecha2))> @Corte7 and convert(int,datepart(dd,@Fecha2)) <= @Corte14 then convert(varchar(8),substring(@Fecha2,1,4) + @Mes + @FecCorte7)
		 when convert(int,datepart(dd,@Fecha2))> @Corte14 and convert(int,datepart(dd,@Fecha2)) <= @Corte19 then convert(varchar(8),substring(@Fecha2,1,4) + @Mes + @FecCorte14)
		 when convert(int,datepart(dd,@Fecha2))> @Corte19 and convert(int,datepart(dd,@Fecha2)) <= @Corte21 then convert(varchar(8),substring(@Fecha2,1,4) + @Mes + @FecCorte19)
		 when convert(int,datepart(dd,@Fecha2))> @Corte21 and convert(int,datepart(dd,@Fecha2)) <= @Corte25 then convert(varchar(8),substring(@Fecha2,1,4) + @Mes + @FecCorte21)
		 when convert(int,datepart(dd,@Fecha2))> @Corte25 and convert(int,datepart(dd,@Fecha2)) <= @Corte31 then convert(varchar(8),substring(@Fecha2,1,4) + @Mes + @FecCorte25)
	else @Fecha2
end 

exec SOANTFECHAB
		@Fecha		= @Fecha output,
		@NumDia		= 1,
		@FinSem		= 'N',
		@Salida_Fox	= 'N'	

select 	@FecAnt	= convert(varchar(8),@Fecha,112) 

select 	@FecAct =  convert(varchar(8),Par_FecAct,112)
	from SOPARAMS noholdlock
	where Par_Sucurs = @SucOrigen
				 
select 	@Contador = min(Pro_Numero) 
	from SOPROAUT noholdlock
	where Pro_Status = @Sta_Activa
				 
select 	@Contador2 = max(Pro_Numero) 
	from SOPROAUT noholdlock
	where Pro_Status = @Sta_Activa		
	
Create Table #Tabla
	(	
	Indice 			int identity,
	Campo			varchar(20) null,
	Posicion		int null,
	Valor			varchar(100) null,
	Procedimiento 	varchar(11) null,
	Grupo			int null
	)
		
Create Table #Tabla1
	(	
	Indice 			int identity,
	Campo			varchar(20) null
	)
		
Create table #Informacion
	(		
	Indice int identity,
	Procedimiento varchar(11) null,
	Resultado  varchar(8000) null,
	Campos		varchar(8000) null
	)
							
create table #SOPRORES
	(
	Pro_Campos varchar(20) null,
	Pro_Posici int null,
	Pro_Valor varchar(100) null,
	Pro_Proced varchar(11) null,
	Pro_Grupo int null,
	NumTransac   char(10) null,
	Transaccio   char(3) null,
	Usuario   	char(6) null,
	FechaSis   	datetime null,
	SucOrigen   	char(3) null,
	SucDestino   char(3) null,
	Modulo   	char(2) null
	)
										
										
while	@Contador <= @Contador2 begin
	
set		@cadena 	= @Vacio
set 	@Par1   	= @Vacio
set 	@Par2   	= @Vacio
set 	@Par3   	= @Vacio
set 	@Par4   	= @Vacio
set 	@Par5   	= @Vacio
set 	@Par6   	= @Vacio
set 	@Par7   	= @Vacio
set 	@Parametros = @Vacio
set 	@Proceso	= @Vacio
set		@ActFecha   = convert(smalldatetime,getdate())
set 	@NumTransac = convert(varchar(10),@IntTran)
	 
select 	@Par1	=	case when Pro_Par1 = @FechaStr then '''' + @FecAct + '''' + ','
						  when Pro_Par1 = @FechaAnt then '''' + @FecAnt + '''' + ','
						  when Pro_Par1 = @Reporte  then '''' + @TipoD + '''' + ','
						  when Pro_Par1 = @Sucursal then '''' + @Todas + '''' + ','
						  when Pro_Par1 = @FechaCor then '''' + @FecCor + '''' + ','
						  when Pro_Par1 = '' then ''
						else '''''' + ','
					end,
		@Par2   = 	case when Pro_Par2 = @FechaStr then '''' + @FecAct + '''' + ','
						  when Pro_Par2 = @FechaAnt then '''' + @FecAnt + '''' + ','
						  when Pro_Par2 = @Reporte  then '''' + @TipoD + '''' + ','
						  when Pro_Par2 = '' then ''
						else '''''' + ','
					end,
		@Par3   = 	case when Pro_Par3 = @FechaStr then '''' + @FecAct + '''' + ','
						  when Pro_Par3 = @FechaAnt then '''' + @FecAnt + '''' + ','
						  when Pro_Par3 = @Reporte  then '''' + @TipoD + '''' + ','
						  when Pro_Par3 = '' then ''
						  else '''''' + ','
					end,
		@Par4   = 	case when Pro_Par4 = @FechaStr then '''' + @FecAct + '''' + ','
						  when Pro_Par4 = @FechaAnt then '''' + @FecAnt + '''' + ','
						  when Pro_Par4 = @Reporte  then '''' + @TipoD + '''' + ','
						  when Pro_Par4 = '' then ''
						  else '''''' + ','
					end,
		@Par5   = 	case when Pro_Par5 = @FechaStr then '''' + @FecAct + '''' + ','
						  when Pro_Par5 = @FechaAnt then '''' + @FecAnt + '''' + ','
						  when Pro_Par5 = @Reporte  then '''' + @TipoD  + '''' + ','
						  when Pro_Par5 = '' then ''
						  else '''''' + ','
					end ,
		@Par6   = 	case when Pro_Par6 = @FechaStr then '''' + @FecAct + '''' + ','
						  when Pro_Par6 = @FechaAnt then '''' + @FecAnt + '''' + ','
						  when Pro_Par6 = @Reporte  then '''' + @TipoD + '''' + ','
						  when Pro_Par6 = '' then ''
						  else '''''' + ','
					end, 
		@Par7   = 	case when Pro_Par7 = @FechaStr then '''' + @FecAct + '''' + ','
						  when Pro_Par7 = @FechaAnt then '''' + @FecAnt + '''' + ',' 
						  when Pro_Par7 = @Reporte  then '''' + @TipoD + '''' + ','
						  when Pro_Par7 = '' then ''
						  else '''''' + ','
					end 
	from SOPROAUT noholdlock 
	where	Pro_Numero	= @Contador
	and 	Pro_Status = @EntUno

select	@Parametros	= @Par1 		+ 	@Par2 		+ 	@Par3 		+ 	@Par4 			+ 	@Par5 		+
					  @Par6 		+ 	@Par7 		+ 	'''' 		+ 	@NumTransac 	+ 	'''' 		+
					  ',' 			+ 	'''' 		+	@Transaccio + 	'''' 			+ 	','   		+	
					  '''' 			+ 	@Usuario	+ 	'''' 		+ 	',' 			+	'''' 		+
					  @Fecha1 		+   '''' 		+   ',' 		+ 	'''' 			+ 	@SucOrigen 	+
					  '''' 			+   ',' 		+   '''' 		+ 	@SucDestino 	+ 	'''' 		+
					  ',' 			+ 	'''' 		+ 	@Modulo 	+	'''' 
						 
if (select Pro_Status 
		from SOPROAUT noholdlock 
		where 	Pro_Numero = @Contador) = @EntUno begin
		
	select 	@cadena = '' + Pro_Nombre + ' ' +	@Parametros,	@Proceso = Pro_Nombre
		from SOPROAUT noholdlock
		where 	Pro_Numero = @Contador 
		
end 
	
	set	@Contador = @Contador + @EntUno
	exec (@cadena)

	
	insert into #Informacion 
	(Procedimiento, Resultado, Campos)
select  Mat_NomRep,	converT(varchar(1000),Mat_Result),	convert(varchar(8000),Mat_Campos)
	from SOTMPMAT noholdlock 
		where Mat_NomRep = @Proceso
		order by Mat_NomRep

select @RegFin = convert(int,max(Indice))  
	from #Informacion

	while @RegIni <= @RegFin begin
	
		Select
				@Texto			= Resultado,
				@Procedimiento	= Procedimiento,
				@Texto2			= Campos
			from #Informacion 
			 where Indice = @RegIni

		Set @Longitud			=	LEN(@Texto)
		
			while @Posicion <= @Longitud begin
				
				set @Posicion = CHARINDEX ('|',@Texto)
		
				Insert #Tabla 
				select @Campos , @NoCampo, Substring(@Texto,1,@Posicion - 1), @Procedimiento, @NoCampo2
				
				set @Texto = Substring(@Texto, @Posicion + 1 ,@Longitud - @Posicion)
				
				set @Posicion = CHARINDEX ('|',@Texto)
				Set @Longitud = Len(@Texto)
			
				set @NoCampo = @NoCampo + 1
			
			end
		
		Set @Longitud2			=	LEN(@Texto2)
		
			while @Posicion2 <= @Longitud2 begin
				
				set @Posicion2 = CHARINDEX ('|',@Texto2)
		
				Insert #Tabla1
				select Substring(@Texto2,1,@Posicion2 - 1)
				
				set @Texto2 = Substring(@Texto2, @Posicion2 + 1 ,@Longitud2 - @Posicion2)
				
				set @Posicion2 = CHARINDEX ('|',@Texto2)
				Set @Longitud2 = Len(@Texto2)
		
			end
	
		set @NoCampo =  @EntUno		
		set @NoCampo2 = @NoCampo2 + @EntUno		
		set @RegIni = @RegIni + @EntUno		
		
	end

	update #Tabla set a.Campo = b.Campo
		from #Tabla as a , #Tabla1 as b 
		where a.Indice = b.Indice
		
	insert into #SOPRORES  
		(Pro_Campos, 	Pro_Posici, Pro_Valor, 	Pro_Proced, Pro_Grupo,
		NumTransac,		Transaccio,	Usuario,	FechaSis,	SucOrigen,
		SucDestino,		Modulo)
	select	Campo,		Posicion,		Valor,		Procedimiento,	Grupo,
		@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,	
		@SucOrigen,		@SucDestino,	@Modulo 
		from #Tabla 
		
	exec @Status = SOPRORESALT 
		@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,	@SucOrigen,
		@SucDestino,	@Modulo
		
	exec @Status = SOPROAUTACT 
		@ActFecha, 		@Proceso,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo
		
	Set @IntTran = @IntTran + @EntUno		
		
	truncate table #Tabla
	truncate table #Tabla1
	truncate table #Informacion
	truncate table #SOPRORES

end
drop table #Tabla
drop table #Tabla1
drop table #Informacion
drop table #SOPRORES
