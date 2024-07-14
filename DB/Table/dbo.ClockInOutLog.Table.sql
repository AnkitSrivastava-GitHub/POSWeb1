CREATE TABLE [dbo].[ClockInOutLog](
    [AutoId] [int] IDENTITY(1,1) NOT NULL,
    [ClockINOUTAutoId] [int] NULL,
    [PreviousDate] [datetime] NULL,
    [NewDate] [datetime] NULL,	
	[Remark] [varchar](250) NULL,
    [Type] [varchar](20) NULL,
    [CreatedBy] [varchar](50) NULL,
    [CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ClockInOutLog] PRIMARY KEY CLUSTERED 
(
    [AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]