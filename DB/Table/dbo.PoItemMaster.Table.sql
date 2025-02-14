USE [PW_POS]
GO
/****** Object:  Table [dbo].[PoItemMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PoItemMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PoAutoId] [int] NULL,
	[ProductId] [int] NULL,
	[PackingId] [int] NULL,
	[RequiredQty] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
