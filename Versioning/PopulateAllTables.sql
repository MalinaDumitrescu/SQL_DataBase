INSERT INTO Clients (ClientID, Name, Contact, Email, PhoneNumber, Address, Industry)
VALUES
(1, 'Acme Corp', 'John Doe', 'contact@acme.com', '123-456-7890', '123 Main St', 'Technology'),
(2, 'Global Inc', 'Jane Smith', 'jane@globalinc.com', '987-654-3210', '456 Elm St', 'Finance'),
(3, 'HealthCare Solutions', 'Dr. Adam', 'adam@healthcare.com', '555-123-4567', '789 Oak St', 'Healthcare'),
(4, 'EduTech', 'Emily Clark', 'emily@edutech.com', '222-333-4444', '321 Maple St', 'Education'),
(5, 'GreenEnergy', 'Robert Green', 'robert@greenenergy.com', '666-777-8888', '654 Pine St', 'Energy'),
(6, 'Foodies', 'Sarah Brown', 'sarah@foodies.com', '999-888-7777', '888 Spruce St', 'Food'),
(7, 'TransportX', 'Tom White', 'tom@transportx.com', '444-555-6666', '777 Birch St', 'Logistics'),
(8, 'BuildPro', 'Mason Gray', 'mason@buildpro.com', '333-222-1111', '999 Cedar St', 'Construction'),
(9, 'EcoWorks', 'Anna Blue', 'anna@ecoworks.com', '111-222-3333', '222 Fir St', 'Environment'),
(10, 'TravelGo', 'Chris Black', 'chris@travelgo.com', '888-999-0000', '555 Palm St', 'Tourism');


INSERT INTO Teams (TeamID, Name, Specialization)
VALUES
(1, 'Development Team', 'Software Development'),
(2, 'Finance Team', 'Financial Analysis'),
(3, 'Healthcare Team', 'Medical Research'),
(4, 'Education Team', 'Curriculum Development'),
(5, 'Energy Team', 'Renewable Energy'),
(6, 'Culinary Team', 'Food Innovation'),
(7, 'Logistics Team', 'Supply Chain Management'),
(8, 'Construction Team', 'Structural Engineering'),
(9, 'Environmental Team', 'Sustainability'),
(10, 'Tourism Team', 'Travel Planning');


INSERT INTO Employees (EmployeeID, Name, Role, Email, PhoneNumber, HireDate, TeamID)
VALUES
(1, 'Alice', 'Software Engineer', 'alice@acme.com', '123-123-1234', '2022-01-15', 1),
(2, 'Bob', 'Financial Analyst', 'bob@globalinc.com', '456-456-4567', '2021-05-10', 2),
(3, 'Charlie', 'Doctor', 'charlie@healthcare.com', '789-789-7890', '2020-03-25', 3),
(4, 'Diana', 'Teacher', 'diana@edutech.com', '222-444-6666', '2019-08-30', 4),
(5, 'Ethan', 'Energy Analyst', 'ethan@greenenergy.com', '555-666-7777', '2023-02-01', 5),
(6, 'Fiona', 'Chef', 'fiona@foodies.com', '888-999-1111', '2022-06-18', 6),
(7, 'George', 'Logistics Manager', 'george@transportx.com', '333-333-4444', '2021-09-12', 7),
(8, 'Hannah', 'Civil Engineer', 'hannah@buildpro.com', '777-888-9999', '2020-12-04', 8),
(9, 'Ian', 'Environmental Scientist', 'ian@ecoworks.com', '111-222-5555', '2018-11-22', 9),
(10, 'Julia', 'Travel Planner', 'julia@travelgo.com', '444-555-8888', '2021-07-15', 10);


INSERT INTO Contracts_Clients (ContractID, ClientID, StartDate, EndDate, Value, PaymentTerms)
VALUES
(1, 1, '2024-01-01', '2024-12-31', 100000, 'Quarterly'),
(2, 2, '2024-02-01', '2024-11-30', 200000, 'Monthly'),
(3, 3, '2024-03-15', '2024-09-15', 150000, 'Half-Yearly'),
(4, 4, '2024-04-01', '2024-10-01', 120000, 'Monthly'),
(5, 5, '2024-05-01', '2025-04-30', 250000, 'Yearly'),
(6, 6, '2024-06-01', '2024-12-31', 80000, 'Quarterly'),
(7, 7, '2024-07-01', '2025-06-30', 300000, 'Monthly'),
(8, 8, '2024-08-01', '2024-12-01', 90000, 'Half-Yearly'),
(9, 9, '2024-09-01', '2025-03-01', 50000, 'Quarterly'),
(10, 10, '2024-10-01', '2025-09-30', 110000, 'Monthly');


INSERT INTO Projects (ProjectID, Name, Description, StartDate, EndDate, Status, Budget, ContractID)
VALUES
(1, 'Alpha', 'Software development project', '2024-01-15', '2024-11-15', 'Ongoing', 50000, 1),
(2, 'Beta', 'Financial software analysis', '2024-02-01', '2024-08-01', 'Completed', 75000, 2),
(3, 'Gamma', 'Health app research', '2024-03-01', '2024-09-01', 'Ongoing', 60000, 3),
(4, 'Delta', 'E-learning platform', '2024-04-01', '2024-12-31', 'Ongoing', 80000, 4),
(5, 'Epsilon', 'Solar energy research', '2024-05-15', '2025-04-15', 'Planned', 100000, 5),
(6, 'Zeta', 'Food delivery app', '2024-06-01', '2024-12-01', 'Completed', 40000, 6),
(7, 'Eta', 'Logistics optimization', '2024-07-01', '2024-12-31', 'Ongoing', 90000, 7),
(8, 'Theta', 'Recycling project', '2024-08-01', '2025-01-31', 'Planned', 30000, 8),
(9, 'Iota', 'Smart building design', '2024-09-15', '2025-03-15', 'Planned', 20000, 9),
(10, 'Kappa', 'Travel booking system', '2024-10-01', '2025-06-01', 'Ongoing', 45000, 10);


INSERT INTO Projects_Contracts (ProjectID, ContractID, Name, Status)
VALUES
(1, 1, 'Alpha Contract', 'Ongoing'),
(2, 2, 'Beta Contract', 'Completed'),
(3, 3, 'Gamma Contract', 'Ongoing'),
(4, 4, 'Delta Contract', 'Ongoing'),
(5, 5, 'Epsilon Contract', 'Planned'),
(6, 6, 'Zeta Contract', 'Completed'),
(7, 7, 'Eta Contract', 'Ongoing'),
(8, 8, 'Theta Contract', 'Planned'),
(9, 9, 'Iota Contract', 'Planned'),
(10, 10, 'Kappa Contract', 'Ongoing');


INSERT INTO Payments (PaymentID, ContractID, Date, Amount)
VALUES
(1, 1, '2024-02-15', 25000),
(2, 2, '2024-03-01', 50000),
(3, 3, '2024-03-20', 50000),
(4, 4, '2024-05-01', 30000),
(5, 5, '2024-06-15', 100000),
(6, 6, '2024-07-01', 20000),
(7, 7, '2024-08-01', 75000),
(8, 8, '2024-09-01', 15000),
(9, 9, '2024-10-01', 5000),
(10, 10, '2024-11-01', 55000);


INSERT INTO Contracts_Employees (ContractID, EmployeeID, Role, AssignedDate, Salary)
VALUES
(1, 1, 'Lead Developer', '2024-01-10', 60000),
(2, 2, 'Financial Analyst', '2024-02-05', 50000),
(3, 3, 'Medical Consultant', '2024-03-01', 70000),
(4, 4, 'Education Specialist', '2024-04-10', 45000),
(5, 5, 'Energy Expert', '2024-05-15', 80000),
(6, 6, 'Head Chef', '2024-06-01', 55000),
(7, 7, 'Logistics Officer', '2024-07-20', 65000),
(8, 8, 'Civil Engineer', '2024-08-25', 70000),
(9, 9, 'Environmental Scientist', '2024-09-15', 60000),
(10, 10, 'Tourism Consultant', '2024-10-01', 50000);


INSERT INTO Resources (ResourceID, Type, Quantity, Cost, ProjectID)
VALUES
(1, 'Server Infrastructure', 10, 50000, 1),
(2, 'Laptops', 20, 40000, 2),
(3, 'Medical Equipment', 5, 75000, 3),
(4, 'Books', 100, 20000, 4),
(5, 'Solar Panels', 50, 150000, 5),
(6, 'Kitchens', 2, 50000, 6),
(7, 'Delivery Trucks', 10, 100000, 7),
(8, 'Recycling Units', 15, 60000, 8),
(9, 'Construction Materials', 200, 200000, 9),
(10, 'Software Licenses', 50, 30000, 10);


INSERT INTO Tasks (TaskID, Name, Priority, Status, DueDate, Description, ProjectID, EmployeeID)
VALUES
(1, 'Develop Feature A', 'High', 'In Progress', '2024-06-01', 'Develop core functionality', 1, 1),
(2, 'Test Module B', 'Medium', 'Pending', '2024-05-15', 'Unit testing for module', 2, 2),
(3, 'Design Prototype', 'Low', 'In Progress', '2024-09-10', 'Initial design phase', 3, 3),
(4, 'Create Curriculum', 'High', 'Completed', '2024-08-01', 'Develop course materials', 4, 4),
(5, 'Install Solar Panels', 'High', 'Pending', '2024-12-15', 'Panel installation', 5, 5),
(6, 'Improve App UI', 'Medium', 'Completed', '2024-07-01', 'Enhance user interface', 6, 6),
(7, 'Optimize Logistics Routes', 'High', 'Pending', '2024-10-20', 'Streamline delivery', 7, 7),
(8, 'Build Recycling Framework', 'Medium', 'Planned', '2024-11-15', 'Initial framework setup', 8, 8),
(9, 'Assemble Smart Building Units', 'Low', 'Planned', '2024-12-01', 'Start assembly', 9, 9),
(10, 'Integrate Payment API', 'High', 'In Progress', '2024-06-10', 'Payment system integration', 10, 10);


INSERT INTO Services (ServiceID, Name, Description, Cost, ContractID)
VALUES
(1, 'Web Hosting', 'Provide reliable and scalable hosting services.', 15000, 1),
(2, 'Accounting', 'Financial accounting and reporting.', 20000, 2),
(3, 'Health Analysis', 'Comprehensive health diagnostics.', 25000, 3),
(4, 'E-Learning Content', 'Interactive course materials.', 30000, 4),
(5, 'Energy Consultancy', 'Consultation for renewable energy projects.', 35000, 5),
(6, 'Catering Services', 'Professional food catering.', 15000, 6),
(7, 'Logistics Optimization', 'Route and supply chain optimization.', 40000, 7),
(8, 'Waste Management', 'Sustainable recycling solutions.', 25000, 8),
(9, 'Building Design', 'Custom structural planning.', 45000, 9),
(10, 'Travel Assistance', 'End-to-end travel planning.', 20000, 10);



INSERT INTO Resource_Distribution (DistributionID, DistributionDate, ResourceID, TeamID, ProjectID)
VALUES
(1, '2024-02-01', 1, 1, 1),
(2, '2024-03-10', 2, 2, 2),
(3, '2024-04-05', 3, 3, 3),
(4, '2024-05-15', 4, 4, 4),
(5, '2024-06-20', 5, 5, 5),
(6, '2024-07-01', 6, 6, 6),
(7, '2024-08-10', 7, 7, 7),
(8, '2024-09-15', 8, 8, 8),
(9, '2024-10-01', 9, 9, 9),
(10, '2024-11-10', 10, 10, 10);
