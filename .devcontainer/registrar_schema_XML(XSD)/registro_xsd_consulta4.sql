-- Asegúrate de tener SERVEROUTPUT ON
DECLARE
  v_xsd_consulta4 CLOB;
  v_schema_url_consulta4 VARCHAR2(250); 
BEGIN
  -- Generar una URL única para el esquema de la Consulta 4
  v_schema_url_consulta4 := 'http://miuniversidad.com/schemas/hr/consulta4_analisissalarial_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFFSSSSS');

  -- Contenido de tu XSD para la Consulta 4
  v_xsd_consulta4 := '<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="AnalisisSalarialGerentesNoGerentes">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="DepartamentoAnalisis" minOccurs="0" maxOccurs="unbounded">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="NombreDepartamento" type="xs:string"/>
              <xs:element name="SalarioPromedioGerentes" type="xs:decimal" minOccurs="0"/>
              <xs:element name="SalarioPromedioNoGerentes" type="xs:decimal" minOccurs="0"/>
              <xs:element name="DiferenciaSalarialPromedio" type="xs:decimal"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>';

  DBMS_OUTPUT.put_line('Intentando registrar XSD para Consulta 4 en: ' || v_schema_url_consulta4);

  -- Intentar borrar el esquema si ya existe con esta URL
  BEGIN
    DBMS_XMLSCHEMA.deleteSchema(v_schema_url_consulta4, DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
    DBMS_OUTPUT.put_line('Esquema previo (Consulta 4) con URL ' || v_schema_url_consulta4 || ' borrado (si existía).');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -31001 THEN 
        DBMS_OUTPUT.put_line('Esquema (Consulta 4) con URL ' || v_schema_url_consulta4 || ' no estaba registrado previamente.');
      ELSE
        DBMS_OUTPUT.put_line('Advertencia al intentar borrar esquema (Consulta 4) previo: ' || SQLERRM);
      END IF;
  END;

  -- Registrar el nuevo esquema
  IF DBMS_LOB.getlength(v_xsd_consulta4) > 0 THEN
    DBMS_XMLSCHEMA.registerSchema(
      SCHEMAURL => v_schema_url_consulta4,
      SCHEMADOC => v_xsd_consulta4,
      LOCAL     => TRUE,
      GENTYPES  => FALSE,
      GENBEAN   => FALSE,
      GENTABLES => FALSE,
      OWNER     => USER 
    );
    DBMS_OUTPUT.put_line('XSD para Consulta 4 registrado exitosamente en: ' || v_schema_url_consulta4);
  ELSE
    DBMS_OUTPUT.put_line('Error: El contenido del XSD para Consulta 4 está vacío.');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('ERROR general registrando XSD para Consulta 4: ' || SQLERRM);
    RAISE;
END;
/