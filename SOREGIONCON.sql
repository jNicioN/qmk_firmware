create procedure SOREGIONCON (
	@Reg_Numero	int,
	@Reg_Descri	varchar(35),
	@Reg_SegNum	int,
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
/* DESCRIPCION: Consulta de Regiones							  */
/******************************************************************/
/* Modificý:	Erick Gloria   							        ****
** Fecha:		27/03/2018									    ****
** Descripciýn:	Se agrego campo Reg_SegNum a consulta y asignacion de constantes			****
** Help Desk:	1093350											****
/******************************************************************/
/** Modificý:	Daniel Salas [CDIS]   							****
** Fecha:		24/Julio/2017									****
** Descripciýn:	Se agrego consulta por descripcion 				****
** Help Desk:	1004978											****
********************************************************************/
/* Creo:		Claudia V Sandoval P							****
** Fecha:		03/10/2016										****
** Help:		903360 											****
********************************************************************/
/* Declaracion de Variables */*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Asignacion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Activo	char(1),
		@Str_Cons1	char(1),
		@Str_Cons2	char(1),
		@Str_Cons3	char(1),
		@Str_Cons4	char(1),
		@Str_ConsC	char(1)

/* Asignacion de Valores */
select	@Str_Vacio	= '',			/* Caracter Vacio	*/
		@Str_Activo	= 'A',          /* Caracter A	*/
		@Str_Cons1	= '1',          /* Caracter 1	*/
		@Str_Cons2	= '2',          /* Caracter 2	*/
		@Str_Cons3	= '3',          /* Caracter 3	*/
		@Str_Cons4	= '4',          /* Caracter 4	*/
		@Str_ConsC	= 'C'           /* Caracter C	*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip	= @Str_ConsC begin			/* 'C': Consulta */
	if @Tip_ConCon	= @Str_Cons1 begin		/* C1 */
		select	Reg_Numero,	Reg_Descri,	Reg_Status
			from SOREGION noholdlock
			where	Reg_Numero	= @Reg_Numero
		end 
	if @Tip_ConCon	= @Str_Cons2 begin		/* C2 */
	    select reg.Reg_Numero,	reg.Reg_Descri,	reg.Reg_Status,	seg.Seg_Nombre, reg.Reg_SegNum
			from SOREGION reg noholdlock
			inner join SOSEGMEN seg noholdlock on (seg.Seg_Numero = reg.Reg_SegNum )
			Where reg.Reg_Status	= @Str_Activo
	end 

end else begin
	if @Tip_ConCon	= @Str_Cons1 begin		/* L1 */
		select	Reg_Numero,	Reg_Descri
			from SOREGION noholdlock
			where	Reg_Status	= @Str_Activo
			and     Reg_Descri like ltrim(@Reg_Descri)+'%'
			order by Reg_Descri
	end
	if @Tip_ConCon	= @Str_Cons2 begin		/* L2 */
		select	reg.Reg_Numero,	reg.Reg_Descri,	reg.Reg_Status,	seg.Seg_Nombre, reg.Reg_SegNum
			from SOREGION reg noholdlock
			inner join SOSEGMEN seg noholdlock on (seg.Seg_Numero = reg.Reg_SegNum )
			where	reg.Reg_Status	= @Str_Activo
			and     reg.Reg_Descri like '%'+ltrim(@Reg_Descri)+'%'
			and     reg.Reg_SegNum = @Reg_SegNum
			order by reg.Reg_Descri
	end
	
end
