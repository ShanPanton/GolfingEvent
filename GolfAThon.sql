-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'TGolferEventYearSponsors' )		IS NOT NULL DROP TABLE	TGolferEventYearSponsors
IF OBJECT_ID( 'TGolferEventYears' )				IS NOT NULL DROP TABLE	TGolferEventYears
IF OBJECT_ID( 'TEventYears' )					IS NOT NULL DROP TABLE	TEventYears
IF OBJECT_ID( 'TGolfers' )						IS NOT NULL DROP TABLE	TGolfers
IF OBJECT_ID( 'TGenders' )						IS NOT NULL DROP TABLE	TGenders
IF OBJECT_ID( 'TShirtSizes' )					IS NOT NULL DROP TABLE	TShirtSizes
IF OBJECT_ID( 'TPaymentTypes' )					IS NOT NULL DROP TABLE	TPaymentTypes
IF OBJECT_ID( 'TSponsors' )						IS NOT NULL DROP TABLE	TSponsors
IF OBJECT_ID( 'TSponsorTypes' )					IS NOT NULL DROP TABLE	TSponsorTypes

-- --------------------------------------------------------------------------------
-- Drop Procedures
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'uspAddGolfer')					IS NOT NULL DROP PROCEDURE uspAddGolfer
IF OBJECT_ID( 'uspAddSponsor')					IS NOT NULL DROP PROCEDURE uspAddSponsor
IF OBJECT_ID( 'uspAddEvent')				    IS NOT NULL DROP PROCEDURE uspAddEvent
IF OBJECT_ID( 'uspAddGolferEvent')		        IS NOT NULL DROP PROCEDURE uspAddGolferEvent
IF OBJECT_ID( 'uspGolferEventYearSponsor')		IS NOT NULL DROP PROCEDURE uspGolferEventYearSponsor

-- --------------------------------------------------------------------------------
-- Drop Views
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'vAvailableGolfers')			    IS NOT NULL DROP VIEW vAvailableGolfers
IF OBJECT_ID( 'vEventGolfers')			        IS NOT NULL DROP VIEW vEventGolfers
IF OBJECT_ID( 'vGolferTotal')					IS NOT NULL DROP VIEW vGolferTotal
IF OBJECT_ID( 'vEventTotal')					IS NOT NULL DROP VIEW vEventTotal
IF OBJECT_ID( 'vSponsorTotal')					IS NOT NULL DROP VIEW vSponsorTotal
IF OBJECT_ID( 'vGolferNotInGolferEvents')	IS NOT NULL DROP VIEW vGolferNotInGolferEvents



-- --------------------------------------------------------------------------------
-- Step #1: Create Tables
-- --------------------------------------------------------------------------------
CREATE TABLE TEventYears
(
	 intEventYearID		INTEGER			NOT NULL
	,intEventYear		INTEGER			NOT NULL
	,CONSTRAINT TEventYears_PK PRIMARY KEY ( intEventYearID	)
)

CREATE TABLE TGenders
(
	 intGenderID		INTEGER			NOT NULL
	,strGenderDesc			VARCHAR(50)		NOT NULL
	,CONSTRAINT TGenders_PK PRIMARY KEY ( intGenderID )
)

CREATE TABLE TShirtSizes
(
	 intShirtSizeID			INTEGER			NOT NULL
	,strShirtSizeDesc		VARCHAR(50)		NOT NULL
	,CONSTRAINT TShirtSizes_PK PRIMARY KEY ( intShirtSizeID )
)

CREATE TABLE TGolfers
(
	 intGolferID		INTEGER			NOT NULL
	,strFirstName		VARCHAR(50)		NOT NULL
	,strLastName		VARCHAR(50)		NOT NULL
	,strStreetAddress	VARCHAR(50)		NOT NULL
	,strCity			VARCHAR(50)		NOT NULL
	,strState			VARCHAR(50)		NOT NULL
	,strZip				VARCHAR(50)		NOT NULL
	,strPhoneNumber		VARCHAR(50)		NOT NULL
	,strEmail			VARCHAR(50)		NOT NULL
	,intShirtSizeID		INTEGER			NOT NULL
	,intGenderID		INTEGER			NOT NULL
	,CONSTRAINT TGolfers_PK PRIMARY KEY ( intGolferID )
)

CREATE TABLE TSponsors
(
	 intSponsorID		INTEGER			NOT NULL
	,strFirstName		VARCHAR(50)		NOT NULL
	,strLastName		VARCHAR(50)		NOT NULL
	,strStreetAddress	VARCHAR(50)		NOT NULL
	,strCity			VARCHAR(50)		NOT NULL
	,strState			VARCHAR(50)		NOT NULL
	,strZip				VARCHAR(50)		NOT NULL
	,strPhoneNumber		VARCHAR(50)		NOT NULL
	,strEmail			VARCHAR(50)		NOT NULL
	,CONSTRAINT TSponsors_PK PRIMARY KEY ( intSponsorID )
)

CREATE TABLE TPaymentTypes
(
	 intPaymentTypeID		INTEGER			NOT NULL
	,strPaymentTypeDesc		VARCHAR(50)		NOT NULL
	,CONSTRAINT TPaymentTypes_PK PRIMARY KEY ( intPaymentTypeID )
)

CREATE TABLE TGolferEventYears
(
	 intGolferEventYearID	INTEGER	        	NOT NULL
	,intGolferID			INTEGER			    NOT NULL
	,intEventYearID			INTEGER			    NOT NULL
	,CONSTRAINT TGolferEventYears_UQ UNIQUE ( intGolferID, intEventYearID )
	,CONSTRAINT TGolferEventYears_PK PRIMARY KEY ( intGolferEventYearID )
)


CREATE TABLE TGolferEventYearSponsors
(
	 intGolferEventYearSponsorID	INTEGER	                NOT NULL
	,intGolferID					INTEGER			        NOT NULL
	,intEventYearID					INTEGER			        NOT NULL
	,intSponsorID					INTEGER			        NOT NULL
	,monPledgeAmount				MONEY			        NOT NULL
	,intSponsorTypeID				INTEGER			        NOT NULL
	,intPaymentTypeID				INTEGER			        NOT NULL
	,blnPaid						BIT			            NOT NULL
	,CONSTRAINT TGolferEventYearSponsors_UQ UNIQUE ( intGolferID, intEventYearID, intSponsorID )
	,CONSTRAINT TGolferEventYearSponsors_PK PRIMARY KEY ( intGolferEventYearSponsorID )
)

CREATE TABLE TSponsorTypes
(
	 intSponsorTypeID		INTEGER			NOT NULL
	,strSponsorTypeDesc		VARCHAR(50)		NOT NULL
	,CONSTRAINT TSponsorTypes_PK PRIMARY KEY ( intSponsorTypeID )
)


-- --------------------------------------------------------------------------------
-- Step #2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child							Parent						Column(s)
-- -	-----							------						---------
-- 1	TGolfers						TGenders					intGenderID
-- 2	TGolfers						TShirtSizes					intShirtSizeID
-- 3    TGolferEventYears				TGolfers					intGolferID
-- 4	TGolferEventYearSponsors		TGolferEventYears			intGolferID, intEventYearID
-- 5	TGolferEventYears				TEventYears					intEventYearID
-- 6    TGolferEventYearSponsors		TSponsors					intSponsorID
-- 7	TGolferEventYearSponsors		TSponsorTypes				intSponsorTypeID
-- 8	TGolferEventYearSponsors		TPaymentTypes				intPaymentTypeID

-- 1
ALTER TABLE TGolfers ADD CONSTRAINT TGolfers_TGenders_FK
FOREIGN KEY ( intGenderID ) REFERENCES TGenders ( intGenderID )

-- 2
ALTER TABLE TGolfers ADD CONSTRAINT TGolfers_TShirtSizes_FK
FOREIGN KEY ( intShirtSizeID ) REFERENCES TShirtSizes ( intShirtSizeID )

-- 3
ALTER TABLE TGolferEventYears ADD CONSTRAINT TGolferEventYears_TGolfers_FK
FOREIGN KEY ( intGolferID ) REFERENCES TGolfers ( intGolferID )

-- 4
ALTER TABLE TGolferEventYearSponsors ADD CONSTRAINT TGolferEventYearSponsors_TGolferEventYears_FK
FOREIGN KEY ( intGolferID, intEventYearID ) REFERENCES TGolferEventYears ( intGolferID, intEventYearID )

-- 5
ALTER TABLE TGolferEventYears ADD CONSTRAINT TGolferEventYears_TEventYears_FK
FOREIGN KEY ( intEventYearID ) REFERENCES TEventYears ( intEventYearID )

-- 6
ALTER TABLE TGolferEventYearSponsors ADD CONSTRAINT TGolferEventYearSponsors_TSponsors_FK
FOREIGN KEY ( intSponsorID ) REFERENCES TSponsors ( intSponsorID )

-- 7
ALTER TABLE TGolferEventYearSponsors ADD CONSTRAINT TGolferEventYearSponsors_TSponsorTypes_FK
FOREIGN KEY ( intSponsorTypeID ) REFERENCES TSponsorTypes ( intSponsorTypeID )

-- 8
ALTER TABLE TGolferEventYearSponsors ADD CONSTRAINT TGolferEventYearSponsors_TPaymentTypes_FK
FOREIGN KEY ( intPaymentTypeID ) REFERENCES TPaymentTypes ( intPaymentTypeID )

-- --------------------------------------------------------------------------------
-- Step #3: Add data to Gender
-- --------------------------------------------------------------------------------

INSERT INTO TGenders( intGenderID, strGenderDesc)
VALUES		(1, 'Female')
		   ,(2, 'Male')

---- --------------------------------------------------------------------------------
---- Step #4: Add men's and women's shirt sizes
---- --------------------------------------------------------------------------------

INSERT INTO TShirtSizes( intShirtSizeID, strShirtSizeDesc)
VALUES	 (1, 'Mens Small')
		,(2, 'Mens Medium')
		,(3, 'Mens Large')
		,(4, 'Mens XLarge')
		,(5, 'Womens Small')
		,(6, 'Womens Medium')
		,(7, 'Womens Large')
		,(8, 'Womens XLarge')

---- --------------------------------------------------------------------------------
---- Step #5: Add years
---- --------------------------------------------------------------------------------
INSERT INTO TEventYears ( intEventYearID, intEventYear )
VALUES	 ( 1, 2018)
		,( 2, 2019)
		,(3, 2020)

---- --------------------------------------------------------------------------------
---- Step #6: Add sponsor types
---- --------------------------------------------------------------------------------
INSERT INTO TSponsorTypes ( intSponsorTypeID, strSponsorTypeDesc)
VALUES   (1, 'Parent')
		,(2, 'Alumni')
		,(3, 'Friend')
		,(4, 'Business')

---- --------------------------------------------------------------------------------
---- Step #7: Add payment types
---- --------------------------------------------------------------------------------
INSERT INTO TPaymentTypes ( intPaymentTypeID, strPaymentTypeDesc)
VALUES   (1, 'Check')
		,(2, 'Cash')
		,(3, 'Credit Card')
---- --------------------------------------------------------------------------------
---- Step #8: Add sponsors
---- --------------------------------------------------------------------------------

INSERT INTO TSponsors ( intSponsorID, strFirstName, strLastName, strStreetAddress, strCity, strState, strZip, strPhoneNumber, strEmail )
VALUES	 ( 1, 'Jim', 'Smith', '1979 Wayne Trace Rd.', 'Willow', 'OH', '42368', '5135551212', 'jsmith@yahoo.com' )
		,( 2, 'Sally', 'Jones', '987 Mills Rd.', 'Cincinnati', 'OH', '45202', '5135551234', 'sjones@yahoo.com' )
		,( 3,'Marsha','Williams','723 Williams Rd.','Cincinnati','OH','45971','5139827164','mwilliams@gmail.com')
---- --------------------------------------------------------------------------------
---- Step #9: Add golfers
---- --------------------------------------------------------------------------------

INSERT INTO TGolfers ( intGolferID, strFirstName, strLastName, strStreetAddress, strCity, strState, strZip, strPhoneNumber, strEmail, intShirtSizeID, intGenderID )
VALUES	 ( 1, 'Bill', 'Goldstein', '156 Main St.', 'Mason', 'OH', '45040', '5135559999', 'bGoldstein@yahoo.com', 1, 2 )
		,( 2, 'Tara', 'Everett', '3976 Deer Run', 'West Chester', 'OH', '45069', '5135550101', 'teverett@yahoo.com', 6, 1 )
		,( 3, 'Harris','Hartung', '827 Galaxy Ln', 'Milford', 'OH', '45150', '5138749283','hhartung@gmail.com', 2, 2)
		,( 4,'Shanique','Panton','826 CherryRed Rd', 'Cincinnati','OH', '45170','5138273847','spanton@gmail.com', 6, 1)
---- --------------------------------------------------------------------------------
---- Step # 10: Add Golfers and sponsors to link them
---- --------------------------------------------------------------------------------

INSERT INTO TGolferEventYears (intGolferEventYearID, intGolferID, intEventYearID)
VALUES   (1,1, 1)
		,(2,2, 1)
		,(3,1, 2)
		,(4,2, 2)

---- --------------------------------------------------------------------------------
---- Step # 10: Add Golfers and sponsors to link them
---- --------------------------------------------------------------------------------
INSERT INTO TGolferEventYearSponsors (intGolferEventYearSponsorID,intGolferID, intEventYearID, intSponsorID, monPledgeAmount, intSponsorTypeID, intPaymentTypeID, blnPaid )
VALUES	 (1, 1, 1, 1, 25.00, 1, 1, 1 )
		,(2, 1, 1, 2, 25.00, 1, 1, 1 )

---------------------------------------------------------------------------------------------------------------------
		
GO
CREATE PROCEDURE uspAddGolfer

		 @intGolferID		      INTEGER  OUTPUT	 
		,@strFirstName		      VARCHAR               
		,@strLastName		      VARCHAR         
		,@strStreetAddress	      VARCHAR         
		,@strCity			      VARCHAR
		,@strState			      VARCHAR
		,@strZip				  VARCHAR
		,@strPhoneNumber		  VARCHAR
		,@strEmail			      VARCHAR
		,@intShirtSizeID		  INTEGER
		,@intGenderID		      INTEGER


AS
			
SET XACT_ABORT ON
BEGIN TRANSACTION

	SELECT @intGolferID = MAX(intGolferID)+1
	FROM TGolfers (TABLOCKX)

	SELECT @intGolferID = COALESCE(@intGolferID,1)
			
	INSERT INTO TGolfers(intGolferID,strFirstName,strLastName,strStreetAddress,strCity,strState,strZip,strPhoneNumber,strEmail,intShirtSizeID,intGenderID)
	VALUES (@intGolferID,@strFirstName,@strLastName,@strStreetAddress,@strCity,@strState,@strZip,@strPhoneNumber,@strEmail,@intShirtSizeID,@intGenderID)
		

COMMIT TRANSACTION

------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspAddSponsor

		 @intSponsorID		      INTEGER  OUTPUT	 
		,@strFirstName		      VARCHAR(50)              
		,@strLastName		      VARCHAR(50)        
		,@strStreetAddress	      VARCHAR(50)         
		,@strCity			      VARCHAR(50)
		,@strState			      VARCHAR(50)
		,@strZip				  VARCHAR(50)
		,@strPhoneNumber		  VARCHAR(50)
		,@strEmail			      VARCHAR(50)
		


AS
			
SET XACT_ABORT ON
BEGIN TRANSACTION

	SELECT @intSponsorID = MAX(intSponsorID)+1
	FROM TSponsors (TABLOCKX)

	SELECT @intSponsorID = COALESCE(@intSponsorID,1)
			
	INSERT INTO TSponsors(intSponsorID,strFirstName,strLastName,strStreetAddress,strCity,strState,strZip,strPhoneNumber,strEmail)
	VALUES (@intSponsorID,@strFirstName,@strLastName,@strStreetAddress,@strCity,@strState,@strZip,@strPhoneNumber,@strEmail)
		

COMMIT TRANSACTION


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspAddEvent

		 @intEventYearID		  INTEGER OUTPUT
		,@intEventYear		      INTEGER               
		

AS
			
SET XACT_ABORT ON
BEGIN TRANSACTION

	SELECT @intEventYearID = MAX(intEventYearID)+1
	FROM TEventYears (TABLOCKX)
	
	SELECT @intEventYearID = COALESCE(@intEventYearID,1)

	INSERT INTO TEventYears(intEventYearID,intEventYear)
	VALUES (@intEventYearID,@intEventYear)
		

COMMIT TRANSACTION

--DECLARE @intEventYearID AS INTEGER = 0
--EXECUTE uspAddEvent @intEventYearID OUTPUT 1,1
--PRINT 'EventID = ' + CONVERT (VARCHAR,@intEventYearID) 
--------------------------------------------------------------------------------------------------------------------------

GO
CREATE PROCEDURE uspAddGolferEvent
		
		 @intGolferEventYearID    INTEGER OUTPUT
		,@intGolferID		      INTEGER
		,@intEventYearID		  INTEGER              
		
AS

SET NOCOUNT ON	 -- Reports Errors Only
SET XACT_ABORT ON
BEGIN TRANSACTION
	
		SELECT @intGolferEventYearID = MAX(intGolferEventYearID)+1
		FROM TGolferEventYears (TABLOCKX)

		SELECT @intGolferEventYearID = COALESCE(@intGolferEventYearID,1)



	INSERT INTO TGolferEventYears WITH (TABLOCKX)(intGolferEventYearID,intGolferID,intEventYearID)
	VALUES (@intGolferEventYearID,@intGolferID,@intEventYearID)

	----SELECT @intGolferEventYearID = MAX(intGolferEventYearID) FROM TGolferEventYears
		

COMMIT TRANSACTION

GO

--DECLARE @intGolferEventYearID AS INTEGER = 0
--EXECUTE uspAddGolferEvent @intGolferEventYearID OUTPUT 1,1
--PRINT 'EventGolferID = ' + CONVERT (VARCHAR,@intGolferEventYearID) 


SELECT * FROM TGolfers
SELECT * FROM TEventYears
SELECT * FROM TGolferEventYears


--------------------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspGolferEventYearSponsor

			@intGolferEventYearSponsorID  INTEGER OUTPUT
		   ,@intGolferID				  INTEGER
		   ,@intEventYearID               INTEGER
		   ,@intSponsorID                 INTEGER
		   ,@monPledgeAmount              MONEY
		   ,@intSponsorTypeID             INTEGER
		   ,@intPaymentTypeID             INTEGER
		   ,@blnPaid                      BIT

AS

SET NOCOUNT ON	 -- Reports Errors Only
SET XACT_ABORT ON

BEGIN TRANSACTION


		SELECT @intGolferEventYearSponsorID = MAX(intGolferEventYearSponsorID)+1
		FROM TGolferEventYearSponsors (TABLOCKX)

		SELECT @intGolferEventYearSponsorID = COALESCE(@intGolferEventYearSponsorID,1)

		INSERT INTO TGolferEventYearSponsors WITH (TABLOCKX)(intGolferEventYearSponsorID,intGolferID,intEventYearID,intSponsorID,monPledgeAmount,intSponsorTypeID,intPaymentTypeID,blnPaid)
		VALUES (@intGolferEventYearSponsorID,@intGolferID,@intEventYearID,@intSponsorID,@monPledgeAmount,@intSponsorTypeID,@intPaymentTypeID,@blnPaid)

		--SELECT @intGolferEventYearSponsorID = MAX(intGolferEventYearSponsorID) FROM TGolferEventYearSponsors

COMMIT TRANSACTION

Go

--DECLARE @intGolferID AS INTEGER = 0
--EXECUTE uspGolferEventYearSponsor @intGolferID OUTPUT 
--PRINT 'uspGolferEventYearSponsor = ' + CONVERT (VARCHAR,@intGolferID) 

-------------------------------------------------------------------------------------------------------
-- Create Views to show golfers in the events and golfers not in the events
-------------------------------------------------------------------------------------------------------
Go

CREATE VIEW vAvailableGolfers
AS
SELECT intGolferID,strLastName	
FROM TGolfers 
WHERE intGolferID NOT IN (SELECT intGolferID FROM TGolferEventYears WHERE intEventYearID IN (SELECT MAX(intEventYearID) FROM TEventYears))

Go

SELECT * FROM vAvailableGolfers

GO
------------------------------------------------------------------------------------------------------------------------
CREATE VIEW vEventGolfers
AS
SELECT
	 TG.intGolferID
	,TG.strLastName
	,TEY.intEventYearID	
FROM
	 TGolfers AS TG
	,TEventYears AS TEY
	,TGolferEventYears AS TEG
WHERE
	TG.intGolferID = TEG.intGolferID
AND TEY.intEventYearID = TEG.intEventYearID


GO


SELECT * FROM vEventGolfers

------------------------------------------------------------------------------------------------------------------
Go

CREATE VIEW vGolferNotInGolferEvents
AS
SELECT intGolferID, strLastName
FROM TGolfers 
WHERE intGolferID NOT IN (SELECT intEventYearID FROM TGolferEventYearSponsors WHERE intGolferEventYearSponsorID IN (SELECT MAX(intGolferEventYearSponsorID) FROM TGolferEventYearSponsors))

Go

SELECT * FROM vGolferNotInGolferEvents

GO

---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
Go
CREATE VIEW vGolferTotal
As
SELECT intGolferID, SUM (monPledgeAmount) as GolferTotal
FROM TGolferEventYearSponsors
GROUP BY intGolferID

GO
----------------------------------------------------------------------------------------------------------------
Go
CREATE VIEW vEventTotal
AS

SELECT intEventYearID, SUM (monPledgeAmount) as EventTotal
FROM TGolferEventYearSponsors
GROUP BY intEventYearID

GO
----------------------------------------------------------------------------------------------------------
GO
CREATE VIEW vSponsorTotal
AS
SELECT intSponsorID, SUM (monPledgeAmount) as SponsorTotal
FROM TGolferEventYearSponsors
GROUP BY intSponsorID

GO

SELECT * FROM vSponsorTotal




