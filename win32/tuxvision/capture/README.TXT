-------------------------------------------------------------------------------------------------

This is version 0.2 of the DBOXII capture Filter
Date: 20.05 2002
-------------------------------------------------------------------------------------------------

Important notice:
Before you start recompiling the filter
make shure you have the latest DirectX SDK installed.
Please ensure you recompiled strmbase.lib and strmbasd.lib from the SDK.
Don´t forget to setup correct path to the include and lib directory of the SDK.
You may ignore this step if you simply want to use the filter binary as it is !

All tests were performed with this (my one and only) hardware configuration

DBOXII, Nokia, Cable, 2xIntel, AVIA500, GTX running
Neutrino from 07.04.2002 with the actual versions of GTX_DVR.O and ENX_DVR.O
(grabbed from http://www.elitedvb.de/files/enx_dvr.o and http://www.elitedvb.de/files/gtx_dvr.o)
For your conveniance I placed a copy on my server http://transputer.dyn.escape.de/src/dboxII/
Also the fbclear utility can be found there. 
You should update your box only if you plan to use the render (clip) mode. These files are NOT
necessary for the capture mode.
To work with the (render)filters you should place these 3 files in your /var/tuxbux directory on
your dbox. (Please use THIS and not another directory because the path is hardcoded in the filter ;-))
(You might use any ftp program for this step) Please don´t forget to make the
fbclear program executable (chmod +x fbclear), otherwise your screen will stay quite dark
during video playback :-))

In general the clipmode is still under heavy development (this is what I hope !) so you may not 
expect tooooo much. Video OR Audio should work but all together ...
VideoCapture is in a muuuuch better shape.
This is true for the neutrino version I´m testing with. I checked a few later revs and found
render completetly broken (xxx_dvr.o is not loadable anymore) and capture only works with preview
turned off. Sorry to solve these problems is out of my reach.

PS: Pardon me for keeping only one version of this important notice for capture and render ...

Have fun,
Bernd.

-------------------------------------------------------------------------------------------------
Rev 0.2
- bug in remultiplexer fixed (ARD Buquet was broken)
- prebuffering raised to 3500ms
- pins for raw video and audio created, but if they will ever get alive ?
Basic Problem for a GENERIC raw-capture support is either WDM or VfW. But this would result in an 
tremendous work on creating a truely compatible ring 0 capture driver. This is definitly 
no fun :-), but if somebody could offer a WDM driver with a nice ring 3 interface I would maybe
change my mind (Simply extending the testcap filter from the M$ DDK maybe ...).

-------------------------------------------------------------------------------------------------
Rev 0.1
- bug in CCircularBuffer canWrite() fixed
- watch out for next TRex that will have PropertySetup for 48kHz Audio, so connecting Audio
is no problem anymore
- 500ms prebuffering is now performed before delivering first data, this
should effectivly help to avoid video/audio stuttering at the very beginning

-------------------------------------------------------------------------------------------------
Rev.0.0 initial alpha drop

1.) (Rebuild the source if you like :-) and then) register the capture filter (DBOXIISource.ax)
using regsvr32.exe (which usually can be found in your windows system or system32 
directory. (I prefere a link on my desktop where I can simply drag and drop
filters to register them).
2.) Take a look at the graphedit.gif image which shows a simple preview graph that makes use
of the source filter.
You´ll see a MPEG2Demultiplexer, a MPEG2VideoDecoder and a VideoRenderFilter.
Of cause you are free to use the existing M$ Demultiplexer but due to lack of appropriate 
bufferhandling this beast is not very smart. If you want to go with the shown filters
go an download the latest TRex installation, which will give you (beneath a nice conversion
utility) the MPEG2Demultiplexer.
In the current version of TRex (1.5.1) the Decoder and Renderer is missing. This should
be fixed in the next drop.
The Cyberlink decoder was checked and proven working with the source filter / splitter
combination.
3.) Open grpahedit and add the source filter first. Once loaded you should open
the properties of the capture filter (right click) and modify parameters like
IPAddress. (Login and Password should be ok in most cases)
4.) Load the Demultiplexer and connect it to the PS Output pin.
5.) From here it highly depends wich MPEGDecoder you are willing to use.
If you don´t care you might give render on the Video Output a try, but I would
strongly recommend (once it is available through TRex) to use the filter that is 
shown in the graphedit_preview_video.gif image.
6.) Hit run. Now your currently selected program should come up in a window.
If it stutters try hitting pause and then run again (That fills up some
buffers internally)
7.) Connecting the audio looks trivial BUT: currently the audio output defaults to 44.1 kHz
and then performs a inband change to 48kHz. This is a completely valid behaviour but
it looks like M$ DSound renderer has some problems ...
8.) The next version of the splitter will have some defaults that can be set up, so for now
I would suggest to leave the audio path unconnected !



-------------------------------------------------------------------------------------------------

TODO:

- AC3 support
- setup more reasonable Types/Subtypes for the pins
- provide automatic fillup of internal queues to produce 
  fluent output in streaming preview (queue up to what watermark level ?)
- implement all the needed interfaces that a REAL capture filter should expose
  (like IAMTVTuner, IAMProcAmp, ...)

-------------------------------------------------------------------------------------------------

Bernd Scharping, Apr. 2002
bernd@transputer.escape.de

-------------------------------------------------------------------------------------------------
