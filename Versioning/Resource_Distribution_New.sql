CREATE TABLE Resource_Distribution_New (
    DistributionID INT IDENTITY(1,1) PRIMARY KEY,
    DistributionDate DATE,
    ResourceID INT,
    TeamID INT,
    ProjectID INT,
    FOREIGN KEY (ResourceID) REFERENCES Resources(ResourceID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
