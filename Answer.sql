
use Netflox;

--1. Tampilkan Name yang merupakan gabungan First Name dan Last Name, CustAddress dengan format "Address, City" diurutkan dari customer dengan umur tertua (CONCAT, ORDER BY)

SELECT CONCAT(FirstName,' ',LastName) AS Name, CONCAT(Address,',',' ',City) AS CustAddress
FROM MsCustomer
ORDER BY DOB

--2. Tampilkan Staff yang merupakan gabungan dari tiga digit terakhir StaffID dan LastName dengan format "ID - Last Name", Email, Gender dari staff yang Salarynya lebih dari 1,6 juta (RIGHT, CONCAT)

SELECT CONCAT(RIGHT(StaffID, 3), ' ', '-', ' ', LastName) AS Staff, Email, Gender
FROM MsStaff
WHERE Salary > 1600000

--3. Create View 'vw_Q3OrderList� yang menampilkan Order ID, Customer Name, Order Date, Rental Duration dimana customer melakukan rental dari Juli hingga September 2021 dengan format Order Date dd-mm-yyyy (CREATE VIEW, CONVERT, DATEPART, BETWEEN, YEAR)

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

--6. Tampilkan kelompok Gender dari Staff, kemudian hitung jumlah salary dari masing-masing kelompok Gender (CASE WHEN, CAST, SUM, GROUP BY)
	WHEN Gender = 'M' THEN 'Male Staff' ELSE 'Female Staff' END, 
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

--11.  Buatlah Stored Procedure "GetTopFiveFilms" untuk menampilkan Title, Synopsis, dan durasi peminjaman dari lima Film yang pernah dirental Customer dengan durasi rental terlama. Jika durasi rental sama, diurutkan dari Title secara abjad.
GetOrderByCode 'OD004'