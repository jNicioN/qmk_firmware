create procedure SOPERCURPRO (
	@Per_Numero	char(8),
	@Tip_Proces	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/*
********************************************************************
** DESCRIPCION: Proceso de personas por CURP					  **
********************************************************************
** REFERENCIAS: 												  **
********************************************************************
** Modificó:	Javier Eduardo Ceron Rangel		                ****
** Fecha:	    04/08/2023      					            ****
** Help:	    TRACL-5498 						                ****
** Descripción:	Se hace ajuste para que se guarde bitacora		****
****************************************************************************
** Modifico:	Armando Alexis Sepulveda Cruz					****
** Fecha:		05/Enero/2022									****
** Help:		1379522											****
** Descripcion:	Se añade la actualización de los campos 		****
**				DaP_PaiNac, DaP_EntNac, Per_Entida, Per_Nacion 	****
**				y Adi_NacExt para para asignar la nacionalidad 	****
**				correspondiente									**** 
********************************************************************
** Modifico:	Armando Alexis Sepulveda Cruz					****
** Fecha:		01/Noviembre/2021								****
** Help:		1379522											****
** Descripcion:	Se agrega el tipo de proceso 1 para actualizar	****
**				la persona antigua y nuevo lider del grupo para	****
**				que tome los valores del enrolamiento marcado   ****
**				verficado del INE y RENAPO
********************************************************************
** Creo:	Marcelo Bautista Hernandez							****
** Fecha:	11-Abr-2019											****
** Help:	01223447											****
********************************************************************
*/

/*Declaración constantes*/
declare	@Str_Vacios	char(1),
		@Str_Porcen	char(1),
		@Lon_Curp	smallint,
		@Ent_Uno	smallint

/* Declaraciýn de variables para la bitacora se SOPERSON*/
declare	@Bit_NumPer	char(8),
		@Bit_Fecha	smalldatetime,
		@Bit_NumTra	char(10),
		@Bit_Tipo	char(1),
		@Bit_NuSeFi	varchar(30),
		@Bit_Titulo	varchar(10),
		@Bit_Nombre	varchar(40),
		@Bit_ApePat	varchar(40),
		@Bit_ApeMat	varchar(40),
		@Bit_RazSoc	varchar(150),
		@Bit_Comple	varchar(150),
		@Bit_ComOrd	varchar(150),
		@Bit_RFC	char(15),
		@Bit_CURP	char(18),
		@Bit_Calle	char(40),
		@Bit_CalNum	varchar(10),
		@Bit_Coloni	varchar(150),
		@Bit_Entida	char(3),
		@Bit_Locali	char(8),
		@Bit_CodPos	char(6),
		@Bit_ApaPos	char(6),
		@Bit_LadTel	varchar(8),
		@Bit_Telefo	char(15),
		@Bit_Email	varchar(50),
		@Bit_ComDom	char(1),
		@Bit_EstCiv	varchar(20),
		@Bit_Nacion	char(3),
		@Bit_ActEmp	char(1),
		@Bit_Giro	char(30),
		@Bit_Sector	char(3),
		@Bit_Activi	char(10),
		@Bit_ActINE	varchar(10)

/* Declaracion de variables para SOPERSOADI*/
declare @Bia_PerNum	char(8),
		@Bia_Fecha	smalldatetime,
		@Bia_NumTra	char(10),
		@Bia_LugNac	varchar(50),
		@Bia_Sexo	char(1),
		@Bia_FecNac	smalldatetime,
		@Bia_RegMat	char(1),
		@Bia_VivCas	char(1),
		@Bia_TieRes	int,
		@Bia_Fax    varchar(20),
		@Bia_NumDep	int,
		@Bia_Puesto	varchar(50),
		@Bia_Ocupac	varchar(50),
		@Bia_AntLab	int,
		@Bia_LugTra	varchar(50),
		@Bia_TelTra	varchar(20),
		@Bia_CalTra	varchar(20),
		@Bia_NuCaTr	varchar(30),
		@Bia_ColTra	varchar(50),
		@Bia_Locali	char(8),
		@Bia_CPTra	varchar(50),
		@Bia_FecCon	smalldatetime,
		@Bia_CaNuIn	varchar(10),
		@Bia_NacExt	char(1),
		@Bia_Reside	char(1),
		@Bia_DocEst	char(3),
		@Bia_OtDoEs	varchar(50),
		@Bia_FeExDo	smalldatetime,
		@Bia_CalInm	char(1),
		@Bia_CalExt	varchar(40),
		@Bia_CaNuEx	varchar(10),
		@Bia_ColExt	varchar(150),
		@Bia_LocExt	varchar(40),
		@Bia_EntExt	varchar(40),
		@Bia_PaiExt	varchar(3),
		@Bia_CoPoEx	char(6),
		@Bia_TipIde	char(1),
		@Bia_OtrIde	varchar(50),
		@Bia_NumIde	varchar(30),
		@Bia_FeExId	smalldatetime,
		@Bia_FeVeId	smalldatetime,
		@Bia_NuIdFi	varchar(20),
		@Bia_EntPri	varchar(40),
		@Bia_EntSeg	varchar(40)

/*Declaración variables*/
declare	@Peu_Grupo	char(8),
		@Per_Grupo  char(8),
		@Ent_Cero	int,
		@Status		int,
		@Tip_ActDat	char(1),
		@Per_Nombre char(40),
		@Per_ApePat char(40),
		@Per_ApeMat char(40),
		@Per_Comple char(180),
		@Per_ComOrd char(180),
		@Per_Nacion char(3),					/* Pais de Nacimiento */
		@Per_Entida char(3),
		@Per_RFC    char(15),
		@Per_CURP   char(18),
		@Adi_FecNac	smalldatetime,
		@Adi_Sexo	char(1),
		@Adi_NuIdFi char(20),
		@Adi_FeExId smalldatetime,
		@Adi_FeVeId smalldatetime,
		@DaP_PaiNac char(3),
		@DaP_EntNac char(3),
		@DaP_ClvEle char(18),
		@DaP_NumEmi char(2),
		@Adi_NacExt char(1)

/* Asignación de constantes */
select	@Str_Vacios	= '',			-- String Vacio
		@Ent_Cero	= 0,			-- Entero en Cero
		@Str_Porcen	= '%',
		@Lon_Curp	= 18,
		@Ent_Uno	= 1,
		@Tip_ActDat	= '1'			-- Proceso de actualización de datos

select	@Per_Grupo	= isnull(Peu_Grupo,	@Str_Vacios)
	from SOUNIPER noholdlock 
	where  Peu_Person	= @Per_Numero

select	@Per_Nombre     = Per_Nombre,
		@Per_ApePat     = Per_ApePat,
		@Per_ApeMat     = Per_ApeMat,
		@Per_Comple     = Per_Comple,
		@Per_ComOrd     = Per_ComOrd,
		@Per_Nacion		= Per_Nacion,
		@Per_Entida     = Per_Entida,
		@Per_RFC        = Per_RFC,
		@Per_CURP       = Per_CURP
  from SOPERSON noholdlock
 where Per_Numero = @Per_Numero

if char_length(ltrim(rtrim(@Per_CURP))) <> @Lon_Curp begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Longitud de curp incorrecto'
	rollback
	return @Ent_Uno
end

select @Peu_Grupo = min(Peu_Grupo)
  from SOUNIPER (index SOUNIPERPER) noholdlock
 where Peu_Person in (select	Per_Numero
								from SOPERSON noholdlock 
								where	Per_Comple	= @Per_Comple and Per_CURP	= @Per_CURP)
	
if ltrim(@Per_Grupo) <> ltrim(@Str_Vacios) begin							/* Actualizar grupo*/
	if @Per_Grupo <> @Peu_Grupo and isnull(ltrim(@Peu_Grupo), @Str_Vacios) <> @Str_Vacios begin
	    update SOUNIPER set
		       Peu_Grupo  = @Peu_Grupo,
			   
			   NumTransac  = @NumTransac,
			   Transaccio  = @Transaccio,
			   Usuario	   = @Usuario,
			   FechaSis	   = @FechaSis,

			   SucOrigen   = @SucOrigen,
			   SucDestino  = @SucDestino
		 where Peu_Person  = @Per_Numero
		 
		if @Tip_Proces = @Tip_ActDat begin
			select	@Adi_FecNac	= Adi_FecNac,
					@Adi_Sexo	= Adi_Sexo,
					@Adi_NuIdFi = Adi_NuIdFi,
					@Adi_FeExId = Adi_FeExId,
					@Adi_FeVeId = Adi_FeVeId,
					@Adi_NacExt = Adi_NacExt
			  from SOPERADI noholdlock
			 where Adi_PerNum = @Per_Numero
			 
			select	@DaP_PaiNac = DaP_PaiNac,
					@DaP_EntNac = DaP_EntNac,
					@DaP_ClvEle = DaP_ClvEle,
					@DaP_NumEmi = DaP_NumEmi
			  from SOPEDACO noholdlock
			 where DaP_Person = @Per_Numero

			/* Respaldar SOPERSON y agregarlo en la BITACORA */
			select	@Bit_NumPer	= Per_Numero,
					@Bit_Fecha	= Per_Fecha,
					@Bit_NumTra	= Per_NumTra,
					@Bit_Tipo	= Per_Tipo,
					@Bit_NuSeFi	= Per_NuSeFi,
					@Bit_Titulo	= Per_Titulo,
					@Bit_Nombre	= Per_Nombre,
					@Bit_ApePat	= Per_ApePat,
					@Bit_ApeMat	= Per_ApeMat,
					@Bit_RazSoc	= Per_RazSoc,
					@Bit_Comple	= Per_Comple,
					@Bit_ComOrd	= Per_ComOrd,
					@Bit_RFC	= Per_RFC,
					@Bit_CURP	= Per_CURP,
					@Bit_Calle	= Per_Calle,
					@Bit_CalNum	= Per_CalNum,
					@Bit_Coloni	= Per_Coloni,
					@Bit_Entida	= Per_Entida,
					@Bit_Locali	= Per_Locali,
					@Bit_CodPos	= Per_CodPos,
					@Bit_ApaPos	= Per_ApaPos,
					@Bit_LadTel	= Per_LadTel,
					@Bit_Telefo	= Per_Email,  
					@Bit_Email	= Per_Email,
					@Bit_ComDom	= Per_ComDom,
					@Bit_EstCiv	= Per_EstCiv,
					@Bit_Nacion	= Per_Nacion,
					@Bit_ActEmp	= Per_ActEmp,
					@Bit_Giro	= Per_Giro,
					@Bit_Sector	= Per_Sector,
					@Bit_Activi	= Per_Activi,
					@Bit_ActINE	= Per_ActINE
			from SOPERSON noholdlock
			where	Per_Numero = @Peu_Grupo

			exec @Status = SOBITPERALT
				@Bit_NumPer,	@Bit_Fecha,		@Bit_NumTra,	@Bit_Tipo,		@Bit_NuSeFi,
				@Bit_Titulo,	@Bit_Nombre,	@Bit_ApePat,	@Bit_ApeMat,	@Bit_RazSoc,
				@Bit_Comple,	@Bit_ComOrd,	@Bit_RFC,		@Bit_CURP,		@Bit_Calle,
				@Bit_CalNum,	@Bit_Coloni,	@Bit_Entida,	@Bit_Locali,	@Bit_CodPos,
				@Bit_ApaPos,	@Bit_LadTel,	@Bit_Telefo,	@Bit_Email,		@Bit_ComDom,
				@Bit_EstCiv,	@Bit_Nacion,	@Bit_ActEmp,	@Bit_Giro,		@Bit_Sector,
				@Bit_Activi,	@Bit_ActINE,	@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo	

			if @Status <> @Ent_Cero begin
				select	Err_Mensaj	= 'Error en ejecución del proceso de BITACORA DE PERSONAS.'
				return @Ent_Uno
			end

			update SOPERSON set
				Per_Nombre     = @Per_Nombre,
				Per_ApePat     = @Per_ApePat,
				Per_ApeMat     = @Per_ApeMat,
				Per_Comple     = @Per_Comple,
				Per_ComOrd     = @Per_ComOrd,
				Per_Nacion	   = @Per_Nacion,
				Per_Entida     = @Per_Entida,
				Per_RFC        = @Per_RFC,
				Per_CURP       = @Per_CURP,
				
				NumTransac	= @NumTransac,
				Transaccio	= @Transaccio,
				Usuario		= @Usuario,
				FechaSis	= @FechaSis,
				SucOrigen	= @SucOrigen,
				SucDestino	= @SucDestino
			 where Per_Numero = @Peu_Grupo


			/*Respaldando SOPERADI y registrando en bitacora*/
			select	@Bia_PerNum	= Adi_PerNum,
					@Bia_Fecha	= Adi_Fecha,
					@Bia_NumTra	= Adi_NumTra,
					@Bia_LugNac	= Adi_LugNac,
					@Bia_Sexo	= Adi_Sexo,
					@Bia_FecNac	= Adi_FecNac,
					@Bia_RegMat	= Adi_RegMat,
					@Bia_VivCas	= Adi_VivCas,
					@Bia_TieRes	= Adi_TieRes,
					@Bia_Fax	= Adi_Fax,
					@Bia_NumDep	= Adi_NumDep,
					@Bia_Puesto	= Adi_Puesto,
					@Bia_Ocupac	= Adi_Ocupac,
					@Bia_AntLab	= Adi_AntLab,
					@Bia_LugTra	= Adi_LugTra,
					@Bia_TelTra	= Adi_TelTra,
					@Bia_CalTra	= Adi_CalTra,
					@Bia_NuCaTr	= Adi_NuCaTr,
					@Bia_ColTra	= Adi_ColTra,
					@Bia_Locali	= Adi_Locali,
					@Bia_CPTra	= Adi_CPTra,
					@Bia_FecCon	= Adi_FecCon,
					@Bia_CaNuIn	= Adi_CaNuIn,
					@Bia_NacExt	= Adi_NacExt,
					@Bia_Reside	= Adi_Reside,
					@Bia_DocEst	= Adi_DocEst,
					@Bia_OtDoEs	= Adi_OtDoEs,
					@Bia_FeExDo	= Adi_FeExDo,
					@Bia_CalInm	= Adi_CalInm,
					@Bia_CalExt	= Adi_CalExt,
					@Bia_CaNuEx	= Adi_CaNuEx,
					@Bia_ColExt	= Adi_ColExt,
					@Bia_LocExt	= Adi_LocExt,
					@Bia_EntExt	= Adi_EntExt,
					@Bia_PaiExt	= Adi_PaiExt,
					@Bia_CoPoEx	= Adi_CoPoEx,
					@Bia_TipIde	= Adi_TipIde,
					@Bia_OtrIde	= Adi_OtrIde,
					@Bia_NumIde	= Adi_NumIde,
					@Bia_FeExId	= Adi_FeExId,
					@Bia_FeVeId	= Adi_FeVeId,
					@Bia_NuIdFi	= Adi_NuIdFi,
					@Bia_EntPri	= Adi_EntPri,
					@Bia_EntSeg	= Adi_EntSeg
				from SOPERADI noholdlock
				where	Adi_PerNum	= @Peu_Grupo
			
			exec @Status = SOBIPEADALT
				@Bia_PerNum,	@Bia_Fecha,		@Bia_NumTra,	@Bia_LugNac,	@Bia_Sexo,
				@Bia_FecNac,	@Bia_RegMat,	@Bia_VivCas,	@Bia_TieRes,	@Bia_Fax,
				@Bia_NumDep,	@Bia_Puesto,	@Bia_Ocupac,	@Bia_AntLab,	@Bia_LugTra,
				@Bia_TelTra,	@Bia_CalTra,	@Bia_NuCaTr,	@Bia_ColTra,	@Bia_Locali,
				@Bia_CPTra,		@Bia_FecCon,	@Bia_CaNuIn,	@Bia_NacExt,	@Bia_Reside,
				@Bia_DocEst,	@Bia_OtDoEs,	@Bia_FeExDo,	@Bia_CalInm,	@Bia_CalExt,
				@Bia_CaNuEx,	@Bia_ColExt,	@Bia_LocExt,	@Bia_EntExt,	@Bia_PaiExt,
				@Bia_CoPoEx,	@Bia_TipIde,	@Bia_OtrIde,	@Bia_NumIde,	@Bia_FeExId,
				@Bia_FeVeId,	@Bia_NuIdFi,	@Bia_EntPri,	@Bia_EntSeg,	@NumTransac,
				@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
				@Modulo

			if @Status <> @Ent_Cero begin
				select	Err_Mensaj	= 'Error en ejecución del proceso de BITACORA DE PERSONAS.'
				return @Ent_Uno
			end

			 update SOPERADI set
				Adi_FecNac	= @Adi_FecNac,
				Adi_Sexo	= @Adi_Sexo,
				Adi_NuIdFi 	= @Adi_NuIdFi,
				Adi_FeExId 	= @Adi_FeExId,
				Adi_FeVeId 	= @Adi_FeVeId,
				Adi_NacExt	= @Adi_NacExt,
				
				NumTransac	= @NumTransac,
				Transaccio	= @Transaccio,
				Usuario		= @Usuario,
				FechaSis	= @FechaSis,
				SucOrigen	= @SucOrigen,
				SucDestino	= @SucDestino
			where Adi_PerNum = @Peu_Grupo
			
			update SOPEDACO set
				DaP_PaiNac = @DaP_PaiNac,
				DaP_EntNac = @DaP_EntNac,
				DaP_ClvEle = @DaP_ClvEle,
				DaP_NumEmi = @DaP_NumEmi,
				
				NumTransac	= @NumTransac,
				Transaccio	= @Transaccio,
				Usuario		= @Usuario,
				FechaSis	= @FechaSis,
				SucOrigen	= @SucOrigen,
				SucDestino	= @SucDestino
			where DaP_Person = @Peu_Grupo 
		end
	end 
end else begin																/* Alta de grupo*/
	if isnull(ltrim(@Peu_Grupo), @Str_Vacios) = @Str_Vacios
		select	@Peu_Grupo = @Per_Numero

	exec @Status =  SOUNIPERALT
		@Peu_Grupo,	@Per_Numero,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,	@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return 1

	end
end

if @@nestlevel = @Ent_Uno begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado',
			Peu_Grupo	= @Peu_Grupo,
			Per_Numero	= @Per_Numero
end
