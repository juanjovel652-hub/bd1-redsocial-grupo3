
-- CONSULTA 4: Publicaciones con mayor interacción

SELECT
    p.id_publicacion,
    p.contenido AS publicacion,
    e.nombre || ' ' || e.apellido AS autor,
    COUNT(DISTINCT c.id_comentario) AS total_comentarios,
    COUNT(DISTINCT r.id_reaccion) AS total_reacciones,
    COUNT(DISTINCT c.id_comentario)
        + COUNT(DISTINCT r.id_reaccion) AS total_interacciones
FROM publicacion p
INNER JOIN estudiante e
    ON p.id_estudiante = e.id_estudiante
LEFT JOIN comentario c
    ON p.id_publicacion = c.id_publicacion
LEFT JOIN reaccion r
    ON p.id_publicacion = r.id_publicacion
GROUP BY
    p.id_publicacion,
    p.contenido,
    e.nombre,
    e.apellido
ORDER BY total_interacciones DESC;
