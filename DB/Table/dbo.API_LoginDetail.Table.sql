
CREATE TABLE [dbo].[API_LoginDetail](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[EmpType] [varchar](50) NULL,
	[DataType] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]
GO
