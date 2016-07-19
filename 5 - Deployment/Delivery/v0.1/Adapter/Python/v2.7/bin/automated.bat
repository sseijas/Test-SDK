ECHO OFF
DEL ..\..\..\..\Results\SDK-Python\v2.7\Sample\*.out

python Adapter.py /c:PaymentFlow /i:..\..\..\..\Scenarios\Sample\Sample_01_PaymentFlow.ini /o:..\..\..\..\Results\SDK-Python\v2.7\Sample\1_PaymentFlow.out /x:..\..\..\..\Scenarios\Sample\WS_Execute_Request.xml
PAUSE