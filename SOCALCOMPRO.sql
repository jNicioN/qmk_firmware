create procedure SOCALCOMPRO (
	@Cal_Tipo   char(2),            /* Tipo de Calculo */
    @Cal_CheExp int,                /* Cantidad de Cheques Expedidos */
	@Cal_FecApe smalldatetime,      /* Fecha de Apertura de la Cuenta */
	@Cal_MesIna int,                /* Cantidad de Meses de Inactividad de la Cuenta */
    @Cal_SalPro float,              /* Saldo Promedio de la Cuenta */
    @Cal_NumCon int,                /* Numero de Configuracion */
    @NumTransac	char(10),			/* Auditoria */
	@Transaccio	char(3),			/* Auditoria */
	@Usuario	char(6),            /* Auditoria */
	@FechaSis	smalldatetime,      /* Auditoria */
	@SucOrigen	char(3),            /* Auditoria */
	@SucDestino	char(3),            /* Auditoria */
    @Modulo		char(2)             /* Auditoria */
)
as

/***************************************************************************
** Descripción:    Calculo de comisiones para fines de reporte en       **** 
**                 modulo de comision next                              ****
****************************************************************************
** Referencias:															****
****************************************************************************
** Modificó:	Fatima Sanchez 										 	****
** Fecha:		28/May/2021											    ****
** Help: 		1471507												    ****
** Descripcion:	Se agrega convert a tipo money a los parametros de		****
**				entrada @Cal_SalPro que fueron cambiados a float		****
****************************************************************************
* Modificó:     David Carmona                                           ****
* Fecha:        07/Mayo/2021                                            ****
* Help:                                                                 ****
* Descripcion:  Se cambia tipo de dato money a float  del parametro de  ****
*               entrada:                                                ****
                          @Cal_SalPro                                   ****
****************************************************************************
** Elaboró: 		CODE4U Jonathan Perez                      			****
** Fecha:		    29/01/2020									        ****
** Help:			1286068  									        ****
** Descripción:	    Procedimiento para calculo de comisiones.           ****
****************************************************************************/

								    /* Declaración de variables  */
declare	@Status     int,			/* Estatus de la ejecucuón de los sp*/
        @Mon_Comisi	money			/* Monto de la Comision*/
        

                                    /* Declaracion de Constantes */
declare	@Com_CheLib	char(2),
		@Com_Apertu	char(2),
        @Com_Inacti	char(2),
        @Com_Aniver	char(2),
        @Com_SalMin	char(2),
        @Com_MonFij	char(2),
        @Com_SalPro	char(2),
        @Mon_Cero   money
                                            
                                    /* Asignacion de Constantes */
select  @Com_CheLib = 'C1',         /* Cheques Librados */
        @Com_Apertu = 'C2',         /* Monto Fijo por Apertura */
        @Com_Inacti = 'C3',         /* Monto Fijo por Inactividad */
        @Com_Aniver = 'C4',         /* Monto Fijo por Aniversario */
        @Com_SalMin = 'C5',         /* Monto Fijo con Saldo Minimo */
        @Com_MonFij = 'C6',         /* Monto Fijo */
        @Com_SalPro = 'C7',         /* Saldo Promedio Minimo No Cubierto */
        @Mon_Cero   = 0

/* Inicializacion */
select @Mon_Comisi = @Mon_Cero

select @Cal_SalPro = convert(money, @Cal_SalPro)


if @Cal_Tipo = @Com_CheLib begin
    /* Calculo de Comision de Tipo Cheques Librados */
    exec dbo.SOCACOCHPRO @Cal_CheExp,	@Cal_NumCon,	@Mon_Comisi output,	@NumTransac,	@Transaccio,
						 @Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
    select @Mon_Comisi =  isnull(@Mon_Comisi,@Mon_Cero)
	
end else if @Cal_Tipo = @Com_Apertu begin
    /* Calculo de Comision de Tipo Monto Fijo por Apertura */
    exec dbo.SOCACOAPPRO @Cal_FecApe,	@Cal_NumCon,	@Mon_Comisi output,	@NumTransac,	@Transaccio,
						 @Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
    select @Mon_Comisi =  isnull(@Mon_Comisi,@Mon_Cero)

end else if @Cal_Tipo = @Com_Inacti begin
    /* Calculo de Comision de Tipo Monto Fijo por Inactividad */
    exec dbo.SOCACOINPRO @Cal_MesIna,	@Cal_NumCon,	@Mon_Comisi output,	@NumTransac,	@Transaccio,
						 @Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
    select @Mon_Comisi = isnull(@Mon_Comisi,@Mon_Cero)
    
end else if @Cal_Tipo = @Com_Aniver begin
    /* Calculo de Comision de Tipo Monto Fijo por Aniversario */
    exec dbo.SOCACOANPRO @Cal_FecApe,	@Cal_NumCon,	@Mon_Comisi output,	@NumTransac,	@Transaccio,
						 @Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
    select @Mon_Comisi = isnull(@Mon_Comisi,@Mon_Cero) 
    
end else if @Cal_Tipo = @Com_SalMin begin
    /* Calculo de Comision de Tipo Monto Fijo con Saldo Minimo */
    exec dbo.SOCACOFIPRO @Cal_SalPro,	@Cal_NumCon,	@Mon_Comisi output,	@NumTransac,	@Transaccio,
						 @Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
    select @Mon_Comisi = isnull(@Mon_Comisi,@Mon_Cero) 
    
end else if @Cal_Tipo = @Com_MonFij begin
    /* Calculo de Comision de Tipo Monto Fijo */
    exec dbo.SOCACOMOPRO @Cal_NumCon,	@Mon_Comisi output,	@NumTransac,	@Transaccio,	 @Usuario,
						 @FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
    select @Mon_Comisi = isnull(@Mon_Comisi,@Mon_Cero) 

end else if @Cal_Tipo = @Com_SalPro begin
    /* Calculo de Comision de Tipo Saldo Promedio Minimo No Cubierto */
    exec dbo.SOCACOPRPRO @Cal_SalPro,	@Cal_NumCon,	@Mon_Comisi output,	@NumTransac,	@Transaccio,
						 @Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
    select @Mon_Comisi = isnull(@Mon_Comisi,@Mon_Cero) 
    
end 
    
select @Mon_Comisi as Mon_Comisi