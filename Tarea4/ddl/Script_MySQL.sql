
CREATE DATABASE IF NOT EXISTS red_social_pascualina
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE red_social_pascualina;

-- 1. ESTUDIANTE
CREATE TABLE ESTUDIANTE (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    correo_institucional VARCHAR(150) NOT NULL UNIQUE,
    programa_academico VARCHAR(120) NOT NULL,
    semestre INT NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (semestre > 0)
) ENGINE=InnoDB;

-- 2. PERFIL
CREATE TABLE PERFIL (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL UNIQUE,
    biografia TEXT,
    ciudad VARCHAR(100),
    foto_perfil VARCHAR(500),
    fecha_actualizacion DATETIME,
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. HABILIDAD
CREATE TABLE HABILIDAD (
    id_habilidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;

-- 4. ESTUDIANTE_HABILIDAD
CREATE TABLE ESTUDIANTE_HABILIDAD (
    id_estudiante INT NOT NULL,
    id_habilidad INT NOT NULL,
    nivel VARCHAR(30) NOT NULL,
    fecha_aprendizaje DATE,
    PRIMARY KEY (id_estudiante, id_habilidad),
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_habilidad)
        REFERENCES HABILIDAD(id_habilidad)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. INTERES
CREATE TABLE INTERES (
    id_interes INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;

-- 6. ESTUDIANTE_INTERESES
CREATE TABLE ESTUDIANTE_INTERESES (
    id_estudiante INT NOT NULL,
    id_interes INT NOT NULL,
    fecha_agregado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_estudiante, id_interes),
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_interes)
        REFERENCES INTERES(id_interes)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. SEGUIR
CREATE TABLE SEGUIR (
    id_seguidor INT NOT NULL,
    id_seguido INT NOT NULL,
    fecha_seguimiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_seguidor, id_seguido),
    CHECK (id_seguidor <> id_seguido),
    FOREIGN KEY (id_seguidor)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_seguido)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. MENSAJE
CREATE TABLE MENSAJE (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    id_emisor INT NOT NULL,
    id_receptor INT NOT NULL,
    texto TEXT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'enviado',
    fecha_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_emisor)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_receptor)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. GRUPO
CREATE TABLE GRUPO (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    tema VARCHAR(100) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;

-- 10. MIEMBRO_GRUPO
CREATE TABLE MIEMBRO_GRUPO (
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    rol VARCHAR(30) NOT NULL DEFAULT 'miembro',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_estudiante, id_grupo),
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_grupo)
        REFERENCES GRUPO(id_grupo)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 11. EVENTO
CREATE TABLE EVENTO (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    fecha DATETIME NOT NULL,
    lugar VARCHAR(200) NOT NULL,
    descripcion TEXT,
    datos_adicionales JSON,
    FOREIGN KEY (id_grupo)
        REFERENCES GRUPO(id_grupo)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 12. ASISTENTE_EVENTO
CREATE TABLE ASISTENTE_EVENTO (
    id_estudiante INT NOT NULL,
    id_evento INT NOT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'inscrito',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_estudiante, id_evento),
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_evento)
        REFERENCES EVENTO(id_evento)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 13. PUBLICACION
CREATE TABLE PUBLICACION (
    id_publicacion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 14. COMENTARIO
CREATE TABLE COMENTARIO (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    id_publicacion INT NOT NULL,
    id_estudiante INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_publicacion)
        REFERENCES PUBLICACION(id_publicacion)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 15. REACCION
CREATE TABLE REACCION (
    id_reaccion INT AUTO_INCREMENT PRIMARY KEY,
    id_publicacion INT NOT NULL,
    id_estudiante INT NOT NULL,
    tipo_reaccion VARCHAR(30) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_publicacion)
        REFERENCES PUBLICACION(id_publicacion)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_estudiante)
        REFERENCES ESTUDIANTE(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
