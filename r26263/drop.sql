if exists	(select 1
				from sysobjects
				where id = object_id('dbo.SOPECLDCCON')
				  and type='P') begin
	drop procedure dbo.SOPECLDCCON
end
