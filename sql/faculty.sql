CREATE TABLE Faculty (
    FacSSN         CHAR(11),
    FacFirstName   VARCHAR(50)  NOT NULL,
    FacLastName    VARCHAR(50)  NOT NULL,
    FacCity        VARCHAR(50)  NOT NULL,
    FacState       CHAR(2)      NOT NULL,
    FacZipCode     CHAR(10)     NOT NULL,
    FacHireDate    DATE,
    FacDept        CHAR(6),
    FacRank        CHAR(4),
    FacSalary      DECIMAL(10,2),
    FacSupervisor  CHAR(11),
    CONSTRAINT PKFaculty PRIMARY KEY (FacSSN),
    CONSTRAINT FKFacSupervisor FOREIGN KEY (FacSupervisor) 
        REFERENCES Faculty(FacSSN)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


INSERT INTO Faculty (FacSSN, FacFirstName, FacLastName, FacCity, FacState, FacDept, FacRank, FacSalary, FacSupervisor, FacHireDate, FacZipCode)
VALUES 
('543-21-0987', 'VICTORIA', 'EMMANUEL', 'BOTHELL', 'WA', 'MS', 'PROF', 120000, NULL, '1996-04-15', '98011-2242'),
('765-43-2109', 'NICKI', 'MACON', 'BELLEVUE', 'WA', 'FIN', 'PROF', 65000, NULL, '1997-04-11', '98015-9945'),
('654-32-1098', 'LEONARD', 'FIBON', 'SEATTLE', 'WA', 'MS', 'ASSC', 70000, '543-21-0987', '1994-05-01', '98121-0094'),
('098-76-5432', 'LEONARD', 'VINCE', 'SEATTLE', 'WA', 'MS', 'ASST', 35000, '654-32-1098', '1995-04-10', '98111-9921'),
('876-54-3210', 'CRISTOPHER', 'COLAN', 'SEATTLE', 'WA', 'MS', 'ASST', 40000, '654-32-1098', '1999-03-01', '98114-1332'),
('987-65-4321', 'JULIA', 'MILLS', 'SEATTLE', 'WA', 'FIN', 'ASSC', 75000, '765-43-2109', '2000-03-15', '98114-9954');