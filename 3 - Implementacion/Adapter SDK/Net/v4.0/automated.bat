ECHO OFF

DEL ..\..\..\Results\SDK-NET\v4.0\Sample\*.out

Adapter.exe /c:PaymentFlow /i:..\..\..\Scenarios\Sample\Sample_01_PaymentFlow.ini /o:..\..\..\Results\SDK-Net\v4.0\Sample\1_PaymentFlow.out /x:..\..\..\Scenarios\Sample\WS_Execute_Request.xml
PAUSE