
CREATE TABLE [dbo].[UserDetailMaster](
	[Userid] [nvarchar](25) NOT NULL,
	[Password] [nvarchar](50) NULL,
	[LoginID] [nvarchar](50) NULL,
	[UserType] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NULL,
	[EmailID] [nvarchar](50) NULL,
	[PhoneNo] [nvarchar](12) NULL,
	[Status] [int] NOT NULL,
	[UserAutoId] [int] IDENTITY(1,1) NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_UserDetailMaster] PRIMARY KEY CLUSTERED 
(
	[UserAutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



Alter table [UserDetailMaster] drop column 

Alter table [UserDetailMaster] add [CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDate] [datetime] NULL

