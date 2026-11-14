
-- CONSULTA 5: Eventos con mayor cantidad de asistentes

SELECT
    ev.nombre AS nombre_evento,
    g.nombre AS grupo_organizador,
    ev.fecha AS fecha_evento,
    ev.lugar AS lugar_evento,
    COUNT(ae.id_estudiante) AS total_asistentes
FROM evento ev
INNER JOIN grupo g
    ON ev.id_grupo = g.id_grupo
LEFT JOIN asistente_evento ae
    ON ev.id_evento = ae.id_evento
GROUP BY
    ev.id_evento,
    ev.nombre,
    g.nombre,
    ev.fecha,
    ev.lugar
ORDER BY total_asistentes DESC, fecha_evento ASC;
