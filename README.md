# Morpheus

Morpheus provides a location aware menu to iPhone users. The menu's are user specific
and can be customized using a web application. 

# Installation
Morpheus consists of a server side application and a client side app. For the server side
an Oracle runtime environment must be available. 

- download and install app from here
- create an Oracle schema with privileges to create session, table, sequence and procedure
  and with quota on the default tablespace
- install de database objects by running install_db.sql in this schema
- in Oracle Apex create an new workspace or chose an existing one
- create a workspace schema assignment for the workspace and the schema
- import the application morpheus_apex_app_export.sql
- during import use the created schema
You are ready to run!

