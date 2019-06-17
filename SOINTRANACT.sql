create procedure SOINTRANACT (
   @Int_Clave	char(15),
   @Int_Passw 	char(32),
   @Int_NewPas	char(32),
   @Tip_Actual	char(1),    
   @Int_DirIP 	char(15),  
   @NumTransac 	char(10),
   @Transaccio 	char(3),
   @Usuario    	char(6),
   @FechaSis    smalldatetime,
   @SucOrigen   char(3),
   @SucDestino  char(3),
   @Modulo      char(2))
as

/*  Dependiendo de @Tip_Actual, puede hacer tres cosas:
       [P]	Cambiar la Contrasea (Password),
       [I]	Desactivcar la Cuenta del Usuario
       [U]	Actualizar la Fecha de Ultimo Acceso del Usuario
       [A]	NO IMPLEMENTADA (Activar el Usuario), porque desde la Intranet no se tendra
           	por el momento esta opcin, y marcar error si se quiere enviar.
   Recibe la Cuenta (Int_Clave) y con slo este dato se puede desactivar una cuenta.
   Se requiere adicionalmente la contrasea actual (@Int_Passw) para poder actualizar la fecha de ultimo acceso.
   Se requiere la contrasea nueva (@Int_NewPas) para poder hacer el cambio de contrasea.
   Ambas contraseas deben venir encriptadas.
*/
declare	@Status     int            /* Var. de Status para exec's       */

declare	@Int_CveDes varchar(15),	/* Contrase#a Desencriptada         */
   		@Int_CveEnc	varchar(15),    /* Contrase#a Encriptada para SIBAMEX     */
   		@Int_CveAux varchar(15),    /* Copia Auxiliar para Encriptar    */
   		@Int_Charac char(1),        /* Caracter Encriptado de @Int_Passw    */
  		@Int_ChrDes char(1),        /* Caracter Desencriptado        */
   		@Int_ValASC int,            /* Valor ASCII de un caracter a Encriptar    */
	   	@Int_Contad int,              
	   	@Str_Vacio  char(1),
	   	@Fec_Vacia  smalldatetime,
	  	@Sta_Inacti char(1),        /* Status de Usuario Inactivo */
	   	@Sta_Activo char(1),        /* Status de Usuario Activo */
	   	@Int_NvoDes varchar(15),    /* Contrase#a Nueva Desencriptada        */
	   	@Int_NvoEnc varchar(15),    /* Contrase#a Nueva Encriptada para SIBAMEX      */
	   	@Act_CamPas char(1),        /* Actualizacin de Cambio de Password         */
	   	@Act_InaUsu char(1),        /* Actualizacin de Inactivar Usuario        */
	   	@Act_ActUsu char(1),        /* Actualizacin de Activar Usuario - NO IMPLEMENTAR */
	   	@Act_UltAcc char(1),        /* Actualizacin de Fecha de ltimo acceso     */
   		@Usu_Numero char(6),        /* Nmero de Usuario             */
   		@Usu_Nombre char(50),       /* Nombre del Usuario            */
   		@Usu_FeAcPa smalldatetime,  /* Fecha Ultima Actualizacion de Password    */
   		@Usu_Status char(1),        /* Status del Usuario            */
   		@Usu_FeUlAc smalldatetime,  /* Fecha Ultimo Acceso           */
  		@Usu_FecDes smalldatetime,  /* Fecha Desactivacin           */
   		@Par_TiCaPa smallint,       /* Tiempo para Cambio de Password     */
   		@Act_UlAcIn char(1),        	/* Actualizacin de Fecha de ltimo acceso     */
		@Ent_Cero	int

select	@Int_CveDes	= space(32),
	   	@Int_CveEnc = space(32),
	   	@Int_CveAux = space(32),
	   	@Int_Charac = '',
	   	@Int_ChrDes = '',
	   	@Int_ValASC = 0,
	   	@Int_Contad = 0,
	   	@Str_Vacio  = '',          	/* String Vaco */
	   	@Fec_Vacia  = '1900-01-01', /* Fecha Vaca */
	   	@Sta_Inacti = 'I',          /* Status de Usuario Inactivo */
	    @Sta_Activo = 'A',          /* Status de Usuario Activo */
	    @Act_CamPas = 'P',          /* Actualizacin de Cambio de Password */
	    @Act_InaUsu = 'I',          /* Actualizacin de Inactivar Usuario */
	    @Act_ActUsu = 'A',          /* Actualizacin de Activar Usuario - NO IMPLEMENTAR */
	    @Act_UltAcc = 'U',          /* Actualizacin de Fecha de ltimo acceso */
	    @Act_UlAcIn = 'D',           /* Actualizacin de Fecha de ltimo acceso */
		@Ent_Cero	= 0

select	@FechaSis    = getdate() 	/* Fecha del Sistema */

select	@Usuario	= 'RHINTR', 
		@SucOrigen	= '001',    
		@SucDestino	= '001',    
		@Modulo		= 'SO'	

/* ******************************************************************************* */
/* Valido los datos y realizo la operacin */

/* Revisar si Existe Cuenta */
if not exists(
	select    Usu_Numero
		from SOUSUARI noholdlock
		where	Usu_Clave = @Int_Clave )	begin        /* Si No Existe la Cuenta marcar Error */
   
	/* 000001    Cuenta Inexistente o Contrasea Invlida */
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Cuenta Inexistente o Contrasea Invlida'
   return 1
 end
else begin        /* Si Existe la Cuenta        */
 	/* Consultar Numero de Usuario de la Cuenta y Otros Datos */
	select	@Usu_Numero	= Usu_Numero,    
			@Usu_Nombre = Usu_Nombre,          
			@Usu_FeAcPa = Usu_FeAcPa,    
			@Usu_Status = Usu_Status,
       		@Usu_FeUlAc = Usu_FeUlAc,     
       		@Usu_FecDes = Usu_FecDes
		from SOUSUARI noholdlock
		where	Usu_Clave 	= @Int_Clave
		  and 	Usu_PassWo 	= @Int_Passw

	/* Si la operacion es la de Desactivar al Usuario */
	if @Tip_Actual	= @Act_InaUsu 	begin 	/* ---- Desactivar Usuario ----- */   		
   		begin transaction
        exec @Status	= SOUSUARIACT	@Usu_Numero,	@Int_Clave,		@Int_Passw,	@FechaSis,	@Int_DirIP, 
        								@Act_InaUsu,    @Str_Vacio, 	@Str_Vacio, @Usuario, 	@FechaSis, 
        								@SucOrigen, 	@SucDestino,	@Modulo
       	if @Status <> @Ent_Cero	begin       	
       		/*select	Err_Codigo	= '000004',
               			Err_Mensaj	= 'Error al Intentar Inactivar Usuario'
       		*/
       		return 1               
       	end
   		/*else
        	select	Err_Codigo	= '000000',
           			Err_Mensaj	= 'Operacion Exitosa'
   		*/
   		commit transaction
   	end

 else      /* Si la operacin es la de Cambio de Contrasea o Actualizacion de Ultimo Acceso (NO Desactivar al Usuario) */
	if not exists(            /* Si Existe la cuenta con esa Contrasea */
		select	Usu_Numero
			from SOUSUARI noholdlock
			where	Usu_Clave	= @Int_Clave
       		  and 	Usu_PassWo 	= @Int_Passw )	begin       /* Si NO Existe la Cuenta con esa Contrasea marcar Error */
            /* 000001    Cuenta Inexistente o Contrasea Invlida */
			select	Err_Codigo    = '000001',
   					Err_Mensaj    = 'Cuenta Inexistente o Contrasea Invlida'
			return 1
 		end

   		else begin       /* Si Existe la cuenta con esa Contrasea */     	
		if @Tip_Actual	= @Act_CamPas	begin /* Si la Operacion es de Cambio de Contrasea */         	
     		/* Cambiar Contraseña */
       		begin transaction     			
            exec @Status = SOUSUARIACT	@Usu_Numero,	@Int_Clave,		@Int_NewPas,	@FechaSis,	@Int_DirIP, 
            							@Act_CamPas,    @Str_Vacio, 	@Str_Vacio, 	@Usuario, 	@FechaSis, 
            							@SucOrigen, 	@SucDestino,	@Modulo
           	if @Status <> @Ent_Cero	begin       	
       			/*select	Err_Codigo	= '000003',
               				Err_Mensaj	= 'Error al Intentar Cambiar Contrasea'
       			*/
       			return 1                   
       		end   
       		/*else
          		select	Err_Codigo	= '000000',
           				Err_Mensaj	= 'Operacion Exitosa'
           	*/       		    
       		commit transaction
         end
         else	
         if @Tip_Actual = @Act_UltAcc	begin  /* Si la Operacion es de Actualizacion de Ultimo Acceso */    
       		/* ---- Actualizar Fecha Ultimo Acceso ----- */
         	begin transaction
            exec @Status	= SOUSUARIACT 	@Usu_Numero, 	@Int_Clave,		@Int_Passw,	@FechaSis, 	@Int_DirIP, 
            								@Act_UlAcIn,	@Str_Vacio,		@Str_Vacio, @Usuario, 	@FechaSis,	
            								@SucOrigen, 	@SucDestino,	@Modulo
         	if @Status <> @Ent_Cero	begin        
         		/*select	Err_Codigo	= '000005',
               				Err_Mensaj	= 'Error al Intentar Actualizar la Fecha de Ultimo Acceso'
          		*/
         		return 1                  
         	end
         	commit transaction
       	end
        else begin         /* Si es otra Operacion (No Reconocida), marcar Error     */         
       		select	Err_Codigo	= '999999',
           			Err_Mensaj	= 'Error Desconocido'
       		return 1
       	end
     end
 end



