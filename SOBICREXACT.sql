create procedure SOBICREXACT (
	 @Bce_Numero int,
	 @Bce_PerNum int,
	 @Bce_Status smallint,
	 @Bce_Mensaj varchar(100),
	 @Tip_Actual char(1),

	 @NumTransac char(10),
	 @Transaccio char(3),
	 @Usuario char(6),
	 @FechaSis smalldatetime,
	 @SucOrigen char(3),
	 @SucDestino char(3),
	 @Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION: Actualizacion de Bitacora de control para 			*/
/*				Creacion expediente									*/
/**  REFERENCIAS:
*****************************************************************************
*****************************************************************************
** Creo:	Josue  Manuel Palomar Rejon									****
** Fecha: 9-Noviembre-2021           									****
** Help:	1574028														****
*****************************************************************************/

/* Declaracion de Variables */
declare @Status  	int   /* Status de Ejecucion */

/* Declaracion de Constantes */
declare @Str_Vacio char(1),
				@Ent_Cero int,
				@Ent_Uno int,
				@Str_Uno char(1),
				@Str_Dos char(1),
				@Str_Tres char(1),
				@Ent_NoIni int,
				@Ent_Pendie int,
				@Ent_Termin int,
				@Ent_Error int

/* Asignacion de Constantes */
select @Str_Vacio = '',			/* Tipo consulta*/
			@Ent_Cero = 0,			/* Entero cero*/
			@Ent_Uno = 1,		/* Entero Uno*/
			@Str_Uno = '1',			/* Caracter Uno*/
			@Str_Dos = '2',			/* Caracter Dos*/
			@Str_Tres = '3',			/* Caracter Tres*/
			@Ent_NoIni = 0,			/* Status No iniciado*/
			@Ent_Pendie = 1,			/* Status pendiente*/
			@Ent_Termin = 2,			/* Status terminado*/
			@Ent_Error = 3			/* Status con error */

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


if @Tip_Actual = @Str_Uno begin /*Tipo 1 Se actualiza el estatus por Cliente*/

	select @Bce_Numero = Bce_Numero
	from SOBICREX Bic noholdlock
	where Bic.Bce_PerNum = @Bce_PerNum

	if(isnull(@Bce_Numero,@Ent_Cero) = @Ent_Cero ) begin

		exec @Status = SOBICREXALT @Bce_Numero out, @Bce_PerNum	, @Bce_Status ,@Bce_Mensaj ,
		 @NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo

		if @Status <> @Ent_Cero begin
			select  Err_Codigo  = '000002',
			Err_Mensaj  = 'Error en el alta de bitacora',
			Err_Variab  = 'Status'
			rollback
			return @Ent_Uno
		end
	end else begin
			update SOBICREX set
					Bce_Status = @Bce_Status,
					Bce_Mensaj = isnull(@Bce_Mensaj,@Str_Vacio),
					NumTransac = @NumTransac,
					Transaccio = @Transaccio,
					Usuario = @Usuario,
					FechaSis = @FechaSis,
					SucOrigen = @SucOrigen,
					SucDestino = @SucDestino
				where  Bce_Numero = @Bce_Numero
	end

end else if @Tip_Actual = @Str_Dos begin /*Tipo 2 Se actualiza el estatus por id*/
	update SOBICREX set
		Bce_Status = @Bce_Status,
		Bce_Mensaj = isnull(@Bce_Mensaj,@Str_Vacio),
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario = @Usuario,
		FechaSis = @FechaSis,
		SucOrigen = @SucOrigen,
		SucDestino = @SucDestino
		where  Bce_Numero = @Bce_Numero

end else if @Tip_Actual = @Str_Tres begin /*Tipo 3 Se actualiza los clientes con estatus 1=pendiente a estatus 2=Exitoso*/
			update SOBICREX set
				Bce_Status = @Bce_Status,
				Bce_Mensaj = isnull(@Bce_Mensaj,@Str_Vacio),
				NumTransac = @NumTransac,
				Transaccio = @Transaccio,
				Usuario = @Usuario,
				FechaSis = @FechaSis,
				SucOrigen = @SucOrigen,
				SucDestino = @SucDestino
				where  Bce_Status = @Ent_Pendie
		end
