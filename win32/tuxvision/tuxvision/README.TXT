-------------------------------------------------------------------------------------------------

This is version 0.0 of TuxVision 
Date: 28.05 2002

-------------------------------------------------------------------------------------------------

Important notice:
Before you start recompiling the filter
make shure you have the latest DirectX SDK installed.
Please ensure you recompiled strmbase.lib and strmbasd.lib from the SDK.
Don´t forget to setup correct path to the include and lib directory of the SDK.
You may ignore this step if you simply want to use the filter binary as it is !


Have fun,
Bernd.

-------------------------------------------------------------------------------------------------
Rev.0.0
- initial revision
- Before giving this App a try make shure you successfully installed TRex !
- Also use regsvr32.exe (can be found in your system or system32 directory) to register
additional filter from the bin directory (same location where the sources are placed)
From the commandline type regsvr32 xxxFilterxxx.ax for ALL the components you wish to register,
or simply make a link to regsvr32.exe on your desktop and drag the binaries on that link.
(You need at least the DBOXIISource.ax and the DBOXIIRender.ax filters) I would also
strongly suggest to register the PCLEDEMUX2_W_48K_SWITCH.AX (interims version :-) ).
- Start the app, go to the options page, fill in your parameters of your box, select and channel
(I would suggest to try some free to air first) and hit the preview button. 
(Hint: You can go to fullscreen mode by maximizing the window or by double clicking the video ...)
Good luck
Bernd.

-------------------------------------------------------------------------------------------------

Bernd Scharping, Apr. 2002
bernd@transputer.escape.de

-------------------------------------------------------------------------------------------------
