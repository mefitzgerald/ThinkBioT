CREATE TABLE IF NOT EXISTS TaskSession (
 SessionID INTEGER PRIMARY KEY AUTOINCREMENT,
 TestLong TEXT,
 TestLat TEXT,
 TestElevation TEXT,
 TransmittedTime TEXT,
 SettingID INTEGER,
 FOREIGN KEY (SettingID) REFERENCES Settings(SettingID)
);

CREATE TABLE IF NOT EXISTS ClassTasks (
 ClassID INTEGER PRIMARY KEY AUTOINCREMENT,
 ClassTaskTime TEXT,
 ClassTaskSourceFile TEXT
 ClassTaskResult TEXT,
 ClassTaskPercent TEXT,
 SessionID INTEGER,
 FOREIGN KEY (SessionID) REFERENCES TaskSession(SessionID)
);

CREATE TABLE IF NOT EXISTS AcousticIndexTasks (
 IndexID INTEGER PRIMARY KEY AUTOINCREMENT,
 IndexTaskTime TEXT,
 IndexTaskType TEXT,
 IndexTaskSource TEXT,
 IndexTaskResult TEXT,
 SessionID INTEGER,
 FOREIGN KEY (SessionID) REFERENCES TaskSession(SessionID)
);

CREATE TABLE IF NOT EXISTS Settings (
 SettingID INTEGER PRIMARY KEY AUTOINCREMENT,
 SettingName TEXT,
 SettingActive INTEGER,
 AcIndexCaptureTime TEXT,
 ClassificationCaptureTime TEXT,
 ProcessingTaskTime TEXT,
 CurrentMode INTEGER
);

INSERT INTO Settings (SettingName, SettingActive, AcIndexCaptureTime, ClassificationCaptureTime, ProcessingTaskTime, CurrentMode) 
VALUES ("DEFAULT", 1, NULL, NULL, NULL, 0);






