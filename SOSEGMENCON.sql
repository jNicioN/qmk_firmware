create procedure SOSEGMENCON (
	@Seg_Numero	int,
	@Seg_Nombre	varchar(35),
	@Seg_Status	char(1),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/******************************************************************/
/* DESCRIPCION: Consulta de Segmentos							  */
/******************************************************************/
/********************************************************************/
/* Creo:		Erick Gloria							        ****
** Fecha:		26/03/2018										****
** Help Desk: 1093350 											 ****
********************************************************************/
/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Asignacion de Constantes */
declare	@Str_Vacio	char(1),
        @Str_RegEst	char(1),
		@Str_Activo	char(1),
		@Str_Cons1	char(1),
		@Str_Cons2	char(1),
		@Str_Cons3	char(1),
		@Str_Cons4	char(1),
		@Str_ConsC	char(1)

/* Asignacion de Valores */
select	@Str_Vacio	= '',			/* Caracter Vacio */
        @Str_RegEst	= 'A',          /* Caracter A */
		@Str_Activo	= '1',          /* Caracter Activo */
		@Str_Cons1	= '1',          /* Caracter 1 */
		@Str_Cons2	= '2',          /* Caracter 2 */
		@Str_Cons3	= '3',          /* Caracter 3 */
		@Str_Cons4	= '4',          /* Caracter 4 */
		@Str_ConsC	= 'C'           /* Caracter C */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip	= @Str_ConsC begin					/* 'C': Consulta */
	if @Tip_ConCon	= @Str_Cons1 begin		/* C1 */
		select	Seg_Numero,  Seg_Nombre,  Seg_Status
			from SOSEGMEN noholdlock
			where	Seg_Nombre like '%'+ ltrim(@Seg_Nombre)+'%'
			AND Seg_Status = @Str_Activo
	end
	if @Tip_ConCon	= @Str_Cons2 begin		/* C2 */
		select	seg.Seg_Numero,  seg.Seg_Nombre,  seg.Seg_Status, reg.Reg_SegNum, reg.Reg_Descri
			from SOSEGMEN seg noholdlock
			inner join SOREGION reg noholdlock on (reg.Reg_SegNum =  @Seg_Numero)
			Where seg.Seg_Status = @Str_Activo
			AND seg.Seg_Numero = @Seg_Numero
			AND reg.Reg_Status = @Str_RegEst
			
	end
end else begin
	if @Tip_ConCon	= @Str_Cons1 begin		/* L1 */
		 select	Seg_Numero,  Seg_Nombre,  Seg_Status
			from SOSEGMEN noholdlock
			Where Seg_Status = @Str_Activo
	end
end
