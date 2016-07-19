ECHO OFF
DEL .\Samples\*.out


Adapter.exe /c:PaymentFlow /i:.\Samples\Sample_01_PaymentFlow.ini /o:.\Samples\Sample_01_PaymentFlow.out /x:.\Samples\WS_Execute_Request.xml

PAUSE