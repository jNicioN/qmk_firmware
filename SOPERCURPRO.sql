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
