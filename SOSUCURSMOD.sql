create procedure SOSUCURSMOD(
	@Suc_Numero char(3), 
	@Suc_Nombre varchar(50), 
	@Suc_Calle	varchar(40),
	@Suc_CalNum	varchar(10),
	@Suc_Coloni	varchar(150),
	@Suc_CodPos	char(6),
	@Suc_ApaPos	char(6),
	@Suc_Telefo char(15),
	@Suc_Ciudad char(3), 
	@Suc_Estado char(2),     
	@Suc_Pais   varchar(20),
	@Suc_Plaza  char(3),
	@Suc_Gerent varchar(50), 
	@Suc_MaiGer varchar(50), 
	@Suc_SubGer varchar(50), 
	@Suc_MaiSub varchar(50), 
	@Suc_CiCrCe	char(1),
	@Suc_Zona	char(2),
	@Suc_IVA	smallmoney,
	@Suc_FecApe	smalldatetime,
	@Suc_DifHor	int,   
	@Suc_ApeSab	char(1),
	@Suc_Cerrad char(1),
	@Suc_Catego	char(1),
	
	@NumTransac char(10), 
	@Transaccio char(3), 
	@Usuario 	char(6), 
	@FechaSis 	smalldatetime, 
	@SucOrigen 	char(3), 
	@SucDestino char(3), 
	@Modulo 	char(2))

as
/****************************************************************************
** Modifico:		Brandon Garcia								****
** Fecha:		20/Feb/17									****
** Help:		       927640										****
** Descripcion   Se agrega campo Suc_Catego					****
****************************************************************************
** Creo:			David Alejandro Cantu Treviýo				****
** Fecha:		25/Ago/15									****
** Help:		       749260										****
** Descripcion   Se agrega campo Suc_Cerrad					****
****************************************************************************
** Modifico:		Armando Garcia								****
** Fecha:		12/Feb/2010								****
** Requi:		000246228								 	****
** Descripcion:	se agrego parametro Suc_ApeSab	 		****
****************************************************************************
****************************************************************************
** Modifico:		Sergio Treviýo Jasso							****
** Fecha:		11/Junio/2008								****
** Help Desk:	75587										****
** Descripcion:	Se quito el mensaje 'Registro modificado'		****
****************************************************************************
** Modifico:		Francis Flores Contreras						****
** Fecha:		6/Sep/2006							      	****
** Descripcion:	Se agrego parýmetos Suc_FecApe  y       		****
**				Suc_DifHor									****
** HD:			 # 3611										****
****************************************************************************

****************************************************************************
** Modifico:		Gabriela Alonso Jalomo						****
** Fecha:		20/Sep/2005								****
** Descripcion:	Se agrego el campo Suc_Zona,Suc_IVA 		****
** HD:			97418										****
****************************************************************************
** Modifico:		Claudia Lazarýn Soto							****
** Fecha:		07/Feb/2003								****
** Descripcion:	Se agrego el campo Suc_CiCrCe				****
****************************************************************************
** Modifico:		Sandra Almaguer							****
** Fecha:		04/Abril/2002								****
** Descripcion:	agregar SoSucursID, SoCiudadID, SoEstadoID****
**				SoPlazaID									****
****************************************************************************
** Modificar:		Ma de Lourdes Vald+s						****
** Fecha:			03/Abr/02								****
** Se agrego la validacion de Suc_PlaCec					****
****************************************************************************
** Modificar:		Jorge Lozano								****
** Fecha:		07/Dic/01									****
** Se agrego los campos Suc_Gerent,Suc_MaiGer,Suc_SubGer,****
** Suc_MaiSub												*****
****************************************************************************
** Creo:			Sandra Almaguer							****
** Fecha:		26/Jul/01									****
****************************************************************************/
declare	@Status		int,			/* Declaraciýn de Variables */
		@Suc_Direcc	varchar(80),
		@Str_Coloni	varchar(150),
		@Str_ApaPos	char(15),
		@Str_CodPos	char(17),
		@Str_CalNum	char(12),
		@SoCiudadID	int,
		@SoEstadoID	int,
		@SoPlazaID	int,
		@Fec_Vacia	smalldatetime	

declare	@Ent_Cero	int,			/* Declaraciýn de Constantes */
		@Str_Vacio	char(1),
		@Str_Espaci	char(1),
		@Tab_Nombre	char(8),
		@Uld_Habil	char(1),
		@Sin_ProApe	char(1),
		@Cre_SiCie	char(1),
		@Cre_NoCie	char(1)

/* Asignaciýn de Constantes */
select	@Ent_Cero	= 0,			/* Entero en Cero */
		@Str_Vacio	= '',			/* String Vacýo */
		@Str_Espaci	= ' ', 			/* String con un Espacio */
		@Tab_Nombre	= 'SOSUCURS',	/* Tabla a Actualizar en SYTABLOC */
		@Uld_Habil	= 'H',			/* Ultimo Dýa: Habil */
		@Sin_ProApe	= 'N',			/* Sucursal que no estý en el Proceso de Apertura */
		@Fec_Vacia	= '1900-01-01', /* Fecha Vacia */
		@Cre_SiCie	= 'S',			/* Si requiere cierre centralizado */
		@Cre_NoCie	= 'N'			/* No requiere cierre centralizado */
	
if not exists (select	Suc_Numero
				from SOSUCURS noholdlock
				where	Suc_Numero	= @Suc_Numero) begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'La sucursal no existe', 
			Err_Variab	= 'Suc_Numero'
	rollback
	return 1
end 

if isnull(@Suc_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Nombre Incorrecto', 
			Err_Variab	= 'Suc_Nombre'
	rollback
	return 1
end 

if isnull(@Suc_Calle, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'Calle Incorrecta', 
			Err_Variab	= 'Suc_Calle'
	rollback
	return 1
end 

if isnull(@Suc_Coloni, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'Colonia Incorrecta', 
			Err_Variab	= 'Suc_Coloni'
	rollback
	return 1
end 

if not exists (select	Est_Numero
				from SOESTADO noholdlock
				where	Est_Numero	= @Suc_Estado) begin
	select	Err_Codigo	= '000006', 
			Err_Mensaj	= 'El estado no existe', 
			Err_Variab	= 'Suc_Ciudad'
	rollback
	return 1
end 

if not exists (select	Ciu_Numero
				from SOCIUDAD noholdlock
				where	Ciu_Numero	= @Suc_Ciudad
				  and	Ciu_Estado	= @Suc_Estado) begin
	select	Err_Codigo	= '000007', 
			Err_Mensaj	= 'La ciudad no existe', 
			Err_Variab	= 'Suc_Ciudad'
	rollback
	return 1
end 

if isnull(@Suc_Pais, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000008', 
			Err_Mensaj	= 'Pais Incorrecto', 
			Err_Variab	= 'Suc_Pais'
	rollback
	return 1
end 

if isnull(@Suc_Plaza, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000009', 
			Err_Mensaj	= 'Plaza Incorrecta', 
			Err_Variab	= 'Suc_Pais'
	rollback
	return 1
end 

if not exists(select	Pla_Numero
				from SOPLAZAS noholdlock
				where	Pla_Numero	= @Suc_Plaza) begin
	select	Err_Codigo	= '000010', 
			Err_Mensaj	= 'La Plaza no Existe', 
			Err_Variab	= 'Suc_TipCue'
	rollback
	return 1
end 

if isnull(@Suc_Gerent, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000011', 
			Err_Mensaj	= 'Falta el Nombre del Gerente', 
			Err_Variab	= 'Suc_Gerent'
	rollback
	return 1
end 

if isnull(@Suc_MaiGer, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000012', 
			Err_Mensaj	= 'Falta el E-Mail del Gerente', 
			Err_Variab	= 'Suc_MaiGer'
	rollback
	return 1
end 

if isnull(@Suc_SubGer, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000013', 
			Err_Mensaj	= 'Falta el Nombre del SubGerente', 
			Err_Variab	= 'Suc_SubGer'
	rollback
	return 1
end 

if isnull(@Suc_MaiSub, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000014', 
			Err_Mensaj	= 'Falta el E-Mail del SubGerente', 
			Err_Variab	= 'Suc_MaiSub'
	rollback
	return 1
end 

if @Suc_CiCrCe like '[^@Cre_SiCie+@Cre_NoCie]' begin
	select 	Err_Codigo = '000015', 
			Err_Mensaj = 'Cierre de Creditos Centralizado incorrecto', 
			Err_Variab = 'Suc_CiCrCe'
	rollback
	return 1
end

if isnull(@Suc_Zona, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000016', 
			Err_Mensaj	= 'Zona Incorrecta', 
			Err_Variab	= 'Suc_Zona'
	rollback
	return 1
end 

if not exists(select	Zon_Numero
				from SOZONAS noholdlock
				where	Zon_Numero	= @Suc_Zona) begin
	select	Err_Codigo	= '000017', 
			Err_Mensaj	= 'La Zona no Existe', 
			Err_Variab	= 'Suc_Zona'
	rollback
end 


if isnull(@Suc_FecApe, @Fec_Vacia) = @Fec_Vacia begin
	select	Err_Codigo	= '000019', 
			Err_Mensaj	= 'No capturý la Fecha', 
			Err_Variab	= 'vFecha'
	rollback
	return 1
end

if isnull(@Suc_ApeSab, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000020', 
			Err_Mensaj	= 'La apertura dia sabado no puede ir vacio', 
			Err_Variab	= 'Suc_ApeSab'
	rollback
	return 1
end

if isnull(@Suc_Catego, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000021', 
			Err_Mensaj	= 'Falta Categoria de Sucursal', 
			Err_Variab	= 'Suc_Catego'
	rollback
	return 1
end 

select	@Suc_DifHor	= isnull(@Suc_DifHor,@Ent_Cero)

if isnull(@Suc_CodPos, @Str_Vacio) <> @Str_Vacio
	select	@Str_CodPos	= ', C.P. ' + ltrim(rtrim(@Suc_CodPos))
else
	select	@Str_ApaPos	= @Str_Vacio

if isnull(@Suc_ApaPos, @Str_Vacio) <> @Str_Vacio
	select	@Str_ApaPos	= ' A.P. ' + ltrim(rtrim(@Suc_ApaPos))
else
	select	@Str_ApaPos	= @Str_Vacio

if upper(ltrim(rtrim(@Suc_Coloni))) not like '%COL%'
	select	@Str_Coloni	= 'COL. ' + ltrim(rtrim(@Suc_Coloni))
else
	select	@Str_Coloni	= ltrim(rtrim(@Suc_Coloni))

if isnull(@Suc_CalNum, @Str_Vacio) = @Str_Vacio
	select	@Str_CalNum	= ' SN '
else
	select	@Str_CalNum	= ' #' + ltrim(rtrim(@Suc_CalNum))
		
select	@Suc_Direcc	= ltrim(rtrim(@Suc_Calle)) + rtrim(@Str_CalNum) + ' ' + rtrim(@Str_Coloni) + rtrim(@Str_CodPos) + rtrim(@Str_ApaPos) + '.'

select	@SoCiudadID	= convert(int, @Suc_Ciudad + @Suc_Estado),
		@SoEstadoID	= convert(int, @Suc_Estado),
		@SoPlazaID	= convert(int, @Suc_Plaza)



update SOSUCURS set
	Suc_Numero	= @Suc_Numero,	
	Suc_Nombre	= @Suc_Nombre,
	Suc_Direcc	= @Suc_Direcc,	
	Suc_Calle	= @Suc_Calle,
	Suc_CalNum	= @Suc_CalNum,
	Suc_Coloni	= @Suc_Coloni,
	Suc_CodPos	= @Suc_CodPos,
	Suc_ApaPos	= @Suc_ApaPos,
	Suc_Telefo	= @Suc_Telefo,
	SoCiudadID	= @SoCiudadID,
	Suc_Ciudad	= @Suc_Ciudad,	
	SoEstadoID	= @SoEstadoID,
	Suc_Estado	= @Suc_Estado,
	Suc_Pais	= @Suc_Pais,	
	SoPlazaID	= @SoPlazaID,
	Suc_Plaza	= @Suc_Plaza,
	Suc_Gerent	= @Suc_Gerent, 
	Suc_MaiGer	= @Suc_MaiGer, 
	Suc_SubGer	= @Suc_SubGer, 
	Suc_MaiSub	= @Suc_MaiSub, 
	Suc_CiCrCe	= @Suc_CiCrCe,
	Suc_Zona	= @Suc_Zona,
	Suc_FecApe	= @Suc_FecApe,
	Suc_DifHor	= @Suc_DifHor,
	Suc_ApeSab	= @Suc_ApeSab,
	Suc_Cerrad  = @Suc_Cerrad,
	Suc_Catego	= @Suc_Catego,

	NumTransac	= @NumTransac, 
	Transaccio	= @Transaccio, 
	Usuario		= @Usuario, 
	FechaSis	= @FechaSis, 
	SucOrigen	= @SucOrigen, 
	SucDestino	= @SucDestino
	where	Suc_Numero	= @Suc_Numero
	
exec @Status = SYTABLOCACT	
	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		
	@SucOrigen,		@SucDestino,	@Modulo
if @Status <> 0 begin
	rollback
	return 1
end
