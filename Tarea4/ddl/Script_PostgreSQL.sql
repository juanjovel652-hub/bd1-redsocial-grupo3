-- =====================================================================
-- Red social estudiantil pascualina - Modelo físico en PostgreSQL
-- SGBD: PostgreSQL 16 | Datos semiestructurados: JSONB
-- =====================================================================

SET client_min_messages TO WARNING;   -- oculta avisos de DROP IF EXISTS

DROP TABLE IF EXISTS reaccion, comentario, publicacion, asistente_evento, evento,
    miembro_grupo, grupo, mensaje, seguir, estudiante_interes, interes,
    estudiante_habilidad, habilidad, perfil, estudiante CASCADE;

-- 1. ESTUDIANTE
CREATE TABLE estudiante (
    id_estudiante        INTEGER GENERATED ALWAYS AS IDENTITY,   -- PK autogenerada
    nombre               VARCHAR(80)  NOT NULL,
    apellido             VARCHAR(80)  NOT NULL,
    correo_institucional VARCHAR(120) NOT NULL,
    programa_academico   VARCHAR(100) NOT NULL,
    semestre             SMALLINT     NOT NULL,
    fecha_registro       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_estudiante PRIMARY KEY (id_estudiante),
    CONSTRAINT uq_estudiante_correo UNIQUE (correo_institucional),   -- un correo por estudiante
    CONSTRAINT ck_estudiante_semestre CHECK (semestre > 0)           -- semestre positivo
);

-- 2. PERFIL (relación 1:1 con ESTUDIANTE)
CREATE TABLE perfil (
    id_perfil           INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante       INTEGER NOT NULL,
    biografia           TEXT,
    ciudad              VARCHAR(80),
    foto_perfil         VARCHAR(255),                                -- ruta o URL
    fecha_actualizacion TIMESTAMP,
    CONSTRAINT pk_perfil PRIMARY KEY (id_perfil),
    CONSTRAINT uq_perfil_estudiante UNIQUE (id_estudiante),          -- máximo un perfil por estudiante
    CONSTRAINT fk_perfil_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON DELETE CASCADE ON UPDATE CASCADE                          -- sin estudiante no hay perfil
);

-- 3. HABILIDAD
CREATE TABLE habilidad (
    id_habilidad INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre       VARCHAR(80) NOT NULL,
    descripcion  TEXT,
    CONSTRAINT pk_habilidad PRIMARY KEY (id_habilidad),
    CONSTRAINT uq_habilidad_nombre UNIQUE (nombre)                   -- evita habilidades repetidas
);

-- 4. ESTUDIANTE_HABILIDAD (N:M)
CREATE TABLE estudiante_habilidad (
    id_estudiante    INTEGER     NOT NULL,
    id_habilidad     INTEGER     NOT NULL,
    nivel            VARCHAR(20) NOT NULL,
    fecha_aprendizaje DATE,
    CONSTRAINT pk_estudiante_habilidad PRIMARY KEY (id_estudiante, id_habilidad),
    CONSTRAINT ck_est_hab_nivel CHECK (nivel IN ('basico','intermedio','avanzado')),
    CONSTRAINT fk_esthab_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_esthab_habilidad FOREIGN KEY (id_habilidad)
        REFERENCES habilidad (id_habilidad) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. INTERES
CREATE TABLE interes (
    id_interes  INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre      VARCHAR(80) NOT NULL,
    descripcion TEXT,
    CONSTRAINT pk_interes PRIMARY KEY (id_interes),
    CONSTRAINT uq_interes_nombre UNIQUE (nombre)
);

-- 6. ESTUDIANTE_INTERES (N:M)
CREATE TABLE estudiante_interes (
    id_estudiante  INTEGER   NOT NULL,
    id_interes     INTEGER   NOT NULL,
    fecha_agregado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_estudiante_interes PRIMARY KEY (id_estudiante, id_interes),
    CONSTRAINT fk_estint_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estint_interes FOREIGN KEY (id_interes)
        REFERENCES interes (id_interes) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. SEGUIR (relación reflexiva N:M)
CREATE TABLE seguir (
    id_seguidor       INTEGER   NOT NULL,
    id_seguido        INTEGER   NOT NULL,
    fecha_seguimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_seguir PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT ck_seguir_no_autoseguir CHECK (id_seguidor <> id_seguido),  -- nadie se sigue a sí mismo
    CONSTRAINT fk_seguir_seguidor FOREIGN KEY (id_seguidor)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_seguir_seguido FOREIGN KEY (id_seguido)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. MENSAJE
CREATE TABLE mensaje (
    id_mensaje  INTEGER GENERATED ALWAYS AS IDENTITY,
    id_emisor   INTEGER     NOT NULL,
    id_receptor INTEGER     NOT NULL,
    texto       TEXT        NOT NULL,
    estado      VARCHAR(15) NOT NULL DEFAULT 'enviado',
    fecha_envio TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_mensaje PRIMARY KEY (id_mensaje),
    CONSTRAINT ck_mensaje_estado CHECK (estado IN ('enviado','entregado','leido')),
    CONSTRAINT ck_mensaje_distintos CHECK (id_emisor <> id_receptor),
    CONSTRAINT fk_mensaje_emisor FOREIGN KEY (id_emisor)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mensaje_receptor FOREIGN KEY (id_receptor)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. GRUPO
CREATE TABLE grupo (
    id_grupo    INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre      VARCHAR(100) NOT NULL,
    tema        VARCHAR(100) NOT NULL,
    descripcion TEXT,
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo)
);

-- 10. MIEMBRO_GRUPO (N:M)
CREATE TABLE miembro_grupo (
    id_estudiante  INTEGER     NOT NULL,
    id_grupo       INTEGER     NOT NULL,
    rol            VARCHAR(20) NOT NULL DEFAULT 'miembro',
    fecha_registro TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_miembro_grupo PRIMARY KEY (id_estudiante, id_grupo),
    CONSTRAINT ck_miembro_rol CHECK (rol IN ('administrador','moderador','miembro')),
    CONSTRAINT fk_miembro_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_miembro_grupo FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 11. EVENTO  (incluye columna JSONB para datos IoT)
CREATE TABLE evento (
    id_evento      INTEGER GENERATED ALWAYS AS IDENTITY,
    id_grupo       INTEGER      NOT NULL,
    nombre         VARCHAR(120) NOT NULL,
    fecha          TIMESTAMP    NOT NULL,
    lugar          VARCHAR(120) NOT NULL,
    descripcion    TEXT,
    datos_sensores JSONB,                                            -- lecturas IoT del espacio (semiestructurado)
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT ck_evento_sensores CHECK (datos_sensores IS NULL OR jsonb_typeof(datos_sensores) = 'object'),
    CONSTRAINT fk_evento_grupo FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo) ON DELETE CASCADE ON UPDATE CASCADE  -- si se elimina el grupo, se eliminan sus eventos
);

-- 12. ASISTENTE_EVENTO (N:M)
CREATE TABLE asistente_evento (
    id_estudiante  INTEGER     NOT NULL,
    id_evento      INTEGER     NOT NULL,
    estado         VARCHAR(15) NOT NULL DEFAULT 'inscrito',
    fecha_registro TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_asistente_evento PRIMARY KEY (id_estudiante, id_evento),
    CONSTRAINT ck_asistente_estado CHECK (estado IN ('inscrito','asistio','cancelado')),
    CONSTRAINT fk_asistente_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_asistente_evento FOREIGN KEY (id_evento)
        REFERENCES evento (id_evento) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 13. PUBLICACION (incluye columna JSONB para metadatos / big data)
CREATE TABLE publicacion (
    id_publicacion INTEGER GENERATED ALWAYS AS IDENTITY,
    id_estudiante  INTEGER     NOT NULL,
    contenido      TEXT        NOT NULL,
    fecha          TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo           VARCHAR(15) NOT NULL,
    metadatos      JSONB,                                            -- etiquetas, adjuntos, dispositivo (semiestructurado)
    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
    CONSTRAINT ck_publicacion_tipo CHECK (tipo IN ('texto','imagen','enlace','archivo')),
    CONSTRAINT ck_publicacion_metadatos CHECK (metadatos IS NULL OR jsonb_typeof(metadatos) = 'object'),
    CONSTRAINT fk_publicacion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 14. COMENTARIO
CREATE TABLE comentario (
    id_comentario  INTEGER GENERATED ALWAYS AS IDENTITY,
    id_publicacion INTEGER   NOT NULL,
    id_estudiante  INTEGER   NOT NULL,
    contenido      TEXT      NOT NULL,
    fecha          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
    CONSTRAINT fk_comentario_publicacion FOREIGN KEY (id_publicacion)
        REFERENCES publicacion (id_publicacion) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comentario_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 15. REACCION
CREATE TABLE reaccion (
    id_reaccion    INTEGER GENERATED ALWAYS AS IDENTITY,
    id_publicacion INTEGER     NOT NULL,
    id_estudiante  INTEGER     NOT NULL,
    tipo_reaccion  VARCHAR(20) NOT NULL,
    fecha          TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_reaccion PRIMARY KEY (id_reaccion),
    CONSTRAINT uq_reaccion_pub_est UNIQUE (id_publicacion, id_estudiante),  -- una reacción por estudiante y publicación
    CONSTRAINT ck_reaccion_tipo CHECK (tipo_reaccion IN ('me_gusta','me_encanta','me_divierte','util')),
    CONSTRAINT fk_reaccion_publicacion FOREIGN KEY (id_publicacion)
        REFERENCES publicacion (id_publicacion) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reaccion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- Índices (FK de mayor consulta y búsqueda dentro de JSONB)
-- ---------------------------------------------------------------------
CREATE INDEX idx_publicacion_estudiante ON publicacion (id_estudiante);
CREATE INDEX idx_comentario_publicacion ON comentario (id_publicacion);
CREATE INDEX idx_evento_grupo           ON evento (id_grupo);
CREATE INDEX idx_mensaje_receptor       ON mensaje (id_receptor);
CREATE INDEX idx_publicacion_metadatos  ON publicacion USING GIN (metadatos);
CREATE INDEX idx_evento_sensores        ON evento      USING GIN (datos_sensores);

-- ---------------------------------------------------------------------
-- Ejemplo de datos semiestructurados y consultas JSONB
-- ---------------------------------------------------------------------
INSERT INTO estudiante (nombre, apellido, correo_institucional, programa_academico, semestre)
VALUES ('Angie', 'Rincón', 'angie.rincon@usta.edu.co', 'Ingeniería de Sistemas', 4);

INSERT INTO grupo (nombre, tema) VALUES ('Estudio Bases de Datos', 'Bases de datos');

INSERT INTO evento (id_grupo, nombre, fecha, lugar, datos_sensores)
VALUES (1, 'Taller de SQL', '2026-11-05 14:00', 'Sala de sistemas 2',
 '{"sensor_id":"SNS-021","temperatura_c":23.5,"co2_ppm":610,"aforo_detectado":28,"lecturas":[{"hora":"14:05","aforo":25},{"hora":"14:20","aforo":28}]}');

INSERT INTO publicacion (id_estudiante, contenido, tipo, metadatos)
VALUES (1, '¿Alguien tiene apuntes de normalización?', 'texto',
 '{"etiquetas":["bd","normalizacion"],"dispositivo":"android","adjuntos":[],"idioma":"es"}');

-- Eventos con CO2 alto
SELECT nombre, datos_sensores->>'co2_ppm' AS co2
FROM evento WHERE (datos_sensores->>'co2_ppm')::int > 600;

-- Publicaciones con la etiqueta 'bd'
SELECT id_publicacion, contenido
FROM publicacion
WHERE metadatos->'etiquetas' @> '["bd"]';
