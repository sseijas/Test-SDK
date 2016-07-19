ECHO OFF
DEL ..\..\..\Results\SDK-Java\v1.8\Sample\*.out

java -jar Adapter.jar /c:PaymentFlow /i:..\..\..\Scenarios\Sample\Sample_01_PaymentFlow.ini /o:..\..\..\Results\SDK-Java\v1.8\Sample\1_PaymentFlow.out /x:..\..\..\Scenarios\Sample\WS_Execute_Request.xml
PAUSE