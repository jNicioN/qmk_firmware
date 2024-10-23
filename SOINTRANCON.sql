create procedure SOINTRANCON (
  	@Int_Clave	char(15),
  	@Int_Passw	varchar(345),
 	@Int_DirIP	char(15),
 	
   	@NumTransac		char(10),
	@Transaccio		char(3),
	@Usuario		char(6),
	@FechaSis		smalldatetime,
	@SucOrigen		char(3),
	@SucDestino		char(3),
	@Modulo			char(2)
  )
  as
/*  Valida a un Usuario para firmarse en la Intranet:
    - Recibe la Contrase#a (Password), desencripta y la convierte al formato de SIBAMEX,
      para consultar y verificar la existencia de la cuenta y su estatus.
    - Consulta la contrase#a de Correo Electronico, la desencripta y la encripta para 
      enviarla a la Intranet, quien consultara asi la cuenta de correo.
    - Valida si el Perfil del usuario es de solo Internet para enviarle ese dato al manejo de perfiles de la misma,
      para evitar que el usuario cambie su contrase#a en la Intranet en vez de su plataforma.
  */

  declare	@Int_CveDes	varchar(15),		/* Contrase#a Desencriptada enviada por Intranet */
  	@Int_CveEnc	varchar(15),			/* Contrase#a Encriptada para SIBAMEX 	*/
  	@Int_CveAux	varchar(15),			/* Copia Auxiliar para Encriptar		*/
  	@Int_Charac	char(1),			/* Caracter Encriptado de @Int_Passw	*/
  	@Int_ChrDes	char(1),			/* Caracter Desencriptado				*/
	@Int_XPassw	char(15),			/* Auxiliar con Copia del Password proporcionado	*/

  	@Int_ValASC	int,				/* Valor ASCII de un caracter a Encriptar	*/
  	@Int_Contad	int,			
  	@Str_Vacio	char(1),
  	@Fec_Vacia	smalldatetime, 
  	@Sta_Inacti	char(1),			/* Status de Usuario Inactivo */
  	@Sta_Activo	char(1),			/* Status de Usuario Activo */
  
  	@Usu_Numero	char(6),			/* Número de Usuario 			*/
  	@Usu_Nombre	char(50),			/* Nombre del Usuario			*/
  	@Usu_FeAcPa	smalldatetime,			/* Fecha Ultima Actualizacion de Password	*/
 	@Usu_Status	char(1),			/* Status del Usuario			*/
 	@Usu_Activo	char(1),			/* Usuario Activo */
  	@Usu_FeUlAc	smalldatetime,		/* Fecha Ultimo Acceso			*/
  	@Usu_FecDes	smalldatetime,		/* Fecha Desactivación			*/
  	@Par_TiCaPa	smallint,			/* Tiempo para Cambio de Password 	*/
 
	@Per_Intran	int,				/* Clave de Perfil para Usuarios Exclusivos de Intranet */
	@Per_PlaInt	char(2),			/* Tipo de Usuario por Plataforma : Intranet	*/
	@Per_PlaOtr	char(2),				/* Tipo de Usuario por Plataforma : Otros	*/
	@Usu_Plataf	char(2),			/* Codigo del Tipo de Usuario segun Plataforma */
	@Usu_PassCE	char(15), 			/* Contrase#a de Correo Electronico Encriptado desde Tabla */
	@Usu_XPasCE	char(15), 			/* Auxiliar con copia de Contrase#a de Correo Electronico encriptado desde Tabla*/
  	@Cor_CveDes	char(15),			/* Correo Electronico Contrase#a Desencriptada desde la Tabla en SIBAMEX */
  	@Cor_CveEnc	char(15),			/* Contrase#a Encriptada para Intranet */
	@Int_ASCLet	int,				/* ASCII de cuarto caracter */
	@Int_ChrExt	char(1),			/* Caracter Extra a Insertar */

	@Usu_PerfID	int,				/* Perfil: Numero de Id		*/
	@Usu_PerAcc	char(1),			/* Perfil: Acceso 		*/
	@Si_Activo	char(1)
  			
  select 	@Int_CveDes 	= space(15),
  	@Int_CveEnc 	= space(15),
  	@Int_CveAux 	= space(15),
  	@Int_Charac 	= '',
  	@Int_ChrDes 	= '',

  	@Int_ValASC 	= 0,
  	@Int_Contad 	= 0,
  	@Str_Vacio	= '',			/* String Vacío */
  	@Fec_Vacia	= '1900-01-01',		/* Fecha Vacía */
  	@Sta_Inacti	= 'I',			/* Status de Usuario Inactivo */
  	@Sta_Activo	= 'A',			/* Status de Usuario Activo */

	@Per_Intran	= 600,				/* Numero de Perfil para Usuario Exclusivo de Intranet */
	@Per_PlaInt	= 'IN',				/* Tipo de Usuario por Plataforma : Intranet	*/
	@Per_PlaOtr	= 'OT',				/* Tipo de Usuario por Plataforma : Otros	*/
  	@Usu_Plataf	= @Per_PlaInt,			/* Default del Tipo de Usuario segun Plataforma: Intranet */
	@Usu_PassCE	= @Str_Vacio,			/* Contrase#a default de Correo Electronico	*/
	@Cor_CveDes	= space(15),
  	@Cor_CveEnc	= space(15),
	@Usu_PerfID	= 0,			/* Numero de Id del Perfil			*/
	@Usu_PerAcc	= 'N',			/* Valor por Omision: Acceso Antes de Apertura	*/
	@Si_Activo	= 'S'			/* El Usuario esta Activo */
  
  /* Desencriptar 
  	Convierto de la Codificacion proveniente de la Intranet a la Plana/Normal
  */
  select @Int_Contad = char_length(rtrim(ltrim(@Int_Passw)))
  select @Int_XPassw = @Int_Passw			/* Copia del Password proporcionado	*/

  	
  	select @Int_CveDes = (rtrim(@Int_CveDes) + @Int_ChrDes)
  	select @Int_XPassw = right(rtrim(@Int_XPassw), char_length(rtrim(@Int_XPassw))-1)
  	select @Int_Contad = @Int_Contad - 1
  
  
  select @Int_CveAux = 	rtrim(@Int_CveDes)	/* Obtener copia para mantener desencriptada la original */

  select @Int_Contad = char_length(rtrim(ltrim(@Int_CveAux)))	/* Inicializo contador */
  
  
  /* Resultado para Debug ----------------------------------------------------------- */
  /* Despliego Password_Enviado_Por_Intranet_Encriptado, Password_Desencriptado, Password_Encriptado_como_SIBAMEX */
  /* select @Int_Passw, @Int_CveDes, @Int_CveEnc */
  /* -------------------------------------------------------------------------------- */
  
  /* Consultar en SIBAMEX de que exista la Cuenta */
  
  /* Revisar si existe */
  if not exists(
  	select	Usu_Numero
  	from	SOUSUARI noholdlock
  	where	Usu_Clave = @Int_Clave
  		and Usu_PassWo = @Int_Passw )
    begin
  	select	Err_Codigo	= '000001', 
  		Err_Mensaj	= 'Acceso Denegado : Cuenta o Contraseña Inválida', 
  		Usu_Numero	= @Str_Vacio,
  		Usu_Nombre	= @Str_Vacio,
  		Usu_Clave	= @Int_Clave,
  		Usu_FeAcPa	= @Fec_Vacia,	
  		Usu_Status	= @Str_Vacio,	
  		Usu_FeUlAc	= @Fec_Vacia,	
  		Usu_FecDes	= @Fec_Vacia,	
  		Par_TiCaPa	= 0,
		Usu_Plataf	= @Str_Vacio,
		Usu_PassCE	= @Str_Vacio
  	return 1	
    end
  else
    begin	

  	select	@Usu_Numero = Usu_Numero,	@Usu_Nombre = Usu_Nombre,	
  		@Usu_FeAcPa = Usu_FeAcPa,	@Usu_Status = Usu_Status,
  		@Usu_FeUlAc = Usu_FeUlAc, 	@Usu_FecDes = Usu_FecDes, 	
  		@Par_TiCaPa = Par_TiCaPa, 	@Usu_PassCE = SOCORELE.Usu_PassCE,
		@Usu_PerfID = SAPERFIL.SaPerfilID,
		@Usu_PerAcc = SAPERFIL.Per_Acceso,
		@Usu_Activo	= Usu_Activo
  	from SOUSUARI noholdlock
		left join SOCORELE noholdlock
			ON SOUSUARI.Usu_Clave = SOCORELE.Usu_Clave,
		SAPARAMS noholdlock,
		SAPERFIL noholdlock
	where		
		SOUSUARI.SaPerfilID	= SAPERFIL.SaPerfilID
		and SOUSUARI.Usu_Clave = @Int_Clave		
  		and Usu_PassWo = @Int_Passw
  	
  /* Temporal cuando no esta la tabla de Contrase#as de Correo Electronico **************** 
  	select	@Usu_Numero = Usu_Numero,	@Usu_Nombre = Usu_Nombre,	
  		@Usu_FeAcPa = Usu_FeAcPa,	@Usu_Status = Usu_Status,
  		@Usu_FeUlAc = Usu_FeUlAc, 	@Usu_FecDes = Usu_FecDes, 	
  		@Par_TiCaPa = Par_TiCaPa, 	@Usu_PassCE = @Str_Vacio,
  		@Usu_Activo	= Usu_Activo
  	from SOUSUARI noholdlock , SAPARAMS noholdlock 
	where		
		SOUSUARI.Usu_Clave = @Int_Clave		
  		and Usu_PassWo = @Int_Passw
  */

  /* 000002	Acceso Denegado : Status Inactivo			(Usu_Status)			*/
  	if @Usu_Activo <> @Si_Activo
  	  begin
  		select	Err_Codigo	= '000002', 
  			Err_Mensaj	= 'Acceso Denegado : Status Inactivo', 
  			Usu_Numero	= @Usu_Numero,
  			Usu_Nombre	= @Usu_Nombre,
  			Usu_Clave	= @Int_Clave,
  			Usu_FeAcPa	= @Usu_FeAcPa,
  			Usu_Status	= @Usu_Status,
  			Usu_FeUlAc	= @Usu_FeUlAc, 
  			Usu_FecDes	= @Usu_FecDes,
  			Par_TiCaPa	= @Par_TiCaPa,		
			Usu_Plataf	= @Str_Vacio,
			Usu_PassCE	= @Str_Vacio

  		return 1	
  	  end
  	else	 
  	  if @Usu_Activo = @Si_Activo
  	    begin	/* *1* */
  /* 000003	Acceso Denegado por Desactivacion 		(Usu_FecDes)			*/
  
  /* PENDIENTE: ¿Existe esta opcion realmente ? ************************* */	
  
  /* 000004	Acceso Denegado por Requerir Nueva Contraseña	(Usu_FeAcPa + 30 <= Fecha_Actual) */			
    
    if ltrim(rtrim(@Usu_PassCE)) <> '' and (isnull(@Usu_PassCE, 'x') != 'x') 	/* Si no es vacia la contraseña */
      begin	
	    /* Obtener contraseña de Correo Electronico, si existe entonces regresarlo,
 	       si no existe, entonces regresar vacio campo */
	    /* Desencriptar contraseña del modo como se guarda, luego encriptarla en el modo como se envia a Intranet */


	    /* Desencriptar 
	  	Convierto de la Codificacion como se guarda en la Tabla a la Plana/Normal */

	    select @Int_Contad = char_length(rtrim(ltrim(@Usu_PassCE)))
  	    select @Usu_XPasCE = ltrim(rtrim(@Usu_PassCE))			/* Copia de Contrase#a de Correo Electronico encriptado	desde Tabla */

	    /* Eliminar caracteres extra que se ingresaron, posiciones 3 y 6 */
	    select @Usu_XPasCE = left(@Usu_PassCE, 2) + substring(@Usu_PassCE, 4, 2) + right(@Usu_PassCE, char_length(@Usu_PassCE)-6)

  	    while @Int_Contad > 0
    	      begin
  		select 	@Int_Charac = substring(@Usu_XPasCE, 1, 1)
  	
  		select @Int_ChrDes =  
  		case @Int_Charac 
  			/* when Codificado then normal */
			when  'f' then 'A'
			when  'r' then 'b'
			when  '0' then 'w'
			when  'T' then 'c'
			when  'A' then 'D'
			when  '9' then '4'
			when  'h' then 'I'
			when  'u' then 'E'
			when  'W' then 'j'
			when  'i' then '3'
			when  'O' then 'U'
			when  '2' then 'f'
			when  'n' then '.'
			when  'U' then 'h'
			when  'c' then '5'
			when  '.' then '7'
			when  '7' then 'M'
			when  'R' then 'Q'
			when  'K' then 'W'
			when  'Z' then 'p'
			when  'k' then '9'
			when  'D' then 'q'
			when  't' then 'R'
			when  'g' then '1'
			when  'w' then 'S'
			when  'q' then 't'
			when  's' then 'K'
			when  '3' then '0'
			when  'Q' then 'V'
			when  'L' then '@'
			when  'v' then 'X'
			when  'j' then 'G'
			when  'C' then 'y'
			when  'y' then 'Z'
			when  'H' then 'n'
			when  'Y' then 'B'		
			when  'P' then 'C'
			when  'F' then 'd'
			when  'o' then 'e'
			when  '4' then 'F'
			when  'b' then '6'
			when  'S' then 'g'
			when  'G' then 'H'
			when  'E' then 'L'
			when  'I' then 'm'
			when  'm' then 'a'
			when  '8' then '2'
			when  'a' then 'o'
			when  'J' then 'P'
			when  'z' then 'N'
			when  'x' then 'r'
			when  '@' then 's'
			when  'X' then 'i'
			when  'd' then 'j'
			when  'l' then 'k'
			when  'V' then 'l'
			when  '1' then 'T'
			when  'N' then '8'
			when  'B' then 'u'
			when  '6' then 'v'
			when  'M' then 'O'
			when  'e' then 'x'
			when  '5' then 'Y'
			when  'p' then 'z'
	  	  else ''
  	  	end

  		select @Cor_CveDes = (rtrim(@Cor_CveDes) + @Int_ChrDes)
  		select @Usu_XPasCE = right(rtrim(@Usu_XPasCE), char_length(rtrim(@Usu_XPasCE))-1)
  		select @Int_Contad = @Int_Contad - 1
 
    	      end

 	    /* El resultado queda en @Cor_CveDes	*/

	    /* --- Termina Desencriptacion ----------------------------------------------------- */

	    /* ********************************************************************************* */
	    /* ********************************************************************************* */
	    /* ********************************************************************************* */

	    /* Encriptar 
	  	Convierto de la forma Plana/Normal a la Codificacion para que la lea la Intranet */

		select @Int_Contad = char_length(rtrim(ltrim(@Cor_CveDes)))
  		select @Usu_XPasCE = @Cor_CveDes	/* Copia de Contrase#a de Correo Electronico encriptado	desde Tabla */

		while @Int_Contad > 0
		  begin
			select 	@Int_Charac = substring(@Usu_XPasCE, 1, 1)
		
			select @Int_ChrDes =  
			case @Int_Charac 
			    /* 	when normal then codificado */	
				when  'H' then 'A'
		  		when  'a' then 'b'
		  		when  'J' then '@'
		  		when  '6' then 'c'
		  		when  '@' then 'D'
		  		when  'x' then '4'
		  		when  'B' then 'E'
		  		when  'i' then 'f'
		  		when  'O' then 'G'
		  		when  'y' then 'h'
		  		when  'n' then '5'
		  		when  'U' then 'i'
		  		when  'c' then 'J'
		  		when  'z' then 'k'
		  		when  'K' then 'l'
		  		when  'q' then '7'
		  		when  's' then 'M'
		  		when  '3' then 'N'
		  		when  'D' then 'O'
		  		when  'L' then 'p'
		  		when  'v' then '8'
		  		when  'W' then 'q'
		  		when  'm' then 'R'
		  		when  'b' then '1'
		  		when  'P' then 'S'
		  		when  '7' then 't'
		  		when  'f' then 'U'
		  		when  'r' then '0'
		  		when  '0' then 'V'
		  		when  'T' then 'w'
		  		when  'A' then 'X'
		  		when  '9' then '.'
		  		when  'h' then 'y'
		  		when  'j' then 'Z'
		  		when  'X' then 'a'
		  		when  'G' then 'B'		
		  		when  'E' then 'C'
		  		when  'I' then 'd'
		  		when  'o' then 'e'
		  		when  '4' then 'F'
		  		when  'Y' then '6'
		 		when  'N' then 'g'
		  		when  '8' then 'H'
		  		when  'u' then 'I'
		  		when  'C' then 'j'
		  		when  '2' then '3'
		  		when  'Z' then 'K'
		  		when  'k' then 'L'
		  		when  'Q' then 'm'
		  		when  '.' then 'n'
		  		when  'S' then '2'
		  		when  'd' then 'o'
		  		when  'l' then 'P'
		  		when  'V' then 'Q'
		  		when  '1' then 'r'
		  		when  'w' then 's'
		  		when  'M' then 'T'
		  		when  'e' then '9'
		  		when  '5' then 'u'
		  		when  'p' then 'v'
		  		when  'F' then 'W'
		  		when  'R' then 'x'
		  		when  't' then 'Y'
		  		when  'g' then 'z'
		  		else ''
		  	end
	
	    		select @Cor_CveEnc = (rtrim(@Cor_CveEnc) + @Int_ChrDes)
	    		select @Usu_XPasCE = right(rtrim(@Usu_XPasCE), char_length(rtrim(@Usu_XPasCE))-1)
	    		select @Int_Contad = @Int_Contad - 1

  		  end

		select @Cor_CveEnc = ltrim(rtrim(@Cor_CveEnc))

		/* Generamos un caracter que aparente ser aleatorio para insertar en el tercer puesto */
		select @Int_ASCLet = ascii(left(@Int_Passw , 1))		/* Ascii de 4o caracter	*/

		select @Int_ASCLet = @Int_ASCLet + 13	
		if @Int_ASCLet = 47		/* Validar que no caiga en un caracter fuera del set valido */
			select @Int_ChrExt = char(46)
		else
		  if @Int_ASCLet > 57 and @Int_ASCLet < 64
			select @Int_ChrExt = char(@Int_ASCLet - 10)
		  else
		    if @Int_ASCLet > 90 and @Int_ASCLet < 97
			select @Int_ChrExt = char(@Int_ASCLet - 25)
		    else
			if @Int_ASCLet > 122
				select @Int_ChrExt = char(@Int_ASCLet - 25)
			else
				select @Int_ChrExt = char(@Int_ASCLet)

		/* Generamos Clave para enviar */
		select @Cor_CveEnc = left(@Cor_CveEnc,2) + @Int_ChrExt +  right(@Cor_CveEnc, char_length(@Cor_CveEnc)-2) 


	    /* --- Termina Encriptacion ----------------------------------------------------- */
      end
    else	/* Si es Vacia la Contraseña entonces pasar un vacio	*/
      select @Cor_CveEnc = @Str_Vacio


 /* Resultado para Debug ----------------------------------------------------------- */
 /* Despliego Password_Enviado_Por_SIBAMEX_Encriptado, Password_Desencriptado, Password_Encriptado_como_Intranet */
 /* select @Usu_PassCE, @Cor_CveDes, @Cor_CveEnc 	*/
 /* -------------------------------------------------------------------------------- */
	    /* Si el Perfil del Usuario es diferente al de Usuario Exclusivo de Intranet, entonces regresamos
		un Usuario de Plataforma: Otros */
	    if @Usu_PerfID = @Per_Intran
		select @Usu_Plataf = @Per_PlaInt
	    else
		select @Usu_Plataf = @Per_PlaOtr

  	    if dateadd(dd, @Par_TiCaPa, @Usu_FeAcPa) <= getdate()
  	      begin
  	  	/* Requiere Nueva Contraseña */ 
  		select	Err_Codigo	= '000004', 
  			Err_Mensaj	= 'Acceso Denegado por Requerir Nueva Contraseña', 
  			Usu_Numero	= @Usu_Numero,
  			Usu_Nombre	= @Usu_Nombre,
  			Usu_Clave	= @Int_Clave,
  			Usu_FeAcPa	= @Usu_FeAcPa,
  			Usu_Status	= @Usu_Status,
  			Usu_FeUlAc	= @Usu_FeUlAc, 
  			Usu_FecDes	= @Usu_FecDes,
  			Par_TiCaPa	= @Par_TiCaPa,		
			Usu_Plataf	= @Usu_Plataf,
			Usu_PassCE	= @Cor_CveEnc		/* Aqui si hay que enviar la contrase#a por aquello de
								que el usuario sea de otra plataforma donde tenga que 
								cambiar su contrase#a AHI forzosamente, en la Intranet
								debera poder pasar aun y que este caduca, y para esto
								necesita el correo electronico */
  		return 1	
  	      end
  	    else
  	      begin
  		/* No hay problema, todo correcto */
 
 		insert into SOINTLOG
 			values( @Int_Clave, @Int_DirIP, getdate() )

  		select	Err_Codigo	= '000000', 
  			Err_Mensaj	= 'Acceso Concedido', 
  			Usu_Numero	= @Usu_Numero,
  			Usu_Nombre	= @Usu_Nombre,
  			Usu_Clave	= @Int_Clave,
  			Usu_FeAcPa	= @Usu_FeAcPa,
  			Usu_Status	= @Usu_Status,
  			Usu_FeUlAc	= @Usu_FeUlAc, 
  			Usu_FecDes	= @Usu_FecDes,
  			Par_TiCaPa	= @Par_TiCaPa,		
			Usu_Plataf	= @Usu_Plataf,
			Usu_PassCE	= @Cor_CveEnc
  		return 1	
  	      end
  /* PENDIENTE: Modificar fecha de ultimo acceso ***********************************/

  	    end	/* *1* */
  	  else /* Status no es Inactivo ni Activo, marcar error */
  	    begin
  		select	Err_Codigo	= '999999', 
  			Err_Mensaj	= 'Error Desconocido', 
  			Usu_Numero	= @Str_Vacio,
  			Usu_Nombre	= @Str_Vacio,
  			Usu_Clave	= @Int_Clave,
  			Usu_FeAcPa	= @Fec_Vacia,	
  			Usu_Status	= @Str_Vacio,	
  			Usu_FeUlAc	= @Fec_Vacia,	
  			Usu_FecDes	= @Fec_Vacia,	
  			Par_TiCaPa	= 0	,	
			Usu_Plataf	= @Str_Vacio,
			Usu_PassCE	= @Str_Vacio
  		return 1	
  	    end
    end
