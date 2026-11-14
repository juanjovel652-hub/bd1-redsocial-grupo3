
-- VISTA 2: Popularidad de los estudiantes

CREATE OR REPLACE VIEW vista_popularidad_estudiantes AS
SELECT
    e.id_estudiante,
    e.nombre || ' ' || e.apellido AS nombre_estudiante,
    e.programa_academico,
    e.semestre,
    COUNT(s.id_seguidor) AS total_seguidores
FROM estudiante e
LEFT JOIN seguir s
    ON e.id_estudiante = s.id_seguido
GROUP BY
    e.id_estudiante,
    e.nombre,
    e.apellido,
    e.programa_academico,
    e.semestre;

-- Consultar los estudiantes más populares

SELECT *
FROM vista_popularidad_estudiantes
ORDER BY total_seguidores DESC;
