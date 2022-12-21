# sysadmin-pablo


## Práctica SysAdmin Pablo Cazallas González
### Despliegue de stack ELK en entorno virtualizado


- Desplegar la infraestructura:
    1. Clonar el repositorio git.
    2. Modificar el fichero *.kibana*, en el que se debe indicar la nueva contraseña para Kibana.
    3. Ejecutar el comando <code>vagrant up</code>.


- Configurar Wordpress:
    1. Abrir la url <code>http://localhost:8081</code> en el navegador.
    2. Seguir los pasos indicados en el asistente de configuración mostrado.


- Configurar monitorización con Kibana:
    1. Abrir la url <code>http://localhost:8080</code> en el navegador.
    2. Identificarse con el usuario <code>kibanaadmin</code> y la contraseña indicada previamente en el fichero *.kibana*.
    3. Crear un *index-pattern* de nombre <code>filebeat-*</code> y seleccionando timestamp como campo de referencia de tiempo.
    4. En el menú desplegable, pinchar en <code>Discover</code> para visualizar los registros.

