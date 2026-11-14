
-- CONSULTA 3: Cantidad de integrantes por grupo

SELECT
    g.nombre AS nombre_grupo,
    g.tema AS tema_grupo,
    COUNT(mg.id_estudiante) AS total_integrantes
FROM grupo g
LEFT JOIN miembro_grupo mg
    ON g.id_grupo = mg.id_grupo
GROUP BY g.id_grupo, g.nombre, g.tema
ORDER BY total_integrantes DESC, nombre_grupo ASC;
