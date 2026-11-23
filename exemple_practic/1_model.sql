USE master;
GO
DROP DATABASE InvestYourStashMaster;
CREATE DATABASE InvestYourStashMaster;
GO

-- 1.  Cream baza de date si o populam
CREATE TABLE Investitori (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nume VARCHAR(100),
    Prenume VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Companii (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Denumire VARCHAR(150),
    Simbol_Bursier VARCHAR(10) UNIQUE,
    Sector VARCHAR(100)
);

CREATE TABLE Brokeri (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nume VARCHAR(100),
    Comision DECIMAL(5, 2) 
);

CREATE TABLE Portofolii (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ID_Investitor INT FOREIGN KEY REFERENCES Investitori(ID),
    ID_Companie INT FOREIGN KEY REFERENCES Companii(ID),
    Cantitate INT CHECK (Cantitate >= 0),
    UNIQUE(ID_Investitor, ID_Companie)
);

CREATE TABLE Tranzactii (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Tip VARCHAR(10) CHECK (Tip IN ('CUMPARARE', 'VANZARE')),
    Data_Ora DATETIME DEFAULT GETDATE(),
    Cantitate INT CHECK (Cantitate > 0),
    Pret_Actiune DECIMAL(10, 2),
    ID_Investitor INT FOREIGN KEY REFERENCES Investitori(ID),
    ID_Companie INT FOREIGN KEY REFERENCES Companii(ID),
    ID_Broker INT FOREIGN KEY REFERENCES Brokeri(ID)
);
GO

INSERT INTO Investitori (Nume, Prenume, Email) VALUES
('Popescu', 'Ion', 'ion.popescu@email.com'),
('Ionescu', 'Maria', 'maria.ionescu@email.com'),
('Popa', 'Andrei', 'andrei.popa@email.com'),
('Stan', 'Elena', 'elena.stan@email.com'),
('Dumitru', 'Alexandru', 'alex.dumitru@email.com');

INSERT INTO Companii (Denumire, Simbol_Bursier, Sector) VALUES
('Tech Corp', 'TECH', 'Tehnologie'),
('Green Energy', 'GREN', 'Energie'),
('Pharma Life', 'PHRM', 'Sanatate'),
('Bank Transilvania', 'TLV', 'Financiar'),
('Aero Space', 'AERO', 'Industrie');

INSERT INTO Brokeri (Nume, Comision) VALUES
('Tradeville', 0.5),
('XTB', 0.2),
('Interactive Brokers', 0.3),
('eToro', 0.1),
('BRK Financial Group', 0.6);

INSERT INTO Portofolii (ID_Investitor, ID_Companie, Cantitate) VALUES
(1, 1, 100),
(1, 2, 50),
(2, 4, 200),
(3, 1, 10),
(4, 3, 75);

INSERT INTO Tranzactii (Tip, Data_Ora, Cantitate, Pret_Actiune, ID_Investitor, ID_Companie, ID_Broker) VALUES
('CUMPARARE', '2023-01-15 10:30:00', 100, 150.50, 1, 1, 1),
('CUMPARARE', '2023-02-20 11:15:00', 50, 45.20, 1, 2, 2),
('CUMPARARE', '2023-03-05 09:45:00', 200, 22.10, 2, 4, 1),
('CUMPARARE', '2023-04-10 14:20:00', 10, 155.00, 3, 1, 3),
('CUMPARARE', '2023-05-12 16:00:00', 75, 80.00, 4, 3, 4);
GO

-- 2.  Vanzarea de actiuni
CREATE OR ALTER PROCEDURE USP_Vinde_Actiuni (
    @ID_Investitor INT,
    @ID_Companie INT,
    @Cantitate_Vanduta INT,
    @ID_Broker INT,
    @Pret_Vanzare DECIMAL(10, 2)
)
AS
BEGIN
    DECLARE @Cantitate_Detinuta INT;
    DECLARE @Nume_Inv VARCHAR(100);
    DECLARE @Prenume_Inv VARCHAR(100);
    DECLARE @Simbol VARCHAR(10);

    SELECT @Nume_Inv = Nume, @Prenume_Inv = Prenume FROM Investitori WHERE ID = @ID_Investitor; -- selectam numele si prenumele investitorilor cu id cautat
    SELECT @Simbol = Simbol_Bursier FROM Companii WHERE ID = @ID_Companie; -- selectam simbolurile pentru companiile cerute

    SELECT @Cantitate_Detinuta = Cantitate 
    FROM Portofolii 
    WHERE ID_Investitor = @ID_Investitor AND ID_Companie = @ID_Companie; -- selectam cantitatea detinuta

    IF ISNULL(@Cantitate_Detinuta, 0) < @Cantitate_Vanduta
    BEGIN
        PRINT 'Investitorul ' + ISNULL(@Nume_Inv, '') + ' ' + ISNULL(@Prenume_Inv, '') + ' nu are destule acțiuni ' + ISNULL(@Simbol, '') + '. Diamond hands, dar portofel gol!';
        RETURN 1;
    END

    UPDATE Portofolii
    SET Cantitate = Cantitate - @Cantitate_Vanduta
    WHERE ID_Investitor = @ID_Investitor AND ID_Companie = @ID_Companie;

    INSERT INTO Tranzactii (Tip, Data_Ora, Cantitate, Pret_Actiune, ID_Investitor, ID_Companie, ID_Broker)
    VALUES ('VANZARE', GETDATE(), @Cantitate_Vanduta, @Pret_Vanzare, @ID_Investitor, @ID_Companie, @ID_Broker);

    RETURN 0;
END
GO

-- 3. Crearea unui view cu cerinta data
CREATE OR ALTER VIEW VW_Tranzactii_Per_Companie AS
SELECT 
    C.Denumire AS Nume_Companie, 
    C.Simbol_Bursier,
    COUNT(T.ID) AS Numar_Tranzactii
FROM 
    Companii C
LEFT JOIN 
    Tranzactii T ON C.ID = T.ID_Companie
GROUP BY 
    C.ID, C.Denumire, C.Simbol_Bursier;
GO

-- Testare

SELECT Cantitate 
FROM Portofolii 
WHERE ID_Investitor = 1;

EXEC USP_Vinde_Actiuni @ID_Investitor = 1, @ID_Companie = 1, @Cantitate_Vanduta = 20, @ID_Broker = 1, @Pret_Vanzare = 160.00;

SELECT Cantitate 
FROM Portofolii 
WHERE ID_Investitor = 1;

EXEC USP_Vinde_Actiuni @ID_Investitor = 1, @ID_Companie = 1, @Cantitate_Vanduta = 1000, @ID_Broker = 1, @Pret_Vanzare = 160.00;

SELECT Cantitate 
FROM Portofolii 
WHERE ID_Investitor = 1;

SELECT * FROM VW_Tranzactii_Per_Companie;
