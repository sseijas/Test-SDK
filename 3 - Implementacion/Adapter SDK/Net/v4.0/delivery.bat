ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Net\v4.0"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Net\v4.0"

copy .\bin\Debug\Adapter.exe "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Net\v4.0"
copy .\bin\Debug\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Net\v4.0"
copy .\bin\Debug\Newtonsoft.Json.dll "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Net\v4.0"
copy .\bin\Debug\TodoPagoConnector.dll "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Net\v4.0"

PAUSE
