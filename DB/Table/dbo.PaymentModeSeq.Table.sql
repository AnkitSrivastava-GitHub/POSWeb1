USE [pos201.priorpos.com]
GO
/****** Object:  Table [dbo].[PaymentModeSeq]    Script Date: 01/09/2024 12:47:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentModeSeq](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentMode] [varchar](25) NOT NULL,
	[SeqNo] [int] NOT NULL,
 CONSTRAINT [PK_PaymentModeSeq] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[PaymentModeSeq] ON 

INSERT [dbo].[PaymentModeSeq] ([AutoId], [PaymentMode], [SeqNo]) VALUES (1, N'Coupon', 1)
INSERT [dbo].[PaymentModeSeq] ([AutoId], [PaymentMode], [SeqNo]) VALUES (2, N'Gift Card', 2)
INSERT [dbo].[PaymentModeSeq] ([AutoId], [PaymentMode], [SeqNo]) VALUES (3, N'Reward points', 3)
INSERT [dbo].[PaymentModeSeq] ([AutoId], [PaymentMode], [SeqNo]) VALUES (4, N'Cash', 4)
INSERT [dbo].[PaymentModeSeq] ([AutoId], [PaymentMode], [SeqNo]) VALUES (5, N'Credit Card', 5)
SET IDENTITY_INSERT [dbo].[PaymentModeSeq] OFF
GO
