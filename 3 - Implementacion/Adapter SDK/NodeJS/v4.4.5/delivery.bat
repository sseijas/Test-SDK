ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\bin"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\lib"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\node_modules"

copy .\src\Adapter.js "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\bin"
copy .\src\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\bin"
xcopy .\lib "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\lib"

robocopy /NJS /NFL /NDL /NJS /S .\node_modules "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\NodeJs\v4.4.5\node_modules"
PAUSE