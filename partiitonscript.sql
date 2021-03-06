USE [AdventureWorks2019]
GO
BEGIN TRANSACTION
CREATE PARTITION FUNCTION [PFbyID](int) AS RANGE LEFT FOR VALUES (N'10790')


CREATE PARTITION SCHEME [PSbyID] AS PARTITION [PFbyID] TO ([id10790], [id10791])




CREATE CLUSTERED INDEX [ClusteredIndex_on_PSbyID_637642071485829329] ON [dbo].[sql_part]
(
	[ID]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PSbyID]([ID])


DROP INDEX [ClusteredIndex_on_PSbyID_637642071485829329] ON [dbo].[sql_part]






COMMIT TRANSACTION



