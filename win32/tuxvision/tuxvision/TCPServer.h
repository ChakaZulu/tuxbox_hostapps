//
//  TuxVision
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

#ifndef __TCPSERVER_H__
#define __TCPSERVER_H__

typedef enum CVCRStates 
{
    CMD_VCR_UNKNOWN = 0,
    CMD_VCR_RECORD  = 1,
    CMD_VCR_STOP    = 2,
    CMD_VCR_PAUSE   = 3,
    CMD_VCR_RESUME  = 4
}CVCRCommand;

enum CVCRDevices
{
    DEVICE_VCR,
    DEVICE_SERVER
};

struct externalCommand                        // command wird an externen server gesendet
{
    unsigned char      messageType;           // egal
    unsigned char      version;               // momentan 1
    unsigned int       command;               // siehe externalcommands
    unsigned __int64   epgID;                 // may be zero
    unsigned int       onidsid;               // may be zero
};


HRESULT HTTPInit(void);
HRESULT HTTPDeInit(void);
HRESULT HTTPRun(void);
HRESULT HTTPStop(void);


#endif