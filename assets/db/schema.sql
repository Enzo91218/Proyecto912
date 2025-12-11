CREATE TABLE usuarios (
  id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  edad INTEGER NOT NULL,
  peso REAL NOT NULL,
  altura REAL NOT NULL
);

CREATE TABLE recetas (
  id TEXT PRIMARY KEY,
  titulo TEXT NOT NULL,
  descripcion TEXT NOT NULL,
  cultura TEXT NOT NULL
);

CREATE TABLE ingredientes (
  id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL,
  cantidad TEXT NOT NULL
);

CREATE TABLE receta_ingredientes (
  receta_id TEXT NOT NULL,
  ingrediente_id TEXT NOT NULL,
  PRIMARY KEY (receta_id, ingrediente_id)
);

CREATE TABLE dietas (
  id TEXT PRIMARY KEY,
  nombre TEXT NOT NULL
);

CREATE TABLE dieta_recetas (
  dieta_id TEXT NOT NULL,
  receta_id TEXT NOT NULL,
  PRIMARY KEY (dieta_id, receta_id)
);

CREATE TABLE registros_imc (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  imc REAL NOT NULL,
  categoria TEXT NOT NULL
);

CREATE TABLE registros_peso_altura (
  id TEXT PRIMARY KEY,
  usuario_id TEXT NOT NULL,
  peso REAL NOT NULL,
  altura REAL NOT NULL,
  fecha TEXT NOT NULL
);
