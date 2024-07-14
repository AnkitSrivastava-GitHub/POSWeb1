USE [pos201.priorpos.com1]
GO

/****** Object:  Table [dbo].[CurrencySymbolMaster]    Script Date: 01/12/2024 4:33:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CurrencySymbolMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyName] [varchar](50) NOT NULL,
	[CurrencySymbol] [nvarchar](50) NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_CurrencySymbolMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


