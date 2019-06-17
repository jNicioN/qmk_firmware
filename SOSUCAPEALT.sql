create procedure SOSUCAPEALT (
	@Sap_NumApe int,
	@Sap_Sucurs char(3),
	@Sap_Apertu	char(1),
	@Sap_FeHrAp	smalldatetime,
	@Sap_Error	varchar(250),
	@Sap_Mensaj	varchar(250),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

/******************************************************************/
/* DESCRIPCION: Alta Aperturas Sucursales 						  */
/******************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modificó:		Edwin E. Pérez Requena						****
** Fecha:		04/Marzo/2015								****
** Help:	   	    	738246										****
** Descripción:	Se agrega @@nestlevel = 1 para regresar		****
**				Err_Codigo	= '000000' cuando se ejecuta	****
**				directamente y no a través de otro proceso.	****
****************************************************************************
** Modificó:		David Ruiz									****
** Fecha:		21/Nov/14									****
** Help:	   	    	718234										****
** Descripción:	Se elimina el Err_Codigo	= '000000'			****
****************************************************************************
** Modificó:		Armando Garcia								****
** Fecha:		16/Feb/10									****
** Help:	   	    	246228										****
** Descripción:	Alta de aperturas sucursales					****
****************************************************************************/

declare	@SoSucursID	int,			/* Declaracion de Variables */
		@Numero 	int,
		@Status		int,
		@Sap_FecApe	smalldatetime,
		@Sap_FecSuc	smalldatetime,   /*Fecha de sucursal*/	
		@Fec_Sucurs	smalldatetime

declare	@Ent_Cero	int,			/* Declaracion de Constantes */
		@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Tab_Nombre	char(8)

/* Asignacion de Constantes */
select	@Ent_Cero	= 0,			/*	Entero en Cero						*/
		@Str_Vacio	= '',			/*	String Vacio						*/
		@Fec_Vacia 	= '1900-01-01',	/*	Fecha Vacia							*/
		@Tab_Nombre	= 'SOSUCAPE'	/*	Tabla a Actualizar en SYTABLOC		*/

exec SOFOLIOSACT 
	@Fol_Tabla	= @Tab_Nombre, 
	@Fol_Numero	= @Numero output

if isnull(@Sap_NumApe ,@Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Numero Apertura Incorrecto',
			Err_Variab	= 'Sap_NumApe'
	rollback
	return 1
end

if isnull(@Sap_Sucurs , @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Sucursal Incorrecta', 
			Err_Variab	= 'Sap_Sucurs '
	rollback
	return 1
end 

if isnull(@Sap_Apertu, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'Status Apertura Incorrecto', 
			Err_Variab	= 'Sap_Apertu'
	rollback
	return 1
end 

if isnull(@Sap_FeHrAp, @Fec_Vacia) = @Fec_Vacia begin 
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'No capturo Fecha', 
			Err_Variab	= 'Sap_FeHrAp'
	rollback
	return 1
end 

if not exists (select	Suc_Numero
				from SOSUCURS noholdlock
				where	Suc_Numero	= @Sap_Sucurs
				) begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'La Sucursal no existe', 
			Err_Variab	= 'Sap_Sucurs'
	rollback
	return 1
end 

if isnull(@Sap_Error, @Str_Vacio) = @Str_Vacio begin
	select	@Sap_Error = @Str_Vacio
end 

if isnull(@Sap_Mensaj, @Str_Vacio) = @Str_Vacio begin
	select	@Sap_Mensaj = @Str_Vacio
end 

select	@SoSucursID	= convert(int, @Sap_Sucurs)

select 	@FechaSis 	= getdate()

select @Sap_FecApe = (convert(char, @Sap_FeHrAp, 101))

select @Fec_Sucurs = Par_FecAct 
	from SOPARAMS noholdlock	
		where Par_Sucurs=@Sap_Sucurs

select @Sap_FecSuc=convert(char,@Fec_Sucurs, 101)

insert into SOSUCAPE values(
	@Sap_NumApe,	@SoSucursID,	@Sap_Sucurs,	@Sap_Apertu,	@Sap_FecApe,
	@Sap_FeHrAp,	@Sap_Error,		@Sap_Mensaj,	@Sap_FecSuc,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)
	
if @@nestlevel = 1 begin
	select	Err_Codigo	= '000000'
end
