-- Asegúrate de tener SERVEROUTPUT ON
DECLARE
  v_xsd_consulta3 CLOB;
  v_schema_url_consulta3 VARCHAR2(250); 
BEGIN
  -- Generar una URL única para el esquema de la Consulta 3
  v_schema_url_consulta3 := 'http://miuniversidad.com/schemas/hr/consulta3_salariofuerarango_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFFSSSSS');

  -- Contenido de tu XSD para la Consulta 3
  v_xsd_consulta3 := '<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="EmpleadosConSalarioFueraDeRango">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="Empleado" minOccurs="0" maxOccurs="unbounded">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="Nombre" type="xs:string"/>
              <xs:element name="Apellido" type="xs:string"/>
              <xs:element name="SalarioActual" type="xs:decimal"/>
              <xs:element name="Puesto" type="xs:string"/>
              <xs:element name="SalarioMinimoPuesto" type="xs:decimal"/>
              <xs:element name="SalarioMaximoPuesto" type="xs:decimal"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>';

  DBMS_OUTPUT.put_line('Intentando registrar XSD para Consulta 3 en: ' || v_schema_url_consulta3);

  -- Intentar borrar el esquema si ya existe con esta URL
  BEGIN
    DBMS_XMLSCHEMA.deleteSchema(v_schema_url_consulta3, DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
    DBMS_OUTPUT.put_line('Esquema previo (Consulta 3) con URL ' || v_schema_url_consulta3 || ' borrado (si existía).');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -31001 THEN 
        DBMS_OUTPUT.put_line('Esquema (Consulta 3) con URL ' || v_schema_url_consulta3 || ' no estaba registrado previamente.');
      ELSE
        DBMS_OUTPUT.put_line('Advertencia al intentar borrar esquema (Consulta 3) previo: ' || SQLERRM);
      END IF;
  END;

  -- Registrar el nuevo esquema
  IF DBMS_LOB.getlength(v_xsd_consulta3) > 0 THEN
    DBMS_XMLSCHEMA.registerSchema(
      SCHEMAURL => v_schema_url_consulta3,
      SCHEMADOC => v_xsd_consulta3,
      LOCAL     => TRUE,
      GENTYPES  => FALSE,
      GENBEAN   => FALSE,
      GENTABLES => FALSE,
      OWNER     => USER 
    );
    DBMS_OUTPUT.put_line('XSD para Consulta 3 registrado exitosamente en: ' || v_schema_url_consulta3);
  ELSE
    DBMS_OUTPUT.put_line('Error: El contenido del XSD para Consulta 3 está vacío.');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('ERROR general registrando XSD para Consulta 3: ' || SQLERRM);
    RAISE;
END;
/