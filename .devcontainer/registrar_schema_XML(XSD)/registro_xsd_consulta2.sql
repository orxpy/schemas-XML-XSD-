-- Asegúrate de tener SERVEROUTPUT ON en tu herramienta para ver los mensajes
-- En SQL Developer: Herramientas > Preferencias > Base de datos > Hoja de trabajo > "Abrir una nueva hoja de trabajo con la salida DBMS activada"
-- O ejecutar: SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_xsd_consulta2 CLOB;
  v_schema_url_consulta2 VARCHAR2(250); -- URL ÚNICA para este nuevo esquema
BEGIN
  -- Generar una URL única para el esquema de la Consulta 2
  -- Esto ayuda a evitar conflictos si ejecutas el script varias veces o tienes otros esquemas.
  v_schema_url_consulta2 := 'http://miuniversidad.com/schemas/hr/consulta2_presupuesto_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFFSSSSS');

  -- Contenido de tu XSD para la Consulta 2
  v_xsd_consulta2 := '<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="PresupuestoSalarialPorDepartamento">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="DepartamentoInfo" minOccurs="0" maxOccurs="unbounded">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="NombreDepartamento" type="xs:string"/>
              <xs:element name="SalarioTotalDepartamento" type="xs:decimal"/>
              <xs:element name="PorcentajeDelTotalCompania" type="xs:decimal"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>';

  DBMS_OUTPUT.put_line('Intentando registrar XSD para Consulta 2 en: ' || v_schema_url_consulta2);

  -- Intentar borrar el esquema si ya existe con esta URL (útil para re-ejecuciones)
  BEGIN
    DBMS_XMLSCHEMA.deleteSchema(v_schema_url_consulta2, DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
    DBMS_OUTPUT.put_line('Esquema previo (Consulta 2) con URL ' || v_schema_url_consulta2 || ' borrado (si existía).');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -31001 THEN -- ORA-31001: Schema "..." is not registered
        DBMS_OUTPUT.put_line('Esquema (Consulta 2) con URL ' || v_schema_url_consulta2 || ' no estaba registrado previamente.');
      ELSE
        DBMS_OUTPUT.put_line('Advertencia al intentar borrar esquema (Consulta 2) previo: ' || SQLERRM);
        -- No relanzar, intentar registrar de todas formas, podría ser un error diferente.
      END IF;
  END;

  -- Registrar el nuevo esquema
  IF DBMS_LOB.getlength(v_xsd_consulta2) > 0 THEN
    DBMS_XMLSCHEMA.registerSchema(
      SCHEMAURL => v_schema_url_consulta2,
      SCHEMADOC => v_xsd_consulta2,
      LOCAL     => TRUE,
      GENTYPES  => FALSE,
      GENBEAN   => FALSE,
      GENTABLES => FALSE,
      OWNER     => USER -- O 'HR' si estás conectado como SYS u otro usuario con permisos para registrar en nombre de HR
    );
    DBMS_OUTPUT.put_line('XSD para Consulta 2 registrado exitosamente en: ' || v_schema_url_consulta2);
  ELSE
    DBMS_OUTPUT.put_line('Error: El contenido del XSD para Consulta 2 está vacío.');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('ERROR general registrando XSD para Consulta 2: ' || SQLERRM);
    RAISE;
END;
/