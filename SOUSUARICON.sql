create procedure SOUSUARICON (
	@Usu_Numero	char(6),
	@Usu_Nombre	varchar(50),
	@Usu_Clave	char(15),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************/
/* DESCRIPCION: ** Consulta de usuarios ** 									*/
/****************************************************************************/
/** REFERENCIAS:
****************************************************************************
** Si se Compila este store en ProducciÃ³n, hay que volverle a 			****
** dar acceso al usuario BLOQUEAR										****
****************************************************************************
** Modifico:		Raúl Apolonio del Angel Karr														****
** Fecha:			12 de Octubre del 2023																		****
** Id Jira:			TCELIDC-710																							****
** Descripcion:		Se agrega consulta CG para PIC contratos							****
****************************************************************************
** Modifico:		Francisco Minajas									****
** Fecha:			09/06/2022											****
** Help:			1649525												****
** Descripcion:		Se agrega consulta C7 y L7 para obtener Usu_Numero	****
****************************************************************************
** Modifico:		Esthepny Aguilar									****
** Fecha:			10/03/2020											****
** Help:			1396836												****
** Descripcion:		Se agrega consulta L6 para obtener campo activo		****
****************************************************************************
** Modifico:		Victor Manuel Osorio Escamilla						****
** Fecha:			14/Ene/2016											****
** Help:			00829266											****
** Descripcion:		Se agrega consulta CE para modulo MS    			****
****************************************************************************
** Modifico:		Perla Cecilia Alcocer S.     						****
** Fecha:			02/Sep/2015											****
** Help:			00794652											****
** Descripcion:		Se agrega consulta CD para modulo PY    			****
****************************************************************************
** Modifico:		David Martinez Nava   								****
** Fecha:			25/Ago/2015											****
** Help:			00758614											****
** Descripcion:		Se agregan campos Usu_MulSes a consulta C5 			****
****************************************************************************
** Modifico:		Abel Marmolejo   									****
** Fecha:			2/Oct/2014											****
** Help:			00670843											****
** Descripcion:		Se agregan consultas L4,L5 							****
****************************************************************************
** Modifico:		Alberto Rodriguez Medina   							****
** Fecha:			04/10/2013											****
** Help:			00600025											****
** Descripcion:		Agregar consulta CC y lista L3.						****
****************************************************************************
** ModificÃ³:		Rolando J. Bernal GonzÃ¡lez							****
** Fecha:			29/10/2012											****
** Help:			00499777											****
** ModificaciÃ³n:	Agregar consulta CA.								****
****************************************************************************
** ModificÃ³:		Dariel Mora RodrÃ­guez								****
** Fecha:			15/02/2012											****
** Help Desk:		00429043											****
** DescripciÃ³n:		Se agregaro la consulta C9							****
****************************************************************************
** ModificÃ³:		Roberto Pascuale Morales Chavez						****
** Fecha:			28/Sep/11											****
** Help:			364751												****
** ModificaciÃ³n:	Se agregÃ³ Usu_Depart a C1							****
****************************************************************************
** ModificÃ³:		Alba Leonor Lara Torres								****
** Fecha:			25/Ago/11											****
** Help:			371155												****
** ModificaciÃ³n:	Se agregÃ³ EMail a L1								****
****************************************************************************
** ModificÃ³:		Ivan Hernandez Aguirre								****
** Fecha:			14/Jul/11											****
** Help:			369352												****
** ModificaciÃ³n:	Agregar Usu_Nombre a C5								****
****************************************************************************
** ModificÃ³:		Edwin E. PÃ©rez Requena								****
** Fecha:			14/Julio/2011										****
** Help:			392148												****
** DescripciÃ³n:		Se agregÃ³ Usu_IPSesi a consulta C1					****
****************************************************************************
** ModificÃ³:		Jose Hernandez										****
** Fecha:			12/Agosto/2010										****
** Help:			00151456											****
** DescripciÃ³n:		Se agrego la consulta C7	 para usuarios que 		****
**					esten en los niveles de autorizacion de SPEI		****
****************************************************************************
** ModificÃ³:		Andrea RamÃ­rez										****
** Fecha:			21/Enero/2010										****
** Help:			00246408											****
** DescripciÃ³n:		Quitar Usu_DisAct, Usu_DisAcc	 a C1				****
****************************************************************************
** ModificÃ³:		Francisco Javier Cordero Guzman						****
** Fecha:			21/Octubre/2009										****
** Help:			00223296											****
** DescripciÃ³n:		Agregar Usu_DisAct, Usu_DisAcc	 a C1				****
****************************************************************************
** ModificÃ³:		Fernando Martinez Miramontes						****
** Fecha:			29/Junio/2009										****
** Help:			169069												****
** DescripciÃ³n:		En C6, agregar modulo para multiperfiles			****
****************************************************************************
** ModificÃ³:		Fernando Martinez 									****
** Fecha:			16/Dic/2008											****
** Help:			133035												****
** DescripciÃ³n:		Quitar modulo Fabrica a consulta C6					****
****************************************************************************
** ModificÃ³:		Luis Castillo										****
** Fecha:			10/Nov/2008											****
** Help:			121200												****
** DescripciÃ³n:		Se Agrego Usu_Email a C2							****
****************************************************************************
** Si se Compila este store en ProducciÃ³n, hay que volverle a 			****
** dar acceso al usuario BLOQUEAR										****
****************************************************************************
** ModificÃ³:		AndrÃ©s Grande DÃ­az									****
** Fecha:			07/Ago/2008											****
** Help:			106698												****
** DescripciÃ³n:		Se Agrego C6										****
****************************************************************************
**					STORE CONVERTIDO									****
** ConvirtiÃ³:		Karina ChavarrÃ­a Tovar								****
** Fecha:			05/Mayo/2008										****
****************************************************************************
** ModificÃ³:		Fernando Martinez Miramontes						****
** Fecha:			29/febrero/2008										****
** Help:			63500												****
** DescripciÃ³n:		Se Agrego Usu_Activo a C5							****
****************************************************************************
** ModificÃ³:		Adrian Abril										****
** Fecha:			19/Diciembre/2007									****
** Help:			38796												****
** DescripciÃ³n:		Se Agrego Usu_Clave a C2							****
****************************************************************************
** ModificÃ³:		Adrian Abril										****
** Fecha:			13/Diciembre/2007									****
** Help:			38796												****
** DescripciÃ³n:		Agregar L2 											****
****************************************************************************
** ModificÃ³:		Ricardo Salinas										****
** Fecha:			10/Abril/2007										****
** Help:			24673												****
** DescripciÃ³n:		Agregar C5 para consulta de usuario web				****
****************************************************************************
**					STORE CONVERTIDO									****
** ConvirtiÃ³: 		Perla Judith Abundis Orozco							****
** Fecha:			15/May/06											****
****************************************************************************
** ModificÃ³:		Fernando Martinez Miramontes 						****
** Fecha:			28/Abril/2006										****
** Help:			88197												****
** DescripciÃ³n:		Agregar el campo Usu_Activo a la C1, C2 y C3		****
****************************************************************************
** ModificÃ³:		Arnoldo Garza Quezada								****
** Fecha:			05/Abril/2006										****
** Help:			ObservaciÃ³n CNBV									****
** DescripciÃ³n:		Nueva Consulta para Validar ContraseÃ±a para 		****
** 					32 caracteres Encriptados por RACAL					****
****************************************************************************
**					STORE CONVERTIDO									****
** ConvirtiÃ³: 		Perla Judith Abundis Orozco							****
** Fecha:			09/Mar/06											****
****************************************************************************
** ModificÃ³:		Sandra Almaguer  									****
** Fecha:			09/Marzo/2006										****
** Help:			ObservaciÃ³n CNBV									****
** DescripciÃ³n:		Agregue campos StaSes, IPSesi a C3					****
****************************************************************************
** 					Store CONVERTIDO 									****
** ConvirtiÃ³: 		Perla J. Abundis Orozco								****
** Fecha:			24/Dic/2004											****
****************************************************************************
** ModificÃ³:		Laura V. VÃ¡zquez									****
** Fecha:			24/Diciembre/2004									****
** DescripciÃ³n:		Agregar el Usu_Passwo a la consulta 'L1'.			****
****************************************************************************
**					Store CONVERTIDO 									****
****************************************************************************
** ModificÃ³:		Sandra Almaguer										****
** Fecha:			26/Marzo/2004										****
** DescripciÃ³n:		Quitar campo Usu_Puesto								****
****************************************************************************
** ModificÃ³:		Jorge M. Maldonado GonzÃ¡lez							****
** Fecha:			22/Ago/2003											****
** DescripciÃ³n:		Agregar campo Per_Acceso							****
****************************************************************************
** ModificÃ³:		Jorge M. Maldonado GonzÃ¡lez							****
** Fecha:			03/Julio/2003										****
** DescripciÃ³n:		Se agrego el campo: SaPerfilID		 				****
****************************************************************************
** ModificÃ³:		Ma de Lourdes ValdÃ©s								****
** Fecha:			30/Mayo/2002										****
** DescripciÃ³n:		Se agrego el campo: Usu_CoEsCu	 					****
****************************************************************************
** ModificÃ³:		Yadira Salazar Guanajuato							****
** Fecha:			14/Mayo/2002										****
** DescripciÃ³n:		Se agregaron los campos: Usu_PasEsp,				****
** 					Usu_InNoCl, Usu_CoInSu, Usu_ImEsCu					****
** 					quitar: RhEmpleaID, Usu_Emplea, Usu_Activo			****
****************************************************************************
** ModificÃ³:		Roberto GutiÃ©rrez SÃ¡nchez							****
** Fecha:			10/Abril/2001										****
** DescripciÃ³n:		Se agregÃ³ el campo Usu_Sucurs						****
****************************************************************************
** ModificÃ³:		Jorge Lozano										****
** Fecha:			07/Diciembre/2001									****
** DescripciÃ³n:		Se agrego los campos de E-mail						****
****************************************************************************
** ModificÃ³:		Sandra Almaguer										****
** Fecha:			03/Marzo/2001										****
** DescripciÃ³n:		No consultar el Password en Visual Basic			****
****************************************************************************
** ModificÃ³:		Mayra Estrada										****
** Fecha:			21/Julio/1999										****
** DescripciÃ³n:		@Tip_Consul p/ Cons. Tipificadas de Visual.			****
***************************************************************************/

declare	@Tip_ConTip	char(1),		/* DeclaraciÃ³n de Variables */
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1),		/* DeclaraciÃ³n de Constantes */
		@Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Mod_FabCon	char(2),
		@Mod_PymCon	char(2),
		@Mod_EmpCon	char(2),
		@Str_Activo	char(1),
		@Niv_AUTOP1	char(2),
		@Niv_AUTOP2	char(2),
		@Niv_AUTOP3	char(2),
		@Niv_AUTOP4	char(2),
		@Str_Porcen	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1),
		@Str_Cuatro	char(1),
		@Str_Cinco	char(1),
		@Str_Seis	char(1),
		@Str_Siete	char(1),
		@Str_Ocho	char(1),
		@Str_Nueve	char(1),
		@Str_A		char(1),
		@Str_B		char(1),
        @Str_C		char(1),
        @Str_D		char(1),
		@Str_E		char(1),
		@Str_F		char(1),
		@Str_G		char(1)

/* AsignaciÃ³n de Constantes */
select	@Str_Vacio	= '',			/* String VacÃ­o												*/
		@Tra_TipLis	= 'L',			/* Tipo : Lista												*/
		@Tra_TipCon	= 'C',			/* Tipo : Consulta											*/
		@Mod_FabCon	= 'FB',			/* MÃ³dulo Fabricas											*/
		@Mod_PymCon	= 'PY',			/* MÃ³dulo PYMe(CrÃ©dito Negocios)     						*/
		@Mod_EmpCon	= 'MS',			/* MÃ³dulo Empresarial (CrÃ©dito Comercial)					*/
		@Str_Activo	= 'A',			/* String Activo											*/
		@Niv_AUTOP1	= 'C1',			/* Nivel que tiene acceso a la autorizaciÃ³n de Ordenes SPEI	*/
		@Niv_AUTOP2	= 'C2',			/* Nivel que tiene acceso a la autorizaciÃ³n de Ordenes SPEI	*/
		@Niv_AUTOP3	= 'C3',			/* Nivel que tiene acceso a la autorizaciÃ³n de Ordenes SPEI	*/
		@Niv_AUTOP4	= 'C4',			/* Nivel que tiene acceso a la autorizaciÃ³n de Ordenes SPEI	*/
		@Str_Porcen	= '%',			/* String Porcentaje										*/
		@Str_Uno	= '1',			/* String para consulta 1									*/
		@Str_Dos	= '2',			/* String para consulta 2									*/
		@Str_Tres	= '3',			/* String para consulta 3									*/
		@Str_Cuatro	= '4',			/* String para consulta 4									*/
		@Str_Cinco	= '5',			/* String para consulta 5									*/
		@Str_Seis	= '6',			/* String para consulta 6									*/
		@Str_Siete	= '7',			/* String para consulta 7									*/
		@Str_Ocho	= '8',			/* String para consulta 8									*/
		@Str_Nueve	= '9',			/* String para consulta 9									*/
		@Str_A		= 'A',			/* String para consulta A									*/
		@Str_B		= 'B',			/* String para consulta B									*/
        @Str_C		= 'C',			/* String para consulta C									*/
        @Str_D		= 'D',			/* String para consulta D									*/
		@Str_E		= 'E',			/* String para consulta E									*/
		@Str_F		= 'F',			/* String para consulta F									*/
		@Str_G		= 'G'


select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tra_TipCon begin					/* 'C':  Consulta */

	if @Tip_ConCon = @Str_Uno begin					/* Consulta de Llave Principal */

		select	Usu.Usu_Numero,	Usu.Usu_Nombre,	Usu.Usu_Clave,	Usu.Usu_Autori,	Usu.Usu_Nivel,
				Usu.Usu_ImEsCu,	Usu.Usu_CoEsCu,	Usu.Usu_Status,	Usu.Usu_EMail,	Usu.Usu_Sucurs,
				Usu.Usu_PassWo,	Usu.Usu_FeAcPa,	Usu.SaPerfilID,	Usu.Usu_Activo,
				Aut_Nombre	= Aut.Usu_Nombre,
				Usu.Usu_IPSesi,	Usu.Usu_Depart
			from SOUSUARI Usu noholdlock,
				 SOUSUARI Aut noholdlock
			where	Usu.Usu_Autori	= Aut.Usu_Numero
			  and	Usu.Usu_Numero	= @Usu_Numero

	end else if @Tip_ConCon = @Str_Dos begin		/* Consulta de Llave Foranea */

		select	Usu_Numero,	Usu_Nombre,	Usu_Nivel,	Usu_Status,	SaPerfilID,
				Usu_Activo,	Usu_Clave,	Usu_EMail,	Usu_IPSesi
			from SOUSUARI noholdlock
			where	Usu_Numero	= @Usu_Numero
			OR Usu_Clave		= @Usu_Clave

	end else if @Tip_ConCon = @Str_Tres begin		/* Consulta de Clave de Entrada */

		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_Autori,		Usu_Nivel,
				Usu_Status,	Usu_FeAcPa,	Per_Acceso,	Usu.SaPerfilID,	Usu_StaSes,
				Usu_IPSesi,	Usu_Activo
			from SOUSUARI Usu noholdlock,
				 SAPERFIL Per noholdlock
			where	Usu.SaPerfilID	= Per.SaPerfilID
			  and	Usu_Clave		= @Usu_Clave

	end else if @Tip_ConCon = @Str_Cuatro begin		/* Consulta de Clave de Entrada - RACAL */

		/* Esta consulta es similar a la C3 pero agrega al final el campo de ContraseÃ±a */
		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_Autori,		Usu_Nivel,
				Usu_Status,	Usu_FeAcPa,	Per_Acceso,	Usu.SaPerfilID,	Usu_StaSes,
				Usu_IPSesi,	Usu_PassWo,	Usu_Activo
			from SOUSUARI Usu noholdlock,
				 SAPERFIL Per noholdlock
			where	Usu.SaPerfilID	= Per.SaPerfilID
			  and	Usu_Clave		= @Usu_Clave

	end else if @Tip_ConCon = @Str_Cinco begin		/* Consulta de Clave de Entrada para WEB */

		select	Usu_Numero,	Usu_Clave,	Usu_Status,	Usu_StaSes,	Usu_FeAcPa,
				Usu_IPSesi,	Usu_PassWo,	Usu_Sucurs,	Usu_Activo,	Usu_Nombre,
				Usu_Sucurs,	Usu_CanSes, Usu_MulSes
			from SOUSUARI Usu noholdlock
			where	Usu_Clave		= @Usu_Clave

	end else if @Tip_ConCon = @Str_Seis begin		/* Consulta de Perfil por medio del numero de usuario para FABCON*/

		select	Usu.Usu_Numero,	Usu.Usu_Clave,	Usu.Usu_Status,	Usu.Usu_StaSes,	Usu.Usu_FeAcPa,
				Usu_IPSesi,		Usu.Usu_PassWo,	Usu.Usu_Sucurs,	Usu.Usu_Activo,	Usu.Usu_Nombre,
				Per.Per_Numero,	Per.Per_Descri
			from SOUSUARI Usu noholdlock,
				 BEUSUPER UsP noholdlock,
				 BEPERFIL Per noholdlock
			where	Usu.Usu_Numero	= UsP.Usu_Numero
			  and	UsP.Usu_Perfil	= Per.Per_Numero
			  and	Per.Per_Status	= @Str_Activo
			  and	(Usu.Usu_Numero	= @Usu_Numero
			   or	Usu.Usu_Clave	= @Usu_Clave)
			  and	Per_Modulo		= @Modulo

	end else if @Tip_ConCon = @Str_Siete begin		/* Consulta de Usuarios con Perfiles de Acceso a Auto. SPEI */

		select	Usu_Numero,	Usu_Nombre
			from SOUSUARI noholdlock
			where	Usu_Nivel	in (@Niv_AUTOP1, @Niv_AUTOP2, @Niv_AUTOP3, @Niv_AUTOP4)
			  and	Usu_Numero	=  @Usu_Numero

	end else if @Tip_ConCon = @Str_Ocho begin		/* Consulta de Usuarios con Perfiles Fabrica Consumo/BPM */

		select	Usu.Usu_Numero,	Usu.Usu_Clave,	Usu.Usu_Status,	Usu.Usu_StaSes,	Usu.Usu_FeAcPa,
				Usu_IPSesi,		Usu.Usu_PassWo,	Usu.Usu_Sucurs,	Usu.Usu_Activo,	Usu.Usu_Nombre,
				Per.Per_Numero,	Per.Per_Descri
			from SOUSUARI Usu noholdlock,
				 BEUSUPER UsP noholdlock,
				 BEPERFIL Per noholdlock
			where	Usu.Usu_Numero	= UsP.Usu_Numero
			  and	UsP.Usu_Perfil	= Per.Per_Numero
			  and	Per.Per_Status	= @Str_Activo
			  and	(	Usu.Usu_Numero	= @Usu_Numero
			   or		Usu.Usu_Clave	= @Usu_Clave	)
			  and	Per_Modulo		= @Mod_FabCon

	end else if @Tip_ConCon = @Str_Nueve begin		/* Consulta de Usuarios para Interconexion Soluciona-Sibamex */

		select	Usu_Numero,	Usu_Nombre,	Usu_Nivel,	Usu_Status,	SaPerfilID,
				Usu_Activo,	Usu_Clave,	Usu_EMail,	Usu_IPSesi,	Usu_Sucurs
			from SOUSUARI noholdlock
			where	rtrim(Usu_Clave)	= rtrim(@Usu_Clave)

	end else if @Tip_ConCon = @Str_A begin			/* Consulta de Usuarios para MultisesiÃ³n */

		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,		Usu_Nivel,	Usu_EMail,
				Usu_FeAcPa,	Per_Acceso,	Usu.SaPerfilID,	Usu_Status,	Usu_Activo,
				Usu_FecDes,	Usu_FeUlAc,	Usu_StaSes,		Usu_IPSesi,	Usu_CanSes,
				Usu_MulSes
			from SOUSUARI Usu noholdlock
					 inner join SAPERFIL Per noholdlock on Per.SaPerfilID = Usu.SaPerfilID
			where	Usu_Numero		= @Usu_Numero

	end else if @Tip_ConCon = @Str_B begin			/* Consulta de Usuarios para MultisesiÃ³n */

		select	Usu_Numero,	Usu_Clave,	Usu_Status,	Usu_StaSes,	Usu_FeAcPa,
				Usu_IPSesi,	Usu_PassWo,	Usu_Sucurs,	Usu_Activo,	Usu_Nombre,
				Usu_CanSes,	Usu_MulSes
			from SOUSUARI Usu noholdlock
			where	Usu_Clave		= @Usu_Clave

	end else if @Tip_ConCon = @Str_C begin			/* Consulta de Perfil por Usuarios */

		select	SaPerfilID,	Usu_Perfil
			from SOUSUARI Usu noholdlock
			where	Usu_Numero	= @Usu_Numero

	end else if @Tip_ConCon = @Str_D begin		/* Consulta de Usuarios con Perfiles PYME (CrÃ©dito Negocios) */

		select	Usu.Usu_Numero,	Usu.Usu_Clave,	Usu.Usu_Status,	Usu.Usu_StaSes,	Usu.Usu_FeAcPa,
			Usu_IPSesi,		Usu.Usu_PassWo,	Usu.Usu_Sucurs,	Usu.Usu_Activo,	Usu.Usu_Nombre,
			Per.Per_Numero,	Per.Per_Descri
		from SOUSUARI Usu noholdlock,
			 BEUSUPER UsP noholdlock,
			 BEPERFIL Per noholdlock
		where	Usu.Usu_Numero	= UsP.Usu_Numero
		  and	UsP.Usu_Perfil	= Per.Per_Numero
		  and	Per.Per_Status	= @Str_Activo
		  and	(	Usu.Usu_Numero	= @Usu_Numero
		   or		Usu.Usu_Clave	= @Usu_Clave	)
		  and	Per_Modulo		= @Mod_PymCon

	end else if @Tip_ConCon = @Str_E begin		/* Consulta de Usuarios con Perfiles de Empresarial (CrÃ©dito Comercial) */

		select	Usu.Usu_Numero,	Usu.Usu_Clave,	Usu.Usu_Status,	Usu.Usu_StaSes,	Usu.Usu_FeAcPa,
			Usu_IPSesi,		Usu.Usu_PassWo,	Usu.Usu_Sucurs,	Usu.Usu_Activo,	Usu.Usu_Nombre,
			Per.Per_Numero,	Per.Per_Descri
		from SOUSUARI Usu noholdlock,
			 BEUSUPER UsP noholdlock,
			 BEPERFIL Per noholdlock
		where	Usu.Usu_Numero	= UsP.Usu_Numero
		  and	UsP.Usu_Perfil	= Per.Per_Numero
		  and	Per.Per_Status	= @Str_Activo
		  and	(	Usu.Usu_Numero	= @Usu_Numero
		   or		Usu.Usu_Clave	= @Usu_Clave	)
		  and	Per_Modulo		= @Mod_EmpCon

	end else if @Tip_ConCon = @Str_F begin		/* Consulta de Clave de Entrada */

		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_Autori,		Usu_Nivel,
				Usu_Status,	Usu_FeAcPa,	Per_Acceso,	Usu.SaPerfilID,	Usu_StaSes,
				Usu_IPSesi,	Usu_Activo
			from SOUSUARI Usu noholdlock,
				 SAPERFIL Per noholdlock
			where	Usu.SaPerfilID	= Per.SaPerfilID
			  and	Usu_Clave		like '%'+@Usu_Clave
	end else if @Tip_ConCon = @Str_G begin
		select
			Usu_Numero,	Usu_Nombre,	Usu_Clave, Usu_Activo, SoUsuariID
		from
			SOUSUARI Usu noholdlock
		where
			Usu_Clave		like '%'+@Usu_Clave
	end
end else begin					/* 'L':  Lista */
	select	@Usu_Nombre = ltrim(rtrim(@Usu_Nombre)) + @Str_Porcen

	if @Tip_ConCon = @Str_Uno begin				/* Lista General */
		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_EMail
			from SOUSUARI noholdlock
			where	Usu_Nombre	like @Usu_Nombre
			order by Usu_Nombre
	end

	if @Tip_ConCon = @Str_Dos begin				/* Lista General */
		select	Usu_Numero,	Usu_Nombre
			from SOUSUARI noholdlock
			order by Usu_Nombre
	end

	if @Tip_ConCon = @Str_Tres begin		/* Lista de usuarios con perfil relacionado a factoraje */
		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_Perfil,	Usu_Activo
			from SOUSUARI Usu noholdlock inner join
				 BEFAPEBA Per noholdlock
			  on Per.Fpa_NuPeBr = Usu_Perfil
			order by Usu_Numero
	end

	if @Tip_ConCon = @Str_Cuatro begin				/* Lista General mas campos de perfil */
		select	usu.Usu_Numero,	usu.Usu_Nombre,	usu.Usu_Clave,	usu.Usu_EMail,	per.Per_Descri
			from SOUSUARI usu noholdlock
			inner join SAPERFIL per	noholdlock on (usu.Usu_Perfil = per.Per_Numero)
			where	Usu_Nombre	like @Usu_Nombre
			order by Usu_Nombre
	end

	if @Tip_ConCon = @Str_Cinco begin				/* Lista General mas campos de perfil */
		select	usu.Usu_Numero,	usu.Usu_Nombre,	usu.Usu_Clave,	usu.Usu_EMail,	per.Per_Descri
			from SOUSUARI usu noholdlock
			inner join SAPERFIL per	noholdlock on (usu.Usu_Perfil = per.Per_Numero)
			where	Usu_Numero	= @Usu_Numero

	end

	if @Tip_ConCon = @Str_Seis begin				/* Lista General mas campo de activo */
		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_EMail, Usu_Activo
			from SOUSUARI noholdlock
			where	Usu_Nombre	like @Usu_Nombre
			order by Usu_Nombre
	end

	if @Tip_ConCon = @Str_Siete begin				/* Lista General mas campo de activo */
		select	Usu_Numero,	Usu_Nombre,	Usu_Clave,	Usu_EMail, Usu_Activo
			from SOUSUARI noholdlock
			where	Usu_Clave	like @Usu_Clave
	end

end
