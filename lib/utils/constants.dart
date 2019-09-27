const COLOR_HEX_CINZA = "#19232D";
const COLOR_DEFAULT = "#F26430";
//const COLOR_DEFAULT = "#35475D";
const COLOR_RED_APP = "#ecaf04";
const OUTHER_COLOR_DEFAULT = "#CC1B25";
const DB_NAME_FILE = 'annotations.db';
const DB_ANOTATION_TABLE_NAME = 'annotation';
const DB_ANOTATION_TABLE_CONTENT = 'content';



const SCRIPT_ANOTATION = '''CREATE TABLE $DB_ANOTATION_TABLE_NAME (
    "id_anotation"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "title"	VARCHAR(80) NOT NULL UNIQUE, 
        "color"	TEXT NOT NULL,
        "createdAt"	INTEGER NOT NULL,
        "modifiedAt"	INTEGER NOT NULL
    )''';

var SCRIPT_CONTENT = '''CREATE TABLE $DB_ANOTATION_TABLE_CONTENT (
        "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "value"	TEXT NOT NULL,
        "createdAt"	INTEGER NOT NULL,
        "modifiedAt"	INTEGER NOT NULL, 
        "id_anotation"	INTEGER NOT NULL,
        FOREIGN KEY("id_anotation") REFERENCES "anotation"("id_anotation")
)''';
