
CREATE TABLE [dbo].[API_CredentialDetail](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[AccessToken] [varchar](50) NOT NULL,
	[Hashkey] [varchar](50) NOT NULL,
	[Status] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[API_CredentialDetail] ON 

INSERT [dbo].[API_CredentialDetail] ([AutoId], [AccessToken], [Hashkey], [Status]) VALUES (1, N'Expense_Pnet', N'Pnet#@2021Expense', 1)
SET IDENTITY_INSERT [dbo].[API_CredentialDetail] OFF
GO
