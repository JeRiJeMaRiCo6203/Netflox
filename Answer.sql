
use Netflox;

--1. Tampilkan Name yang merupakan gabungan First Name dan Last Name, CustAddress dengan format "Address, City" diurutkan dari customer dengan umur tertua (CONCAT, ORDER BY)

SELECT CONCAT(FirstName,' ',LastName) AS Name, CONCAT(Address,',',' ',City) AS CustAddress
FROM MsCustomer
ORDER BY DOB

--2. Tampilkan Staff yang merupakan gabungan dari tiga digit terakhir StaffID dan LastName dengan format "ID - Last Name", Email, Gender dari staff yang Salarynya lebih dari 1,6 juta (RIGHT, CONCAT)

SELECT CONCAT(RIGHT(StaffID, 3), ' ', '-', ' ', LastName) AS Staff, Email, Gender
FROM MsStaff
WHERE Salary > 1600000

--3. Create View 'vw_Q3OrderList’ yang menampilkan Order ID, Customer Name, Order Date, Rental Duration dimana customer melakukan rental dari Juli hingga September 2021 dengan format Order Date dd-mm-yyyy (CREATE VIEW, CONVERT, DATEPART, BETWEEN, YEAR)

CREATE VIEW vw_Q3OrderList AS

SELECT [Customer Name] = CONCAT(FirstName,' ',LastName), [Order Date] =  CONVERT(VARCHAR, OrderDate, 105), RentalDuration
FROM TrOrder
JOIN MsCustomer ON TrOrder.CustomerID = MsCustomer.CustomerID
JOIN TrOrderDetail ON TrOrder.OrderID = TrOrderDetail.OrderID
WHERE DATEPART(YEAR,OrderDate) = 2021 AND DATEPART(m,OrderDate) BETWEEN 6 AND 9

SELECT * FROM vw_Q3OrderList

--4. Tampilkan Title Film yang terdiri dari 2 kata atau lebih, kemudian ganti kata kedua dan seterusnya dengan Genre dan tampilkan kolom Film Details yang berisi (Tahun Rilis : Director) untuk film yang dirilis di Region Europe (REPLACE, SUBSTRING, CHARINDEX, LEN, JOIN, CONVERT, YEAR, LIKE)

SELECT [Title] = REPLACE(Title, SUBSTRING(Title, CHARINDEX(' ', Title, 0) + 1, LEN(Title)), GenreName), [Film Details] = CONCAT(YEAR(ReleaseDate), ' : ', Director)
FROM MsGenre
JOIN MsFilms ON MsGenre.GenreID = MsFilms.GenreID
JOIN MsRegion ON MsRegion.RegionID = MsFilms.RegionID
WHERE Title LIKE '% %' AND RegionName LIKE '%Europe%'

--5. Tampilkan Customer Name dengan di depan kata Mr untuk gender M dan Ms untuk gender perempuan, Order Date dengan format dd-mm-yyyy, dan judul film yang dirental untuk transaksi yang menggunakan metode pembayaran E-Wallet (CASE WHEN, CONVERT, JOIN)

SELECT [Customer Name] = CASE 
	WHEN Gender = 'M' THEN CONCAT('Mr. ', FirstName, ' ', LastName) ELSE CONCAT('Ms. ', FirstName, ' ', LastName) END,
	[Order Date] = CONVERT(VARCHAR, OrderDate, 105), [Title] = Title

FROM TrOrder
JOIN MsCustomer ON TrOrder.CustomerID = MsCustomer.CustomerID
JOIN MsPayment ON TrOrder.PaymentMethodID = MsPayment.PaymentMethodID
JOIN TrOrderDetail ON TrOrder.OrderID = TrOrderDetail.OrderID
JOIN MsFilms ON TrOrderDetail.FilmID = MsFilms.FilmID

WHERE PaymentMethodName LIKE '%E-Wallet%'

--6. Tampilkan kelompok Gender dari Staff, kemudian hitung jumlah salary dari masing-masing kelompok Gender (CASE WHEN, CAST, SUM, GROUP BY)SELECT [Gender] = CASE 
	WHEN Gender = 'M' THEN 'Male Staff' ELSE 'Female Staff' END, 	[Total Salary] = 'Rp. ' + CAST(SUM(Salary) AS VARCHAR) + ',-'FROM MsStaffGROUP BY Gender--7. Tampilkan Title Film di awali dengan 2 huruf pertama dari nama Region, Synopsis di awali kata terakhir dari Director, dan Release Date dimana Film tersebut bergenre Horror (LEFT, REVERSE,SUBSTRING, CHARINDEX)SELECT [Title] = LEFT(RegionName, 2) + ' ' + Title, [Synopsis] = RIGHT(Director, CHARINDEX(' ', REVERSE(Director)) - 1) + ' ' + Synopsis, ReleaseDateFROM msFilmsJOIN MsGenre ON MsFilms.GenreID = MsGenre.GenreIDJOIN MsRegion ON MsFilms.RegionID = MsRegion.RegionIDWHERE GenreName LIKE '%Horror%'--8.  Tampilkan Customer Name dengan huruf kecil semua, dan hitung berapa kali customer melakukan order, dan jumlah total film yang diorder lalu urutkan customer dari yang paling sedikit melakukan order rental film dimana transaksi di lakukan di Februari 2021 - Desember 2021 (LOWER, COUNT, DISTINCT, MONTH, BETWEEN, YEAR, GROUP BY, ORDER BY)SELECT DISTINCT [Customer Name] = LOWER(CONCAT(FirstName,' ',LastName)), [Order Count] = COUNT(TrOrderDetail.OrderID), [Film Count] = COUNT(TrOrderDetail.FilmID)FROM MsCustomerJOIN TrOrder ON MsCustomer.CustomerID = TrOrder.CustomerIDJOIN TrOrderDetail ON TrOrder.OrderID = TrOrderDetail.OrderIDJOIN MsFilms ON TrOrderDetail.FilmID = MsFilms.FilmIDWHERE DATEPART(YEAR,OrderDate) = 2021 AND DATEPART(m,OrderDate) BETWEEN 2 AND 12GROUP BY FirstName, LastNameORDER BY [Order Count], [Film Count], [Customer Name]--9. Tampilkan Customer Name,Jam Order dengan diakhiri dengan AM dan PM dan Total Rental Duration dimana ordernya dilayani oleh staff dengan nama akhir Sitorus atau Haryanti (CONVERT, CAST, SUM, IN)SELECT [Customer Name] = CONCAT(MsCustomer.FirstName,' ', MsCustomer.LastName), [Customer Order Time] = FORMAT(CAST(TrOrder.OrderDate AS datetime), 'hh:mmtt'), [Total Rental Duration] = SUM(RentalDuration)FROM MsCustomerJOIN TrOrder ON MsCustomer.CustomerID = TrOrder.CustomerIDJOIN TrOrderDetail ON TrOrder.OrderID = TrOrderDetail.OrderIDJOIN MsStaff ON TrOrder.StaffID = MsStaff.StaffIDWHERE MsStaff.LastName IN ('Sitorus', 'Haryanti')GROUP BY MsCustomer.FirstName, MsCustomer.LastName, TrOrder.OrderDate--10. Tampilkan Customer Name, Customer Gender dengan return Male dan Female, total order yang dilakukan customer, dan hitung rata rata durasi rental customer dimana Film tersebut diproduksi di Region Asia, Africa dan America dan Staff yang melayani transaksi memiliki nama belakang Nuraini (CASE WHEN, COUNT, AVG, IN)SELECT [Customer Name] = CONCAT(MsCustomer.FirstName,' ',MsCustomer.LastName), 
	[Customer Gender] = CASE 
	WHEN MsCustomer.Gender = 'M' THEN 'Male' ELSE 'Female' END, 
	[Total Order Count] = COUNT(TrOrderDetail.OrderID), 
	[Average Rental Duration] = AVG(RentalDuration)
FROM MsCustomer
JOIN TrOrder ON MsCustomer.CustomerID = TrOrder.CustomerID
JOIN TrOrderDetail ON TrOrder.OrderID = TrOrderDetail.OrderID
JOIN MsFilms ON TrOrderDetail.FilmID = MsFilms.FilmID
JOIN MsRegion ON MsFilms.RegionID = MsRegion.RegionID
JOIN MsStaff ON TrOrder.StaffID = MsStaff.StaffID
WHERE RegionName IN ('Asia', 'Africa', 'America') AND MsStaff.LastName IN ('Nuraini')
GROUP BY MsCustomer.FirstName, MsCustomer.LastName, MsCustomer.Gender

--11.  Buatlah Stored Procedure "GetTopFiveFilms" untuk menampilkan Title, Synopsis, dan durasi peminjaman dari lima Film yang pernah dirental Customer dengan durasi rental terlama. Jika durasi rental sama, diurutkan dari Title secara abjad.CREATE PROCEDURE GetTopFiveFilms@input VARCHAR(MAX)ASBEGIN	SELECT TOP (5) [Title] = Title, [Synopsis] = Synopsis, RentalDuration	FROM TrOrderDetail	JOIN MsFilms ON TrOrderDetail.FilmID = MsFilms.FilmID	GROUP BY RentalDuration, Title, Synopsis	ORDER BY RentalDuration descENDSELECT * FROM GetTopFiveFilms--12. Buatlah Stored Procedure "GetYearTotalFilm" untuk menampilkan tahun beserta jumlah film berbeda yang diorder di tahun tersebut, diurutkan dari tahun terlama.CREATE PROCEDURE GetYearTotalFilm@input VARCHAR(MAX)ASBEGIN	SELECT [Film Year] = YEAR(ReleaseDate), [Count Data] = COUNT(TrOrderDetail.FilmID)	FROM MsFilms	JOIN TrOrderDetail ON MsFilms.FilmID = TrOrderDetail.FilmID	WHERE ReleaseDate IN ('2021', '2022')	GROUP BY ReleaseDate	ORDER BY ReleaseDate ascEND--13. Buatlah Stored Procedure "GetOrderByCustomer <CustomerId>" untuk menampilkan data order dengan parameter CustomerId dengan output OrderId, OrderDate, CustomerName = (FirstName + LastName), Film Title, Rental Duration GetOrderById 'MC001'CREATE PROCEDURE "GetOrderByCustomer"@input VARCHAR(MAX)AS BEGIN	SELECT TrOrder.OrderID, OrderDate, [CustomerName] = FirstName + ' ' + LastName ,Title, RentalDuration	FROM TrOrder	JOIN MsCustomer ON TrOrder.CustomerID = MsCustomer.CustomerID	JOIN TrOrderDetail ON TrOrder.OrderID = TrOrderDetail.OrderID	JOIN MsFilms ON TrOrderDetail.FilmID = MsFilms.FilmID	WHERE MsCustomer.CustomerID = @inputENDGetOrderByCustomer'MC001'--14. Buatlah Stored Procedure "GetFilm <RegionName,GenreName?>" untuk menampilkan data film sudah di order dengan parameter Region Name (Wajib) dan Genre Name (Optional) dan jika parameter Genre Name kosong akan menampilkan semua Genre dengan output Film Title, Genre Name, Release Date, Synopsis, dan Director.GetFilm ‘Asia’,’Horror’GetFilm ‘Asia’,’’CREATE PROCEDURE GetFilm@inputRegion VARCHAR(MAX),@inputGenre VARCHAR(MAX)ASBEGIN	IF(@inputGenre = '')	BEGIN		SELECT Title, GenreName, ReleaseDate, Synopsis, Director		FROM MsFilms		JOIN MsGenre ON MsFilms.GenreID = MsGenre.GenreID		JOIN MsRegion ON MsFilms.RegionID = MsRegion.RegionID		WHERE MsRegion.RegionName = @inputRegion	END	ELSE	BEGIN		SELECT Title, GenreName, ReleaseDate, Synopsis, Director		FROM MsFilms		JOIN MsGenre ON MsFilms.GenreID = MsGenre.GenreID		JOIN MsRegion ON MsFilms.RegionID = MsRegion.RegionID		WHERE MsRegion.RegionName = @inputRegion AND MsGenre.GenreName = @inputGenre	ENDENDGetFilm 'Asia','Horror'GetFilm 'Asia',''--15. Buatlah Stored Procedure "GetOrderByCode <OrderId | OrderDetailId>" untuk menampilkan data order dengan parameter OrderId atau OrderDetailId dengan output OrderId, OrderDate, Film Title, Release Detail yang terdiri dari (tahun rilis : Director), dan durasi rental. Gunakan dynamic query (optional) GetOrderByCode 'TO002' GetOrderByCode 'OD004CREATE PROCEDURE GetOrderByCode@inputId VARCHAR(MAX)ASBEGIN	SELECT TrOrder.OrderID, OrderDate, Title, [Release Detail] = CONCAT(YEAR(ReleaseDate), ' : ', Director), RentalDuration	FROM TrOrder	JOIN TrOrderDetail ON TrOrder.OrderID = TrOrderDetail.OrderID	JOIN MsFilms ON TrOrderDetail.FilmID = MsFilms.FilmID	WHERE TrOrder.OrderID = @inputId OR TrOrderDetail.OrderDetailID = @inputIDEND GetOrderByCode 'TO002'
GetOrderByCode 'OD004'