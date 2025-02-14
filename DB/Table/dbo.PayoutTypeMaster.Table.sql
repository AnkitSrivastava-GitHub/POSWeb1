USE [pos101.priorpos.com]
GO
/****** Object:  Table [dbo].[PayoutTypeMaster]    Script Date: 11/3/2023 11:48:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayoutTypeMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PayoutType] [varchar](50) NOT NULL,
	[SeqNo] [int] NOT NULL,
 CONSTRAINT [PK_PayoutTypeMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[PayoutTypeMaster] ON 

INSERT [dbo].[PayoutTypeMaster] ([AutoId], [PayoutType], [SeqNo]) VALUES (1, N'Pruchase', 1)
INSERT [dbo].[PayoutTypeMaster] ([AutoId], [PayoutType], [SeqNo]) VALUES (2, N'Expense', 2)
SET IDENTITY_INSERT [dbo].[PayoutTypeMaster] OFF
GO
