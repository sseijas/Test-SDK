ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\bin"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\lib"

copy .\src\Adapter.js "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\bin"
copy .\src\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\bin"
xcopy .\lib "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\lib"

PAUSE
