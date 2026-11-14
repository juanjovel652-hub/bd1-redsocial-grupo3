
-- CONSULTA 2: Habilidades más populares

SELECT
    h.nombre AS habilidad,
    COUNT(eh.id_estudiante) AS cantidad_estudiantes
FROM habilidad h
LEFT JOIN estudiante_habilidad eh
    ON h.id_habilidad = eh.id_habilidad
GROUP BY h.id_habilidad, h.nombre
ORDER BY cantidad_estudiantes DESC, h.nombre ASC;
