
-- VISTA 3: Actividad e interacción de publicaciones

CREATE OR REPLACE VIEW vista_actividad_publicaciones AS
SELECT
    p.id_publicacion,
    p.contenido,
    p.tipo,
    p.fecha,
    e.nombre || ' ' || e.apellido AS autor,

    (
        SELECT COUNT(*)
        FROM comentario c
        WHERE c.id_publicacion = p.id_publicacion
    ) AS total_comentarios,

    (
        SELECT COUNT(*)
        FROM reaccion r
        WHERE r.id_publicacion = p.id_publicacion
    ) AS total_reacciones,

    (
        SELECT COUNT(*)
        FROM comentario c
        WHERE c.id_publicacion = p.id_publicacion
    )
    +
    (
        SELECT COUNT(*)
        FROM reaccion r
        WHERE r.id_publicacion = p.id_publicacion
    ) AS total_interacciones

FROM publicacion p
INNER JOIN estudiante e
    ON p.id_estudiante = e.id_estudiante;

-- Consultar las publicaciones con mayor interacción

SELECT *
FROM vista_actividad_publicaciones
ORDER BY total_interacciones DESC;
