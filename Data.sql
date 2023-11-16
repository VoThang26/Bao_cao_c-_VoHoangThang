﻿CREATE DATABASE QuanLyQuanTraDa
GO

USE QuanLyQuanTraDa
GO


-- Food
-- Table
-- FoodCategory
-- Account
-- Bill
-- BillInfo

CREATE TABLE TableFood
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100)NOT NULL DEFAULT N'Bàn chưa có tên',
	status NVARCHAR(100)NOT NULL DEFAULT N'Trống'
)
GO

CREATE TABLE Account
(
	UserName NVARCHAR(100) NOT NULL PRIMARY KEY,
	DisplayName NVARCHAR(100) NOT NULL DEFAULT N'Kter', 
	PassWord NVARCHAR(100) NOT NULL DEFAULT 0,
	Type INT  NOT NULL DEFAULT 0
)
GO

CREATE TABLE FoodCategory
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chua dat ten'
)
GO

CREATE TABLE Food
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100)NOT NULL DEFAULT N'Chua dat ten',
	idCategory INT NOT NULL,
	price FLOAT  NOT NULL DEFAULT 0

	FOREIGN KEY (idCategory) REFERENCES dbo.FoodCategory(id)
)
GO

CREATE TABLE Bill
(
	id INT IDENTITY PRIMARY KEY,
	DateCheckIn DATE NOT NULL DEFAULT GETDATE() ,
	DateCheckOut DATE,
	idTable INT NOT NULL,
	status INT  NOT NULL DEFAULT 0

	FOREIGN KEY (idTable) REFERENCES dbo.TableFood(id)
)
GO

CREATE TABLE BillInfo
(
	id INT IDENTITY PRIMARY KEY,
	idBill INT NOT NULL,
	idFood INT NOT NULL,
	count INT NOT NULL DEFAULT 0

	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id)
)
GO

INSERT INTO dbo.Account
( UserName ,
	DisplayName, 
	PassWord,
	Type
	)
	VALUES
	( N'user1' ,
	N'H' ,
	N'1' ,
	0
	)
GO

INSERT INTO dbo.Account
( UserName ,
	DisplayName, 
	PassWord,
	Type
	)
	VALUES
	( N'user2' ,
	N'THANG' ,
	N'1' ,
	0
	)
GO
INSERT INTO dbo.Account
( UserName ,
	DisplayName, 
	PassWord,
	Type
	)
	VALUES
	( N'user3' ,
	N'H' ,
	N'1' ,
	1
	)
GO
INSERT INTO dbo.Account
( UserName ,
	DisplayName, 
	PassWord,
	Type
	)
	VALUES
	( N'admin' ,
	N'H' ,
	N'1' ,
	1
	)
GO

SELECT * FROM dbo.Account
GO
CREATE PROC USP_GetAccountByUserName
@userName nvarchar(100)
AS 
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName 
END
GO

CREATE PROC USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
AS 
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName AND  PassWord = @passWord
END
GO


EXEC dbo.USP_GetAccountByUserName @userName = N'user1'

--THEM table
DECLARE @i INT = 0
while @i <= 10
begin 
insert dbo.TableFood (name) VALUES(N'Bàn ' + CAST(@i as nvarchar(100)))
set @i = @i +1
end
GO

--DELETE FROM dbo.TableFood WHERE id = '33';
--DELETE FROM dbo.FoodCategory WHERE id = '6';



CREATE PROC USP_GetTableList
AS 
BEGIN
	SELECT * FROM dbo.TableFood
END
GO

--THEM CATEGORY
INSERT dbo.FoodCategory (name) values ( N'Hải sản')
INSERT dbo.FoodCategory (name) values ( N'Đậu' )
INSERT dbo.FoodCategory (name) values ( N'Hạt' )
INSERT dbo.FoodCategory (name) values ( N'Bánh tráng')
INSERT dbo.FoodCategory (name) values ( N'Nước' )

--them mon
INSERT dbo.Food(name,idCategory,price) values ( N'Mực một nắng sa tế',1,120000)
INSERT dbo.Food(name,idCategory,price) values ( N'Mực một nắng bơ tỏi',1,110000)
INSERT dbo.Food(name,idCategory,price) values ( N'Đậu phông rang',2,30000)
INSERT dbo.Food(name,idCategory,price) values ( N'Đậu phông lộc',2,20000)
INSERT dbo.Food(name,idCategory,price) values ( N'Hạt hướng dương',3,30000)
INSERT dbo.Food(name,idCategory,price) values ( N'Bánh tráng trộn',4,30000)
INSERT dbo.Food(name,idCategory,price) values ( N'Bánh tráng nướng',4,25000)
INSERT dbo.Food(name,idCategory,price) values ( N'Trà đá',5 ,5000)
INSERT dbo.Food(name,idCategory,price) values ( N'Nước ngọt ',5 ,15000)
INSERT dbo.Food(name,idCategory,price) values ( N'Cafe',5 ,12000)


--them bill
INSERT dbo.Bill(DateCheckIn,DateCheckOut,idTable,status) values(GETDATE(),NULL,31,0 )
INSERT dbo.Bill(DateCheckIn,DateCheckOut,idTable,status) values(GETDATE(),NULL,32,0 )
INSERT dbo.Bill(DateCheckIn,DateCheckOut,idTable,status) values(GETDATE(),GETDATE(),32,1 )
INSERT dbo.Bill(DateCheckIn,DateCheckOut,idTable,status) values(GETDATE(),GETDATE(),30,1 )

--THEM bill info
INSERT dbo.BillInfo(idBill,idFood,count) values(30,1,2)
INSERT dbo.BillInfo(idBill,idFood,count) values(30,3,4)
INSERT dbo.BillInfo(idBill,idFood,count) values(31,5,1)
INSERT dbo.BillInfo(idBill,idFood,count) values(28,1,2)
INSERT dbo.BillInfo(idBill,idFood,count) values(28,6,2)
INSERT dbo.BillInfo(idBill,idFood,count) values(29,5,2)
INSERT dbo.BillInfo(idBill,idFood,count) values(32,4,2)

GO

SELECT f.name, bi.count, f.price, f.price*bi.count AS totalPrice FROM dbo.BillInfo AS bi, dbo.Bill AS b, dbo.Food AS f
WHERE bi.idBill = b.id AND bi.idFood = f.id AND b.idTable = 31

SELECT * FROM dbo.Bill
SELECT * FROM dbo.BillInfo
SELECT * FROM dbo.Food
SELECT * FROM dbo.FoodCategory

select * from dbo.TableFood

CREATE PROC USP_InsertBill
@idTable INT
AS 
BEGIN
	INSERT dbo.Bill(DateCheckIn,DateCheckOut,idTable,status,discount) values(GETDATE(),NULL,@idTable,0,0 ) 
END
GO

--ALTER PROC USP_InsertBillInFo
CREATE PROC USP_InsertBillInFo
@idBill INT, @idFood INT, @count INT
AS 
BEGIN
	DECLARE @isExitsBillInfo INT;
	DECLARE @foodCount INT=1 ;
	SELECT @isExitsBillInfo = id, @foodCount = b.count 
	FROM  dbo.BillInfo AS b WHERE idBill = @idBill AND idFood = @idFood
	IF (@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @Count
		IF(@newCount>0)
			UPDATE dbo.BillInfo SET count = @foodCount + @count WHERE idFood=@idFood
		ELSE
		DELETE dbo.BillInfo WHERE idBIll = @idBill AND idFood = @idFood
	END
	ELSE
		BEGIN
			INSERT dbo.BillInfo(idBill,idFood,count) values(@idBill,@idFood,@count)
		END
END
GO

--DELETE dbo.BillInfo
--DELETE dbo.Bill

CREATE TRIGGER UTG_UpdateBillInfo
ON dbo.BillInfo FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @idBill INT
	SELECT @idBill = idBIll FROM Inserted
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill AND status = 0
	
	UPDATE dbo.TableFood SET status = N'Có người' WHERE id = @idTable
END
GO

CREATE TRIGGER UTG_UpdateBill
ON dbo.Bill FOR UPDATE
AS 
BEGIN
	DECLARE @idBill INT
	SELECT @idBill = id FROM Inserted
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill 
	DECLARE @count int = 0
	SELECT @count = COUNT(*) FROM dbo.Bill WHERE idTable = @idTable AND status = 0
	IF (@count = 0 )
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable
END
GO

ALTER TABLE dbo.Bill
ADD discount INT

UPDATE dbo.Bill SET discount = 0


ALTER PROC USP_SwitchTable1
@idTable1 INT, @idTable2 int
AS BEGIN

	DECLARE @idFirstBill int
	DECLARE @idSeconrdBill INT
	
	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1
	
	
	SELECT @idSeconrdBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idFirstBill IS NULL)
	BEGIN
		PRINT '0000001'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable1 , -- idTable - int
		          0  -- status - int
		        )
		        
		SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
		
	END
	
	SELECT @isFirstTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idFirstBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idSeconrdBill IS NULL)
	BEGIN
		PRINT '0000002'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable2 , -- idTable - int
		          0  -- status - int
		        )
		SELECT @idSeconrdBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
		
	END
	
	SELECT @isSecondTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'

	SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	UPDATE dbo.BillInfo SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill
	
	UPDATE dbo.BillInfo SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF (@isFirstTablEmty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable2
		
	IF (@isSecondTablEmty= 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable1
END
GO


SELECT * FROM dbo.Bill

CREATE PROC USP_GetListBillByDate
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount AS [Giảm giá]
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable
END
GO

CREATE PROC USP_UpdateAccount
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	
	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE USERName = @userName AND PassWord = @password
	
	IF (@isRightPass = 1)
	BEGIN
		IF (@newPassword = NULL OR @newPassword = '')
		BEGIN
			UPDATE dbo.Account SET DisplayName = @displayName WHERE UserName = @userName
		END		
		ELSE
			UPDATE dbo.Account SET DisplayName = @displayName, PassWord = @newPassword WHERE UserName = @userName
	end
END
GO

CREATE TRIGGER UTG_DeteleBillInfo
ON dbo.BillInfo FOR DELETE
AS
BEGIN
	DECLARE @idBillInfo INT
	DECLARE @idBill INT
	SELECT @idBillInfo = id, @idBill = Deleted.idBill FROM Deleted

	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill

	DECLARE @count INT = 0
	SELECT @idBill = COUNT(*) FROM dbo.BillInfo AS bi, dbo.Bill AS b WHERE b.id = bi.idBill AND b.id =@idBill AND b.status = 0

	IF (@count = 0)
		UPDATE dbo.TableFood SET status =  N'Trống' WHERE id = @idTable
END
GO

SELECT * FROM dbo.Account

CREATE FUNCTION fuConvertToUnsign1 
( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) 
AS
BEGIN 
IF @strInput IS NULL 
RETURN @strInput IF @strInput = '' 
RETURN @strInput DECLARE @RT NVARCHAR(4000) 
DECLARE @SIGN_CHARS NCHAR(136) 
DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' 
DECLARE @COUNTER int 
DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) 
BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) 
BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) 
BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput 
END
GO

CREATE PROC USP_GetListBillByDateAndPage
@checkIn date, @checkOut date, @page int
AS 
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH BillShow AS( SELECT b.ID, t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount AS [Giảm giá]
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable)
	
	SELECT TOP (@selectRows) * FROM BillShow WHERE id NOT IN (SELECT TOP (@exceptRows) id FROM BillShow)
END
GO
CREATE PROC USP_GetNumBillByDate
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT COUNT(*)
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable
END
GO

