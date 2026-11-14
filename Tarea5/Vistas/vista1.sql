
-- VISTA 1: Perfiles completos de estudiantes

CREATE OR REPLACE VIEW vista_perfiles_estudiantes AS
SELECT
    e.id_estudiante,
    e.nombre,
    e.apellido,
    e.correo_institucional,
    e.programa_academico,
    e.semestre,
    p.biografia,
    p.ciudad,

    (
        SELECT STRING_AGG(h.nombre, ', ' ORDER BY h.nombre)
        FROM estudiante_habilidad eh
        INNER JOIN habilidad h
            ON eh.id_habilidad = h.id_habilidad
        WHERE eh.id_estudiante = e.id_estudiante
    ) AS habilidades,

    (
        SELECT STRING_AGG(i.nombre, ', ' ORDER BY i.nombre)
        FROM estudiante_interes ei
        INNER JOIN interes i
            ON ei.id_interes = i.id_interes
        WHERE ei.id_estudiante = e.id_estudiante
    ) AS intereses

FROM estudiante e
LEFT JOIN perfil p
    ON e.id_estudiante = p.id_estudiante;

-- Consultar los perfiles de los estudiantes

SELECT *
FROM vista_perfiles_estudiantes
ORDER BY nombre ASC;
