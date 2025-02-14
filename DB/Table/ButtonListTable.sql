USE [pos201.priorpos.com1]
GO
/****** Object:  Table [dbo].[ActionButton]    Script Date: 01/26/2024 7:01:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionButton](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ButtonName] [varchar](50) NOT NULL,
	[ButtonColor] [varchar](20) NULL,
	[SeqNo] [int] NOT NULL,
	[Type] [varchar](50) NULL,
 CONSTRAINT [PK_ActionButton] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ActionButton] ON 

INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (1, N'No Sale', N'#526f84', 1, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (2, N'Save as Draft Order', N'#ff996b', 2, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (3, N'Draft List', N'#4cbb9f', 3, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (4, N'Discount', N'#92afa0', 4, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (5, N'Add Screen', N'#c98069', 5, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (7, N'Add To Screen', N'#c98069', 6, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (8, N'Deposit', N'#cab287', 7, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (9, N'Withdraw', N'#f6cacb', 8, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (10, N'Safe Cash List', N'#929a68', 9, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (11, N'Payout', N'#e4d973', 10, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (12, N'Payout List', N'#e4d973', 11, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (13, N'Invoice List', N'#4c74bb', 12, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (14, N'End Shift', N'#ff0000', 13, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (15, N'Clock In/Out', N'#9bcdff', 14, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (16, N'Sale Gift Card', N'#9bcdff', 15, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (17, N'Gift Card Look Up', N'#9bcdff', 16, N'Action')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (18, N'1', N'#ff996b', 1, N'Currency')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (19, N'5', N'#4cbb9f', 2, N'Currency')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (20, N'10', N'#92afa0', 3, N'Currency')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (21, N'20', N'#c98069', 4, N'Currency')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (22, N'50', N'#4c74bb', 5, N'Currency')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (23, N'100', N'#526f84', 6, N'Currency')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (24, N'Custom Pay', N'#c98069', 1, N'Pay')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (25, N'', N'#4c74bb', 2, N'Pay')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (26, N'Coupon', N'#4cbb9f', 1, N'PayFrom')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (27, N'Gift Card', N'#ff996b', 2, N'PayFrom')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (28, N'Reward Points', N'#92afa0', 3, N'PayFrom')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (29, N'Go Back', N'#ff0000', 1, N'Footer')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (30, N'Credit Card', N'#526f84', 2, N'Footer')
INSERT [dbo].[ActionButton] ([AutoId], [ButtonName], [ButtonColor], [SeqNo], [Type]) VALUES (31, N'Proceed', N'#4cbb9f', 3, N'Footer')
SET IDENTITY_INSERT [dbo].[ActionButton] OFF
GO
