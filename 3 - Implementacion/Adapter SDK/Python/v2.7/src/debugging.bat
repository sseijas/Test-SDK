ECHO OFF

python .\bin\Adapter.py /c:PaymentFlow /i:..\..\..\_Common\Samples\Sample_01_PaymentFlow.ini /o:..\out\1_PaymentFlow.out /x:..\..\..\_Common\Samples\WS_Execute_Request.xml
PAUSE