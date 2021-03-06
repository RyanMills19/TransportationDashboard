USE [master]
GO
/****** Object:  Database [Tendering Dashboard]    Script Date: 10/21/2019 4:38:46 PM ******/
CREATE DATABASE [Tendering Dashboard]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Tendering Dashboard', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Tendering Dashboard.mdf' , SIZE = 401408KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Tendering Dashboard_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Tendering Dashboard_log.ldf' , SIZE = 270336KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Tendering Dashboard] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Tendering Dashboard].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Tendering Dashboard] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET ARITHABORT OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Tendering Dashboard] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Tendering Dashboard] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Tendering Dashboard] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Tendering Dashboard] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Tendering Dashboard] SET  MULTI_USER 
GO
ALTER DATABASE [Tendering Dashboard] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Tendering Dashboard] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Tendering Dashboard] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Tendering Dashboard] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Tendering Dashboard] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Tendering Dashboard', N'ON'
GO
ALTER DATABASE [Tendering Dashboard] SET QUERY_STORE = ON
GO
ALTER DATABASE [Tendering Dashboard] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = ALL, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [Tendering Dashboard]
GO
/****** Object:  UserDefinedFunction [dbo].[BetweenMinMaxFunc]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[BetweenMinMaxFunc] (@input int)
RETURNS VARCHAR(250)
BEGIN  
    DECLARE @ret VARCHAR(250);  
    SELECT @ret = a.Lane_Description   
    FROM dbo.[GeoLoc Zones] a   
    WHERE @input BETWEEN a.Dest_Min_Zip AND a.Dest_Max_Zip  
    RETURN @ret;  
END; 
GO
/****** Object:  Table [dbo].[Shipment File]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipment File](
	[ShPt] [nvarchar](50) NOT NULL,
	[SC] [nvarchar](50) NOT NULL,
	[Ship_To] [nvarchar](50) NOT NULL,
	[Shipment] [float] NOT NULL,
	[ServcAgent] [nvarchar](50) NULL,
	[Cty] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Rg] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](50) NOT NULL,
	[At] [datetime2](7) NOT NULL,
	[Deliv_Date] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ShipmentTrim]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ShipmentTrim] As
SELECT a.ShPt, a.Ship_To, a.Shipment, a.ServcAgent, a.Cty, LEFT(a.PostalCode,5) as ZipCode, a.City, a.Rg as State
FROM [Shipment File] a
WHERE a.Cty = 'US'
GO
/****** Object:  View [dbo].[ShipmentZipCode]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ShipmentZipCode] AS
SELECT a.ShPt, a.Ship_To, a.Shipment, a.ServcAgent, a.Cty, FORMAT(CONVERT(INT,a.ZipCode), '00000') as ZipCode, a.City, a.State
FROM dbo.ShipmentTrim a
GO
/****** Object:  View [dbo].[ShipmentGeoLoc]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[ShipmentGeoLoc] AS
SELECT a.ShPt, a.Ship_To, a.Shipment, a.ServcAgent, a.Cty, a.ZipCode, a.City, a.State, dbo.BetweenMinMaxFunc(a.ZipCode) as GeoLoc 
FROM dbo.[ShipmentZipCode] a




GO
/****** Object:  Table [dbo].[TORROT-TORTEN-TORTST]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TORROT-TORTEN-TORTST](
	[_SCMTMS_D_TORROT_DB_KEY] [nvarchar](50) NOT NULL,
	[Document] [float] NOT NULL,
	[Subcontracting_Relevance] [int] NOT NULL,
	[_SCMTMS_D_TORTEN_DB_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTEN_PARENT_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTEN_REL_TORQ_UUID] [nvarchar](50) NOT NULL,
	[Tendering_Process_Sequence_Num] [int] NOT NULL,
	[Created_By] [nvarchar](50) NOT NULL,
	[Created_On] [datetime2](7) NOT NULL,
	[_SCMTMS_D_TORTST_DB_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTST_ROOT_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTST_PARENT_KEY] [nvarchar](50) NOT NULL,
	[Tendering_Type] [nvarchar](50) NOT NULL,
	[Life_Cycle_Status] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TORTRE]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TORTRE](
	[_SCMTMS_D_TORTRE_DB_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTRE_ROOT_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTRE_PARENT_KEY] [nvarchar](50) NOT NULL,
	[Freight_Quotation_Sequence_Num] [int] NOT NULL,
	[Response_Code] [nvarchar](50) NOT NULL,
	[Award_Status] [nvarchar](50) NOT NULL,
	[Created_On] [datetime2](7) NOT NULL,
	[Created_By] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TORTRQ]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TORTRQ](
	[_SCMTMS_D_TORTRQ_DB_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTRQ_ROOT_KEY] [nvarchar](50) NOT NULL,
	[_SCMTMS_D_TORTRQ_PARENT_KEY] [nvarchar](50) NOT NULL,
	[Freight_RFQ_Sequence_Number] [int] NOT NULL,
	[Start_Date_and_Time] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TORROT-Shipment]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















CREATE VIEW [dbo].[TORROT-Shipment] AS
SELECT	a.Document, a.Tendering_Process_Sequence_Num, b.Freight_RFQ_Sequence_Number, c.Freight_Quotation_Sequence_Num, 
		c.Response_Code, LEFT(a.Created_On,10) as Created_On,
		e.ShPt, e.Ship_To, e.ServcAgent, e.Cty as DC, e.ZipCode, e.City, e.State, e.GeoLoc,
		CASE a.Created_By
		WHEN 'JM_TMS' THEN 'Auto'
		ELSE 'Manual'
    END AS Order_Type
FROM dbo.[TORROT-TORTEN-TORTST] a
INNER JOIN dbo.TORTRQ b
	ON a._SCMTMS_D_TORTST_DB_KEY = b._SCMTMS_D_TORTRQ_PARENT_KEY
INNER JOIN dbo.TORTRE c
	ON b._SCMTMS_D_TORTRQ_DB_KEY = c._SCMTMS_D_TORTRE_PARENT_KEY
INNER JOIN dbo.ShipmentGeoLoc e
	ON a.Document = e.Shipment
WHERE a.Life_Cycle_Status != '10' AND e.ServcAgent != 'CCPU'
GO
/****** Object:  View [dbo].[HighestProcessNum]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[HighestProcessNum] AS
SELECT a._SCMTMS_D_TORTEN_PARENT_KEY, a.Tendering_Process_Sequence_Num, a.Created_By
FROM dbo.[TORROT-TORTEN-TORTST] as a
INNER JOIN (
    SELECT _SCMTMS_D_TORTEN_PARENT_KEY, MAX(Tendering_Process_Sequence_Num) ProcessNum
    FROM dbo.[TORROT-TORTEN-TORTST]
    GROUP BY _SCMTMS_D_TORTEN_PARENT_KEY, Created_By
) b ON a._SCMTMS_D_TORTEN_PARENT_KEY = b._SCMTMS_D_TORTEN_PARENT_KEY AND a.Tendering_Process_Sequence_Num = b.ProcessNum
GO
/****** Object:  Table [dbo].[GeoLoc Zones]    Script Date: 10/21/2019 4:38:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GeoLoc Zones](
	[Lane_Description] [nvarchar](50) NOT NULL,
	[Dest_Min_Zip] [int] NOT NULL,
	[Dest_Max_Zip] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_Shipment File]    Script Date: 10/21/2019 4:38:46 PM ******/
CREATE NONCLUSTERED INDEX [ix_Shipment File] ON [dbo].[Shipment File]
(
	[ShPt] ASC,
	[Ship_To] ASC,
	[Shipment] ASC,
	[ServcAgent] ASC,
	[City] ASC,
	[Rg] ASC,
	[PostalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix.TORROT-TORTEN-TORTST]    Script Date: 10/21/2019 4:38:46 PM ******/
CREATE NONCLUSTERED INDEX [ix.TORROT-TORTEN-TORTST] ON [dbo].[TORROT-TORTEN-TORTST]
(
	[Document] ASC,
	[Created_By] ASC,
	[Created_On] ASC,
	[_SCMTMS_D_TORTST_DB_KEY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix.TORTRE]    Script Date: 10/21/2019 4:38:46 PM ******/
CREATE NONCLUSTERED INDEX [ix.TORTRE] ON [dbo].[TORTRE]
(
	[_SCMTMS_D_TORTRE_PARENT_KEY] ASC,
	[Response_Code] ASC,
	[Created_On] ASC,
	[Created_By] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix.TORTRQ]    Script Date: 10/21/2019 4:38:46 PM ******/
CREATE NONCLUSTERED INDEX [ix.TORTRQ] ON [dbo].[TORTRQ]
(
	[_SCMTMS_D_TORTRQ_PARENT_KEY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [Tendering Dashboard] SET  READ_WRITE 
GO
