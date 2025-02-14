USE [PW_POS]
GO
/****** Object:  Table [dbo].[StateMaster]    Script Date: 6/26/2023 12:07:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[State] [varchar](100) NULL,
	[Status] [int] NULL,
	[stateabbr] [varchar](10) NULL,
	[Country] [int] NULL,
	[CenterLat] [nvarchar](50) NULL,
	[CenterLag] [varchar](50) NULL,
	[StateZoom] [varchar](50) NULL,
 CONSTRAINT [PK_StateMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[StateMaster] ON 

INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (1, N'New Jersey', 1, N'NJ', 1, N'40.644301', N'-74.408036', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (2, N'Maryland', 1, N'MD', 1, N'39.250637', N'-76.644838', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (3, N'New York', 1, N'NY', 1, N'40.912871', N'-73.83661', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (4, N'Connecticut', 1, N'CT', 1, N'41.409912', N'-73.414108', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (5, N'Pennsylvania', 1, N'PA', 1, N'40.615829', N'-77.568747', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (6, N'New Hampshire', 1, N'NH', 1, N'42.744931', N'-71.200364', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (7, N'West Virginia
', 1, N'WV', 1, N'38.5976', N'-80.4549', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (8, N'Minnesota', 1, N'MN', 1, N'44.990227', N'-93.105612', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (9, N'Virginia', 1, N'VA', 1, N'37.295171', N'-80.001372', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (10, N'Illinois', 1, N'IL', 1, N'41.930921', N'-88.777824', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (11, N'Massachusetts', 1, N'MA', 1, N'42.402243', N'-71.049997', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (12, N'Ohio', 1, N'OH', 1, N'41.061202', N'-80.663374', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (13, N'Delaware', 1, N'DE', 1, N'38.728519', N'-75.133144', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (14, N'Maine', 1, N'ME', 1, N'43.636878', N'-70.33637', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (16, N'Wisconsin', 1, N'WI', 1, N'44.962519', N'-92.726147', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (17, N'North Carolina', 1, N'NC', 1, N'35.7596', N'-79.0193', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (18, N'Georgia', 1, N'GA', 1, N'32.1656', N'-82.9001', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (19, N'Florida', 1, N'FL', 1, N'27.6648', N'-81.5158', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (20, N'Texas', 1, N'TX', 1, N'31.9686', N'-99.9018', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (21, N'South Carolina', 1, N'SC', 1, N'33.8361', N'-81.1637', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (22, N'Bloomington', 1, N'BL', 1, N'44.8408', N'-93.2983', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (23, N'Tennessee', 1, N'TN', 1, N'35.5175', N'-86.5804', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (24, N'Alabama', 1, N'AL', 1, N'32.3182', N'-86.9023', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (25, N'Alaska', 1, N'AK', 1, N'64.2008', N'-149.4937', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (26, N'Arizona', 1, N'AZ', 1, N'34.0489', N'-111.0937', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (27, N'Arkansas', 1, N'AR', 1, N'35.2010', N'-91.8318', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (28, N'California', 1, N'CA', 1, N'36.7783', N'-119.4179', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (29, N'Iowa', 1, N'IA', 1, N'41.8780', N'-93.0977', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (30, N'Colorado', 1, N'CO', 1, N'39.5501', N'-105.7821', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (31, N'Hawaii', 1, N'HI', 1, N'19.8968', N'-155.5828', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (32, N'Idaho', 1, N'ID', 1, N'44.0682', N'-114.7420', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (33, N'Indiana', 1, N'IN', 1, N'40.2672', N'-86.1349', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (34, N'Kansas', 1, N'KS', 1, N'39.0119', N'-98.4842', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (35, N'Kentucky', 1, N'KY', 1, N'37.8393', N'-84.2700', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (37, N'Michigan', 1, N'MI', 1, N'44.3148', N'-85.6024', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (38, N'Mississippi', 1, N'MS', 1, N'32.3547', N'-89.3985', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (39, N'Missouri', 1, N'MO', 1, N'37.9643', N'-91.8318', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (40, N'Montana', 1, N'MT', 1, N'46.8797', N'-110.3626', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (41, N'Nebraska', 1, N'NE', 1, N'41.4925', N'-99.9018', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (42, N'Nevada', 1, N'NV', 1, N'38.8026', N'-116.4194', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (43, N'New Mexico', 1, N'NM', 1, N'34.5199', N'-105.8701', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (44, N'North Dakota', 1, N'ND', 1, N'47.5515', N'-101.0020', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (45, N'Oklahoma', 1, N'OK', 1, N'35.0078', N'-97.0929', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (46, N'Oregon', 1, N'OR', 1, N'43.8041', N'-120.5542', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (47, N'Rhode Island', 1, N'RI', 1, N'41.5801', N'-71.4774', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (48, N'South Dakota', 1, N'SD', 1, N'43.9695', N'-99.9018', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (49, N'Utah', 1, N'UT', 1, N'39.3210', N'-111.0937', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (50, N'Vermont', 1, N'VT', 1, N'44.5588', N'-72.5778', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (51, N'Washington', 1, N'WA', 1, N'47.7511', N'-120.7401', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (52, N'Wyoming', 1, N'WY', 1, N'43.0760', N'-107.2903', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (53, N'BC', 1, N'BC', 2, NULL, NULL, N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (54, N'Washington DC', 1, N'DC', 1, N'38.9072', N'-77.0369', N'8')
INSERT [dbo].[StateMaster] ([AutoId], [State], [Status], [stateabbr], [Country], [CenterLat], [CenterLag], [StateZoom]) VALUES (55, N'Louisiana', 1, N'LA', 1, N'30.9843', N'-91.9623', N'8')
SET IDENTITY_INSERT [dbo].[StateMaster] OFF
GO
