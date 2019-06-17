create procedure SOPANNIVCON (
	@Pan_Nombre	char(8),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

create table #NivelPan (
	Niv_Numero	char(2) null,
	Niv_Descri	varchar(30) null,
	Niv_Acceso 	char(1) null,
	Niv_Pantal 	char(1) null,
	Niv_Nombre	char(8) null)

declare	@Pan_CoNiAc	char(1),				/* Declaración de Constantes */
		@Pan_SiNiAc	char(1)
		
/* Asignación de Constantes */
select	@Pan_CoNiAc	= 'S',					/* Con Nivel de Acceso */
		@Pan_SiNiAc	= 'N'					/* Sin Nivel de Acceso */
		
insert #NivelPan
	select	Niv.Niv_Numero,
			Niv.Niv_Descri,
			Niv.Niv_Acceso,
			Niv_Pantal = @Pan_CoNiAc,
			Niv_Nombre = @Pan_Nombre
		from SYPANNIV Pni noholdlock,
		 	 SYPANTAL Pan noholdlock,
		 	 SONIVELE Niv noholdlock
		where	Pni.Pni_Pantal	= Pan.Pan_Nombre
  		  and 	Pni.Pni_Nivel	= Niv.Niv_Numero
 	  	  and	Pan.Pan_Nombre	= @Pan_Nombre

insert #NivelPan
	select	Niv.Niv_Numero,
			Niv.Niv_Descri,
			Niv.Niv_Acceso,
			Niv_Pantal = @Pan_SiNiAc,
			Niv_Nombre = @Pan_Nombre
		from SONIVELE Niv noholdlock
		where	Niv_Numero	not in (select	Niv_Numero
										from #NivelPan)

/* Adaptive Server has expanded all '*' elements in the following statement */ select	#NivelPan.Niv_Numero, #NivelPan.Niv_Descri, #NivelPan.Niv_Acceso, #NivelPan.Niv_Pantal, #NivelPan.Niv_Nombre
	from #NivelPan noholdlock
	order by Niv_Numero

drop table #NivelPan


