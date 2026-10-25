
/*
  Proyecto: Red Social Estudiantil Pascualina
  SGBD: MongoDB
  Archivo: Script_MongoDB.js

  Objetivo:
  Crear las colecciones, validar los tipos de datos,
  definir índices y representar las relaciones del modelo lógico.

  Nota:
  Las referencias entre colecciones se validan desde la aplicación
  o mediante lógica adicional; no funcionan como FK relacionales.
*/

// =====================================================
// 1. SELECCIONAR LA BASE DE DATOS
// =====================================================

const dbPascualina = db.getSiblingDB("red_social_pascualina");

// Crea una colección con validación, si todavía no existe.
function crearColeccion(nombre, propiedades, requeridos = []) {
    const existentes = dbPascualina
        .getCollectionNames();

    if (!existentes.includes(nombre)) {
        dbPascualina.createCollection(nombre, {
            validator: {
                $jsonSchema: {
                    bsonType: "object",
                    required: requeridos,
                    properties: propiedades
                }
            },
            validationLevel: "strict",
            validationAction: "error"
        });

        print("Colección creada: " + nombre);
    } else {
        print("La colección ya existe: " + nombre);
    }
}

// =====================================================
// 2. ESTUDIANTE
// =====================================================

crearColeccion("estudiantes", {
    nombre: { bsonType: "string" },
    apellido: { bsonType: "string" },
    correo_institucional: { bsonType: "string" },
    programa_academico: { bsonType: "string" },
    semestre: { bsonType: "int", minimum: 1 },
    fecha_registro: { bsonType: "date" }
}, [
    "nombre",
    "apellido",
    "correo_institucional",
    "programa_academico",
    "semestre",
    "fecha_registro"
]);

// =====================================================
// 3. PERFIL
// =====================================================

crearColeccion("perfiles", {
    id_estudiante: { bsonType: "objectId" },
    biografia: { bsonType: ["string", "null"] },
    ciudad: { bsonType: ["string", "null"] },
    foto_perfil: { bsonType: ["string", "null"] },
    fecha_actualizacion: { bsonType: ["date", "null"] }
}, [
    "id_estudiante"
]);

// =====================================================
// 4. HABILIDAD
// =====================================================

crearColeccion("habilidades", {
    nombre: { bsonType: "string" },
    descripcion: { bsonType: ["string", "null"] }
}, [
    "nombre"
]);

// =====================================================
// 5. ESTUDIANTE_HABILIDAD
// =====================================================

crearColeccion("estudiante_habilidad", {
    id_estudiante: { bsonType: "objectId" },
    id_habilidad: { bsonType: "objectId" },
    nivel: { bsonType: "string" },
    fecha_aprendizaje: { bsonType: ["date", "null"] }
}, [
    "id_estudiante",
    "id_habilidad",
    "nivel"
]);

// =====================================================
// 6. INTERES
// =====================================================

crearColeccion("intereses", {
    nombre: { bsonType: "string" },
    descripcion: { bsonType: ["string", "null"] }
}, [
    "nombre"
]);

// =====================================================
// 7. ESTUDIANTE_INTERESES
// =====================================================

crearColeccion("estudiante_intereses", {
    id_estudiante: { bsonType: "objectId" },
    id_interes: { bsonType: "objectId" },
    fecha_agregado: { bsonType: "date" }
}, [
    "id_estudiante",
    "id_interes",
    "fecha_agregado"
]);

// =====================================================
// 8. SEGUIR
// =====================================================

crearColeccion("seguir", {
    id_seguidor: { bsonType: "objectId" },
    id_seguido: { bsonType: "objectId" },
    fecha_seguimiento: { bsonType: "date" }
}, [
    "id_seguidor",
    "id_seguido",
    "fecha_seguimiento"
]);

// =====================================================
// 9. MENSAJE
// =====================================================

crearColeccion("mensajes", {
    id_emisor: { bsonType: "objectId" },
    id_receptor: { bsonType: "objectId" },
    texto: { bsonType: "string" },
    estado: {
        bsonType: "string",
        enum: ["enviado", "entregado", "leido"]
    },
    fecha_envio: { bsonType: "date" }
}, [
    "id_emisor",
    "id_receptor",
    "texto",
    "estado",
    "fecha_envio"
]);

// =====================================================
// 10. GRUPO
// =====================================================

crearColeccion("grupos", {
    nombre: { bsonType: "string" },
    tema: { bsonType: "string" },
    descripcion: { bsonType: ["string", "null"] }
}, [
    "nombre",
    "tema"
]);

// =====================================================
// 11. MIEMBRO_GRUPO
// =====================================================

crearColeccion("miembro_grupo", {
    id_estudiante: { bsonType: "objectId" },
    id_grupo: { bsonType: "objectId" },
    rol: { bsonType: "string" },
    fecha_registro: { bsonType: "date" }
}, [
    "id_estudiante",
    "id_grupo",
    "rol",
    "fecha_registro"
]);

// =====================================================
// 12. EVENTO
// Incluye datos_adicionales para información semiestructurada.
// =====================================================

crearColeccion("eventos", {
    id_grupo: { bsonType: "objectId" },
    nombre: { bsonType: "string" },
    fecha: { bsonType: "date" },
    lugar: { bsonType: "string" },
    descripcion: { bsonType: ["string", "null"] },
    datos_adicionales: { bsonType: ["object", "null"] }
}, [
    "id_grupo",
    "nombre",
    "fecha",
    "lugar"
]);

// =====================================================
// 13. ASISTENTE_EVENTO
// =====================================================

crearColeccion("asistente_evento", {
    id_estudiante: { bsonType: "objectId" },
    id_evento: { bsonType: "objectId" },
    estado: { bsonType: "string" },
    fecha_registro: { bsonType: "date" }
}, [
    "id_estudiante",
    "id_evento",
    "estado",
    "fecha_registro"
]);

// =====================================================
// 14. PUBLICACION
// =====================================================

crearColeccion("publicaciones", {
    id_estudiante: { bsonType: "objectId" },
    contenido: { bsonType: "string" },
    fecha: { bsonType: "date" },
    tipo: { bsonType: "string" }
}, [
    "id_estudiante",
    "contenido",
    "fecha",
    "tipo"
]);

// =====================================================
// 15. COMENTARIO
// =====================================================

crearColeccion("comentarios", {
    id_publicacion: { bsonType: "objectId" },
    id_estudiante: { bsonType: "objectId" },
    contenido: { bsonType: "string" },
    fecha: { bsonType: "date" }
}, [
    "id_publicacion",
    "id_estudiante",
    "contenido",
    "fecha"
]);

// =====================================================
// 16. REACCION
// =====================================================

crearColeccion("reacciones", {
    id_publicacion: { bsonType: "objectId" },
    id_estudiante: { bsonType: "objectId" },
    tipo_reaccion: { bsonType: "string" },
    fecha: { bsonType: "date" }
}, [
    "id_publicacion",
    "id_estudiante",
    "tipo_reaccion",
    "fecha"
]);

// =====================================================
// 17. ÍNDICES Y RESTRICCIONES DE UNICIDAD
// =====================================================

// El correo institucional no se puede repetir.
dbPascualina.estudiantes.createIndex(
    { correo_institucional: 1 },
    { unique: true }
);

// Un estudiante puede tener como máximo un perfil.
dbPascualina.perfiles.createIndex(
    { id_estudiante: 1 },
    { unique: true }
);

// Evitar asociaciones duplicadas.
dbPascualina.estudiante_habilidad.createIndex(
    { id_estudiante: 1, id_habilidad: 1 },
    { unique: true }
);

dbPascualina.estudiante_intereses.createIndex(
    { id_estudiante: 1, id_interes: 1 },
    { unique: true }
);

dbPascualina.seguir.createIndex(
    { id_seguidor: 1, id_seguido: 1 },
    { unique: true }
);

dbPascualina.miembro_grupo.createIndex(
    { id_estudiante: 1, id_grupo: 1 },
    { unique: true }
);

dbPascualina.asistente_evento.createIndex(
    { id_estudiante: 1, id_evento: 1 },
    { unique: true }
);

// Índices para consultar mensajes, publicaciones y comentarios.
dbPascualina.mensajes.createIndex(
    { id_emisor: 1, fecha_envio: -1 }
);

dbPascualina.mensajes.createIndex(
    { id_receptor: 1, fecha_envio: -1 }
);

dbPascualina.publicaciones.createIndex(
    { id_estudiante: 1, fecha: -1 }
);

dbPascualina.comentarios.createIndex(
    { id_publicacion: 1, fecha: 1 }
);

dbPascualina.reacciones.createIndex(
    { id_publicacion: 1, id_estudiante: 1 }
);

dbPascualina.eventos.createIndex(
    { id_grupo: 1, fecha: 1 }
);

print("Configuración de Red Social Estudiantil Pascualina finalizada.");
