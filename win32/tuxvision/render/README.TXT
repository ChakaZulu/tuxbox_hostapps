-------------------------------------------------------------------------------------------------

This is version 0.1 of the DBOXII Render Filter
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

Rev.0.1
- With the gtx_dvr.o (I can´t say anything about enx_dvr.o !) things look better on the 
render side. Take a look at graphedit_render_ps_video.gif, this is whow it should work.
(The PES splitter can be found in binary form at http://transputer.dyn.escape.de/src/dboxII/)
- I also tweaked buffersizes for audio and video but still AV playback is not that reliable
- path for binaries now fixed to /var/tuxbox (see important notice)

-------------------------------------------------------------------------------------------------
Rev.0.0 initial alpha drop

Basicly Video and Audio works, BUT it looks like streaming on both pins parallel
confuses my GTX + dvrv/dvra !
In the current state of those software parts simply try to avoid using both pins at the same time.

Video should work fine with 352x288@25fps MPEG1/MPEG2, 480x576@25fps MPEG2, 704x576@25fps MPEG2
and 720x576@25fps MPEG2. (I´ll have to check if also 352x576@25fps MPEG2 is supported)
graphedit_render_dv_video.gif shows how things are connected up for a video path.
Ofcause DV is BottomField first, samples are displayed in a wrong field order, but overall
picture quality (I had no probs with 6Mbit) was really nice. If you want to display MPEG1
VCD simply connect the splitter video output to VPES input of the renderer. 
If you need the MPEGEncoderEngine (is include in TRex install) take a look at 
graphedit_MPEGEncoder_Properties.gif. Depending on your decoder it might be neccesary to switch 
to Offline mode to avoid stalling the graph.

On the Audio side things get only a little bit more complicated. It looks like the decoder simply
needs packetized data. Therefore a ES to PES translation is neccesary. 
(I´ll attach this special Mutiplexer in binary only, sorry for that but I´ll think this is a thing
you won´t touch anyway, believe me ...)
Take a look at graphedit_render_audio.gif. I took a MP3 only as an example, in practice you might 
convert ANY audio stream you have a DSHow reader/splitter combination (WAVE, MP3, WMA, MPA, ...).
Please take care of setting the AudioResampler to 48kHz destination frequency. On the AudioMPEG-
Encoder side I decided to go for 256kBit (always Layer II).

As an input filter I used for all tests the FileSource(Async).

-------------------------------------------------------------------------------------------------

TODO:

- avoid annoying "queeek" at the very beginning when streaming audio
- AC3 support
- bottom field first order support
- setup more reasonable Types/Subtypes for the pins
- provide automatic fillup of internal queues to produce 
  fluent output in streaming preview (queue up to what watermark level ?)
- implement all the needed interfaces that a REAL Render filter should expose
- pray for a nice guy to improve GTX playback performance (resyncing ...)

-------------------------------------------------------------------------------------------------

Bernd Scharping, Apr. 2002
bernd@transputer.escape.de

-------------------------------------------------------------------------------------------------
