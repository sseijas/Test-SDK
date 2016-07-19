ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Java\v1.8"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Java\v1.8"

copy .\bin\Adapter.jar "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Java\v1.8"
copy .\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Java\v1.8"
copy .\lib\json-20090211.jar "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Java\v1.8"
copy .\lib\TodoPago.jar "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Java\v1.8"

PAUSE
