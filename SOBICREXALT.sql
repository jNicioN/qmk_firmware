create procedure SOBICREXALT (
	@Bce_Numero int output,
	@Bce_PerNum int,
	@Bce_Status smallint,
	@Bce_Mensaj varchar(100),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION: Alta de Bitacora de control para 				*/
/*						Creacion de expediente						*/
/**  REFERENCIAS:
*****************************************************************************
*****************************************************************************
** Creo:	Josue  Manuel Palomar Rejon									****
** Fecha: 	9-Noviembre-2021           									****
** Help:	1574028														****
*****************************************************************************/
/*Definicion constantes*/
declare @Ent_NoIni int,
				@Ent_Pendie int,
				@Ent_Termin int,
				@Ent_Error int,
				@Ent_Uno int

/*Asignacion de constantes*/
select	@Ent_NoIni = 0,			/* Status No iniciado*/
			@Ent_Pendie = 1,			/* Status pendiente*/
			@Ent_Termin = 2,			/* Status terminado*/
			@Ent_Error = 3,			/* Status con error */
			@Ent_Uno = 1			/* Entero Uno */



if(@Bce_Status<> @Ent_NoIni
	and @Bce_Status<> @Ent_Pendie
	and @Bce_Status<> @Ent_Termin
	and @Bce_Status<> @Ent_Error)
	begin

		select  Err_Codigo  = '000001',
				Err_Mensaj  = 'El estatus es incorrecto',
				Err_Variab  = 'Status'
		rollback
		return 1
end

insert into SOBICREX (
		Bce_PerNum, Bce_Status , Bce_Mensaj, 	NumTransac,
		Transaccio, 	Usuario, 	FechaSis, 	SucOrigen, 	SucDestino)
	values (
		@Bce_PerNum , @Bce_Status , @Bce_Mensaj, 	@NumTransac,
		@Transaccio, 	@Usuario, 	@FechaSis, 	@SucOrigen, 	@SucDestino)

select @Bce_Numero = @@identity
