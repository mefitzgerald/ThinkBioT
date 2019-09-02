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
 ClassTaskSourceFile TEXT,
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
 DawnCaptureTime TEXT,
 DuskCaptureTime TEXT,
 ProcessTXTime TEXT,
 Tr_Sil_dur REAL,
 Tr_Sil_dur_perc INTEGER,
 Tr_Sil_below_dur REAL,
 Tr_Sil_below_dur_perc INTEGER,
 Tr_Hpfilter INTEGER,
 Tr_Gain INTEGER,
 Tr_Wav_length INTEGER,
 Tr_Test_Length INTEGER,
 Ai_Gain INTEGER,
 CurrentMode INTEGER,
 ResearchStartDateTime TEXT,
 ResearchEndDateTime TEXT
);

INSERT INTO Settings 	(SettingName, SettingActive, DawnCaptureTime, DuskCaptureTime, ProcessTXTime, 
						Tr_Sil_dur, Tr_Sil_dur_perc, Tr_Sil_below_dur, Tr_Sil_below_dur_perc, Tr_Hpfilter, 
						Tr_Gain, Tr_Wav_length, Tr_Test_Length, Ai_Gain, 
						CurrentMode, ResearchStartDateTime, ResearchEndDateTime) 
VALUES ("DEFAULT", 1, 0630, "-1", 2300, 
		0.1, 1, 1.0, 1, 80, 
		6, 5, 300, 6, 
		0, "-1", "-1");





