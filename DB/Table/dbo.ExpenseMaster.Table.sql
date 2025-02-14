USE [pos101.priorpos.com]
GO
/****** Object:  Table [dbo].[ExpenseMaster]    Script Date: 11/3/2023 11:48:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpenseMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseId] [varchar](50) NULL,
	[ExpenseName] [varchar](50) NULL,
	[StoreId] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_ExpenseMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ExpenseMaster] ON 

INSERT [dbo].[ExpenseMaster] ([AutoId], [ExpenseId], [ExpenseName], [StoreId], [CreatedOn], [CreatedBy], [UpdatedBy], [UpdatedOn], [Status]) VALUES (1, N'EX100001', N'expense 1', 1, CAST(N'2023-11-02T18:52:43.670' AS DateTime), 1, NULL, NULL, 1)
INSERT [dbo].[ExpenseMaster] ([AutoId], [ExpenseId], [ExpenseName], [StoreId], [CreatedOn], [CreatedBy], [UpdatedBy], [UpdatedOn], [Status]) VALUES (2, N'EX100002', N'Expense 2', 1, CAST(N'2023-11-02T18:52:52.200' AS DateTime), 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[ExpenseMaster] OFF
GO
