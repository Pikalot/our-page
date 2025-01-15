-- 1
CREATE TABLE Members (
    mid INTEGER AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255),
    username VARCHAR(100) NOT NULL,
    password VARCHAR(30) NOT NULL CHECK (CHAR_LENGTH(password) >= 8),
    role ENUM('admin', 'user'),
    pid BIGINT
);

-- 2
CREATE TABLE Employers (
    eid INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state CHAR(2),
    country VARCHAR(20)
);

-- 3
CREATE TABLE works_at (
    mid INTEGER,
    eid INTEGER,
    from_date VARCHAR(20) NOT NULL,
    to_date VARCHAR(20),
    PRIMARY KEY (mid, eid),
    FOREIGN KEY (mid) REFERENCES Members(mid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (eid) REFERENCES Employers(eid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 4
CREATE TABLE Schools (
    sid INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    city VARCHAR(100),
    state CHAR(2),
    country VARCHAR(20)
);

-- 5
CREATE TABLE Majors(
    id CHAR(4) PRIMARY KEY,
    name VARCHAR(255) 
);

-- 6
CREATE TABLE graduates_at (
    mid INTEGER,
    sid INTEGER,
    major_id CHAR(4),
    degree ENUM(
        'AA', 
        'AS', 
        'BA', 
        'BS',
        'MA',
        'MS',
        'MFA',
        'LLM',
        'PhD',
        'MD',
        'DDS',
        'DFA'),
    gpa FLOAT(3, 2),
    PRIMARY KEY (mid, sid, major_id),
    FOREIGN KEY (mid) REFERENCES Members(mid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (sid) REFERENCES Schools(sid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (major_id) REFERENCES Majors(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 7
CREATE TABLE Courses (
    cid CHAR(4) PRIMARY KEY,
    name VARCHAR(255),
    code VARCHAR(50)
);

-- 8
CREATE TABLE takes_course (
    mid INTEGER,
    sid INTEGER,
    cid CHAR(4),
    grade VARCHAR(2),
    PRIMARY KEY (mid, sid, cid),
    FOREIGN KEY (mid) REFERENCES Members(mid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (sid) REFERENCES Schools(sid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (cid) REFERENCES Courses(cid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 9
CREATE TABLE Projects (
    pid CHAR(4) PRIMARY KEY,
    name VARCHAR(255),
    repository VARCHAR(255)
);

-- 10
CREATE TABLE owns_project (
    mid INTEGER,
    pid CHAR(4),
    PRIMARY KEY (mid, pid),
    FOREIGN KEY (mid) REFERENCES Members(mid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (pid) REFERENCES Projects(pid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 11
CREATE TABLE Contents (
    cid BIGINT AUTO_INCREMENT PRIMARY KEY,
    mid INT NOT NULL,
    created_date DATE NOT NULL,
    text TEXT,
    Short_video VARCHAR(255),
    FOREIGN KEY (mid) REFERENCES Members(mid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 12
CREATE TABLE Photos(
    pid BIGINT PRIMARY KEY,
    source TEXT NOT NULL,
    FOREIGN KEY (pid) REFERENCES Contents(cid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 13
ALTER TABLE Members
ADD CONSTRAINT frkey_pid_ref_photos
FOREIGN KEY (pid) REFERENCES Photos(pid)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- 14
CREATE TABLE Personal_URLs (
    uid INTEGER PRIMARY KEY,
    url VARCHAR(255)
);

-- 15
CREATE TABLE has_URL (
    mid INTEGER,
    uid INTEGER,
    PRIMARY KEY (mid, uid),
    FOREIGN KEY (mid) REFERENCES Members(mid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (uid) REFERENCES Personal_URLs(uid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DELIMITER //

-- 16
CREATE TRIGGER before_insert_majors
BEFORE INSERT ON Majors
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    IF (SELECT id FROM Majors) IS NULL
        THEN SET NEW.id = 'm001';
    ELSE 
        SELECT MAX(CAST(SUBSTRING(id, 2) AS UNSIGNED)) + 1
        INTO new_id
        FROM Majors;
        SET NEW.id = CONCAT('m', LPAD(new_id, 3, '0'));
    END IF;
END//

-- 17
CREATE TRIGGER before_insert_courses
BEFORE INSERT ON Courses
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    IF (SELECT cid FROM COURSES) IS NULL
        THEN SET NEW.cid = 'c001';
    ELSE 
        SELECT MAX(CAST(SUBSTRING(cid, 2) AS UNSIGNED)) + 1
        INTO new_id
        FROM Courses;
        SET NEW.cid = CONCAT('c', LPAD(new_id, 3, '0'));
    END IF;
END//

-- 18
CREATE TRIGGER before_insert_projects
BEFORE INSERT ON Projects
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    IF (SELECT pid FROM Projects) IS NULL
        THEN SET NEW.pid = 'p001';
    ELSE
        SELECT MAX(CAST(SUBSTRING(pid, 2) AS UNSIGNED)) + 1
        INTO new_id
        FROM Projects;
        SET NEW.pid = CONCAT('p', LPAD(new_id, 3, '0'));
    END IF;
END//

DELIMITER ;

-- POPULATE TEST DATABASE

