//
//  DBOXII Audio RawFileRenderer
//  
//  Rev.0.0 Bernd Scharping 
//  bernd@transputer.escape.de
//
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by 
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; see the file COPYING.  If not, write to
* the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/

// {6DFFFA3B-9364-4b73-9060-4CFB8BDB532E}
DEFINE_GUID(CLSID_DBOXIIAudioRawFileRenderer,
0x6dfffa3b, 0x9364, 0x4b73, 0x90, 0x60, 0x4c, 0xfb, 0x8b, 0xdb, 0x53, 0x2e);

// ----------------------------------------------------------------------------

// {292B9187-C7C8-4529-9793-63EA9EBDA300}
DEFINE_GUID(IID_IDBOXIIAudioRawFileRenderer, 
0x292b9187, 0xc7c8, 0x4529, 0x97, 0x93, 0x63, 0xea, 0x9e, 0xbd, 0xa3, 0x0);

// ----------------------------------------------------------------------------

DECLARE_INTERFACE_(IDBOXIIAudioRawFileRenderer,IUnknown)
{
STDMETHOD(setParameter) (THIS_ __int64 command, __int64  data1, __int64  data2, __int64 data3) PURE;
STDMETHOD(getParameter) (THIS_ __int64 command, __int64 *data1, __int64 *data2) PURE;
};

// ----------------------------------------------------------------------------

//!!BS: use different values for the commands here to avoid testing the used renderer
#define CMD_SPLITEVENT          0x00010000   
#define CMD_SPLITDATA           0x00020000   
#define CMD_SPLITMODE           0x00030000

#define OPT_SPLIT_OFF           0x00000000
#define OPT_SPLIT_EVENT         0x00000001
#define OPT_SPLIT_DISCONTINUITY 0x00000002