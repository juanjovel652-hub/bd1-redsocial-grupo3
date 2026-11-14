
-- CONSULTA 1: Estudiantes por programa académico y semestre

SELECT
    programa_academico AS programa,
    semestre,
    COUNT(id_estudiante) AS cantidad_estudiantes
FROM estudiante
GROUP BY programa_academico, semestre
ORDER BY programa_academico, semestre;
