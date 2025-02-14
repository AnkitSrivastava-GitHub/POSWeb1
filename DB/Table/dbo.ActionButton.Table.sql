USE [pos201.priorpos.com]
GO
/****** Object:  Table [dbo].[ActionButton]    Script Date: 01/09/2024 4:14:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionButton](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ButtonName] [varchar](50) NOT NULL,
	[ButtonColor] [varchar](20) NULL,
	[SeqNo] [int] NOT NULL,
 CONSTRAINT [PK_ActionButton] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ActionButton] ON 

INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (1, N'No Sale', N'#526f84', 1)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (2, N'Save as Draft Order', N'#ff996b', 2)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (3, N'Draft List', N'#4cbb9f', 3)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (4, N'Discount', N'#92afa0', 4)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (5, N'Add Screen', N'#c98069', 5)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (7, N'Add To Screen', N'#c98069', 6)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (8, N'Deposit', N'#cab287', 7)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (9, N'Withdraw', N'#f6cacb', 8)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (10, N'Safe Cash List', N'#929a68', 9)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (11, N'Payout', N'#e4d973', 10)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (12, N'Payout List', N'#e4d973', 11)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (13, N'Invoice List', N'#4c74bb', 12)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (14, N'End Shift', N'#ff0000', 13)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (15, N'Clock In/Out', N'#9bcdff', 14)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (16, N'Sale Gift Card', N'#9bcdff', 15)
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo]) VALUES (17, N'Gift Card Look Up', N'#9bcdff', 16)
SET IDENTITY_INSERT [dbo].[ActionButton] OFF
GO
