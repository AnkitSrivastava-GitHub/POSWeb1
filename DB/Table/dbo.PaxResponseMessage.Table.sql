USE [PW_POS]
GO
/****** Object:  Table [dbo].[PaxResponseMessage]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaxResponseMessage](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ResultCode] [varchar](100) NULL,
	[ResultTxt] [varchar](100) NULL,
	[RefNum] [varchar](100) NULL,
	[AvsResponse] [varchar](100) NULL,
	[CvResponse] [varchar](100) NULL,
	[Timestamp] [varchar](100) NULL,
	[HostCode] [varchar](100) NULL,
	[RequestedAmount] [varchar](100) NULL,
	[ApprovedAmount] [varchar](100) NULL,
	[RemainingBalance] [varchar](100) NULL,
	[ExtraBalance] [varchar](100) NULL,
	[HostResponse] [varchar](100) NULL,
	[BogusAccountNum] [varchar](100) NULL,
	[CardType] [varchar](100) NULL,
	[Message] [varchar](100) NULL,
	[AuthCode] [varchar](100) NULL,
	[SigFileName] [varchar](100) NULL,
	[InvNum] [varchar](100) NULL,
	[VASCode] [varchar](100) NULL,
	[SignData] [varchar](100) NULL,
	[TORResponseInfo] [varchar](100) NULL,
	[TranIntgClass] [varchar](100) NULL,
	[TransactionRemainingAmount] [varchar](100) NULL,
	[DebitAccountType] [varchar](100) NULL
) ON [PRIMARY]
GO
