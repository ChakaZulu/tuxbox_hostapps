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

#include <windows.h>
#include <windowsx.h>
#include <commctrl.h>
#include <prsht.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <io.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <vfw.h>
#include <wingdi.h>
#include <process.h>

#include <streams.h>

#include "TuxVision.h"
#include "resource.h"	// application resources
#include "options.h"
#include "DShow.h"
#include "..\\capture\\interface.h"
#include "debug.h"


// ------------------------------------------------------------------------
//
// ------------------------------------------------------------------------
BOOL CALLBACK DlgProc_DBOX(
    HWND    hdlg,
    UINT    msg,
    WPARAM  wParam,
    LPARAM  lParam)
{
	switch (msg)
		{
		case WM_INITDIALOG:
			{
            HRESULT hr=E_FAIL;
            IDBOXIICapture *pIDBOXIICapture=NULL;
			__int64 val;
            char szStr[264];

            SetCursor(LoadCursor(NULL, MAKEINTRESOURCE (IDC_WAIT)));
            if (gpVCap!=NULL)
                {
                hr=gpVCap->QueryInterface(IID_IDBOXIICapture, (void **)&pIDBOXIICapture);
                if (SUCCEEDED(hr))
                    {
			        pIDBOXIICapture->getParameter(CMD_STOPPLAYBACK, &val, NULL);
			        SendMessage( GetDlgItem(hdlg,IDC_STOPPLAYBACK), BM_SETCHECK, (unsigned int)val, 0 );

                    pIDBOXIICapture->getParameter(CMD_IPADDRESS, (__int64 *)szStr, NULL);
                    SetWindowText(GetDlgItem(hdlg,IDC_IPADDRESS), szStr);

                    pIDBOXIICapture->getParameter(CMD_LOGIN, (__int64 *)szStr, NULL);
                    SetWindowText(GetDlgItem(hdlg,IDC_LOGIN), szStr);

                    pIDBOXIICapture->getParameter(CMD_PASSWORD, (__int64 *)szStr, NULL);
                    SetWindowText(GetDlgItem(hdlg,IDC_PASSWORD), szStr);

                    pIDBOXIICapture->getParameter(CMD_STATUS, &val, NULL);
			        if (val)
                        SetWindowText(GetDlgItem(hdlg,IDC_STATUS), "DBOXII Status: Online");
                    else
                        hr=E_FAIL;
                    }
                RELEASE(pIDBOXIICapture);
                }

			if (FAILED(hr))
                SetWindowText(GetDlgItem(hdlg,IDC_STATUS), "DBOXII Status: Offline");
            SetCursor(LoadCursor(ghInstApp, MAKEINTRESOURCE (IDC_ARROW)));
            }
			return TRUE;

		case WM_COMMAND:
			switch (GET_WM_COMMAND_ID (wParam, lParam))
				{
				case IDC_TEST:
                    NMHDR nmh;
                    nmh.code=PSN_APPLY;
                    SendMessage(hdlg,WM_NOTIFY,0,(LPARAM)&nmh);
                    SendMessage(hdlg,WM_INITDIALOG,0,0);
					break;
				
				}
			return TRUE;
		break;


	case WM_NOTIFY:
		{
		LPNMHDR pnmh=(LPNMHDR)lParam;
		switch(pnmh->code)
			{
            case PSN_HELP:
                break;

			case PSN_APPLY:
            if (gpVCap!=NULL)
                    {
                    IDBOXIICapture *pIDBOXIICapture=NULL;
                    HRESULT hr=gpVCap->QueryInterface(IID_IDBOXIICapture, (void **)&pIDBOXIICapture);
                    char szStr[264];
                    if (SUCCEEDED(hr))
                        {
                        int val=SendMessage( GetDlgItem(hdlg,IDC_STOPPLAYBACK), BM_GETCHECK, 0, 0 );
                        pIDBOXIICapture->setParameter(CMD_STOPPLAYBACK, (__int64)val);

                        GetWindowText(GetDlgItem(hdlg,IDC_IPADDRESS), szStr, 264);
                        pIDBOXIICapture->setParameter(CMD_IPADDRESS, (__int64)szStr);

                        GetWindowText(GetDlgItem(hdlg,IDC_LOGIN), szStr, 264);
                        pIDBOXIICapture->setParameter(CMD_LOGIN, (__int64)szStr);

                        GetWindowText(GetDlgItem(hdlg,IDC_PASSWORD), szStr, 264);
                        pIDBOXIICapture->setParameter(CMD_PASSWORD, (__int64)szStr);
                        }
                    RELEASE(pIDBOXIICapture);
                    }
				PropSheet_UnChanged(GetParent(hdlg),hdlg);
			    break;

			case PSN_SETACTIVE:
                gLastPropertyPage=0;
				break;

			case PSN_KILLACTIVE:
				break;
			}
		return TRUE;
		}
    }
    return FALSE;
}

// ------------------------------------------------------------------------
//
// ------------------------------------------------------------------------
BOOL CALLBACK DlgProc_MISC(HWND hDlg, UINT msg, WPARAM wParam, LPARAM lParam)
{
switch (msg)
    {
	case WM_INITDIALOG:
        switch(gApplicationPriority)
            {
            case REALTIME_PRIORITY_CLASS:
                SendMessage(GetDlgItem(hDlg,IDC_PRIORITY_REALTIME),BM_SETCHECK, 1, 0);
                break;
            case HIGH_PRIORITY_CLASS:
                SendMessage(GetDlgItem(hDlg,IDC_PRIORITY_HIGH),BM_SETCHECK, 1, 0);
                break;
            case NORMAL_PRIORITY_CLASS:
                SendMessage(GetDlgItem(hDlg,IDC_PRIORITY_NORMAL),BM_SETCHECK, 1, 0);
                break;
            }
        if (gAlwaysOnTop)
            SendMessage(GetDlgItem(hDlg,IDC_ALLWAYSONTOP),BM_SETCHECK, 1, 0);
        if (gAutomaticAspectRatio)
            SendMessage(GetDlgItem(hDlg,IDC_AUTOASPECTRATIO),BM_SETCHECK, 1, 0);

        if (gSetVideoToWindow)
            SendMessage(GetDlgItem(hDlg,IDC_WINDOW),BM_SETCHECK, 1, 0);
        else
            SendMessage(GetDlgItem(hDlg,IDC_FULLSCREEN),BM_SETCHECK, 1, 0);

		return TRUE;

    case WM_COMMAND:
			switch (GET_WM_COMMAND_ID (wParam, lParam))
				{
				case IDC_PRIORITY_REALTIME:
                    gApplicationPriority=REALTIME_PRIORITY_CLASS;
                    SetPriorityClass(GetCurrentProcess(),gApplicationPriority);
					break;
				case IDC_PRIORITY_HIGH:
                    gApplicationPriority=HIGH_PRIORITY_CLASS;
                    SetPriorityClass(GetCurrentProcess(),gApplicationPriority);
					break;
				case IDC_PRIORITY_NORMAL:
                    gApplicationPriority=NORMAL_PRIORITY_CLASS;
                    SetPriorityClass(GetCurrentProcess(),gApplicationPriority);
					break;
				}
			return TRUE;

	case WM_NOTIFY:
		{
		LPNMHDR pnmh=(LPNMHDR)lParam;
		switch(pnmh->code)
			{
            case PSN_HELP:
                break;
			case PSN_APPLY:
                gAlwaysOnTop=SendMessage( GetDlgItem(hDlg,IDC_ALLWAYSONTOP), BM_GETCHECK, 0, 0 );
                gAutomaticAspectRatio=SendMessage( GetDlgItem(hDlg,IDC_AUTOASPECTRATIO), BM_GETCHECK, 0, 0 );
                gSetVideoToWindow=SendMessage(GetDlgItem(hDlg,IDC_WINDOW),BM_GETCHECK, 1, 0);

                if (gAlwaysOnTop)
                    SetWindowPos(ghWndApp, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE|SWP_NOSIZE);
                else
                    SetWindowPos(ghWndApp, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE|SWP_NOSIZE);

				PropSheet_UnChanged(GetParent(hDlg),hDlg);
			    break;
			case PSN_SETACTIVE:
                gLastPropertyPage=1;
				break;
			case PSN_KILLACTIVE:
				PropSheet_UnChanged(GetParent(hDlg),hDlg);
				break;
			}
		return TRUE;
		}
    }
    return FALSE;
}

// ------------------------------------------------------------------------
//
// ------------------------------------------------------------------------
BOOL CALLBACK DlgProc_ABOUT(
    HWND    hDlg,
    UINT    msg,
    WPARAM  wParam,
    LPARAM  lParam)
{
switch (msg)
    {
	case WM_INITDIALOG:
		return TRUE;

    case WM_COMMAND:
        return TRUE;

	case WM_NOTIFY:
		{
		LPNMHDR pnmh=(LPNMHDR)lParam;
		switch(pnmh->code)
			{
            case PSN_HELP:
                break;

			case PSN_APPLY:
				PropSheet_UnChanged(GetParent(hDlg),hDlg);
			    break;

			case PSN_SETACTIVE:
                gLastPropertyPage=2;
				break;

			case PSN_KILLACTIVE:
				PropSheet_UnChanged(GetParent(hDlg),hDlg);
				break;
			}
		return TRUE;
		}
    }
    return FALSE;
}


// ------------------------------------------------------------------------
//
// ------------------------------------------------------------------------
BOOL CreatePropertySheet(HWND hWndParent, HINSTANCE hInst, int StartPage)
{
	TCHAR szPTitle[10][32];
	PROPSHEETHEADER pshead;
	PROPSHEETPAGE	pspage[3];
	ZeroMemory(&pshead,sizeof(PROPSHEETHEADER));

	lstrcpy(szPTitle[0],"Options");
	lstrcpy(szPTitle[1],"DBox");
	lstrcpy(szPTitle[2],"Misc");
	lstrcpy(szPTitle[3],"About");

	pshead.dwSize=sizeof(PROPSHEETHEADER);
	pshead.dwFlags=PSH_PROPSHEETPAGE; //|PSH_HASHELP; /*PSH_USECALLBACK*/ /*|PSH_NOAPPLYNOW*/
	pshead.hwndParent=hWndParent;
	pshead.hInstance=hInst;
	pshead.hIcon=NULL;
	pshead.pszCaption=szPTitle[0];
	pshead.nPages=3;
	pshead.nStartPage=StartPage;
	pshead.ppsp=pspage;
	pshead.pfnCallback=NULL;

	ZeroMemory(&pspage,3*sizeof(PROPSHEETPAGE));

    pspage[0].dwSize=sizeof(PROPSHEETPAGE);
    pspage[0].dwFlags  =PSP_DEFAULT|PSP_USETITLE;
    pspage[0].hInstance=hInst;
    pspage[0].pszTemplate=MAKEINTRESOURCE(DBOX);
    pspage[0].pszIcon=NULL;
    pspage[0].pfnDlgProc=DlgProc_DBOX;
    pspage[0].lParam=WS_CHILD|WS_VISIBLE|WS_BORDER|WS_CAPTION;
    pspage[0].pfnCallback=NULL;
    pspage[0].pszTitle=szPTitle[1];

    memcpy(&pspage[1],&pspage[0],sizeof(PROPSHEETPAGE));
    pspage[1].pszTemplate=MAKEINTRESOURCE(MISC);
    pspage[1].pfnDlgProc=DlgProc_MISC;
    pspage[1].pszTitle=szPTitle[2];

    memcpy(&pspage[2],&pspage[0],sizeof(PROPSHEETPAGE));
    pspage[2].pszTemplate=MAKEINTRESOURCE(ABOUT);
    pspage[2].pfnDlgProc=DlgProc_ABOUT;
    pspage[2].pszTitle=szPTitle[3];

return(PropertySheet(&pshead));
}


