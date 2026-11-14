
-- CONSULTA 6: Estudiantes con mayor cantidad de seguidores

SELECT
    e.id_estudiante,
    e.nombre || ' ' || e.apellido AS nombre_estudiante,
    e.programa_academico,
    COUNT(s.id_seguidor) AS total_seguidores
FROM estudiante e
LEFT JOIN seguir s
    ON e.id_estudiante = s.id_seguido
GROUP BY
    e.id_estudiante,
    e.nombre,
    e.apellido,
    e.programa_academico
ORDER BY total_seguidores DESC, nombre_estudiante ASC;
