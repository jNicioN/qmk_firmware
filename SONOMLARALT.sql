create procedure SONOMLARALT (
    @Nol_Person int,       
    @Nol_Nombre varchar(84),
    @Nol_ApePat varchar(84),
    @Nol_ApeMat varchar(84),
    @Nol_RazSoc varchar(254),
    @Nol_Comple varchar(254),
    @Nol_ComOrd varchar(254),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Alta de personas con nombre largo **		****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		10/01/2024										****
** Help: 		36841 											****
** Descripcion:	Se crea SP				 						****
*******************************************************************/

--declaracion de variables
declare	@Existe		int,
		@Status		int

--Declaracion de Constantes
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int

--Asignacion de constantes
select 	@Str_Vacio = '',			--string vacio
		@Ent_Cero	= 0,			-- Entero : 0
		@Ent_Uno	= 1				-- Entero : 1

insert into SONOMLAR values (
	@Nol_Person,	@Nol_Nombre,	@Nol_ApePat,	@Nol_ApeMat,	@Nol_RazSoc,
    @Nol_Comple,	@Nol_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
    @FechaSis,		@SucOrigen,		@SucDestino
)

--insertar en bitacora
exec @Status = SOBINOLAALT
	@Nol_Person,	@Nol_Nombre,	@Nol_ApePat,	@Nol_ApeMat,	@Nol_RazSoc,
    @Nol_Comple,	@Nol_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
    @FechaSis,		@SucOrigen,		@SucDestino

if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end


