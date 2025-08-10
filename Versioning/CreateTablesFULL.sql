create table Clients (
    ClientID int primary key,
    Name varchar(255) not null,
    Contact varchar(255),
    Email varchar(255) unique,
    PhoneNumber varchar(20),
    Address text,
    Industry varchar(100)
);

create table Teams (
    TeamID int primary key,
    Name varchar(255) not null,
    Specialization varchar(255)
);

create table Employees (
    EmployeeID int primary key,
    Name varchar(255) not null,
    Role varchar(100),
    Email varchar(255) unique,
    PhoneNumber varchar(20),
    HireDate date,
    TeamID int,
    foreign key (TeamID) references Teams(TeamID)
);

create table Contracts_Clients (
    ContractID int primary key,
    ClientID int,
    StartDate date,
    EndDate date,
    Value decimal(15, 2),
    PaymentTerms varchar(255),
    foreign key (ClientID) references Clients(ClientID)
);

create table Projects (
    ProjectID int primary key,
    Name varchar(255) not null,
    Description text,
    StartDate date,
    EndDate date,
    Status varchar(50),
    Budget decimal(15, 2),
    ContractID int,
    foreign key (ContractID) references Contracts_Clients(ContractID)
);

create table Projects_Contracts (
    ProjectID int,
    ContractID int,
    Name varchar(255),
    Status varchar(50),
    primary key (ProjectID, ContractID),
    foreign key (ProjectID) references Projects(ProjectID),
    foreign key (ContractID) references Contracts_Clients(ContractID)
);

create table Payments (
    PaymentID int primary key,
    ContractID int,
    Date date,
    Amount decimal(15, 2),
    foreign key (ContractID) references Contracts_Clients(ContractID)
);

create table Contracts_Employees (
    ContractID int,
    EmployeeID int,
    Role varchar(100),
    AssignedDate date,
    Salary decimal(15, 2),
    primary key (ContractID, EmployeeID),
    foreign key (ContractID) references Contracts_Clients(ContractID),
    foreign key (EmployeeID) references Employees(EmployeeID)
);

create table Resources (
    ResourceID int primary key,
    Type varchar(255) not null,
    Quantity int,
    Cost decimal(15, 2),
    ProjectID int,
    foreign key (ProjectID) references Projects(ProjectID)
);

create table Tasks (
    TaskID int primary key,
    Name varchar(255) not null,
    Priority varchar(50),
    Status varchar(50),
    DueDate date,
    Description TEXT,
    ProjectID int,
    EmployeeID int,
    foreign key (ProjectID) references Projects(ProjectID),
    foreign key (EmployeeID) references Employees(EmployeeID)
);

create table Services (
    ServiceID int primary key,
    Name varchar(255),
    Description text,
    Cost decimal(15, 2),
    ContractID int,
    foreign key (ContractID) references Contracts_Clients(ContractID)
);

create table Resource_Distribution (
    DistributionID int primary key,
    DistributionDate date,
    ResourceID int,
    TeamID int,
    ProjectID int,
    foreign key (ResourceID) references Resources(ResourceID),
    foreign key (TeamID) references Teams(TeamID),
    foreign key (ProjectID) references Projects(ProjectID)
);
