create procedure SOVALPROPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Declaracion de Variables			*/
declare	@Str_Comand	varchar(200),
		@Val_Numero char(8),
		@Val_Tipo	char(1),
		@Str_Modulo char(2),
		@Str_Result char(1),
		@Str_MenOK 	varchar(200),
		@Str_MenNOK varchar(200),
		@Str_Mensaj varchar(200),
		@Fec_Fecha  smalldatetime,
		@Fec_FecHab smalldatetime,
		@Fec_FecInh smalldatetime,
		@Fec_FecVal smalldatetime,
		@Val_NumReg	int,
		@Int_Dias   int,
		@Int_Reg	int,
		@Str_Fecha  char(1),
		@Str_Si		char(1),
		@Str_No 	char(1),
		@Str_Vacio	char(1),
		@Str_TipDia char(1),
		@Str_DiaHab char(1),
		@Str_Count	char(1),
		@Str_SiErr  char(1),
		@Str_NoErr  char(1)
		

select 	@Str_Fecha 	= 'F',
		@Str_Si		= 'S',
		@Str_No		= 'N',
		@Str_Vacio  = '',
		@Str_DiaHab = 'H',
		@Str_Count	= 'C',
		@Fec_FecInh	= convert(char, dateadd(dd, -1, getdate()), 101),
		@Fec_FecHab = convert(char, getdate(), 101),
		@Int_Dias	= 0,
		@Str_SiErr  = '1',
		@Str_NoErr  = '0'

exec SOSIGFECHAB @Fec_FecHab,@Int_Dias,@Str_No,@Str_No


create table #tmpprocesados (
Tmp_Proces char(8) null)

create table #tmp (
Tmp_Fecha smalldatetime null)

create table #tmpcount (
Tmp_Registros Int null)

while exists ( select Val_Numero
			  from SOVALPRO noholdlock 
			where Val_Valida	!=	@Str_Vacio
			    and Val_Numero not in (select Tmp_Proces from #tmpprocesados))
begin

    set rowcount 1
    select	@Val_Numero = Val_Numero,	@Str_Comand = Val_Valida, 
    		@Str_Modulo = Val_Modulo,	@Str_MenOK 	= Val_MenOK,  
    		@Str_MenNOK = Val_MenNOK,	@Str_TipDia = Val_TipDia,
    		@Val_Tipo	= Val_Tipo,		@Val_NumReg	= Val_NumReg
	  from 	SOVALPRO noholdlock
	 where	Val_Valida  != @Str_Vacio
	    	and Val_Numero not in (select Tmp_Proces from #tmpprocesados)
    set rowcount 0
    
    execute (@Str_Comand)
    
	if @Val_Tipo = @Str_Fecha begin
	    select @Fec_Fecha = Tmp_Fecha 
    	  from #tmp

		if @Str_TipDia = 'A'
			select @Fec_FecVal = dateadd (dd, - 1, @Fec_FecHab)

		if @Str_TipDia = @Str_DiaHab
			select @Fec_FecVal = @Fec_FecHab
		 else
		 	select @Fec_FecVal = @Fec_FecInh

	    if @Fec_FecVal = @Fec_Fecha 
			select 	@Str_Result = @Str_NoErr,
        		 	@Str_Mensaj = @Str_MenOK
	      else
    	    select 	@Str_Result = @Str_SiErr,
        	   		@Str_Mensaj = @Str_MenNOK
	end else begin
	    select @Int_Reg = Tmp_Registros
	      from #tmpcount

		if @Int_Reg = @Val_NumReg
			select 	@Str_Result = @Str_NoErr,
        		 	@Str_Mensaj = @Str_MenOK
	      else
    	    select 	@Str_Result = @Str_SiErr,
        	   		@Str_Mensaj = @Str_MenNOK

	end        	   		
           		
       
    insert into #tmpprocesados
          select @Val_Numero
    
    insert into SOBITVAL
          select	@Val_Numero,	@Str_Modulo,	@Str_Result,	@Str_Mensaj,
          			@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
					@SucOrigen,		@SucDestino
    delete #tmp
    delete #tmpcount
end/* Adaptive Server has expanded all '*' elements in the following statement */ 


select SOBITVAL.Bit_Valida, SOBITVAL.Bit_Modulo, SOBITVAL.Bit_Result, SOBITVAL.Bit_Mensaj, SOBITVAL.NumTransac, SOBITVAL.Transaccio, SOBITVAL.Usuario, SOBITVAL.FechaSis, SOBITVAL.SucOrigen, SOBITVAL.SucDestino from SOBITVAL
	where FechaSis = @FechaSis

drop table #tmpprocesados, #tmp, #tmpcount

