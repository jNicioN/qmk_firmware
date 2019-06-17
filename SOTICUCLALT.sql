create procedure SOTICUCLALT (
   @Tcc_Numero int,
   @Tcc_TipCue int,
   @Tcc_ClEsFi int,
   @Tcc_Formul varchar(150),
   @Tcc_Captur bit,
   @Tcc_ForBas varchar(400),
   @Tcc_ForPor varchar(50),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
as

/****************************************************************/
/* DESCRIPCION: Alta de registros de tipo cuenta				*/
/*				clasificacion estado financiero       			*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Variables */
declare	@Int_Uno int

select	@Int_Uno = 1

insert into SOTICUCL 
	(Tcc_TipCue,    Tcc_ClEsFi,		Tcc_Formul,		Tcc_Captur,		Tcc_ForBas, 
	Tcc_ForPor,    	NumTransac,		Transaccio,		Usuario,		FechaSis, 
	SucOrigen,		SucDestino)
	values (
	@Tcc_TipCue,    @Tcc_ClEsFi,	@Tcc_Formul,	@Tcc_Captur,    @Tcc_ForBas, 
	@Tcc_ForPor,    @NumTransac,    @Transaccio,    @Usuario,		@FechaSis, 
	@SucOrigen,		@SucDestino) 

select @Tcc_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Tcc_Numero= @Tcc_Numero 
end
