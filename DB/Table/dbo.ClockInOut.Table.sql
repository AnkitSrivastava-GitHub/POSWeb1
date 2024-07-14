CREATE TABLE [dbo].[ClockINOUT](
    [AutoId] [int] IDENTITY(1,1) NOT NULL,
    [EmpId] [varchar](50) NULL,
	[Remark] [varchar](250) NULL,
    [ClockIN] [datetime] NULL,
    [ClockOUT] [datetime] NULL,
    [CreatedDate] [datetime] NULL,
    [UpdatedDate] [datetime] NULL,   
    [TotalTime]  AS (case when isnull([ClockOUT],'')<>'' then CONVERT([decimal](18,2),datediff(minute,[ClockIN],[ClockOUT])/(60.0)) else CONVERT([decimal](18,2),datediff(minute,[ClockIN],getdate())/(60.0)) end),
    [IsDeleted] [int] NULL,
    [DeletedDate] [datetime] NULL,
    [DeletedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ClockINOUT] PRIMARY KEY CLUSTERED 
(
    [AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

