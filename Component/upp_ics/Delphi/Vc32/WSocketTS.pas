{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Fran�ois PIETTE
Description:  Multi-threaded socket server component derived from TWSocketServer
              Based on code written by Arno Garrels, Berlin, Germany,
              contact: <arno.garrels@gmx.de>
Creation:     November 2005
Version:      1.00
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2005-2006 by Fran�ois PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
Mar 06, 2006 A. Garrels: Fixed synchronisation in ClientAttachThread and
             TriggerClientDisconnect. Multi-threading: OpenSSL library is
             thread safe as long as the application provides an appropriate
             locking callback. Implemented such callbacks as two components
             see unit IcsSslThrdLock and changed TSslWSocketThrdServer to
             use TSslDynamicLock.


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit WSocketTS;

{$B-}              { Enable partial boolean evaluation   }
{$T-}              { Untyped pointers                    }
{$X+}              { Enable extended syntax              }
{$I ICSDEFS.INC}
{$IFDEF DELPHI6_UP}
    {$WARN SYMBOL_PLATFORM   OFF}
    {$WARN SYMBOL_LIBRARY    OFF}
    {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
{$IFDEF COMPILER2_UP}{ Not for Delphi 1                    }
    {$H+}            { Use long strings                    }
    {$J+}            { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF BCB3_UP}
    {$ObjExportAll On}
{$ENDIF}

interface

uses
    Messages,
{$IFDEF USEWINDOWS}
    Windows,
{$ELSE}
    WinTypes, WinProcs,
{$ENDIF}
    SysUtils, Classes, WSocket, WSocketS,
{$IFDEF USE_SSL}
    IcsSSLEAY, IcsLIBEAY, IcsSslThrdLock,
{$ENDIF}
    Winsock;

const
    WSocketThrdServerVersion = 100;
    CopyRight : String       = ' TWSocketThrdServer (c) 2005-2006 F. Piette V1.00 ';

    WM_THREAD_BASE_MSG           = WM_USER + 100;
    WM_THREAD_ADD_CLIENT         = WM_THREAD_BASE_MSG + 0;
    WM_THREAD_REMOVE_CLIENT      = WM_THREAD_BASE_MSG + 1;
    WM_THREAD_TERMINATE          = WM_THREAD_BASE_MSG + 2;
    WM_THREAD_START_CNX          = WM_THREAD_BASE_MSG + 3;
    WM_THREAD_TERMINATED         = WM_THREAD_BASE_MSG + 4;
    WM_THREAD_DISCONNECT_ALL     = WM_THREAD_BASE_MSG + 5;
    WM_THREAD_EXCEPTION          = WM_THREAD_BASE_MSG + 6;
    WM_THREAD_EXCEPTION_TEST     = WM_THREAD_BASE_MSG + 7;

type
    TWSocketThrdServer = class;
    TWSocketThrdClient = class;

    TWsClientThreadEventID = (cteiClientAttached,
                              cteiClientRemoved,
                              cteiThreadUnlock,
                              cteiThreadReady);

    TWsClientThread = class(TThread)
    private
        FReadyForMsgs     : Boolean;
        FServer           : TWSocketThrdServer;
        FClients          : TList;
        FEventArray       : array [TWsClientThreadEventID] of THandle;
    protected
        procedure   DetachClient(Client: TWSocketThrdClient);
        procedure   AttachClient(Client: TWSocketThrdClient);
        procedure   DisconnectAll;
        procedure   PumpMessages(WaitForMessages : Boolean); virtual;
        procedure   Execute; override;
        function    GetClientCount : Integer;
    public
        constructor Create(Suspended : Boolean);
        destructor  Destroy; override;
        property    ClientCount  : Integer             read  GetClientCount;
        property    ReadyForMsgs : Boolean             read  FReadyForMsgs;
    end;

    TWsClientThreadClass  = class of TWsClientThread;

    TWSocketThrdClient = class(TWSocketClient)
    protected
        FServer        : TWSocketThrdServer;
        FClientThread  : TWsClientThread;
        procedure   WndProc(var MsgRec: TMessage); override;
        procedure   WMThreadStartCnx(var Msg: TMessage); message WM_THREAD_START_CNX;
    public
        constructor Create(AOwner: TComponent); override;
        procedure   StartConnection; override;
        property    ClientThread : TWsClientThread read FClientThread;
    end;

    TThreadCreate           = procedure(Sender  : TObject;
                                        AThread : TWsClientThread) of object;
    TBeforeThreadDestroy    = procedure(Sender  : TObject;
                                        AThread : TWsClientThread) of object;
    TClientAttached         = procedure(Sender  : TObject;
                                        AClient : TWSocketThrdClient;
                                        AThread : TWsClientThread) of object;
    TClientDetached         = procedure(Sender  : TObject;
                                        AClient : TWSocketThrdClient;
                                        AThread : TWsClientThread) of object;
    TThreadExceptionEvent   = procedure(Sender        : TObject;
                                        AThread : TWsClientThread;
                                        const AErrMsg : String) of object;

    TWSocketThrdServer = class(TWSocketServer)
    private
        FThreadList             : TList;
        FClientsPerThread       : Integer;
        FClientThreadClass      : TWSClientThreadClass;
        FThreadCount            : Integer;
        FOnThreadCreate         : TThreadCreate;
        FOnBeforeThreadDestroy  : TBeforeThreadDestroy;
        FOnClientAttached       : TClientAttached;
        FOnClientDetached       : TClientDetached;
        FOnThreadException      : TThreadExceptionEvent;
    protected
        procedure   WndProc(var MsgRec: TMessage); override;
        procedure   WmThreadTerminated(var Msg: TMessage); message WM_THREAD_TERMINATED;
        procedure   WmThreadException(var Msg: TMessage); message WM_THREAD_EXCEPTION;
        function    ClientAttachThread(Client: TWSocketThrdClient): TWSClientThread;
        function    AcquireThread: TWsClientThread;
        procedure   TerminateThreads;
        procedure   SetClientsPerThread(const Value : Integer);
        procedure   TriggerClientCreate(Client : TWSocketClient); override;
        procedure   TriggerClientDisconnect(Client  : TWSocketClient;
                                            ErrCode : Word); override;
    public
        constructor Create(AOwner: TComponent); override;
        destructor  Destroy; override;
        procedure   DisconnectAll;
        property    ThreadCount : Integer            read  FThreadCount;
        property    ClientThreadClass  : TWsClientThreadClass
                                                     read  FClientThreadClass
                                                     write FClientThreadClass;
    published
        property    ClientsPerThread : Integer       read  FClientsPerThread
                                                     write SetClientsPerThread;
        property    OnThreadCreate         : TThreadCreate
                                                     read  FOnThreadCreate
                                                     write FOnThreadCreate;
        property    OnBeforeThreadDestroy  : TBeforeThreadDestroy
                                                     read  FOnBeforeThreadDestroy
                                                     write FOnBeforeThreadDestroy;
        property    OnClientAttached       : TClientAttached
                                                     read  FOnClientAttached
                                                     write FOnClientAttached;
        property    OnClientDetached       : TClientDetached
                                                     read  FOnClientDetached
                                                     write FOnClientDetached;
        property    OnThreadException      : TThreadExceptionEvent
                                                     read  FOnThreadException
                                                     write FOnThreadException;
    end;

{$IFDEF USE_SSL}
    TSslWSocketThrdClient = class(TWSocketThrdClient)
    protected
        procedure WndProc(var MsgRec: TMessage); override;
        procedure WMThreadStartCnx(var Msg: TMessage); message WM_THREAD_START_CNX;
    end;

    TSslWSocketThrdServer = class(TWSocketThrdServer)
    protected
        FSslLock    : TSslDynamicLock;
        procedure   TriggerClientConnect(Client : TWSocketClient; Error : Word); override;
    public
        constructor Create(AOwner : TComponent); override;
        destructor  Destroy; override;
        procedure   Listen; override;
        property    ClientClass;
        property    ClientCount;
        property    Client;
        property    SslMode;
    published
        property    SslContext;
        property    Banner;
        property    BannerTooBusy;
        property    MaxClients;
        property    OnClientDisconnect;
        property    OnClientConnect;
        property    SslEnable;
        property    SslAcceptableHosts;
        property    OnSslVerifyPeer;
        property    OnSslSetSessionIDContext;
        property    OnSslSvrNewSession;
        property    OnSslSvrGetSession;
        property    OnSslHandshakeDone;
    end;
{$ENDIF}

procedure Register;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('FPiette', [TWSocketThrdServer
{$IFDEF USE_SSL}
                                   , TSslWSocketThrdServer
{$ENDIF}
                                   ]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*
var
    DbLock : TRtlCriticalSection;

procedure LogDebug(const Msg: string);
begin
    if IsConsole then
    begin
        EnterCriticalSection(DbLock);
        try
            WriteLn('T: ' + IntToHex(GetCurrentThreadID, 8) + ' C: ' + Msg);
        finally
            LeaveCriticalSection(DbLock);
        end;
    end;
end;
*)

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TWSocketThrdServer.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FThreadList             := nil;
    FClientsPerThread       := 1;
    FThreadCount            := 0;
    FThreadList             := TList.Create;
    FClientThreadClass      := TWsClientThread;
    FClientClass            := TWSocketThrdClient;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.WmThreadTerminated(var Msg: TMessage);
var
    AThread : TWsClientThread;
    I      : Integer;
begin
    AThread := TObject(Msg.WParam) as TWsClientThread;
    I := FThreadList.IndexOf(AThread);
    if I > -1 then
        FThreadList.Delete(I);
    AThread.WaitFor;
    if Assigned(FOnBeforeThreadDestroy) then
        FOnBeforeThreadDestroy(Self, AThread);
    if not AThread.FreeOnTerminate then
        AThread.Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.TerminateThreads;
var
    AThread : TWsClientThread;
    I            : Integer;
begin
    for I := 0 to FThreadList.Count - 1 do begin
        AThread := TWsClientThread(FThreadList[I]);
        if not PostThreadMessage(AThread.ThreadID,
                                 WM_THREAD_TERMINATE, 0, 0) then
            raise Exception.Create('PostThreadMessage ' +
                                   SysErrorMessage(GetLastError));
            InterlockedDecrement(FThreadCount);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TWSocketThrdServer.Destroy;
var
    WaitRes : LongWord;
    Dummy   : Byte;
    Msg     : tagMsg;
begin
    Close; // while waiting for our threads do not accept any new client!!
    try
        TerminateThreads; // may raise, otherwise wait below would loop infinite 
        if FThreadList.Count > 0 then
        repeat
            WaitRes := MsgWaitForMultipleObjects(0, Dummy, FALSE, 500,
                                             QS_POSTMESSAGE or QS_SENDMESSAGE);
            if WaitRes = WAIT_FAILED then
                raise Exception.Create('Wait for threads failed ' +
                                       SysErrorMessage(GetLastError))
            else if WaitRes = WAIT_OBJECT_0 then
                while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
                begin
                    TranslateMessage(Msg);
                    DispatchMessage(Msg);
                end;
        until FThreadList.Count = 0; 
    finally
    inherited Destroy;
    FreeAndNil(FThreadList);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.DisconnectAll;
var
    I : Integer;
begin
    for I := 0 to FThreadList.Count - 1 do begin
        PostThreadMessage(TThread(FThreadList[I]).ThreadID,
                          WM_THREAD_DISCONNECT_ALL, 0, 0);
end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TWSocketThrdServer.AcquireThread: TWsClientThread;
var
    I : Integer;
begin
    for I := 0 to FThreadList.Count - 1 do begin
        Result := TWSClientThread(FThreadList[I]);
        if (Result.ClientCount < FClientsPerThread) and
             (not Result.Terminated) then
            Exit; //***
    end;

    Result                 := FClientThreadClass.Create(FALSE); // create suspended not required
    Result.OnTerminate     := nil;
    Result.FreeOnTerminate := FALSE;
    Result.FServer         := TWSocketThrdServer(Self);
    FThreadList.Add(Result);
    InterlockedIncrement(FThreadCount);
    if Assigned(FOnThreadCreate) then
        FOnThreadCreate(Self, Result);
    Sleep(0); // not sure if required?
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TWSocketThrdServer.ClientAttachThread(
    Client: TWSocketThrdClient): TWsClientThread;
var
    WaitRes : Longword;
    H : array[0..1] of THandle;
begin
    if Client.Handle <> 0 then
    Client.ThreadDetach;
    //LogDebug(IntToHex(Integer(Client), 8) + ' Main Thread Detached');
    Client.FClientThread  := nil;
    Client.FServer        := Self;
    Result                := AcquireThread;
    H[1] := Result.Handle;
    { Wait until the thread has initialized its message queue }
    if not Result.FReadyForMsgs then begin
        H[0] := Result.FEventArray[cteiThreadReady];
        WaitRes := WaitForMultipleObjects(2, @H, FALSE, Infinite);
        if WaitRes = WAIT_FAILED then
            raise Exception.Create('Wait failed ' +
                                   SysErrorMessage(GetLastError))
        else if WaitRes = WAIT_OBJECT_0 + 1 then
            raise Exception.Create('Thread terminated while waiting');
    end;
    if not PostThreadMessage(Result.ThreadID,
                             WM_THREAD_ADD_CLIENT, Integer(Client), 0) then
        raise Exception.Create('PostThreadMessage ' +
                               SysErrorMessage(GetLastError));
    H[0] := Result.FEventArray[cteiClientAttached];
    { Wait until thread has attached client socket to his own context. }
    WaitRes := WaitForMultipleObjects(2, @H, FALSE, Infinite);
    if WaitRes = WAIT_FAILED then
        raise Exception.Create('Wait client ThreadAttach ' +
                               SysErrorMessage(GetLastError))
    else if WaitRes = WAIT_OBJECT_0 + 1 then begin
        { ThreadAttach failed due to the thread terminated, let's try again }
        ClientAttachThread(Client);
        Exit;
    end;
    if Assigned(FOnClientAttached) then
        FOnClientAttached(Self, Client, Result);
    //LogDebug(IntToHex(Integer(Client), 8) + ' W att ID: ' + IntToHex(Result.ThreadID, 8));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.TriggerClientCreate(Client: TWSocketClient);
begin
    inherited TriggerClientCreate(Client);
    ClientAttachThread(TWSocketThrdClient(Client));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.TriggerClientDisconnect(
    Client  : TWSocketClient;
    ErrCode : Word);
var
    AThread : TWsClientThread;
    WaitRes : Longword;
    H : array[0..1] of THandle;
begin
    inherited TriggerClientDisconnect(Client, ErrCode);
    AThread := TWSocketThrdClient(Client).ClientThread;
    if Assigned(AThread) then begin
        H[1] := AThread.Handle;
        if not PostThreadMessage(AThread.ThreadID,
                                 WM_THREAD_REMOVE_CLIENT,
                                 Integer(Client), 0) then
            raise Exception.Create('PostThreadMessage ' +
                                   SysErrorMessage(GetLastError));
        H[0] := AThread.FEventArray[cteiClientRemoved];
        { Wait until thread has Detached client socket to his context. }
        WaitRes := WaitForMultipleObjects(2, @H, FALSE, Infinite);
        if WaitRes = WAIT_FAILED then
            raise Exception.Create('Wait client ThreadDetach ' +
                                   SysErrorMessage(GetLastError));
        {else if WaitRes = WAIT_OBJECT_0 + 1 then ...
        { The thread has terminated so we are already detached }
    end;
    if Assigned(FOnClientDetached) then
        FOnClientDetached(Self, TWSocketThrdClient(Client), AThread);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.SetClientsPerThread(const Value: Integer);
begin
    if Value <= 0 then
        raise Exception.Create('At least one client per thread must be allowed')
    else
       FClientsPerThread := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TWSClientThread }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TWSClientThread.Create(Suspended: Boolean);
var
    I : TWsClientThreadEventID;
begin
    inherited Create(Suspended);
    FReadyForMsgs := FALSE;
    FClients      := nil;
    for I := Low(FEventArray) to High(FEventArray) do begin
        FEventArray[I] := 0;
        FEventArray[I] := CreateEvent(nil, False, False, nil);
        if FEventArray[I] = 0 then
            raise Exception.Create('Cannot create Event: ' +
                                   SysErrorMessage(GetLastError));
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TWSClientThread.Destroy;
var
    I : TWsClientThreadEventID;
begin
    //FreeOnTerminate := FALSE;
    inherited Destroy;
    for I := Low(FEventArray) to High(FEventArray) do
        if FEventArray[I] <> 0 then
            CloseHandle(FEventArray[I]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWsClientThread.PumpMessages(WaitForMessages: Boolean);
var
    HasMessage : Boolean;
    Msg        : TMsg;
    MsgRec     : TMessage;
    Client     : TWSocketThrdClient;
    WaitRes    : LongWord;
begin
    while TRUE do begin
        if Terminated and WaitForMessages then
            Break;
        if WaitForMessages then
            HasMessage := GetMessage(Msg, 0, 0, 0)
        else
            HasMessage := PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
        if not HasMessage then
            break;

        if Msg.hwnd = 0 then begin
            case Msg.message of
            WM_THREAD_ADD_CLIENT :
                begin
                    Client := TObject(Msg.WParam) as TWSocketThrdClient;
                    AttachClient(Client);
                    { Tell the main thread that a client attached     }
                    { to this thread. Unlocks the waiting main thread }
                    SetEvent(FEventArray[cteiClientAttached]);
                    { Wait until the main thread signals }
                    WaitRes := WaitForSingleObject(FEventArray[cteiThreadUnlock],
                                                   INFINITE);
                    if WaitRes = WAIT_FAILED then
                        raise Exception.Create('Wait failed ' + SysErrorMessage(GetLastError));
                    {else if WaitRes = WAIT_TIMEOUT then
                        raise Exception.Create('Wait timeout');}

                end;
            WM_THREAD_REMOVE_CLIENT :
                begin
                    Client := TObject(Msg.WParam) as TWSocketThrdClient;
                    DetachClient(Client);
                    { Tell the main thread that a client detached from t}
                    { his thread.  Unlocks the waiting main thread      }
                    SetEvent(FEventArray[cteiClientRemoved]);
                    if ClientCount = 0 then begin
                        Terminate;
                        Exit; //***
                    end;
                end;
            WM_THREAD_DISCONNECT_ALL :
                DisconnectAll;
            WM_QUIT,
            WM_THREAD_TERMINATE :
                begin
                    //FreeOnTerminate := TRUE;
                    Terminate;
                    Exit //***
                end;
            WM_THREAD_EXCEPTION_TEST :
                raise Exception.Create('** TEST EXCEPTION ***')
            else
                MsgRec.Msg    := Msg.message;
                MsgRec.WParam := Msg.wParam;
                MsgRec.LParam := Msg.lParam;
                Dispatch(MsgRec);
            end;
        end
        else begin
            TranslateMessage(Msg);
            DispatchMessage(Msg);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSClientThread.Execute;
var
    I       : Integer;
    Client  : TWSocketThrdClient;
    Msg     : tagMsg;
    ErrMsg  : PChar;
    ExcFlag : Boolean;
begin
    try
        { Initialize thread's message queue }
        PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
        ExcFlag       := FALSE;
        FClients      := TList.Create;
        try
            try
                FReadyForMsgs := TRUE;
                SetEvent(FEventArray[cteiThreadReady]);
                PumpMessages(True);
            except
                // No exception can go outside of a thread !
                on E:Exception do begin
                    ExcFlag := TRUE;
                    ErrMsg  := AllocMem(1024);
                    StrLCopy(ErrMsg, PChar(E.ClassName + ': ' + E.Message), 1023);
                    PostMessage(FServer.Handle, WM_THREAD_EXCEPTION,
                                Integer(Self), Integer(ErrMsg));
                end;
            end;
            InterlockedDecrement(FServer.FThreadCount);
            for I := 0 to FClients.Count - 1 do begin
                Client := FClients[I];
                if Assigned(Client) then begin
                    try
                        try
                            Client.ThreadDetach;
                            if ExcFlag then begin
                                Client.Abort;
                                // Quick hack to close the socket
                                //WSocket.WSocket_closesocket(Client.HSocket);
                                //Client.HSocket := -1;
                            end;
                        except
                        end;
                    finally
                        Client.FClientThread := nil;
                    end;
                end;
            end;
        finally
            FClients.Free;
            FClients := nil;
        end;
    finally
        if FreeOnTerminate then
            FreeOnTerminate := FALSE; 
        if not Terminated then
            Terminate;
        PostMessage(FServer.Handle, WM_THREAD_TERMINATED, Integer(Self), 0);
        { Just to make sure the  main thread isn't waiting for this thread }
        { we signal the events }
        //SetEvent(FEventArray[cteiClientRemoved]);
        //SetEvent(FEventArray[cteiClientAttached]);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSClientThread.AttachClient(Client: TWSocketThrdClient);
begin
    Client.ThreadAttach;
    Client.FClientThread := Self;
    FClients.Add(Client);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSClientThread.DetachClient(Client: TWSocketThrdClient);
var
    I : Integer;
begin
    try
        if Assigned(Client) then begin
            try
                Client.ThreadDetach;
            finally
                Client.FClientThread := nil;
            end;
        end;
    finally
        I := FClients.IndexOf(Client);
        if I > -1 then
            FClients.Delete(I);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWsClientThread.DisconnectAll;
var
    I : Integer;
begin
    for I := 0 to FClients.Count - 1 do
        TWSocket(FClients[I]).CloseDelayed;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TWsClientThread.GetClientCount: Integer;
begin
    if Assigned(FClients) then
        Result := FClients.Count
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.WmThreadException(var Msg: TMessage);
begin
    try
        if Assigned(FOnThreadException) then
            FOnThreadException(Self,
                               TObject(Msg.WParam) as TWsClientThread,
                               StrPas(PChar(Msg.LParam)));
    finally
        FreeMem(PChar(Msg.LParam));
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdServer.WndProc(var MsgRec: TMessage);
begin
    try
    case MsgRec.Msg of
    WM_THREAD_TERMINATED : WmThreadTerminated(MsgRec);
    WM_THREAD_EXCEPTION  : WmThreadException(MsgRec);
    else
        inherited WndProc(MsgRec);
    end;
    except
        on E:Exception do
            HandleBackGroundException(E);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TWSocketThrdClient }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TWSocketThrdClient.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FClientThread := nil;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdClient.StartConnection;
begin
    PostMessage(Self.Handle, WM_THREAD_START_CNX, 0, 0);
    { Now unlock the worker thread }
    SetEvent(ClientThread.FEventArray[cteiThreadUnlock]);
    //LogDebug(IntToHex(Integer(Self), 8) + ' Worker unlocked');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdClient.WMThreadStartCnx(var Msg: TMessage);
begin
    //LogDebug(IntToHex(Integer(Self), 8) + ' StartConnection (in worker thread)');
    if (Length(FBanner) > 0) and (State = wsConnected) then
        SendStr(FBanner + FLineEnd);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure TWSocketThrdClient.TriggerSessionClosed(ErrCode : Word);
var
    AThread : TWsClientThread;
begin
    if not FSessionClosedFlag then begin
        FSessionClosedFlag := TRUE;
        AThread := FClientThread
        Self.ThreadDetach;
        AThread.FClients
        Self.FClientThread.DetachClient(Self);

        if Assigned(FServer) then
            PostMessage(FServer.Handle, WM_CLIENT_CLOSED, ErrCode, LongInt(Self));
        inherited TriggerSessionClosed(ErrCode);
    end;
end;}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketThrdClient.WndProc(var MsgRec: TMessage);
begin
    try
    case MsgRec.Msg of
        WM_THREAD_START_CNX: WMThreadStartCnx(MsgRec);
    else
        inherited WndProc(MsgRec);
    end;
    except                                                       // <= 12/12/05
        on E:Exception do
            HandleBackGroundException(E);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF USE_SSL}

{ TSslWSocketThrdServer }

constructor TSslWSocketThrdServer.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FSslEnable       := TRUE;
    Port             := '443';
    Proto            := 'tcp';
    Addr             := '0.0.0.0';
    SslMode          := sslModeServer;
    FSslLock         := TSslDynamicLock.Create(nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TSslWSocketThrdServer.Destroy;
begin
    inherited Destroy;
    FSslLock.Free;
    FSslLock := nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslWSocketThrdServer.Listen;
begin
    inherited;
    FSslLock.Enabled := SslEnable;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslWSocketThrdServer.TriggerClientConnect(
    Client : TWSocketClient;
    Error  : Word);
begin
    inherited TriggerClientConnect(Client, Error);
    { The event handler may have closed the connection.                     }
    { The event handler may also have started the SSL though it won't work. }
    if (Error <> 0) or (Client.State <> wsConnected) or
       (Client.SslState > sslNone) or (not FSslEnable) then
        Exit;
    Client.Pause;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ TSslWSocketThrdClient }

procedure TSslWSocketThrdClient.WMThreadStartCnx(var Msg: TMessage);
begin
    if (State = wsConnected) and (SslState = sslNone) then begin
        SslEnable := FServer.SslEnable;
        if SslEnable then begin
        { Once SslEnable is set to TRUE we may resume the socket }
            Resume;
            SslMode                  := FServer.SslMode;
            SslAcceptableHosts       := FServer.SslAcceptableHosts;
            SslContext               := FServer.SslContext;
            OnSslVerifyPeer          := FServer.OnSslVerifyPeer;
            OnSslSetSessionIDContext := FServer.OnSslSetSessionIDContext;
            OnSslSvrNewSession       := FServer.OnSslSvrNewSession;
            OnSslSvrGetSession       := FServer.OnSslSvrGetSession;
            OnSslHandshakeDone       := FServer.OnSslHandshakeDone;
            try
                if SslMode = sslModeClient then
                    StartSslHandshake
                else
                    AcceptSslHandshake;
            except
                SslEnable := False;
                Abort;
                Exit;
            end;
        end;
    end;

    inherited WMThreadStartCnx(Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslWSocketThrdClient.WndProc(var MsgRec: TMessage);
begin
    try
    case MsgRec.Msg of
        WM_THREAD_START_CNX: WMThreadStartCnx(MsgRec);
    else
        inherited WndProc(MsgRec);
    end;
    except                                                       // <= 12/12/05
        on E:Exception do
            HandleBackGroundException(E);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{$ENDIF}




end.
