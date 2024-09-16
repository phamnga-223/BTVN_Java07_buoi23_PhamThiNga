-- 1)	Liệt kê tên sản phẩm và tên nhà cung cấp cho tất cả các sản phẩm có giá lớn hơn 15.00
SELECT p.ProductName , s.SupplierName 
FROM Products p 
JOIN Suppliers s ON p.SupplierID = s.SupplierID 
WHERE p.Price > 15;

-- 2)	Tìm tất cả các đơn hàng được thực hiện bởi khách hàng ở "Mexico"
SELECT o.*
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE c.Country = 'Mexico';

-- 3)	Tìm số lượng đơn hàng được thực hiện trong mỗi quốc gia
SELECT c.Country , COUNT(*) AS so_don_hang
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
GROUP BY c.Country ;

-- 4)	Liệt kê tất cả các nhà cung cấp và số lượng loại sản phẩm mà họ cung cấp
SELECT s.*, COUNT(0) AS so_san_pham
FROM Suppliers s 
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID ;

-- 5)	Liệt kê tên sản phẩm và giá của các sản phẩm đắt hơn sản phẩm "Chang"
SELECT p.ProductName , p.Price 
FROM Products p 
WHERE p.Price > (SELECT p2.Price FROM Products p2 WHERE p2.ProductName = 'Chang');

-- 6)	Tìm tổng số lượng sản phẩm bán ra trong tháng 5 năm 2024
SELECT COUNT(*)
FROM OrderDetails od
JOIN Orders o ON o.OrderID = od.OrderID 
WHERE DATE_FORMAT(o.OrderDate, "%m - %Y") = '05 - 2024';

-- 7)	Tìm tên của các khách hàng chưa từng đặt hàng
SELECT c.CustomerName 
FROM Customers c 
WHERE NOT EXISTS (SELECT * FROM Orders o WHERE o.CustomerID = c.CustomerID);

-- 8)	Liệt kê các đơn hàng với tổng số tiền lớn hơn 200.00
SELECT o.*, SUM(p.PRICE * od.Quantity) AS tong_tien
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY o.OrderID
HAVING tong_tien > 200;

-- 9)	Tìm tên sản phẩm và số lượng trung bình được đặt hàng cho mỗi đơn hàng
SELECT p.ProductID , p.ProductName , SUM(od.Quantity) / COUNT(DISTINCT od.OrderID) AS so_luong_TB
FROM Products p 
JOIN OrderDetails od ON p.ProductID = od.ProductID 
GROUP BY p.ProductID ;

-- 10)	Tìm khách hàng có tổng giá trị đơn hàng cao nhất
SELECT c.*, SUM(p.Price * od.Quantity) AS tong_tien
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od ON od.OrderID = o.OrderID 
JOIN Products p ON p.ProductID = od.ProductID 
GROUP BY c.CustomerID 
ORDER BY tong_tien DESC
LIMIT 1;

-- 11)	Tìm các đơn hàng có tổng giá trị nằm trong top 10 cao nhất
SELECT o.*, SUM(p.Price * od.Quantity) AS tong_gia_tri
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID 
JOIN Products p ON p.ProductID = od.ProductID 
GROUP BY o.OrderID 
ORDER BY tong_gia_tri DESC
LIMIT 10;

-- 12)	Tìm tên khách hàng và số lượng đơn hàng của họ, chỉ bao gồm các khách hàng có số lượng đơn hàng lớn hơn mức trung bình
SELECT c.CustomerName, COUNT(*) as so_don_hang
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID
HAVING so_don_hang > ((SELECT COUNT(*) FROM Orders o2) / (SELECT COUNT(*) FROM Customers c2));

-- 13)	Tìm sản phẩm có giá trị đơn hàng trung bình cao nhất (dựa trên giá sản phẩm và số lượng).
SELECT p.*, SUM(p.Price * od.Quantity)/COUNT(DISTINCT od.OrderID) AS gia_tri_DH_TB
FROM Products p 
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID 
ORDER BY gia_tri_DH_TB DESC 
LIMIT 1;


-- 14)	Liệt kê các sản phẩm chưa bao giờ được đặt hàng bởi khách hàng đến từ "USA"
SELECT p.*
FROM Products p 
WHERE p.ProductID NOT IN (
	SELECT p.ProductID 
	FROM Products p 
	JOIN OrderDetails od ON p.ProductID = od.ProductID 
	JOIN Orders o ON o.OrderID = od.OrderID AND o.CustomerID = (SELECT CustomerID FROM Customers c WHERE c.country = 'USA')
	GROUP BY p.ProductID
);

-- 15)	Tìm nhà cung cấp có số lượng sản phẩm cung cấp nhiều nhất.
SELECT s.*, COUNT(*) as so_luong_sp
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID 
GROUP BY s.SupplierID
HAVING so_luong_sp >= (
	SELECT COUNT(*) as so_luong_sp_2
	FROM Products p2  
	GROUP BY p2.SupplierID
	ORDER BY so_luong_sp_2 DESC 
	LIMIT 1)
;
