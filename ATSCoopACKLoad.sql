set nocount on

Use CMSystemScripts

IF OBJECT_ID('Cmsystemscripts.dbo.ATSCoopackfile', 'U') IS NOT NULL
  DROP TABLE ATSCoopackfile; 
;
create table  ATSCoopackfile

( FLEET_LEVEL_1 varchar(max) default Char(32)
, FLEET_LEVEL_2 varchar(max) default Char(32)
, FLEET_LEVEL_3 varchar(max) default Char(32)
, FLEET_LEVEL_4 varchar(max) default Char(32)
, FLEET_LEVEL_5 varchar(max) default Char(32)
, FLEET_LEVEL_6 varchar(max) default Char(32)
, FLEET_LEVEL_7 varchar(max) default Char(32)
, NODE_NAME varchar(11) default Char(32)
, RESERVED1 varchar(11) default Char(32)
, RESERVED2 varchar(11) default Char(32)
, VIOLOGICS_SERVICE_TYPE varchar(11) default Char(32)
, PLATE_PASS_SERVICE_TYPE varchar(11) default Char(32)
, ENROLLED_IN_PERSONAL_TOLLING varchar(11) default Char(32)
, RESERVED3 varchar(11) default ' '
, VEHICLE_ID varchar(11) default ' '
, VIN varchar(30) default ' '
, LICENSE_PLATE_STATE varchar(20) default ' '
, LICENSE_PLATE_NUMBER varchar(11) default ' '
, VEHICLE_MAKE varchar(11) default ' '
, VEHICLE_MODEL varchar(11) default ' '
, VEHICLE_COLOR varchar(11) default ' '
, VEHICLE_YEAR varchar(11) default ' ' 
, FLEET_CUSTOMER_VEHICLE_ID varchar(11) default ' '
, OWNERSHIP varchar(20) default ' '
, OWNERSHIP_NAME varchar(20) default ' '
, TRANSPONDER_ID varchar(11) default ' '
, FULFILLMENT_TYPE varchar(11) default ' '
, DELIVERY_CONTACT_TYPE varchar(11) default ' '
, DELIVERY_CONTACT_FIRST_NAME varchar(11) default ' '
, DELIVERY_CONTACT_LAST_NAME varchar(11) default ' ' 
, DELIVERY_CONTACT_NOTE varchar(11) default ' '
, DELIVERY_CONTACT_ADDRESS_1 varchar(11) default ' '
, DELIVERY_CONTACT_ADDRESS_2 varchar(11) default ' '
, DELIVERY_CONTACT_CITY varchar(11) default ' '
, DELIVERY_CONTACT_STATE varchar(11) default ' '
, DELIVERY_CONTACT_POSTAL_CODE varchar(11) default ' '
, DELIVERY_CONTACT_COUNTRY varchar(11) default ' '
, DELIVERY_CONTACT_PHONE_NUMBER varchar(11) default ' '
, DELIVERY_CONTACT_EMAIL varchar(11) default ' '
, SHIPPING_MODE varchar(11) default ' '
, SHIPPING_CLIENT_ACCOUNT_NUMBER varchar(11) default ' '
, EXPEDITE varchar(11) default ' '
, GARAGE_POSTAL_CODE varchar(11) default ' '
, FUELING_POSTAL_CODE_1 varchar(11) default ' '
, FUELING_POSTAL_CODE_2 varchar(11) default ' '
, FUELING_POSTAL_CODE_3 varchar(11) default ' '
, FUELING_POSTAL_CODE_4 varchar(11) default ' '
, FUELING_POSTAL_CODE_5 varchar(11) default ' '
, GVWR varchar(11) default ' '
, AXLE_COUNT varchar(11) default ' '
, TIRE_COUNT varchar(11) default ' '
, PLATE_TYPE varchar(11) default ' '
, ASSET_TYPE varchar(11) default ' '
, POOLED_Vehicle varchar(11) default ' '
, DRIVER_ID varchar(11) default ' '
, FLEET_CUSTOMER_DRIVER_ID varchar(11) default ' '
, FIRST_NAME varchar(11) default ' '
, LAST_NAME varchar(11) default ' '
, ADDRESS_1 varchar(11) default ' '
, ADDRESS_2 varchar(11) default ' '
, CITY varchar(11) default ' '
, STATE varchar(11) default ' '
, POSTAL_CODE varchar(11) default ' '
, COUNTRY varchar(11) default ' '
, DRIVER_TYPE varchar(11) default ' '
, PHONE_NUMBER varchar(11) default ' '
, CELL_PHONE_NUMBER varchar(11) default ' '
, EMAIL_ADDRESS varchar(11) default ' '
, DRIVERS_DATE_OF_BIRTH varchar(11) default ' '
, DRIVERS_LICENSE_NUMBER varchar(11) default ' '
, DRIVERS_LICENSE_STATE varchar(11) default ' '
, DRIVERS_TITLE varchar(11) default ' '
, ESCALATION_FIRST_NAME varchar(11) default ' '
, ESCALATION_LAST_NAME varchar(11) default ' '
, ESCALATION_EMAIL_ADDRESS varchar(11) default ' '
, RESERVED4 varchar(max) default ' '
, RESERVED5 varchar(max) default ' '
, RESERVED6 varchar(max) default ' '
)
;
/*
BCP CMSystemScripts.dbo.ATSCoopackfile in C:\OLD-Laptop\Documents\Work-Documents\ATSTollProject\ACKFiles\ACK_ATS_COMBO_CCM_20170925.txt -Scmsdb.applicationbackup.com -Urkota -PrK0t@ -F1 -c -t\t -r\n -e bcperr.txt
*/
;
select * from ATSCoopackfile where FLEET_LEVEL_1 like 'FOOT%'
;
select case 
		when fleet_level_1 = 'SUCCESS' then 'Success'
		when CHARINDEX('IS ENROLLED IN A SIMILAR SERVICE UNDER FMC ID', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'IS ENROLLED IN A SIMILAR SERVICE UNDER FMC ID'
		when CHARINDEX('IS ENROLLED IN A SIMILAR SERVICE UNDER FMC ID', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'Plate Assigned to other Entity'
		when CHARINDEX('DUPLICATE_PLATE_EXCEPTION', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'DUPLICATE_PLATE_EXCEPTION'
		when CHARINDEX('DUPLICATE_VIN_EXCEPTION', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'DUPLICATE_VIN_EXCEPTION'
		when CHARINDEX('REQUIRED_FIELD_EXCEPTION', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'REQUIRED_FIELD_EXCEPTION'
		else 'other'
		end as 'Chassis-Validation'
, fleet_level_4 as 'Contributor', count(*) as 'Count'
 from ATSCoopackfile
 group by fleet_level_4, case 
		when fleet_level_1 = 'SUCCESS' then 'Success'
		when CHARINDEX('IS ENROLLED IN A SIMILAR SERVICE UNDER FMC ID', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'IS ENROLLED IN A SIMILAR SERVICE UNDER FMC ID'
		when CHARINDEX('IS ENROLLED IN A SIMILAR SERVICE UNDER FMC ID', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'Plate Assigned to other Entity'
		when CHARINDEX('DUPLICATE_PLATE_EXCEPTION', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'DUPLICATE_PLATE_EXCEPTION'
		when CHARINDEX('DUPLICATE_VIN_EXCEPTION', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'DUPLICATE_VIN_EXCEPTION'
		when CHARINDEX('REQUIRED_FIELD_EXCEPTION', fleet_level_1 COLLATE Latin1_General_CI_AS) <>'0' then 'REQUIRED_FIELD_EXCEPTION'
		else 'other'
		end
	order by Contributor, [Chassis-Validation]