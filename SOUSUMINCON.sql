create procedure SOUSUMINCON (
	@Usuario	char(5))

as

select	Nombre	= Usu_Nombre,
		Perfil	= Per_Descri,
		Sucurs	= Suc_Numero + ' - ' + ltrim(rtrim(Suc_Nombre))
	from SOUSUARI noholdlck,
		 SAPERFIL noholdlock,
		 SOSUCURS noholdlock
	where	Usu_Perfil	= Per_Numero
	  and	Usu_Sucurs	= Suc_Numero
	  and	substring(Usu_Clave, 4, 5) = @Usuario
