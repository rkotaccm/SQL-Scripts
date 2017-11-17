/*
***************************************************************************************
** Name : LoadATSTollTable-script.sql
** Date             : 08/22/2017
** Author           : Rajesh Kota
** Purpose          : •	Objective: To generate movement data corresponding to toll violation data to provided by ATS to CCM.
						•	Criteria:
						o	System – CMS
						o	Entity – OUT and IN Move attributes before and after toll activity respectively.
						o	Criteria - For All units that are involved in a Toll Violation
										
						o	Output  - Relevant movement attributes trucker woudl need to validate acitivty, toll vilation as part of paying the toll.				

						o	Intended use - To geneate invoice in the amount of the toll and send to trucker for collection.

***************************************************************************************
** ver:      date:        change:      reviewed by:
** 1.0     1/xx/2017     initial        Felix M
***************************************************************************************
*/

/* Using CMSystemscripts table to extract Coop data*/

set nocount on

Use CMSystemScripts
/*Have to run this create table script to make sure the table is present*/

IF OBJECT_ID('Cmsystemscripts.dbo.ATSTollfileload00', 'U') IS NOT NULL
  DROP TABLE ATSTollfileload00; 
;
create table  ATSTollfileload00

( deadfield1 varchar(25)
, deadfield2 varchar(25)
, External_Fleet_Code varchar(25)
, FleetName varchar(25)
, FLEET_LEVEL_2 varchar(50)
, FLEET_LEVEL_3 varchar(50)
, FLEET_LEVEL_4 varchar(50)
, FLEET_LEVEL_5 varchar(50)
, FLEET_LEVEL_6 varchar(50)
, FLEET_LEVEL_22 varchar(50)
, VEHICLE_ID varchar(20)
, VIN varchar(50)
, [Plate State] varchar(10)
, [Plate Number] varchar(50)
, [Driver First Name] varchar(50)
, [Driver Last Name] varchar(50)
, [Address 1] varchar(50)
, [Address 2] varchar(50)
, [City] varchar(50)
, [State] varchar(10)
, [Zip] varchar(10)
, [Driver Email Address] varchar(50)
, [Toll ID] varchar(50)
, [Entry Amount] varchar(15)
, [Transaction Type] varchar(100)
, Deadfield3 varchar(100)
, [Toll Date] varchar(10)
, [Toll Time] varchar(25)
, [Toll Time2] varchar(15)
, [Toll Exit Date] varchar(20)
, [Toll Exit time] varchar(20)
, [Toll Authority] varchar(100)
, [Toll Authority Description] varchar(100)
, Deadfield4 varchar(100)
)
;

/*
Run this BCP Command next

BCP CMSystemScripts.dbo.ATSTollFileload in C:\OLD-Laptop\Documents\Work-Documents\ATSTollProject\ATS-Sent-TollFiles\CCM_PP-Fleet_Toll_Detail_Report_2017_09_15_080136.csv -Scmsdb.applicationbackup.com -Urkota -PrK0t@ -F2 -c -t "," -e bcperr.txt

new - BCP CMSystemScripts.dbo.ATSTollFileload00 in C:\OLD-Laptop\Documents\Work-Documents\ATSTollProject\ATS-Sent-TollFiles\CCMSecondaryBillingFile.csv -Scmsdb.applicationbackup.com -Urkota -PrK0t@ -F2 -c -t "," -e bcperr.txt*/
;
	select * from ATSTollfileload00
	;
	IF OBJECT_ID('Cmsystemscripts.dbo.ATSTollfileload', 'U') IS NOT NULL
	  DROP TABLE ATSTollfileload; 
	;
	create table  ATSTollfileload

	( deadfield1 varchar(25)
	, deadfield2 varchar(25)
	, External_Fleet_Code varchar(25)
	, FleetName varchar(25)
	, FLEET_LEVEL_2 varchar(50)
	, FLEET_LEVEL_3 varchar(50)
	, FLEET_LEVEL_4 varchar(50)
	, FLEET_LEVEL_5 varchar(50)
	, FLEET_LEVEL_6 varchar(50)
	, FLEET_LEVEL_22 varchar(50)
	, VEHICLE_ID varchar(20)
	, VIN varchar(50)
	, [Plate State] varchar(10)
	, [Plate Number] varchar(50)
	, [Driver First Name] varchar(50)
	, [Driver Last Name] varchar(50)
	, [Address 1] varchar(50)
	, [Address 2] varchar(50)
	, [City] varchar(50)
	, [State] varchar(10)
	, [Zip] varchar(10)
	, [Driver Email Address] varchar(50)
	, [Toll ID] varchar(50)
	, [Entry Amount] varchar(15)
	, [Transaction Type] varchar(100)
	, Deadfield3 varchar(100)
	, [Toll Date] date
	, [Toll Time] time
	, [Toll Exit Date] date
	, [Toll Exit time] varchar(20)
	, [Toll Authority] varchar(100)
	, [Toll Authority Description] varchar(100)
	, Deadfield4 varchar(100)
	)
	;
	insert into ATSTollfileload

	select deadfield1 
	, deadfield2 
	, External_Fleet_Code 
	, FleetName 
	, FLEET_LEVEL_2 
	, FLEET_LEVEL_3 
	, FLEET_LEVEL_4 
	, FLEET_LEVEL_5 
	, FLEET_LEVEL_6 
	, FLEET_LEVEL_22 
	, VEHICLE_ID 
	, VIN 
	, [Plate State] 
	, [Plate Number] 
	, [Driver First Name] 
	, [Driver Last Name] 
	, [Address 1] 
	, [Address 2] 
	, [City] 
	, [State] 
	, [Zip] 
	, [Driver Email Address] 
	, [Toll ID] 
	, [Entry Amount] 
	, [Transaction Type] 
	, Deadfield3 
	, convert(varchar(10), [Toll Date], 121) as [Toll Date]
	, convert(varchar(5),cast(SUBSTRING(LTRIM(RTRIM(([Toll Time]))),1,2)+':'+SUBSTRING(LTRIM(RTRIM(([Toll Time]))),4,2)+':'+SUBSTRING(LTRIM(RTRIM(([Toll Time]))),7,2)+' '+SUBSTRING(LTRIM(RTRIM(([Toll Time]))),10,2) as time),114) as [TollTime]
	--, convert(varchar(5),cast((SUBSTRING(([Toll Time]),2,2)+':'+SUBSTRING([Toll Time],5,2)+':'+SUBSTRING([Toll Time],8,2)+' '+SUBSTRING([Toll Time],11,2)) as time),114) as [TollTime]
	, [Toll Exit Date]
	, [Toll Exit time]
	, [Toll Authority] 
	, [Toll Authority Description] 
	, Deadfield4 
	from ATSTollfileload00 where [Toll ID] = '1004' --and deadfield1 = 'DATA'

	;
	select * from ATSTollfileload order by VEHICLE_ID, [Toll Date], [Toll Time];
	select [Transaction Type], count(*) from ATSTollfileload group by [Transaction Type] -- order by VEHICLE_ID, [Toll Date], [Toll Time];
	select count(Distinct VEHICLE_ID) from ATSTollfileload --group by [Transaction Type] -- order by VEHICLE_ID, [Toll Date], [Toll Time];
	;


	;
	IF OBJECT_ID('Cmsystemscripts.dbo.ATSTollfile', 'U') IS NOT NULL
	  DROP TABLE ATSTollfile; 
	;
	create table  ATSTollfile

	( PrevRowNum int
	, Rownum int
	, NextRownum int
	, Unitid int
	, External_Fleet_Code varchar(25)
	, FleetName varchar(25)
	, FLEET_LEVEL_2 varchar(50)
	, FLEET_LEVEL_3 varchar(50)
	, FLEET_LEVEL_4 varchar(50) 
	, FLEET_LEVEL_5 varchar(50) 
	, FLEET_LEVEL_6 varchar(50) 
	, VEHICLE_ID varchar(20) 
	, VIN varchar(50)
	, [Plate State] varchar(10) 
	, [Plate Number] varchar(50) 
	, [Driver First Name] varchar(50) 
	, [Driver Last Name] varchar(50) 
	, [Address 1] varchar(50) 
	, [Address 2] varchar(50) 
	, [City] varchar(50) 
	, [State] varchar(10) 
	, [Zip] varchar(10) 
	, [Driver Email Address] varchar(50)
	, [Toll ID] varchar(50)
	, OutMoveDate datetime
	, OutContainer varchar(11)
	, OutMoveType varchar(50)
	, OutMoveLoc varchar(100) 
	, OutTrkSCAC varchar(10)
	, OutTrkCompany varchar(100)
	, OutRP varchar(100)
	, [OutUU-Shipper] varchar(100)
	, OutBK varchar(25)
	, OutBOL varchar(25)
	, OutClass varchar(100)
	, [Toll Date] varchar(15)
	, [Toll Time] varchar(15)
	, TollDateTime varchar(25)
	, [Toll Exit Date] varchar(25)
	, InMoveDate datetime
	, InContainer varchar(11)
	, InMoveType varchar(50)
	, InMoveLoc varchar(100) 
	, InTrkSCAC varchar(10)
	, InTrkCompany varchar(100)
	, INRP varchar(100)
	, [InUU-Shipper] varchar(100)
	, InBK varchar(25)
	, InBOL varchar(25)
	, InClass varchar(100) 
	, [Toll Authority] varchar(100)
	, [Toll Authority Description] varchar(100)
	, [Transaction Type] varchar(100)
	, [Entry] varchar(100)
	, [Exit] varchar(100)
	, [Entry Amount] decimal(5,2)
	, ATSFee decimal(5,2)
	, Total decimal(5,2)
	, [Entry Currency] varchar(10)
	, VTOLL varchar(25)
	, TransponderNUm varchar(25)
	)
	;

	declare @lf3 Char(1)
	declare @cr3 char(2)
	declare @tr3 char(3)
	Set @lf3=CHAR(13)
	set @cr3=CHAR(10)
	set @cr3=CHAR(9)

	Insert into ATSTollfile


	select distinct '' as Prevrownum
	, '' as Rownum
	, '' as NextRowNum
	, '' as 'cunit.UnitId'
	, isnull(atsfile.External_Fleet_Code,'') as 'External Fleet Code'
	, isnull(atsfile.FleetName,'') as 'FleetName'
	, isnull(atsfile.FLEET_LEVEL_2,'') as 'FLEET_LEVEL_2'
	, isnull(atsfile.FLEET_LEVEL_3,'') as 'FLEET_LEVEL_3'
	, isnull(atsfile.FLEET_LEVEL_4,'') as 'FLEET_LEVEL_4'
	, isnull(atsfile.FLEET_LEVEL_5,'') as 'FLEET_LEVEL_5'
	, isnull(atsfile.FLEET_LEVEL_6,'') as 'FLEET_LEVEL_6'
	, isnull(atsfile.VEHICLE_ID,'') as Chassisid
	, isnull(atsfile.VIN,'') as 'VIN'
	, isnull(atsfile.[Plate State],'') as 'License_Plate_State'
	, isnull(atsfile.[Plate Number],'') as 'License_Plate_Number'
	, isnull(atsfile.[Driver First Name],'') as [Driver First Name]
	, isnull(atsfile.[Driver Last Name],'') as [Driver Last Name]
	, isnull(atsfile.[Address 1],'') as 'ADDRESS_1'
	, isnull(atsfile.[Address 2],'') as 'ADDRESS_2'
	, isnull(atsfile.City,'') as 'CITY'
	, isnull(atsfile.State,'') as 'STATE'
	, isnull(atsfile.Zip,'') as 'Zip'
	, isnull(atsfile.[Driver Email Address],'') as 'DRIVER EMAIL_ADDRESS'
	, isnull(atsfile.[Toll ID],'') as 'TollID'
	, '' as OutMOveDateTime
	, '' as OutContainer
	, '' as outmovetype
	, '' as OutmoveLoc
	, '' as OutTrkSCAC
	, '' as OutTrkCompany
	, '' as outrp
	, '' as Outshipper
	, '' as OutBK
	, '' as OutBOL
	, '' as OutClass
	, isnull(atsfile.[Toll Date],'') as 'Toll Date'
	, isnull(atsfile.[Toll Time],'') as 'Toll Time'
	, isnull(convert(varchar(10), atsfile.[Toll Date], 121)+' '+convert(varchar(5), atsfile.[Toll Time], 108),'') as TollDatetime
	, isnull(atsfile.[Toll Exit Date],'') as 'ExitDate'
	, '' as InMOveDateTime
	, '' as InContainer
	, '' as InMoveType
	, '' as InMoveLoc
	, '' as InTrkSCAC
	, '' as InTrkCompany
	, '' as InRp
	, '' as InShipper
	, '' as InBK
	, '' as InBOL
	, '' as InClass
	, isnull(replace(Replace(RTrim(replace(replace(atsfile.[Toll Authority],  @lf3, ''),@cr3,'')),',','-'),'"',''),' ') as'Toll Authority'
	, isnull(replace(Replace(RTrim(replace(replace(atsfile.[Toll Authority Description],  @lf3, ''),@cr3,'')),',','-'),'"',''),' ')  as 'Toll Authority Description'
	, isnull(replace(Replace(RTrim(replace(replace(atsfile.[Transaction Type],  @lf3, ''),@cr3,'')),',','-'),'"',''),' ') as 'Transaction Type'
	, '' as 'Entry' -- isnull(replace(Replace(RTrim(replace(replace(atsfile.,  @lf3, ''),@cr3,'')),',','-'),'"',''),' ') as 'Entry'   
	, '' as 'Exit' --isnull(replace(Replace(RTrim(replace(replace(atsfile.exit,  @lf3, ''),@cr3,'')),',','-'),'"',''),' ') as  
	, isnull(cast(atsfile.[Entry Amount] as Money),'') as 'Entry Amount'
	, case 
		when (atsfile.[Toll ID]='1004') then cast(5.00 as money) 
		when (atsfile.[Toll ID]<>'1004') then cast(0.00 as money) 
		else '99.99'
		end as  'ATSFee'
	, cast(atsfile.[Entry Amount] as money)+case 
		when (atsfile.[Toll ID]='1004') then cast(5.00 as money) 
		when (atsfile.[Toll ID]<>'1004') then cast(0.00 as money) 
		else '99.99'
		end as 'Total'
	, '' as 'Entry Currency' --atsfile.[Entry Currency] as 
	, '' as 'VTOLL' --isnull(atsfile.VTOLL,'') as 'VTOLL'
	, '' as 'TransponderNum' --isnull(atsfile.TransponderNUm,'') as 'TransponderNum'
	from ATSTollfileload atsfile where VEHICLE_ID is not null
	;

	Update K
	set k.prevrownum = k1.PrevRowNum
	, k.Rownum = k1.RowNum
	, k.NextRownum = k1.NextRowNum
	from ATSTollfile k
	inner join 
	(
	SELECT  ROW_NUMBER() OVER (ORDER BY Vehicle_Id, convert(varchar(16), TollDateTime, 121))-1 as PrevRowNum, 
			ROW_NUMBER() OVER (ORDER BY Vehicle_Id, convert(varchar(16), TollDateTime, 121)) AS RowNum, 
			ROW_NUMBER() OVER (ORDER BY Vehicle_Id, convert(varchar(16), TollDateTime, 121))+1 as NextRowNum, 
			vehicle_id,
			convert(varchar(16), TollDateTime, 121) as TollDatetime
	from ATSTollfile
	) k1 on k.VEHICLE_ID = k1.VEHICLE_ID
	and convert(varchar(16), k.TollDateTime, 121) = k1.TollDatetime
	;

	Update K
	set k.Unitid = k1.unitid
	from ATSTollfile k
	inner join 
	(
	SELECT  vehicle_id, rownum, cunit.UnitId
			from ATSTollfile aa
			inner join CMST_Unit cunit on aa.VEHICLE_ID = cunit.ActualUnitPrefix+cunit.ActualUnitNumber
	) k1 on k.Rownum = k1.Rownum
	;


	IF OBJECT_ID('Cmsystemscripts.dbo.updateoutmove', 'U') IS NOT NULL
	  DROP TABLE updateoutmove; 
	;
	create table  updateoutmove
	(  OutMovedate datetime
	, ChassisID varchar(11)
	, TollDatetime varchar(20)
	, OutRownum int
	, OutLoc varchar(100)
	, OutTruckerdesc varchar(100)
	, OutTruckerCode varchar(10)
	, OutMoveTYpe varchar(50)
	, OutContainer varchar(11)
	, OutShipper varchar(50)
	, OutClass varchar(50)
	, Outbk varchar(25)
	, Outbol varchar(25)
	, OutResponsibleParty varchar(100)
	, unittranid int
	)
	;

	DECLARE @intFlagout INT
	SET @intFlagout = (select min(rownum) from ATSTollfile)
	WHILE (@intFlagout <=(select max(rownum) from ATSTollfile))
	BEGIN

	insert into updateoutmove

	select outmvattr.MoveDate1
	, maxout1.VEHICLE_ID
	, maxout1.TollDateTime
	, maxout1.Rownum
	, outloc.Title as 'Out Gate Location'
	, outtrkcom.ShortDisplayName as 'Out Trk Desc'
	, outmvattr.TruckerCode as 'Out Trk SCAC'
	, outtype.Title as 'Out Move Type'
	, outmvattr.ContainerPrefix+outmvattr.ContainerNumber as 'Container Num'
	, outuu.ShortDisplayName as 'Out Shipper/UU'
	, Outclass.Title as 'Out Class'
	, outmvattr.BookingNumber as 'Booking Num'
	, outmvattr.BillOfLading as 'Bill of Lading'
	, outrp.ShortDisplayName as 'Out-RP'
	, outmvattr.UnitTransactionId 
	 from
	(
	select distinct maxout.MaxOutmoveDate, tollfile.VEHICLE_ID, tollfile.Rownum, tollfile.TollDateTime, tollfile.Unitid
	from ATSTollfile tollfile inner join 
	(
	 select distinct max(convert(varchar(16), [OutMoveDate], 121)) as MaxOutmoveDate, aa.rownum from 
	  (
	select TollDateTime, UnitId, rownum
	from ATSTollFile where Rownum = @intFlagout
	) AA  left outer join (select CASE 
			WHEN MoveDateTimeZoneId = '2' THEN Convert(varchar(16), DATEADD(hour, -1, movedate), 121)
			WHEN MoveDateTimeZoneId = '3' THEN Convert(varchar(16), DATEADD(hour, -2, movedate), 121)
			WHEN MoveDateTimeZoneId = '4' THEN Convert(varchar(16), DATEADD(hour, -3, movedate), 121)
			WHEN MoveDateTimeZoneId = '1' THEN Convert(varchar(16), movedate, 121)
			WHEN MoveDateTimeZoneId not IN ('1','2','3','4') Then Convert(varchar(16), movedate, 121)
				END as [OutMoveDate], UnitId from CMST_Unittransaction --where UnitTransactionTypeId in ('10','11','12','13','14')
				) bb on aa.UnitId = bb.UnitId and bb.[OutMoveDate] < convert(varchar(16), aa.TollDateTime, 121)
	group by aa.rownum
	) maxout on tollfile.Rownum = maxout.Rownum
	) maxout1 
	left outer join (select CASE 
			WHEN MoveDateTimeZoneId = '2' THEN Convert(varchar(16), DATEADD(hour, -1, movedate), 121)
			WHEN MoveDateTimeZoneId = '3' THEN Convert(varchar(16), DATEADD(hour, -2, movedate), 121)
			WHEN MoveDateTimeZoneId = '4' THEN Convert(varchar(16), DATEADD(hour, -3, movedate), 121)
			WHEN MoveDateTimeZoneId = '1' THEN Convert(varchar(16), movedate, 121)
			WHEN MoveDateTimeZoneId not IN ('1','2','3','4') Then Convert(varchar(16), movedate, 121)
				END as [MoveDate1], * from CMST_Unittransaction where UnitTransactionTypeId in ('10','11','12','13','14')) outmvattr on maxout1.Unitid = outmvattr.UnitId and convert(varchar(16), maxout1.MaxOutmoveDate, 121) = convert(varchar(16), outmvattr.[MoveDate1], 121)
	left outer join CMST_Company outrp on outmvattr.OffResponsiblePartyCompanyId = outrp.CompanyId
	left outer join CMST_Company outuu on outmvattr.OffUltimateUserCompanyId = outuu.CompanyId
	left outer join CMST_Company outtrkcom on outmvattr.TruckerCompanyId = outtrkcom.CompanyId
	left outer join CMST_Companylocation outloc on outmvattr.CompanyLocationId = outloc.CompanyLocationId
	Left Outer join CMST_UnitTransactionType outtype on outmvattr.UnitTransactionTypeId = outtype.UnitTransactionTypeId
	Left Outer join CMST_UnitTransactionClassification Outclass on outmvattr.OffUnitTransactionClassificationId = Outclass.UnitTransactionClassificationId


	SET @intFlagout = @intFlagout + 1
	END
	;
	select * from updateoutmove
	;
	IF OBJECT_ID('Cmsystemscripts.dbo.updateInmove', 'U') IS NOT NULL
	  DROP TABLE updateInmove; 
	;
	create table  updateInmove

	(  InMovedate varchar(20)
	, ChassisID varchar(11)
	, TollDatetime varchar(20)
	, InRownum int
	, InLoc varchar(100)
	, InTruckerdesc varchar(100)
	, InTruckerCode varchar(10)
	, InMoveTYpe varchar(50)
	, InContainer varchar(11)
	, Inoffuu varchar(50)
	, Inmoveclass varchar(50)
	, Inbk varchar(25)
	, Inbol varchar(25)
	, InResponsibleParty varchar(100)
	, Inunittranid int
	)
	;

	DECLARE @intFlagin INT
	SET @intFlagin = (select min(rownum) from ATSTollfile)
	WHILE (@intFlagin <=(select max(rownum) from ATSTollfile))
	BEGIN

	insert into updateInmove

	select Inmvattr.MoveDate1
	, minin1.VEHICLE_ID
	, minin1.TollDateTime
	, minin1.Rownum
	, Inloc.Title as 'In Gate Location'
	, Intrkcom.ShortDisplayName as 'In Trk Desc'
	, Inmvattr.TruckerCode as 'In Trk SCAC'
	, outtype.Title as 'In Move Type'
	, Inmvattr.ContainerPrefix+Inmvattr.ContainerNumber as 'Container Num'
	, Inuu.ShortDisplayName as 'Shipper/OutUU'
	, Inclass.Title as 'In Move Class'
	, Inmvattr.BookingNumber as 'In Booking Num'
	, Inmvattr.BillOfLading as 'In Bill of Lading'
	, Inrp.ShortDisplayName as 'In-RP'
	, Inmvattr.UnitTransactionId 
	 from
	(
	select distinct minin.MinInmoveDate, tollfile.VEHICLE_ID, tollfile.Rownum, tollfile.TollDateTime, tollfile.Unitid
	from ATSTollfile tollfile inner join 
	(
	 select distinct min(convert(varchar(16), [InMoveDate], 121)) as MinInmoveDate, aa.rownum from 
	  (
	select TollDateTime, UnitId, rownum
	from ATSTollFile where Rownum = @intFlagin
	) AA  left outer join (select CASE 
			WHEN MoveDateTimeZoneId = '2' THEN Convert(varchar(16), DATEADD(hour, -1, movedate), 121)
			WHEN MoveDateTimeZoneId = '3' THEN Convert(varchar(16), DATEADD(hour, -2, movedate), 121)
			WHEN MoveDateTimeZoneId = '4' THEN Convert(varchar(16), DATEADD(hour, -3, movedate), 121)
			WHEN MoveDateTimeZoneId = '1' THEN Convert(varchar(16), movedate, 121)
			WHEN MoveDateTimeZoneId not IN ('1','2','3','4') Then Convert(varchar(16), movedate, 121)
				END as [InMoveDate], UnitId from CMST_Unittransaction --where UnitTransactionTypeId in ('2','3','5','6','8')
				) bb on aa.UnitId = bb.UnitId and bb.[InMoveDate] > convert(varchar(16), aa.TollDateTime, 121)
	group by aa.rownum
	) minin on tollfile.Rownum = minin.Rownum
	) minin1 
	left outer join (select CASE 
			WHEN MoveDateTimeZoneId = '2' THEN Convert(varchar(16), DATEADD(hour, -1, movedate), 121)
			WHEN MoveDateTimeZoneId = '3' THEN Convert(varchar(16), DATEADD(hour, -2, movedate), 121)
			WHEN MoveDateTimeZoneId = '4' THEN Convert(varchar(16), DATEADD(hour, -3, movedate), 121)
			WHEN MoveDateTimeZoneId = '1' THEN Convert(varchar(16), movedate, 121)
			WHEN MoveDateTimeZoneId not IN ('1','2','3','4') Then Convert(varchar(16), movedate, 121)
				END as [MoveDate1], * from CMST_Unittransaction where UnitTransactionTypeId in ('2','3','5','6','8')) Inmvattr on minin1.Unitid = Inmvattr.UnitId and convert(varchar(16), minin1.MinInmoveDate, 121) = convert(varchar(16), Inmvattr.[MoveDate1], 121)
	left outer join CMST_Company Inrp on Inmvattr.OffResponsiblePartyCompanyId = Inrp.CompanyId
	left outer join CMST_Company Inuu on Inmvattr.OffUltimateUserCompanyId = Inuu.CompanyId
	left outer join CMST_Company Intrkcom on Inmvattr.TruckerCompanyId = Intrkcom.CompanyId
	left outer join CMST_Companylocation Inloc on Inmvattr.CompanyLocationId = Inloc.CompanyLocationId
	Left Outer join CMST_UnitTransactionType outtype on Inmvattr.UnitTransactionTypeId = outtype.UnitTransactionTypeId
	Left Outer join CMST_UnitTransactionClassification Inclass on Inmvattr.OffUnitTransactionClassificationId = Inclass.UnitTransactionClassificationId


	SET @intFlagin = @intFlagin + 1
	END
	;
	
	Update K
	set k.OutMoveDate = k1.OutMovedate
	, k.OutContainer = k1.OutContainer
	, k.OutMoveType = k1.OutMoveTYpe
	, k.OutMoveLoc = k1.OutLoc
	, k.OutTrkSCAC = k1.OutTruckerCode
	, k.OutTrkCompany = k1.OutTruckerdesc
	, k.OutRP = k1.OutResponsibleParty
	, k.[OutUU-Shipper] = k1.OutShipper
	, k.OutBK = k1.Outbk
	, k.OutBOL = k1.Outbol
	, k.OutClass = k1.OutClass
	from ATSTollfile k
	inner join updateoutmove k1 on k.Rownum = k1.OutRownum
	;

	Update K
	set k.InMoveDate = k1.InMovedate
	, k.InContainer = k1.InContainer
	, k.InMoveType = k1.InMoveTYpe
	, k.InMoveLoc = k1.InLoc
	, k.InTrkSCAC = k1.InTruckerCode
	, k.InTrkCompany = k1.InTruckerdesc
	, k.INRP = k1.InResponsibleParty
	, k.[InUU-Shipper] = k1.Inoffuu
	, k.InBK = k1.Inbk
	, k.InBOL = k1.Inbol
	, k.InClass = k1.Inmoveclass
	from ATSTollfile k
	inner join updateInmove k1 on k.Rownum = k1.InRownum
	;
		
	IF OBJECT_ID('Cmsystemscripts.dbo.ATSTollFinaloutput', 'U') IS NOT NULL
	  DROP TABLE ATSTollFinaloutput; 
	;
	create table  ATSTollFinaloutput
	( External_Fleet_Code varchar(50)
	, FleetName varchar(50)
	, FLEET_LEVEL_2 varchar(50)
	, FLEET_LEVEL_3 varchar(50)
	, VEHICLE_ID varchar(20) 
	, VIN varchar(50)
	, [Plate State] varchar(25) 
	, [Plate Number] varchar(50) 
	, [Toll ID] varchar(50)
	, [Toll Date] varchar(25)
	, [Toll Time] varchar(25)
	, [Toll Exit Date] varchar(25)
	, [Toll Authority] varchar(100)
	, [Entry Amount] varchar(25)
	, ATSFee varchar(25)
	, Total varchar(10)
	, OutMoveDate varchar(20)
	, OutContainer varchar(20)
	, OutMoveType varchar(50)
	, OutMoveLoc varchar(100) 
	, OutTrkSCAC varchar(10)
	, OutTrkCompany varchar(100)
	, OutRP varchar(100)
	, [OutUU-Shipper] varchar(100)
	, OutBK varchar(25)
	, OutBOL varchar(25)
	, OutClass varchar(100)
	, InMoveDate varchar(20)
	, InContainer varchar(20)
	, InMoveType varchar(50)
	, InMoveLoc varchar(100) 
	, InTrkSCAC varchar(10)
	, InTrkCompany varchar(100)
	, INRP varchar(100)
	, [InUU-Shipper] varchar(100)
	, InClass varchar(100) 
	, [Toll Authority Description] varchar(100)
	, [Transaction Type] varchar(100)
	, [Entry] varchar(100)
	, [Exit] varchar(100)
	, VTOLL varchar(25)
	, TransponderNUm varchar(25)
	)
	;

	insert into ATSTollFinaloutput (External_Fleet_Code
	, FleetName
	, FLEET_LEVEL_2
	, FLEET_LEVEL_3
	, VEHICLE_ID 
	, VIN 
	, [Plate State] 
	, [Plate Number] 
	, [Toll ID] 
	, [Toll Date] 
	, [Toll Time] 
	, [Toll Exit Date] 
	, [Toll Authority] 
	, [Entry Amount] 
	, ATSFee 
	, Total 
	, OutMoveDate 
	, OutContainer 
	, OutMoveType 
	, OutMoveLoc 
	, OutTrkSCAC 
	, OutTrkCompany 
	, OutRP 
	, [OutUU-Shipper] 
	, OutBK 
	, OutBOL 
	, OutClass 
	, InMoveDate 
	, InContainer 
	, InMoveType 
	, InMoveLoc 
	, InTrkSCAC 
	, InTrkCompany 
	, INRP 
	, [InUU-Shipper] 
	, InClass 
	, [Toll Authority Description] 
	, [Transaction Type] 
	, [Entry] 
	, [Exit] 
	, VTOLL 
	, TransponderNUm)
	values
	('External_Fleet_Code' 
	, 'FleetName'
	,'FLEET_LEVEL_2'
	, 'FLEET_LEVEL_3'
	, 'VEHICLE_ID' 
	, 'VIN' 
	, 'Plate State'
	, 'Plate Number'
	, 'Toll ID'
	, 'Toll Date' 
	, 'Toll Time' 
	, 'Toll Exit Date'
	, 'Toll Authority' 
	, 'Entry Amount' 
	, 'ATSFee' 
	, 'Total' 
	, 'OutMoveDate' 
	, 'OutContainer' 
	, 'OutMoveType' 
	, 'OutMoveLoc' 
	, 'OutTrkSCAC' 
	, 'OutTrkCompany' 
	, 'OutRP' 
	, 'OutUU-Shipper'
	, 'OutBK' 
	, 'OutBOL' 
	, 'OutClass' 
	, 'InMoveDate'
	, 'InContainer' 
	, 'InMoveType' 
	, 'InMoveLoc' 
	, 'InTrkSCAC' 
	, 'InTrkCompany'
	, 'INRP' 
	, 'InUU-Shipper'
	, 'InClass' 
	, 'Toll Authority Description'
	, 'Transaction Type'
	, 'Entry'
	, 'Exit'
	, 'VTOLL' 
	, 'TransponderNUm')
	;

	declare @lf5 Char(1)
	declare @cr5 char(2)
	Set @lf5=CHAR(13)
	set @cr5=CHAR(10)

	insert into ATSTollFinaloutput

	select  External_Fleet_Code 
	, FleetName 
	, FLEET_LEVEL_2 
	, FLEET_LEVEL_3 
	--, FLEET_LEVEL_4 
	--, FLEET_LEVEL_5 
	--, FLEET_LEVEL_6 
	, VEHICLE_ID 
	, VIN 
	, [Plate State] 
	, [Plate Number] 
	--, [Driver First Name]  
	--, [Driver Last Name]  
	--, [Address 1]  
	--, [Address 2]  
	--, [City]  
	--, [State]  
	--, [Zip]  
	--, [Driver Email Address] 
	, [Toll ID] 
	, [Toll Date] 
	, [Toll Time] 
	--, TollDateTime 
	, [Toll Exit Date] 
	, [Toll Authority] 
	, '$'+cast([Entry Amount]  as varchar(10)) ---as 'Entry Amount'
	, '$'+cast(ATSFee as varchar(10)) --as 'ATS Fee'
	, '$'+cast(Total as varchar(10)) --as 'Total'
	, isnull(convert(varchar(20),OutMoveDate,121), 'N/A') --as 'Out Move Date'
	, isnull(Replace(RTrim(replace(replace(OutContainer,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Container'
	, isnull(Replace(RTrim(replace(replace(OutMoveType ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Move Type'
	, isnull(Replace(RTrim(replace(replace(OutMoveLoc ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Move Location'
	, isnull(Replace(RTrim(replace(replace(OutTrkSCAC ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Trucker SCAC'
	, isnull(Replace(RTrim(replace(replace(OutTrkCompany ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Trucker Compamy'
	, isnull(Replace(RTrim(replace(replace(OutRP ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out RP'
	, isnull(Replace(RTrim(replace(replace([OutUU-Shipper] ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Shipper/UU'
	, isnull(Replace(RTrim(replace(replace(OutBK,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Booking'
	, isnull(Replace(RTrim(replace(replace(OutBOL,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Bill Of Lading'
	, isnull(Replace(RTrim(replace(replace(OutClass ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'Out Class'
	, isnull(Replace(RTrim(replace(replace(convert(varchar(16),InMoveDate,121) ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In Move Date'
	, isnull(Replace(RTrim(replace(replace(InContainer,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In Container'
	, isnull(Replace(RTrim(replace(replace(InMoveType ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In Move Type'
	, isnull(Replace(RTrim(replace(replace(InMoveLoc ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In Move Location'
	, isnull(Replace(RTrim(replace(replace(InTrkSCAC ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In Trucker SCAC'
	, isnull(Replace(RTrim(replace(replace(InTrkCompany ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In Trucker Company'
	, isnull(Replace(RTrim(replace(replace(INRP ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In RP'
	, isnull(Replace(RTrim(replace(replace([InUU-Shipper] ,  @lf5, ''),@cr5,'')),',','-'),'') --as 'In Shipper/UU'
	--, isnull(InBK, '') as 'In Booking'
	--, isnull(InBOL, '') as 'In Bill of Lading'
	, isnull(InClass,'') as 'In Class'
	, [Toll Authority Description] 
	, [Transaction Type] 
	, [Entry] 
	, [Exit]  
	, VTOLL 
	, TransponderNUm 
	--, [Entry Currency] 
	 from ATSTollfile order by rownum
	/*
	BCP CMSystemScripts.dbo.ATSTollFinaloutput out C:\OLD-Laptop\Documents\Work-Documents\ATSTollProject\ATS_TOLL_MOVT_%date:~-4%%date:~4,2%%date:~7,2%.txt.csv -c -t "," -Scmsdb.applicationbackup.com -Urkota -PrK0t@
	*/
	 ;
	 select 
	 External_Fleet_Code 
	, FleetName 
	, FLEET_LEVEL_2 
	, FLEET_LEVEL_3 
	, VEHICLE_ID 
	, VIN 
	, [Plate State] 
	, [Plate Number]  
	, [Toll ID] 
	, convert(varchar(10), [Toll Date], 121) as [Toll Date]
	, convert(varchar(5),[Toll Time], 114) as [Toll Time]
	, [Toll Exit Date] 
	, [Toll Authority] 
	, [Entry Amount] 
	, ATSFee 
	, Total 
	, convert(varchar(16),OutMoveDate , 121) as [Out Move Date]
	, OutContainer 
	, OutMoveType 
	, OutMoveLoc 
	, OutTrkSCAC 
	, OutTrkCompany 
	, OutRP 
	, [OutUU-Shipper] 
	, OutBK 
	, OutBOL 
	, OutClass 
	, convert(varchar(16), InMoveDate , 121) as [In Move Date] 
	, InContainer 
	, InMoveType 
	, InMoveLoc 
	, InTrkSCAC 
	, InTrkCompany 
	, INRP 
	, [InUU-Shipper] 
	, InClass  
	, [Toll Authority Description] 
	, [Transaction Type] 
	, [Entry] 
	, [Exit] 
	, VTOLL 
	, TransponderNUm 
	 from ATSTollFinaloutput where [Toll ID] = '1004' order by VEHICLE_ID,[Transaction Type] , [Toll Date]



	/* 
	update K
	set k.OutMoveDate = k1.OutMovedate
	from ATSTollfile k
	left outer join updateoutmove k1 on k.Rownum = k1.OutRownum

	;
	update K
	set k.InMoveDate = k1.InMovedate
	from ATSTollfile k
	left outer join updateInmove k1 on k.Rownum = k1.InRownum
	*/


	/*select maxout.MaxOutmoveDate, tollfile.* from ATSTollfile tollfile left outer join 
	(
	 select max(convert(varchar(16), movedate, 121)) as MaxOutmoveDate, aa.unitid from 
	  (
	select a1.[Toll Datetime], cunit.UnitId
	from (select * from ATSTollFile) a1
	inner join CMST_Unit cunit on a1.Unitid = cunit.UnitId
	) AA  inner join (select MoveDate, UnitId from CMST_Unittransaction where UnitTransactionTypeId in ('10','11','12','13','14'))bb on aa.UnitId = bb.UnitId and bb.MoveDate < aa.[Toll Datetime]
	group by aa.UnitId
	) maxout on tollfile.Unitid = maxout.UnitId

	/*
	BULK INSERT ATSTollfile
	FROM 'C:\OLD-Laptop\Documents\Work-Documents\ATSTollProject\ATS-Sent-TollFiles\CCM_PP-Fleet_Toll_Detail_Report2017_09_15_080136.xls';
	GO

	SELECT * INTO ATSTollfiletest
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
		'Excel 12.0; Database=C:\OLD-Laptop\Documents\Work-Documents\ATSTollProject\ATS-Sent-TollFiles\CCM_PP-Fleet_Toll_Detail_Report2017_09_15_080136.xls', [Data$]);
	*/

	/*
	Update K
	set k.OutMoveDate = k1.OutDate
	, k.InMoveDate = k1.InDate
	, k.OutTrkSCAC = k1.TruckerCode
	, k.OutTrkCompany = k1.trkcom
	, k.OutRP = k1.outrpcom
	, k.InRP = k1.Inrpcom
	, k.OutShipper = k1.outship
	, k.Inshipper = k1.Inship
	from ATSTollfile k
	inner join 
	(select K0.Rownum, convert(varchar(16),outmove.[OutMoveDate],121) as OutDate, convert(varchar(16),inmove.[InMoveDate],121) as InDate, isnull(outmove.TruckerCode,'') as Truckercode, isnull(outtrkcom.ShortDisplayName,'') as trkcom
	, isnull(outrp.ShortDisplayName,'') as outrpcom, isnull(INrp.ShortDisplayName,'') as Inrpcom, isnull(outmove.shipper,'') as outship, isnull(inmove.Shipper,'') as Inship  from ATSTollfile K0
	inner join CMST_Unit cunit on k0.VEHICLE_ID = cunit.ActualUnitPrefix+cunit.ActualUnitNumber
	inner join (select *
	, CASE 
			WHEN MoveDateTimeZoneId = '2' THEN Convert(varchar(16), DATEADD(hour, -1, movedate), 121)
			WHEN MoveDateTimeZoneId = '3' THEN Convert(varchar(16), DATEADD(hour, -2, movedate), 121)
			WHEN MoveDateTimeZoneId = '4' THEN Convert(varchar(16), DATEADD(hour, -3, movedate), 121)
			WHEN MoveDateTimeZoneId = '1' THEN Convert(varchar(16), movedate, 121)
			WHEN MoveDateTimeZoneId not IN ('1','2','3','4') Then Convert(varchar(16), movedate, 121)
				END as [OutMoveDate]
	 from CMST_Unittransaction 
		where (movedate between getdate() - 25 and getdate() - 10) and UnitTransactionTypeId in ('10','11','12','13')) outmove on cunit.UnitId = outmove.unitid
		and convert(varchar(16), outmove.[OutMoveDate], 121) < convert(varchar(16), K0.TollDateTime, 121) 
	left outer join (select *
	, CASE 
			WHEN MoveDateTimeZoneId = '2' THEN Convert(varchar(16), DATEADD(hour, -1, movedate), 121)
			WHEN MoveDateTimeZoneId = '3' THEN Convert(varchar(16), DATEADD(hour, -2, movedate), 121)
			WHEN MoveDateTimeZoneId = '4' THEN Convert(varchar(16), DATEADD(hour, -3, movedate), 121)
			WHEN MoveDateTimeZoneId = '1' THEN Convert(varchar(16), movedate, 121)
			WHEN MoveDateTimeZoneId not IN ('1','2','3','4') Then Convert(varchar(16), movedate, 121)
				END as [InMoveDate]
	 from CMST_Unittransaction 
					where UnitTransactionTypeId in ('2','3','5','6','8')) inmove on cunit.UnitId = inmove.unitid
					and convert(varchar(16), inmove.[InMoveDate], 121) > convert(varchar(16), K0.TollDateTime, 121) 
	inner join CMST_Pool cpool on outmove.PoolId = cpool.PoolId
	inner join CMST_Company outtrkcom on outmove.TruckerCompanyId = outtrkcom.CompanyId
	inner join CMST_Company outrp on outmove.OffResponsiblePartyCompanyId = outrp.CompanyId
	inner join CMST_Company Inrp on inmove.OffResponsiblePartyCompanyId = Inrp.CompanyId
	inner join cmst_equipmenttype t on t.equipmenttypeid = cunit.actualequipmenttypeid
	inner join CMST_SCAC cscac on outtrkcom.SCACId = cscac.SCACId
	) K1 on k.Rownum = k1.Rownum

	*/


	*/	  
