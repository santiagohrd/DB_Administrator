--Creaci�n de vistas como metodo de seguridad
CREATE VIEW Customers.info
AS
SELECT CustomerID,
	CustomerName,
	PhoneNumber,
	DeliveryLocation
FROM [WideWorldImporters].Sales.Customers;

--Asignaci�n de la vista al usuario
GRANT SELECT ON [Customers].[info] TO [new_employee]
GO