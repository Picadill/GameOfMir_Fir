unit svMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, D7ScktComp, ExtCtrls, Buttons, StdCtrls, IniFiles, M2Share,
  Grobal2, SDK, HUtil32, RunSock, Envir, ItmUnit, ItemEvent, Magic, NoticeM, Guild, Event,
  Castle, FrnEngn, UsrEngn, Mudutil, SyncObjs, Menus, ComCtrls, Grids, ObjBase,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, RzCommon, Common,
  RzEdit, RzPanel, RzSplit, RzGrids, ImgList, Gauges, DataEngn, Spin;

type
  TFrmMain = class(TForm)
    Timer1: TTimer;
    RunTimer: TTimer;
    StartTimer: TTimer;
    SaveVariableTimer: TTimer;
    CloseTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_CONTROL_RELOAD_CONF: TMenuItem;
    MENU_CONTROL_CLEARLOGMSG: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_MANAGE: TMenuItem;
    MENU_CONTROL_RELOAD: TMenuItem;
    MENU_CONTROL_RELOAD_ITEMDB: TMenuItem;
    MENU_CONTROL_RELOAD_MAGICDB: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem;
    MENU_MANAGE_PLUG: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_SERVERCONFIG: TMenuItem;
    MENU_OPTION_GAME: TMenuItem;
    MENU_OPTION_FUNCTION: TMenuItem;
    MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem;
    MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem;
    MENU_CONTROL_GATE: TMenuItem;
    MENU_CONTROL_GATE_OPEN: TMenuItem;
    MENU_CONTROL_GATE_CLOSE: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;
    MENU_VIEW_ONLINEHUMAN: TMenuItem;
    MENU_VIEW_LEVEL: TMenuItem;
    MENU_VIEW_LIST: TMenuItem;
    MENU_MANAGE_ONLINEMSG: TMenuItem;
    MENU_VIEW_KERNELINFO: TMenuItem;
    MENU_TOOLS: TMenuItem;
    MENU_OPTION_ITEMFUNC: TMenuItem;
    MENU_CONTROL_RELOAD_STARTPOINT: TMenuItem;
    G1: TMenuItem;
    MENU_OPTION_MONSTER: TMenuItem;
    MENU_TOOLS_IPSEARCH: TMenuItem;
    MENU_MANAGE_CASTLE: TMenuItem;
    MENU_HELP_REGKEY: TMenuItem;
    RzSplitter: TRzSplitter;
    MemoLog: TRzMemo;
    RzSplitter1: TRzSplitter;
    MonItems: TMenuItem;
    MENU_OPTION_HERO: TMenuItem;
    MENU_CONTROL_REFSERVERCONFIG: TMenuItem;
    MENU_MANAGE_SYS: TMenuItem;
    Panel: TPanel;
    LbRunTime: TLabel;
    LbUserCount: TLabel;
    MemStatus: TLabel;
    LTotalRAM: TLabel;
    LTotalVirtual: TLabel;
    LMemoryLoad: TLabel;
    GridGate: TStringGrid;
    Label20: TLabel;
    IdUDPClientLog: TIdUDPClient;

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MemoLogChange(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
    procedure MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_GAMEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_OPTION_FUNCTIONClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_OPENClick(Sender: TObject);
    procedure MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
    procedure MENU_CONTROLClick(Sender: TObject);
    procedure MENU_VIEW_GATEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
    procedure MENU_VIEW_LEVELClick(Sender: TObject);
    procedure MENU_VIEW_LISTClick(Sender: TObject);
    procedure MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
    procedure MENU_VIEW_KERNELINFOClick(Sender: TObject);
    procedure MENU_OPTION_ITEMFUNCClick(Sender: TObject);
    procedure MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
    procedure MENU_MANAGE_PLUGClick(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure MENU_OPTION_MONSTERClick(Sender: TObject);
    procedure MENU_TOOLS_IPSEARCHClick(Sender: TObject);
    procedure MENU_MANAGE_CASTLEClick(Sender: TObject);
    procedure MENU_HELP_REGKEYClick(Sender: TObject);
    procedure MonItemsClick(Sender: TObject);
    procedure MENU_OPTION_HEROClick(Sender: TObject);
    procedure MENU_CONTROL_REFSERVERCONFIGClick(Sender: TObject);
    procedure MENU_MANAGE_SYSClick(Sender: TObject);
    procedure DBSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    boServiceStarted: Boolean;
    procedure GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);

    procedure Timer1Timer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure SaveVariableTimerTimer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
    procedure ConnectTimerTimer(Sender: TObject);

    procedure StartService();
    procedure StopService();
    procedure SaveItemNumber;
    function LoadClientFile(): Boolean;
    procedure StartEngine;
    procedure MakeStoneMines;
    procedure ReloadConfig(Sender: TObject);
    procedure ClearMemoLog();
    procedure CloseGateSocket();
    { Private declarations }
  public
    GateSocket: TServerSocket;
    procedure AppOnIdle(Sender: TObject; var Done: Boolean);
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure SetMenu(); virtual;
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    { Public declarations }
  end;
function LoadAbuseInformation(FileName: string): Boolean;
procedure LoadServerTable();
procedure WriteConLog(MsgList: TStringList);
procedure ChangeCaptionText(Msg: PAnsiChar; nLen: Integer); stdcall;

procedure ProcessGameRun();
procedure ChangeGateSocket(boOpenGateSocket: Boolean); stdcall;
var
  FrmMain: TFrmMain;
  g_GateSocket: TServerSocket;

implementation
uses
  LocalDB, {InterServerMsg, InterMsgClient,} IdSrvClient, FSrvValue, PlugIn,
  GeneralConfig, GameConfig, FunctionConfig, ObjRobot, ViewSession,
  ViewOnlineHuman, ViewLevel, ViewList, OnlineMsg, ViewKernelInfo,
  ConfigMerchant, ItemSet, ConfigMonGen, PlugInManage, EncryptUnit, StorageEngn, SellEngn, DuelEngn,
  GameCommand, MonsterConfig, RunDB, CastleManage, PlugOfEngine, AboutUnit, HeroConfig,
  SysManager, GroupItems, AI3, PathFind;

var
  sCaption: string;
  l_dwRunTimeTick: LongWord;
  boRemoteOpenGateSocket: Boolean = False;
  boRemoteOpenGateSocketed: Boolean = False;
  dwGetLicenseTick: LongWord;
  sChar: string = ' ?';
  sRun: string = 'Run';

{$R *.dfm}

procedure ChangeCaptionText(Msg: PAnsiChar; nLen: Integer);
var
  sMsg: AnsiString;
begin
  if (nLen > 0) and (nLen < 50) then begin
    SetLength(sMsg, nLen);
    Move(Msg^, sMsg[1], nLen);
    sCaptionExtText := sMsg;
    //MainOutMessage('sCaptionExtText:'+sCaptionExtText);
  end;
end;

procedure ChangeGateSocket(boOpenGateSocket: Boolean);
begin
  boRemoteOpenGateSocket := boOpenGateSocket;
end;

function LoadAbuseInformation(FileName: string): Boolean;
var
  I: Integer;
  sText: string;
begin
  Result := False;
  if FileExists(FileName) then begin
    AbuseTextList.Clear;
    AbuseTextList.LoadFromFile(FileName);
    I := 0;
    while (True) do begin
      if AbuseTextList.Count <= I then Break;
      sText := Trim(AbuseTextList.Strings[I]);
      if sText = '' then begin
        AbuseTextList.Delete(I);
        Continue;
      end;
      Inc(I);
    end;
    Result := True;
  end;
end;

procedure LoadServerTable();
var
  I, II: Integer;
  LoadList: TStringList;
  GateList: TStringList;
  SrvNetInfo: pTSrvNetInfo;
  sLineText, sGateMsg: string;
  sServerIdx, sIPaddr, sPort: string;
begin
  for I := 0 to ServerTableList.Count - 1 do begin
    TList(ServerTableList.Items[I]).Free;
  end;
  ServerTableList.Clear;
  if FileExists('.\!servertable.txt') then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile('.\!servertable.txt');
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sGateMsg := Trim(GetValidStr3(sLineText, sGateMsg, [' ', #9]));
        if sGateMsg <> '' then begin
          GateList := TStringList.Create;
          for II := 0 to 30 do begin
            if sGateMsg = '' then Break;
            sGateMsg := Trim(GetValidStr3(sGateMsg, sIPaddr, [' ', #9]));
            sGateMsg := Trim(GetValidStr3(sGateMsg, sPort, [' ', #9]));
            if (sIPaddr <> '') and (sPort <> '') then begin
              GateList.AddObject(sIPaddr, TObject(Str_ToInt(sPort, 0)));
            end;
          end;
          ServerTableList.Add(GateList);
        end;
      end;
    end;
    FreeAndNil(LoadList);
  end else begin
    Application.MessageBox('文件!servertable.txt未找到！！！', '错误信息', MB_ICONERROR); //MB_ICONQUESTION
    //ShowMessage('文件!servertable.txt未找到！！！');
  end;
end;

procedure WriteConLog(MsgList: TStringList);
var
  I: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
begin
  if MsgList.Count <= 0 then Exit;
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  if not DirectoryExists(g_Config.sConLogDir) then begin
    //CreateDirectory(PChar(g_Config.sConLogDir),nil);
    CreateDir(g_Config.sConLogDir);
  end;
  sLogDir := g_Config.sConLogDir + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day);
  if not DirectoryExists(sLogDir) then begin
    CreateDirectory(PChar(sLogDir), nil);
  end;
  sLogFileName := sLogDir + '\C-' + IntToStr(nServerIndex) + '-' + IntToStr2(Hour) + 'H' + IntToStr2((Min div 10 * 2) * 5) + 'M.txt';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then begin
    Rewrite(LogFile);
  end else begin
    Append(LogFile);
  end;
  for I := 0 to MsgList.Count - 1 do begin
    Writeln(LogFile, '1' + #9 + MsgList.Strings[I]);
  end; // for
  CloseFile(LogFile);
end;

procedure TFrmMain.SaveItemNumber();
var
  I: Integer;
  dwRunTick: LongWord;
  boProcessLimit: Boolean;
begin
  try
    Config.WriteInteger('Setup', 'ItemNumber', g_Config.nItemNumber);
    Config.WriteInteger('Setup', 'ItemNumberEx', g_Config.nItemNumberEx);

    dwRunTick := GetTickCount();
    boProcessLimit := False;
    if g_boExitServer then g_nSaveGlobalValIdx := 0;

    for I := g_nSaveGlobalValIdx to High(g_Config.GlobalVal) do begin

      if g_TempGlobalVal[I] <> g_Config.GlobalVal[I] then begin
        g_TempGlobalVal[I] := g_Config.GlobalVal[I];
        Config.WriteInteger('Setup', 'GlobalVal' + IntToStr(I), g_Config.GlobalVal[I]);
      end;

      if g_TempGlobalAVal[I] <> g_Config.GlobalAVal[I] then begin
        g_TempGlobalAVal[I] := g_Config.GlobalAVal[I];
        Config.WriteString('Setup', 'GlobalStrVal' + IntToStr(I), g_Config.GlobalAVal[I]);
      end;
      if not g_boExitServer then begin
        if (GetTickCount - dwRunTick) > 8 then begin
          g_nSaveGlobalValIdx := I;
          boProcessLimit := True;
          //MainOutMessage('g_nSaveGlobalValIdx:'+IntToStr(g_nSaveGlobalValIdx));
          Break;
        end;
      end;
    end;

    if not boProcessLimit then begin
      g_nSaveGlobalValIdx := 0;
    end;

    Config.WriteInteger('Setup', 'WinLotteryCount', g_Config.nWinLotteryCount);
    Config.WriteInteger('Setup', 'NoWinLotteryCount', g_Config.nNoWinLotteryCount);
    Config.WriteInteger('Setup', 'WinLotteryLevel1', g_Config.nWinLotteryLevel1);
    Config.WriteInteger('Setup', 'WinLotteryLevel2', g_Config.nWinLotteryLevel2);
    Config.WriteInteger('Setup', 'WinLotteryLevel3', g_Config.nWinLotteryLevel3);
    Config.WriteInteger('Setup', 'WinLotteryLevel4', g_Config.nWinLotteryLevel4);
    Config.WriteInteger('Setup', 'WinLotteryLevel5', g_Config.nWinLotteryLevel5);
    Config.WriteInteger('Setup', 'WinLotteryLevel6', g_Config.nWinLotteryLevel6);
  except
  end;
end;

procedure TFrmMain.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
  //   MainOutMessage ('空闲');
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFrmMain.DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  tStr: string;
begin
  EnterCriticalSection(UserDBSection);
  try
    tStr := Socket.ReceiveText;
    g_Config.sDBSocketRecvText := g_Config.sDBSocketRecvText + tStr;
    //    MainOutMessage(sDBSocStr[1]);
    if not g_Config.boDBSocketWorking then begin
      g_Config.sDBSocketRecvText := '';
    end;
  finally
    LeaveCriticalSection(UserDBSection);
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  boWriteLog: Boolean;
  I: Integer;
  nRow: Integer;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  tSecond: Integer;
  sSrvType: string;
  sVerType: string;
  tTimeCount: Currency;
  GateInfo: pTGateInfo;
  //  sGate,tGate      :String;
  LogFile: TextFile;
  s28: string;
  MemoryStatus: TMemoryStatus;
begin
  if sCaptionExtText <> '' then
    Caption := sCaption + ' [' + sCaptionExtText + ']';
  EnterCriticalSection(LogMsgCriticalSection);
  try
    if MemoLog.Lines.Count > 500 then MemoLog.Clear;
    boWriteLog := True;
    if MainLogMsgList.Count > 0 then begin
      try
        if not FileExists(sLogFileName) then begin
          AssignFile(LogFile, sLogFileName);
          Rewrite(LogFile);
        end else begin
          AssignFile(LogFile, sLogFileName);
          Append(LogFile);
        end;
        boWriteLog := False;
      except
        MemoLog.Lines.Add('保存日志信息出错！！！');
      end;
    end;

    for I := 0 to MainLogMsgList.Count - 1 do begin
      MemoLog.Lines.Add(MainLogMsgList.Strings[I]);
      if not boWriteLog then begin
        Writeln(LogFile, MainLogMsgList.Strings[I]);
      end;
    end;
    MainLogMsgList.Clear;

    if not boWriteLog then CloseFile(LogFile);

    {if IdUDPClientLog.Connected then begin
      try
        IdUDPClientLog.Connect;
      except
      end;
    end; }

    //if IdUDPClientLog.Connected then begin
    for I := 0 to LogStringList.Count - 1 do begin
      try
        s28 := '1' + #9 + IntToStr(g_Config.nServerNumber) + #9 + IntToStr(nServerIndex) + #9 + LogStringList.Strings[I];
        IdUDPClientLog.Send(s28);
      except
        Continue;
      end;
    end;
    //end;

    LogStringList.Clear;
    if LogonCostLogList.Count > 0 then begin
      WriteConLog(LogonCostLogList);
    end;
    LogonCostLogList.Clear;
  finally
    LeaveCriticalSection(LogMsgCriticalSection);
  end;

{$IF SoftVersion = VERDEMO}
  sVerType := '[D]';
{$ELSEIF SoftVersion = VERFREE}
  sVerType := '[F]';
{$ELSEIF SoftVersion = VERSTD}
  sVerType := '[S]';
{$ELSEIF SoftVersion = VEROEM}
  sVerType := '[O]';
{$ELSEIF SoftVersion = VERPRO}
  sVerType := '[P]';
{$ELSEIF SoftVersion = VERENT}
  sVerType := '[E]';
{$IFEND}
  sSrvType := '[M]';
  {if nServerIndex = 0 then begin
    sSrvType := '[M]';
  end else begin
    if FrmMsgClient.MsgClient.Socket.Connected then begin
      sSrvType := '[S]';
    end else begin
      sSrvType := '[ ]';
    end;
  end; }
  LabelVersion.Caption := sSoftVersionType;

  //检查线程 运行时间
  //g_dwEngineRunTime:=GetTickCount - g_dwEngineTick;

  tSecond := (GetTickCount() - g_dwStartTick) div 1000;
  wHour := tSecond div 3600;
  wMinute := (tSecond div 60) mod 60;
  wSecond := tSecond mod 60;
  LbRunTime.Caption := IntToStr(wHour) + ':' +
    IntToStr(wMinute) + ':' +
    IntToStr(wSecond) + ' ' + sSrvType + sVerType; { +
  IntToStr(g_dwEngineRunTime) + g_sProcessName + '-' + g_sOldProcessName;}
  LbUserCount.Caption := '怪物(' + IntToStr(UserEngine.MonsterCount) + ') 人物(登录:' +
    //IntToStr(UserEngine.OnlinePlayObject) + '/' +
  IntToStr(UserEngine.LoadPlayCount) + '/释放:' +
    IntToStr(UserEngine.m_PlayObjectFreeList.Count) + '/在线:' +
    IntToStr(UserEngine.PlayObjectCount) + '/' +

  ') 英雄(登录:' + IntToStr(UserEngine.m_LoadHeroList.Count) + '/释放:' +
    IntToStr(UserEngine.m_HeroObjectFreeList.Count) + '/在线:' +
    IntToStr(UserEngine.m_HeroObjectList.Count) + ')';
  {
  Label1.Caption:= 'Run' + IntToStr(nRunTimeMin) + '/' + IntToStr(nRunTimeMax) + ' ' +
                   'Soc' + IntToStr(g_nSockCountMin) + '/' + IntToStr(g_nSockCountMax) + ' ' +
                   'Usr' + IntToStr(g_nUsrTimeMin) + '/' + IntToStr(g_nUsrTimeMax);
  }
  Label1.Caption := Format('处理(%d/%d) 传输(%d/%d) 角色(%d/%d)', [nRunTimeMin, nRunTimeMax, g_nSockCountMin, g_nSockCountMax, g_nUsrTimeMin, g_nUsrTimeMax]);
  {
  Label2.Caption:= 'Hum' + IntToStr(g_nHumCountMin) + '/' + IntToStr(g_nHumCountMax) + ' ' +
                   'Mon' + IntToStr(g_nMonTimeMin) + '/' + IntToStr(g_nMonTimeMax) + ' ' +
                   'UsrRot' + IntToStr(dwUsrRotCountMin) + '/' + IntToStr(dwUsrRotCountMax) + ' ' +
                   'Merch' + IntToStr(UserEngine.dwProcessMerchantTimeMin) + '/' + IntToStr(UserEngine.dwProcessMerchantTimeMax) + ' ' +
                   'Npc' + IntToStr(UserEngine.dwProcessNpcTimeMin) + '/' + IntToStr(UserEngine.dwProcessNpcTimeMax) + ' ' +
                   '(' + IntToStr(g_nProcessHumanLoopTime) + ')';
  }
  Label2.Caption := Format('人物(%d/%d) 循环(%d/%d) 交易(%d/%d) 管理(%d/%d) (%d)', [g_nHumCountMin,
    g_nHumCountMax,
      dwUsrRotCountMin,
      dwUsrRotCountMax,
      UserEngine.dwProcessMerchantTimeMin,
      UserEngine.dwProcessMerchantTimeMax,
      UserEngine.dwProcessNpcTimeMin,
      UserEngine.dwProcessNpcTimeMax,
      g_nProcessHumanLoopTime]);

  Label5.Caption := g_sMonGenInfo1 + ' - ' + g_sMonGenInfo2 + '    ';


  {Label20.Caption:='MonG' + IntToStr(g_nMonGenTime) + '/' + IntToStr(g_nMonGenTimeMin) + '/' + IntToStr(g_nMonGenTimeMax) + ' ' +
                   'MonP' + IntToStr(g_nMonProcTime) + '/' + IntToStr(g_nMonProcTimeMin) + '/' + IntToStr(g_nMonProcTimeMax) + ' ' +
                   'ObjRun' + IntToStr(g_nBaseObjTimeMin) + '/' + IntToStr(g_nBaseObjTimeMax);
 }
  Label20.Caption := Format('刷新怪物(%d/%d/%d) 处理怪物(%d/%d/%d) 角色处理(%d/%d)', [g_nMonGenTime, g_nMonGenTimeMin, g_nMonGenTimeMax, g_nMonProcTime, g_nMonProcTimeMin, g_nMonProcTimeMax, g_nBaseObjTimeMin, g_nBaseObjTimeMax]);

  //MemStatus.Caption:='内存: ' + IntToStr(ROUND(AllocMemSize / 1024)) + 'KB';// + ' 内存块数: ' + IntToStr(AllocMemCount);
  //Lbcheck.Caption:='check' + IntToStr(g_CheckCode.dwThread0) + '/w' + IntToStr(g_ProcessMsg.wIdent) + '/' + IntToStr(g_ProcessMsg.nParam1) + '/' +  IntToStr(g_ProcessMsg.nParam2) + '/' +  IntToStr(g_ProcessMsg.nParam3) + '/' + g_ProcessMsg.sMsg;

  if dwStartTimeTick = 0 then dwStartTimeTick := GetTickCount;
  dwStartTime := (GetTickCount - dwStartTimeTick) div 1000;

  tTimeCount := GetTickCount() / (24 * 60 * 60 * 1000);
  if tTimeCount >= 36 then LbTimeCount.Font.Color := clRed
  else LbTimeCount.Font.Color := clBlack;
  LbTimeCount.Caption := CurrToStr(tTimeCount) + '天';
  {
  //004E5B78
  for i:= Low(RunSocket.GateList) to High(RunSocket.GateList) do begin
    GateInfo:=@RunSocket.GateList[i];
    if GateInfo.boUsed and (GateInfo.Socket <> nil) then begin
      if GateInfo.nSendMsgBytes < 1024 then begin
        tGate:=IntToStr(GateInfo.nSendMsgBytes) + 'b ';
      end else begin//004E5BDA
        tGate:=IntToStr(GateInfo.nSendMsgBytes div 1024) + 'kb ';
      end;//004E5C0A
      sGate:='[G' + IntToStr(i) + ': ' +
             IntToStr(GateInfo.nSendMsgCount) + '/' +
             IntToStr(GateInfo.nSendRemainCount) + ' ' +
             tGate + IntToStr(GateInfo.nSendedMsgCount) + ']' + sGate;
    end;//004E5C90
  end;
  Label3.Caption:=sGate;
  }

  MemStatus.Caption := '内存: ' + IntToStr(ROUND(AllocMemSize / 1024)) + 'KB'; // + ' 内存块数: ' + IntToStr(AllocMemCount);

  MemoryStatus.dwLength := SizeOf(MemoryStatus);
  GlobalMemoryStatus(MemoryStatus);
  LTotalRAM.Caption := Format('%s%dM', ['物理内存总量:', MemoryStatus.dwTotalPhys div 1000000]);
  LTotalRAM.Caption := Format('ClosedEvent:%d/EventList:%d', [g_EventManager.m_ClosedEventList.Count, g_EventManager.m_EventList.Count]);

  LFreeRAM.Caption := Format('%s%dM', ['可用物理内存:', MemoryStatus.dwAvailPhys div 1000000]);
  //LTotalPage.Caption := Format('%d' + b, [ms.dwTotalPageFile]);
  //LPageFree.Caption := Format('%d' + b, [ms.dwAvailPageFile]);
  LTotalVirtual.Caption := Format('%s%dM', ['虚拟内存总量:', MemoryStatus.dwTotalVirtual div 1000000]);
  LFreeVirtual.Caption := Format('%s%dM', ['可用虚拟内存:', MemoryStatus.dwAvailVirtual div 1000000]);
  LMemoryLoad.Caption := Format('%s%d %%', ['内存使用比率:', MemoryStatus.dwMemoryLoad]);

 { s28 := s28 + Format('物理内存总量:%d M', [MemoryStatus.dwTotalPhys div 1000000]) + #13;
  s28 := s28 + Format('可用物理内存:%d M', [MemoryStatus.dwAvailPhys div 1000000]) + #13;
  s28 := s28 + Format('对换区的总量:%d M', [MemoryStatus.dwTotalPageFile div 1000000]) + #13;
  s28 := s28 + Format('可用的对换区:%d M', [MemoryStatus.dwAvailPageFile div 1000000]) + #13;
  s28 := s28 + Format('虚拟内存总量:%d M', [MemoryStatus.dwTotalVirtual div 1000000]) + #13;
  s28 := s28 + Format('可用虚拟内存:%d M', [MemoryStatus.dwAvailVirtual div 1000000]) + #13;
  s28 := s28 + Format('内存使用比率:%d %%', [MemoryStatus.dwMemoryLoad]);
  Pie.Hint := s28; }

 // GridGate

  nRow := 1;
  //for i:= Low(RunSocket.GateList) to High(RunSocket.GateList) do begin
  for I := Low(g_GateArr) to High(g_GateArr) do begin
    GridGate.Cells[0, I + 1] := '';
    GridGate.Cells[1, I + 1] := '';
    GridGate.Cells[2, I + 1] := '';
    GridGate.Cells[3, I + 1] := '';
    GridGate.Cells[4, I + 1] := '';
    GridGate.Cells[5, I + 1] := '';
    GridGate.Cells[6, I + 1] := '';
    GateInfo := @g_GateArr[I];
    //GateInfo:=@RunSocket.GateList[i];
    if GateInfo.boUsed and (GateInfo.Socket <> nil) then begin
      GridGate.Cells[0, nRow] := IntToStr(I);
      GridGate.Cells[1, nRow] := GateInfo.sAddr + ':' + IntToStr(GateInfo.nPort);
      GridGate.Cells[2, nRow] := IntToStr(GateInfo.nSendMsgCount);
      GridGate.Cells[3, nRow] := IntToStr(GateInfo.nSendedMsgCount);
      GridGate.Cells[4, nRow] := IntToStr(GateInfo.nSendRemainCount);
      if GateInfo.nSendMsgBytes < 1024 then begin
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes) + 'b';
      end else begin
        GridGate.Cells[5, nRow] := IntToStr(GateInfo.nSendMsgBytes div 1024) + 'kb';
      end;
      GridGate.Cells[6, nRow] := IntToStr(GateInfo.nUserCount) + '/' + IntToStr(GateInfo.UserList.Count);
      Inc(nRow);
    end;
  end;
  //LbRunSocketTime.Caption := 'Soc' + IntToStr(g_nGateRecvMsgLenMin) + '/' + IntToStr(g_nGateRecvMsgLenMax) { + ' Ct' + IntToStr(CertCheck.Count) + '/' + IntToStr(EventCheck.Count)};
  //LbRunSocketTime.Caption:='Sess' + IntToStr(FrmIDSoc.GetSessionCount());
  Inc(nRunTimeMax);
  if g_nSockCountMax > 0 then Dec(g_nSockCountMax);
  if g_nUsrTimeMax > 0 then Dec(g_nUsrTimeMax);
  if g_nHumCountMax > 0 then Dec(g_nHumCountMax);
  if g_nMonTimeMax > 0 then Dec(g_nMonTimeMax);
  if dwUsrRotCountMax > 0 then Dec(dwUsrRotCountMax);
  if g_nMonGenTimeMin > 1 then Dec(g_nMonGenTimeMin, 2);
  if g_nMonProcTimeMin > 1 then Dec(g_nMonProcTimeMin, 2);
  if g_nBaseObjTimeMax > 0 then Dec(g_nBaseObjTimeMax);
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  nCode, nError: Integer;

  nSize, nCRC: Cardinal;
  EngineConfig: TEngineConfig;
  Buffer: Pointer;
  sText: string;
  dwTickTime: LongWord;
begin
  SendGameCenterMsg(SG_STARTNOW, '正在启动游戏主程序...');
  StartTimer.Enabled := False;
  //Showmessage(IntToHex(4654,3));
  FrmDB := TFrmDB.Create();
  StartService();
  nError := 0;
  try
   { ShowMessage('SizeOf(THumDataInfo) ' + IntToStr(SizeOf(THumDataInfo))); //5474   3164
    ShowMessage('SizeOf(THumDataInfo)16 ' + IntToHex(SizeOf(THumDataInfo), 4));//1B16 //6934 }
    if SizeOf(THumDataInfo) <> SIZEOFTHUMAN then begin
      //ShowMessage('sizeof(THuman) ' + IntToStr(SizeOf(THumDataInfo)) + ' <> SIZEOFTHUMAN ' + IntToStr(SIZEOFTHUMAN));
      Application.MessageBox(PChar('sizeof(THuman) ' + IntToStr(SizeOf(THumDataInfo)) + ' ' + IntToHex(SizeOf(THumDataInfo), 4) + ' <> SIZEOFTHUMAN ' + IntToStr(SIZEOFTHUMAN)), '错误信息', MB_ICONERROR); //MB_ICONQUESTION
      Close;
      Exit;
    end;
{$IF CHECKCRACK = 1}
//{$I VMProtectBeginVirtualization.inc}
{$I VMProtectBeginUltra.inc}

    g_sConfigText := '';
    g_sNoticeInfo1 := ''; //MakeGM最权威最专业的传奇服务.轻松做GM!
    g_sNoticeInfo2 := ''; //Www.51pao.Com.就是要舒服.寻找新开游戏.还有MM陪你游戏!
    sText := '';
    dwTickTime := GetTickCount;

    g_nTickTime1 := nNoticeTime1;
    g_nTickTime2 := nNoticeTime2;
    EngineConfig.nNoticeTime1 := nNoticeTime1;
    EngineConfig.nNoticeTime2 := nNoticeTime2;
    //EngineConfig.boShareAllow := boShareAllow;
    g_sNoticeInfo1 := sNoticeInfo1; //MakeGM最权威最专业的传奇服务.轻松做GM!
    g_sNoticeInfo2 := sNoticeInfo2; //Www.51pao.Com.就是要舒服.寻找新开游戏.还有MM陪你游戏!

    g_sNoticeInfo3 := sNoticeInfo3; //MakeGM最权威最专业的传奇服务.轻松做GM!
    g_sNoticeInfo4 := sNoticeInfo4; //Www.51pao.Com.就是要舒服.寻找新开游戏.还有MM陪你游戏!
{$I VMProtectEnd.inc}
{$IFEND}
    if not LoadClientFile then begin
      Close;
      Exit;
    end;
{$IF DBTYPE = BDE}
    FrmDB.Query.DatabaseName := sDBName;
{$ELSE}
    FrmDB.Query.ConnectionString := g_sADODBString;
{$IFEND}
    nError := 1;
    LoadGameLogItemNameList();
    LoadDenyIPAddrList();
    LoadDenyAccountList();
    LoadDenyChrNameList();
    LoadNoClearMonList();
    LoadAICharNameList();
    LoadAIHeroNameList();
    g_Config.nServerFile_CRCB := CalcFileCRC(Application.ExeName);
    MemoLog.Lines.Add('正在加载物品数据库...');
    nCode := FrmDB.LoadItemsDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('物品数据库加载失败！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add(Format('物品数据库加载成功(%d)...', [UserEngine.StdItemList.Count]));
    MemoLog.Lines.Add('正在加载数据图文件...');
    nCode := FrmDB.LoadMinMap;
    if nCode < 0 then begin
      MemoLog.Lines.Add('小地图数据加载失败！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('小地图数据加载成功...');

    MemoLog.Lines.Add('正在加载地图数据...');
    nCode := FrmDB.LoadMapInfo;
    if nCode < 0 then begin
      MemoLog.Lines.Add('地图数据加载失败！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add(Format('地图数据加载成功(%d)...', [g_MapManager.Count]));

    MemoLog.Lines.Add('正在加载怪物数据库...');
    nCode := FrmDB.LoadMonsterDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载怪物数据库失败！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add(Format('加载怪物数据库成功(%d)...', [UserEngine.MonsterList.Count]));

    MemoLog.Lines.Add('正在加载技能数据库...');
    nCode := FrmDB.LoadMagicDB;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载技能数据库失败！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add(Format('加载技能数据库成功(%d)...', [UserEngine.m_MagicList.Count]));

    MemoLog.Lines.Add('正在加载怪物刷新配置信息...');
    nCode := FrmDB.LoadMonGen;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载怪物刷新配置信息失败！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add(Format('加载怪物刷新配置信息成功(%d)...', [g_MapManager.MonGenCount]));

    MemoLog.Lines.Add('正加载怪物说话配置信息...');
    LoadMonSayMsg();
    MemoLog.Lines.Add(Format('加载怪物说话配置信息成功(%d)...', [g_MonSayMsgList.Count]));

    nError := 2;
    LoadDisableTakeOffList();
    LoadMonDropLimitList();
    LoadDisableMakeItem();
    LoadEnableMakeItem();
    LoadDisableMoveMap;
    ItemUnit.LoadCustomItemName();
    LoadDisableSendMsgList();
    LoadItemBindIPaddr();
    LoadItemBindAccount();
    LoadItemBindCharName();
    LoadUnMasterList();
    LoadUnForceMasterList();
    LoadRememberItemList();
    LoadEnableUpgradeItem();
    nError := 3;

    LoadBoxList();

    LoadAllowPickUpItemList(); //加载允许捡取物品
    LoadAllowHumPickUpItemList();
    LoadAllowScatterItemList();
    LoadAllowSellOffItemList();

    LoadEffectList();
    LoadEffectImageList();
    LoadEffectItemList();


    MemoLog.Lines.Add('正在加载寄售物品数据库...');
    g_SellList.LoadSellList();
    g_GoldList.LoadGoldList();
    MemoLog.Lines.Add(Format('加载寄售物品数据库成功(%d/%d)...', [g_SellList.RecordCount, g_GoldList.RecordCount]));

    MemoLog.Lines.Add('正在加载无限仓库数据库...');

    g_Storage.LoadStorageList();
    MemoLog.Lines.Add(Format('加载无限仓库数据库成功(%d/%d)...', [g_Storage.HumManCount, g_Storage.RecordCount]));

    MemoLog.Lines.Add('正在加载捆装物品信息...');

    nCode := FrmDB.LoadUnbindList;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载捆装物品信息失败！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('加载捆装物品信息成功...');

    LoadBindItemTypeFromUnbindList(); {加载捆装物品类型}

    g_DuelEngine.Initialize();

    MemoLog.Lines.Add('正在加载任务地图信息...');
    nCode := FrmDB.LoadMapQuest;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载任务地图信息失败！！！');
      Exit;
    end;
    MemoLog.Lines.Add('加载任务地图信息成功...');

    MemoLog.Lines.Add('正在加载地图触发事件信息...');
    nCode := FrmDB.LoadMapEvent;
    {if nCode < 0 then begin
      MemoLog.Lines.Add('加载地图触发事件信息失败！！！');
      Exit;
    end; }
    MemoLog.Lines.Add('加载地图触发事件信息成功...');

    MemoLog.Lines.Add('正在加载地图魔法系统...');
    nCode := FrmDB.LoadMapMagicEvent;
    MemoLog.Lines.Add('加载地图魔法系统成功...');

    MemoLog.Lines.Add('正在加载任务说明信息...');
    nCode := FrmDB.LoadQuestDiary;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载任务说明信息失败！！！');
      Exit;
    end;
    MemoLog.Lines.Add('加载任务说明信息成功...');

    if LoadAbuseInformation('.\!abuse.txt') then begin
      MemoLog.Lines.Add('加载文字过滤信息成功...');
    end;

    MemoLog.Lines.Add('正在加载公告提示信息...');
    if not LoadLineNotice(g_Config.sNoticeDir + 'LineNotice.txt') then begin
      MemoLog.Lines.Add('加载公告提示信息失败！！！');
    end;
    MemoLog.Lines.Add('加载公告提示信息成功...');

    FrmDB.LoadAdminList();
    MemoLog.Lines.Add('管理员列表加载成功...');
    g_GuildManager.LoadGuildInfo();
    MemoLog.Lines.Add('行会列表加载成功...');

    g_CastleManager.LoadCastleList();
    MemoLog.Lines.Add('城堡列表加载成功...');

    g_GroupItems.LoadFromFile();

    nError := 4;
    //UserCastle.Initialize;
    g_CastleManager.Initialize;
    MemoLog.Lines.Add('城堡城初始完成...');
    {
    if (nServerIndex = 0) then FrmSrvMsg.StartMsgServer
    else FrmMsgClient.ConnectMsgServer;
    }
    StartEngine();




    boStartReady := True;
    Sleep(500);
    nError := 5;

    g_dwRunTick := GetTickCount();

    n4EBD1C := 0;
    g_dwUsrRotCountTick := GetTickCount();

    RunTimer.Enabled := True;
    SendGameCenterMsg(SG_STARTOK, '游戏主程序启动完成...');
    GateSocket.Address := g_Config.sGateAddr;
    GateSocket.Port := g_Config.nGatePort;
    g_GateSocket := GateSocket;
    nError := 6;

    SendGameCenterMsg(SG_CHECKCODEADDR, IntToStr(Integer(@g_CheckCode)));
  except
    on E: Exception do
      MainOutMessage('服务器启动异常！！！' + E.Message + IntToStr(nError));
  end;
end;

procedure TFrmMain.StartEngine();
var
  Buffer: Pointer;
  sText: string;
  sBuffer: string;
  nLen: Integer;
  nCode, nError: Integer;
begin
  try
    nError := 1;
    Application.ProcessMessages;
    FrmIDSoc.Initialize;
    MemoLog.Lines.Add('登录服务器连接初始化完成...');

    nError := 2;
    Application.ProcessMessages;
    g_MapManager.LoadMapDoor;
    MemoLog.Lines.Add('地图环境加载成功...');
    nError := 3;
    Application.ProcessMessages;
    MakeStoneMines();
    MemoLog.Lines.Add('矿物数据初始成功...');
    nError := 4;
    Application.ProcessMessages;
    nCode := FrmDB.LoadMerchant;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load Merchant Error ！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('交易NPC列表加载成功...');
    nError := 5;
    Application.ProcessMessages;
    if not g_Config.boVentureServer then begin
      nCode := FrmDB.LoadGuardList;
      if nCode < 0 then begin
        MemoLog.Lines.Add('Load GuardList Error ！！！' + 'Code: ' + IntToStr(nCode));
      end;
      MemoLog.Lines.Add('守卫列表加载成功...');
    end;
    nError := 6;
    Application.ProcessMessages;
    nCode := FrmDB.LoadNpcs;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load NpcList Error ！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('管理NPC列表加载成功...');
    nError := 7;
    Application.ProcessMessages;
    nCode := FrmDB.LoadMakeItem;
    if nCode < 0 then begin
      MemoLog.Lines.Add('Load MakeItem Error ！！！' + 'Code: ' + IntToStr(nCode));
      Exit;
    end;
    MemoLog.Lines.Add('炼制物品信息加载成功...');
    nError := 8;
    Application.ProcessMessages;
    nCode := FrmDB.LoadStartPoint;
    if nCode < 0 then begin
      MemoLog.Lines.Add('加载回城点配置时出现错误 ！！！(错误码: ' + IntToStr(nCode) + ')');
      Close;
    end;
    MemoLog.Lines.Add('回城点配置加载成功...');
    nError := 9;
    Application.ProcessMessages;
    FrontEngine.Resume;
    MemoLog.Lines.Add('人物数据引擎启动成功...');
    nError := 10;
    Application.ProcessMessages;
    UserEngine.Initialize;
    MemoLog.Lines.Add('游戏处理引擎初始化成功...');
    nError := 11;
    Application.ProcessMessages;
    g_MapManager.MakeSafePkZone; //安全区光圈
    nError := 12;
    sCaptionExtText := '正在初始化引擎插件...';
    Caption := sCaption + ' [' + sCaptionExtText + ']';

    LoadStringList;
{$IF DBSOCKETMODE = THREADENGINE}
    DataEngine.Active := True;
{$IFEND}
    Application.ProcessMessages;

    MainOutMessage(sProductInfo);
    MainOutMessage(sWebSite);
    MainOutMessage(sBbsSite);
    MainOutMessage(sSellInfo1);

    Application.ProcessMessages;

    PlugInEngine.StartPlugMoudle;

    MainOutMessage('引擎插件初始化成功...');
    ChangeGateSocket(True);
    sCaptionExtText:='www.MirYQ.com 无需注册，无广告，无功能限制版';
    Sleep(1000);
    //if g_boMinimize then Application.Minimize; //启动完成后最小化
    //if g_boMinimize then SendMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
  except
    MainOutMessage('服务启动时出现异常错误 ！！！' + IntToStr(nError));
  end;
end;

procedure TFrmMain.MakeStoneMines();
var
  I, nW, nH: Integer;
  Envir: TEnvirnoment;
begin
  for I := 0 to g_MapManager.Count - 1 do begin
    Envir := TEnvirnoment(g_MapManager.Items[I]);
    if Envir.m_boMINE then begin
      for nW := 0 to Envir.m_nWidth - 1 do begin
        for nH := 0 to Envir.m_nHeight - 1 do begin
          //if (nW mod 2 = 0) and (nH mod 2 = 0) then
          g_EventManager.AddEvent(TStoneMineEvent.Create(Envir, nW, nH, ET_STONEMINE), False);
        end;
      end;
    end;
  end;
end;

function TFrmMain.LoadClientFile(): Boolean;
begin
  MemoLog.Lines.Add('正在加载客户端版本信息...');
  if not (g_Config.sClientFile1 = '') then g_Config.nClientFile1_CRC := CalcFileCRC(g_Config.sClientFile1);
  if not (g_Config.sClientFile2 = '') then g_Config.nClientFile2_CRC := CalcFileCRC(g_Config.sClientFile2);
  if not (g_Config.sClientFile3 = '') then g_Config.nClientFile3_CRC := CalcFileCRC(g_Config.sClientFile3);
  if (g_Config.nClientFile1_CRC <> 0) or (g_Config.nClientFile2_CRC <> 0) or (g_Config.nClientFile3_CRC <> 0) then begin
    MemoLog.Lines.Add('加载客户端版本信息成功...');
    Result := True;
  end else begin
    MemoLog.Lines.Add('加载客户端版本信息失败！！！');
    Result := False;
  end;
  Result := True;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
  Year, Month, Day: Word;
  //ScriptConfig: TScriptConfig;
  //EngineOption:TEngineOption;
resourcestring
  //sDemoVersion = '演示版';
  sGateIdx = '网关';
  sGateIPaddr = '网关地址';
  sGateListMsg = '队列数据';
  sGateSendCount = '发送数据';
  sGateMsgCount = '剩余数据';
  sGateSendKB = '平均流量';
  sGateUserCount = '最高人数';
begin
  Randomize;
  //ShowMessage(IntToStr(Length(EncryptBuffer(@ScriptConfig, SizeOf(TScriptConfig)))));
  //ShowMessage(IntToStr(Length(EncryptBuffer(@ConfigOption, SizeOf(TConfigOption)))));

  g_dwGameCenterHandle := Str_ToInt(ParamStr(1), 0);
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then begin
    Left := nX;
    Top := nY;
  end;
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
  GridGate.RowCount := 21;
  GridGate.ColWidths[0] := 30;
  GridGate.ColWidths[1] := 90;
  GridGate.Cells[0, 0] := sGateIdx;
  GridGate.Cells[1, 0] := sGateIPaddr;
  GridGate.Cells[2, 0] := sGateListMsg;
  GridGate.Cells[3, 0] := sGateSendCount;
  GridGate.Cells[4, 0] := sGateMsgCount;
  GridGate.Cells[5, 0] := sGateSendKB;
  GridGate.Cells[6, 0] := sGateUserCount;

  GateSocket := TServerSocket.Create(Owner);
  GateSocket.OnClientConnect := GateSocketClientConnect;
  GateSocket.OnClientDisconnect := GateSocketClientDisconnect;
  GateSocket.OnClientError := GateSocketClientError;
  GateSocket.OnClientRead := GateSocketClientRead;

{$IF DBSOCKETMODE = TIMERENGINE}
  DBSocket.OnConnect := DBSocketConnect;
  DBSocket.OnDisconnect := DBSocketDisconnect;
  DBSocket.OnError := DBSocketError;
  DBSocket.OnRead := DBSocketRead;
{$IFEND}
  //for nX := 0 to Length(g_BooleanArray) - 1 do
    //g_BooleanArray[nX] := True;

  Timer1.OnTimer := Timer1Timer;

  RunTimer.OnTimer := RunTimerTimer;

  StartTimer.OnTimer := StartTimerTimer;
  SaveVariableTimer.OnTimer := SaveVariableTimerTimer;
{$IF DBSOCKETMODE = TIMERENGINE}
  ConnectTimer.OnTimer := ConnectTimerTimer;
{$IFEND}
  CloseTimer.OnTimer := CloseTimerTimer;
  MemoLog.OnChange := MemoLogChange;
  StartTimer.Enabled := True;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
resourcestring
  sCloseServerYesNo = '是否确认关闭游戏服务器？';
  sCloseServerTitle = '确认信息';
begin
  if not boServiceStarted then begin
    //    Application.Terminate;
    Exit;
  end;
  if g_boExitServer then begin
    boStartReady := False;
    Exit;
  end;
  CanClose := False;
  if Application.MessageBox(PChar(sCloseServerYesNo), PChar(sCloseServerTitle), MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    g_boExitServer := True;
    CloseGateSocket();
    g_Config.boKickAllUser := True;
    // RunSocket.CloseAllGate;
    //    GateSocket.Close;
    CloseTimer.Enabled := True;
  end;
end;

procedure TFrmMain.CloseTimerTimer(Sender: TObject);

resourcestring
  sCloseServer = '%s [正在关闭服务器(%s %d/%s %d)...]';
  sCloseServer1 = '%s [服务器已关闭]';
begin
  Caption := Format(sCloseServer, [g_Config.sServerName, '人物', UserEngine.OnlinePlayObject, '数据', FrontEngine.SaveListCount]);
  if UserEngine.OnlinePlayObject = 0 then begin
    if FrontEngine.IsIdle then begin
      CloseTimer.Enabled := False;
      Caption := Format(sCloseServer1, [g_Config.sServerName]);
      StopService;
      Close;
    end;
  end;
end;

procedure TFrmMain.SaveVariableTimerTimer(Sender: TObject);
begin
  SaveItemNumber();
end;

procedure TFrmMain.GateSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  RunSocket.CloseErrGate(Socket, ErrorCode);
end;

procedure TFrmMain.GateSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.CloseGate(Socket);
end;

procedure TFrmMain.GateSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.AddGate(Socket);
end;

procedure TFrmMain.GateSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.SocketRead(Socket);
end;

procedure TFrmMain.RunTimerTimer(Sender: TObject);
begin
  if boStartReady then begin
    RunSocket.Execute;

    FrmIDSoc.Run;

    UserEngine.Execute;

    ProcessGameRun();

  end;
  Inc(n4EBD1C);
  if (GetTickCount - g_dwRunTick) > 250 then begin
    g_dwRunTick := GetTickCount();
    nRunTimeMin := n4EBD1C;
    if nRunTimeMax > nRunTimeMin then nRunTimeMax := nRunTimeMin;
    n4EBD1C := 0;
  end;
  if boRemoteOpenGateSocket then begin
    if not boRemoteOpenGateSocketed then begin
      boRemoteOpenGateSocketed := True;
      try
        if Assigned(g_GateSocket) then begin
          g_GateSocket.Active := True;
        end;
      except
        on E: Exception do begin
          MainOutMessage(E.Message);
        end;
      end;
    end;
  end else begin
    if Assigned(g_GateSocket) then begin
      if g_GateSocket.Socket.Connected then
        g_GateSocket.Active := False;
    end;
  end;
end;

procedure TFrmMain.ConnectTimerTimer(Sender: TObject);
begin

end;

procedure TFrmMain.ReloadConfig(Sender: TObject);
begin
  LoadConfig();
  FrmIDSoc.Timer1Timer(Sender);
  IdUDPClientLog.Host := g_Config.sLogServerAddr;
  IdUDPClientLog.Port := g_Config.nLogServerPort;
  LoadServerTable();
  LoadClientFile();
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 500 then MemoLog.Clear;
end;

procedure TFrmMain.MemoLogDblClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_CONTROL_REFSERVERCONFIGClick(Sender: TObject);
begin
  UserEngine.RefServerConfig;
  MainOutMessage('客户端配制信息刷新完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_CONFClick(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_CLEARLOGMSGClick(Sender: TObject);
begin
  ClearMemoLog();
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  ReloadConfig(Sender);
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_ITEMDBClick(Sender: TObject);
begin
  FrmDB.LoadItemsDB();
  MainOutMessage('重新加载物品数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MAGICDBClick(Sender: TObject);
begin
  FrmDB.LoadMagicDB();
  MainOutMessage('重新加载技能数据库完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERDBClick(Sender: TObject);
begin
  FrmDB.LoadMonsterDB();
  MainOutMessage('重新加载怪物数据库完成...');
end;

procedure TFrmMain.StartService;
var
  TimeNow: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  F: TextFile;
  Config: pTConfig;
  s: string;
begin
  Config := @g_Config;
  nRunTimeMax := 99999;
  g_nSockCountMax := 0;
  g_nUsrTimeMax := 0;
  g_nHumCountMax := 0;
  g_nMonTimeMax := 0;
  g_nMonGenTimeMax := 0;
  g_nMonProcTime := 0;
  g_nMonProcTimeMin := 0;
  g_nMonProcTimeMax := 0;
  dwUsrRotCountMin := 0;
  dwUsrRotCountMax := 0;
  g_nProcessHumanLoopTime := 0;
  g_dwHumLimit := 30;
  g_dwMonLimit := 30;
  g_dwZenLimit := 5;
  g_dwNpcLimit := 5;
  g_dwSocLimit := 10;
  nDecLimit := 20;
  Config.sDBSocketRecvText := '';
  Config.sDBSocketBufferText := '';
  Config.boDBSocketWorking := False;
  Config.nLoadDBErrorCount := 0;
  Config.nLoadDBCount := 0;
  Config.nSaveDBCount := 0;
  Config.nDBQueryID := 0;
  Config.nItemNumber := 0;
  Config.nItemNumberEx := High(Integer) div 2;
  boStartReady := False;
  g_boExitServer := False;
  boFilterWord := True;
  Config.nWinLotteryCount := 0;
  Config.nNoWinLotteryCount := 0;
  Config.nWinLotteryLevel1 := 0;
  Config.nWinLotteryLevel2 := 0;
  Config.nWinLotteryLevel3 := 0;
  Config.nWinLotteryLevel4 := 0;
  Config.nWinLotteryLevel5 := 0;
  Config.nWinLotteryLevel6 := 0;
  FillChar(g_Config.GlobalVal, SizeOf(g_Config.GlobalVal), #0);
  FillChar(g_Config.GlobaDyMval, SizeOf(g_Config.GlobaDyMval), #0);
  FillChar(g_Config.GlobalAVal, SizeOf(g_Config.GlobalAVal), #0);

  FillChar(g_TempGlobalVal, SizeOf(g_TempGlobalVal), #0);
  FillChar(g_TempGlobalAVal, SizeOf(g_TempGlobalAVal), #0);
{$IF USECODE = USEREMOTECODE}
  New(Config.Encode6BitBuf);
  Config.Encode6BitBuf^ := g_Encode6BitBuf;

  New(Config.Decode6BitBuf);
  Config.Decode6BitBuf^ := g_Decode6BitBuf;
{$IFEND}
  LoadConfig();


  Memo := MemoLog;
  nServerIndex := 0;
  PlugInEngine := TPlugInManage.Create;
  RunSocket := TRunSocket.Create();
  MainLogMsgList := TStringList.Create;
  LogStringList := TStringList.Create;
  LogonCostLogList := TStringList.Create;
  g_MapManager := TMapManager.Create;
  ItemUnit := TItemUnit.Create;
  MagicManager := TMagicManager.Create;
  NoticeManager := TNoticeManager.Create;
  g_GuildManager := TGuildManager.Create;
  g_EventManager := TEventManager.Create;
  g_CastleManager := TCastleManager.Create;
  g_ItemManager := TItemManager.Create;

{$IF DBSOCKETMODE = THREADENGINE}
  DataEngine := TDataEngine.Create;
{$IFEND}
  FrontEngine := TFrontEngine.Create(True);
  UserEngine := TUserEngine.Create();
  RobotManage := TRobotManage.Create;
  g_MakeItemList := TStringList.Create;
  g_StartPointList := TStringList.Create;
  ServerTableList := TList.Create;
  g_DenySayMsgList := TQuickList.Create;
  MiniMapList := TStringList.Create;
  g_UnbindList := TStringList.Create;
  LineNoticeList := TStringList.Create;
  QuestDiaryList := TList.Create;
  ItemEventList := TStringList.Create;
  AbuseTextList := TStringList.Create;
  g_MonSayMsgList := TStringList.Create;
  g_DisableMakeItemList := TGStringList.Create;
  g_EnableMakeItemList := TGStringList.Create;
  g_DisableMoveMapList := TGStringList.Create;
  g_ItemNameList := TGList.Create;
  g_DisableSendMsgList := TGStringList.Create;
  g_MonDropLimitLIst := TGStringList.Create;
  g_DisableTakeOffList := TGStringList.Create;
  g_UnMasterList := TGStringList.Create;
  g_UnForceMasterList := TGStringList.Create;
  g_GameLogItemNameList := TGStringList.Create;
  g_DenyIPAddrList := TGStringList.Create;
  g_DenyChrNameList := TGStringList.Create;
  g_DenyAccountList := TGStringList.Create;
  g_NoClearMonList := TGStringList.Create;

  g_EnableUpgradeItemList := TGStringList.Create;

  g_ItemBindIPaddr := TGList.Create;
  g_ItemBindAccount := TGList.Create;
  g_ItemBindCharName := TGList.Create;

  g_AllowSellOffItemList := TGStringList.Create;

  g_SellList := TSellEngine.Create;
  g_GoldList := TGoldEngine.Create;
  g_Storage := TStorageEngine.Create;

  g_MapEventListOfDropItem := TGList.Create;
  g_MapEventListOfPickUpItem := TGList.Create;
  g_MapEventListOfMine := TGList.Create;
  g_MapEventListOfWalk := TGList.Create;
  g_MapEventListOfRun := TGList.Create;

  g_DuelEngine := TDuelEngine.Create;

  g_ItemBoxList := TGStringList.Create;

  g_GroupItems := TGroupItems.Create;

  g_AICharNameList := TGStringList.Create;
  g_AIHeroNameList := TGStringList.Create;
  g_AI3 := TAI3.Create;

  g_FindPath := TFindPath.Create();
  //g_MemoryIniFileList := TStringList.Create;

  g_AllowPickUpItemList := TGStringList.Create;
  g_AllowHumPickUpItemList := TGStringList.Create;
  InitializeCriticalSection(LogMsgCriticalSection);
  InitializeCriticalSection(ProcessMsgCriticalSection);
  InitializeCriticalSection(ProcessHumanCriticalSection);
  InitializeCriticalSection(HumanSortCriticalSection);
  InitializeCriticalSection(Config.UserIDSection);
  InitializeCriticalSection(UserDBSection);
  CS_6 := TCriticalSection.Create;
  g_DynamicVarList := TList.Create;

  TimeNow := Now();
  DecodeDate(TimeNow, Year, Month, Day);
  DecodeTime(TimeNow, Hour, Min, Sec, MSec);
  if not DirectoryExists(g_Config.sLogDir) then begin
    CreateDir(Config.sLogDir);
  end;

  sLogFileName := g_Config.sLogDir {'.\Log\'} + IntToStr(Year) + '-' + IntToStr2(Month) + '-' + IntToStr2(Day) + '.' + IntToStr2(Hour) + '-' + IntToStr2(Min) + '.txt';
  AssignFile(F, sLogFileName);
  Rewrite(F);
  CloseFile(F);
  Caption := '';

  g_MemoryStream := TMemoryStream.Create;
  g_MemoryStream.LoadFromFile(Application.ExeName);

  g_nTickTime1 := 60;
  g_nTickTime1 := 60;

  PlugInEngine.HookChangeCaptionText(ChangeCaptionText);
  PlugInEngine.HookChangeGateSocket(ChangeGateSocket);
  PlugInEngine.HookGetMaxPlayObjectCount(TUserEngine_GetMaxPlayObjectCount);
  PlugInEngine.HookSetMaxPlayObjectCount(TUserEngine_SetMaxPlayObjectCount);

  PlugInEngine.LoadPlugIn();
  MemoLog.Lines.Add('正在读取配置信息...');
  nShiftUsrDataNameNo := 1;

  Caption := g_Config.sServerName;
  sCaption := g_Config.sServerName;
  LoadServerTable();

  sSoftVersionType := DeCodeString(sSoftVersion_HERO); //英雄版
  MENU_OPTION_HERO.Visible := True;

  IdUDPClientLog.Host := g_Config.sLogServerAddr;
  IdUDPClientLog.Port := g_Config.nLogServerPort;

  Application.OnIdle := AppOnIdle;
  Application.OnException := OnProgramException;
  dwRunDBTimeMax := GetTickCount();
  g_dwStartTick := GetTickCount();
  Timer1.Enabled := True;
  boServiceStarted := True;
end;

procedure TFrmMain.StopService;
var
  I, II: Integer;
  ItemBox: pTItemBox;
  Config: pTConfig;
  ThreadInfo: pTThreadInfo;
  QDDinfoList: TList;
  QDDinfo: pTQDDinfo;
  nError: Integer;
begin
  try
    nError := 0;
    Config := @g_Config;
    nError := 1;
    PlugInEngine.Free;
    nError := 2;
    Timer1.Enabled := False;
    nError := 3;
    RunTimer.Enabled := False;
    nError := 4;

    FrmIDSoc.Close;
    nError := 5;

    g_EventManager.Free;
    nError := 18;
    g_ItemManager.Free;

    g_CastleManager.Free;

    g_MapManager.Free;

    GateSocket.Close;
    nError := 6;
    Memo := nil;
    SaveItemNumber();
    nError := 7;

    nError := 8;
    FrontEngine.Terminate();
    nError := 9;
    FrontEngine.Free;
    nError := 10;
    MagicManager.Free;

    nError := 77;
{$IF DBSOCKETMODE = THREADENGINE}
    //DataEngine.Active := False;
    DataEngine.Terminate();
    nError := 78;
    DataEngine.Free;
{$IFEND}

    nError := 11;
    UserEngine.Free;
    nError := 12;
    RobotManage.Free;
    nError := 13;
    RunSocket.Free;
    nError := 14;
    UnLoadStringList;
    nError := 15;
    FreeAndNil(MainLogMsgList);
    nError := 16;
    FreeAndNil(LogStringList);
    nError := 17;
    FreeAndNil(LogonCostLogList);

    nError := 19;
    ItemUnit.Free;
    nError := 20;
    NoticeManager.Free;
    nError := 21;
    g_GuildManager.Free;
    nError := 22;

    for I := 0 to g_MakeItemList.Count - 1 do begin
      TStringList(g_MakeItemList.Objects[I]).Free;
    end;

    nError := 23;
    for I := 0 to g_StartPointList.Count - 1 do begin
      Dispose(pTStartPoint(g_StartPointList.Objects[I]));
    end;
    FreeAndNil(g_StartPointList);
    nError := 24;

    for I := 0 to QuestDiaryList.Count - 1 do begin
      QDDinfoList := QuestDiaryList.Items[I];
      if QDDinfoList = nil then Continue;
      for II := 0 to QDDinfoList.Count - 1 do begin
        QDDinfo := QDDinfoList.Items[II];
        QDDinfo.sList.Free;
        Dispose(QDDinfo);
      end;
      QDDinfoList.Free;
    end;

    nError := 25;
    FreeAndNil(g_MakeItemList);
    nError := 26;
    FreeAndNil(ServerTableList);
    nError := 27;
    FreeAndNil(g_DenySayMsgList);
    nError := 28;
    FreeAndNil(MiniMapList);
    nError := 29;
    FreeAndNil(g_UnbindList);
    nError := 30;
    FreeAndNil(LineNoticeList);
    nError := 31;
    FreeAndNil(QuestDiaryList);
    nError := 32;
    FreeAndNil(ItemEventList);
    nError := 33;
    FreeAndNil(AbuseTextList);
    nError := 34;
    FreeAndNil(g_MonSayMsgList);
    nError := 35;
    FreeAndNil(g_DisableMakeItemList);
    nError := 36;
    FreeAndNil(g_EnableMakeItemList);
    nError := 37;
    FreeAndNil(g_DisableMoveMapList);
    nError := 38;
    FreeAndNil(g_ItemNameList);
    nError := 39;
    FreeAndNil(g_DisableSendMsgList);
    nError := 40;
    FreeAndNil(g_MonDropLimitLIst);
    nError := 41;
    FreeAndNil(g_DisableTakeOffList);
    nError := 42;
    FreeAndNil(g_UnMasterList);
    nError := 43;
    FreeAndNil(g_UnForceMasterList);
    nError := 44;
    FreeAndNil(g_GameLogItemNameList);
    nError := 45;
    FreeAndNil(g_DenyIPAddrList);
    nError := 46;
    FreeAndNil(g_DenyChrNameList);
    nError := 47;
    FreeAndNil(g_DenyAccountList);
    nError := 48;
    FreeAndNil(g_NoClearMonList);
    nError := 49;
    FreeAndNil(g_AllowSellOffItemList);
    nError := 50;
    FreeAndNil(g_SellList);
    nError := 51;
    FreeAndNil(g_GoldList);
    nError := 52;
    FreeAndNil(g_Storage);
    nError := 53;
    FreeAndNil(g_EnableUpgradeItemList);
    nError := 54;
    for I := 0 to g_ItemBindIPaddr.Count - 1 do begin
      Dispose(pTItemBind(g_ItemBindIPaddr.Items[I]));
    end;
    nError := 55;
    for I := 0 to g_ItemBindAccount.Count - 1 do begin
      Dispose(pTItemBind(g_ItemBindAccount.Items[I]));
    end;
    nError := 56;
    for I := 0 to g_ItemBindCharName.Count - 1 do begin
      Dispose(pTItemBind(g_ItemBindCharName.Items[I]));
    end;
    nError := 57;
    FreeAndNil(g_ItemBindIPaddr);
    nError := 58;
    FreeAndNil(g_ItemBindAccount);
    nError := 59;
    FreeAndNil(g_ItemBindCharName);
    nError := 60;
    for I := 0 to g_MapEventListOfDropItem.Count - 1 do begin
      Dispose(pTMapEvent(g_MapEventListOfDropItem.Items[I]));
    end;
    FreeAndNil(g_MapEventListOfDropItem);
    nError := 61;
    for I := 0 to g_MapEventListOfPickUpItem.Count - 1 do begin
      Dispose(pTMapEvent(g_MapEventListOfPickUpItem.Items[I]));
    end;
    FreeAndNil(g_MapEventListOfPickUpItem);
    nError := 62;
    for I := 0 to g_MapEventListOfMine.Count - 1 do begin
      Dispose(pTMapEvent(g_MapEventListOfMine.Items[I]));
    end;
    FreeAndNil(g_MapEventListOfMine);
    nError := 63;
    for I := 0 to g_MapEventListOfWalk.Count - 1 do begin
      Dispose(pTMapEvent(g_MapEventListOfWalk.Items[I]));
    end;
    FreeAndNil(g_MapEventListOfWalk);
    nError := 64;
    for I := 0 to g_MapEventListOfRun.Count - 1 do begin
      Dispose(pTMapEvent(g_MapEventListOfRun.Items[I]));
    end;
    FreeAndNil(g_MapEventListOfRun);
    nError := 65;
    g_DuelEngine.Free;
    nError := 66;
    for I := 0 to g_ItemBoxList.Count - 1 do begin
      ItemBox := pTItemBox(g_ItemBoxList.Objects[I]);
      for II := 0 to ItemBox.ItemList.Count - 1 do begin
        Dispose(pTBoxItem(ItemBox.ItemList.Objects[II]));
      end;
      ItemBox.ItemList.Free;
      Dispose(ItemBox);
    end;
    g_ItemBoxList.Free;
    nError := 67;

    g_GroupItems.Free;
    nError := 68;
    FreeAndNil(g_AICharNameList);
    FreeAndNil(g_AIHeroNameList);
    nError := 69;
    FreeAndNil(g_AI3);
    g_FindPath.Free;
    nError := 70;

   { for I := 0 to g_MemoryIniFileList.Count - 1 do
      g_MemoryIniFileList.Objects[I].Free;

    g_MemoryIniFileList.Free; }

    UnLoadEffectList();
    UnLoadEffectImageList();
    UnLoadEffectItemList();

    if g_PlayRobotNPC <> nil then
      g_PlayRobotNPC.Free;

    nError := 71;
    DeleteCriticalSection(LogMsgCriticalSection);
    DeleteCriticalSection(ProcessMsgCriticalSection);
    DeleteCriticalSection(ProcessHumanCriticalSection);
    DeleteCriticalSection(HumanSortCriticalSection);
    DeleteCriticalSection(Config.UserIDSection);
    DeleteCriticalSection(UserDBSection);
    nError := 72;
    FreeAndNil(CS_6);
    nError := 73;
    for I := 0 to g_DynamicVarList.Count - 1 do begin
      Dispose(pTDynamicVar(g_DynamicVarList.Items[I]));
    end;
    FreeAndNil(g_DynamicVarList);
    nError := 74;
    if g_BindItemTypeList <> nil then begin
      for I := 0 to g_BindItemTypeList.Count - 1 do begin
        Dispose(pTBindItem(g_BindItemTypeList.Items[I]));
      end;
      FreeAndNil(g_BindItemTypeList);
    end;
    nError := 75;
    FreeAndNil(g_AllowPickUpItemList);
    FreeAndNil(g_AllowHumPickUpItemList);
    FreeAndNil(g_AllowScatterItemList);
    nError := 76;
    for I := 0 to g_RememberItemList.Count - 1 do begin
      Dispose(pTItemEvent(g_RememberItemList.Objects[I]));
    end;
    FreeAndNil(g_RememberItemList);
    FreeAndNil(g_MemoryStream);


    boServiceStarted := False;
  except
    on E: Exception do begin
      ShowMessage('错误信息:' + E.Message + ' Error:=' + IntToStr(nError));
    end;
  end;
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  FrmAbout := TFrmAbout.Create(Owner);
  FrmAbout.Open();
  FrmAbout.Free;
end;

procedure TFrmMain.DBSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  MainOutMessage('数据库服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接成功...');
  g_nSaveRcdErrorCount := 0;
end;

procedure TFrmMain.MENU_OPTION_SERVERCONFIGClick(Sender: TObject);
begin
  FrmServerValue := TFrmServerValue.Create(Owner);
  FrmServerValue.Top := Self.Top + 20;
  FrmServerValue.Left := Self.Left;
  FrmServerValue.AdjuestServerConfig();
  FrmServerValue.Free;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig := TfrmGeneralConfig.Create(Owner);
  frmGeneralConfig.Top := Self.Top + 20;
  frmGeneralConfig.Left := Self.Left;
  frmGeneralConfig.Open();
  frmGeneralConfig.Free;
end;

procedure TFrmMain.MENU_OPTION_GAMEClick(Sender: TObject);
begin
  frmGameConfig := TfrmGameConfig.Create(Owner);
  frmGameConfig.Top := Self.Top + 20;
  frmGameConfig.Left := Self.Left;
  frmGameConfig.Open;
  frmGameConfig.Free;
end;

procedure TFrmMain.MENU_OPTION_FUNCTIONClick(Sender: TObject);
begin
  frmFunctionConfig := TfrmFunctionConfig.Create(Owner);
  frmFunctionConfig.Top := Self.Top + 20;
  frmFunctionConfig.Left := Self.Left;
  frmFunctionConfig.Open;
  frmFunctionConfig.Free;
end;

procedure TFrmMain.G1Click(Sender: TObject);
begin
  frmGameCmd := TfrmGameCmd.Create(Owner);
  frmGameCmd.Top := Self.Top + 20;
  frmGameCmd.Left := Self.Left;
  frmGameCmd.Open;
  frmGameCmd.Free;
end;

procedure TFrmMain.MENU_OPTION_MONSTERClick(Sender: TObject);
begin
  frmMonsterConfig := TfrmMonsterConfig.Create(Owner);
  frmMonsterConfig.Top := Self.Top + 20;
  frmMonsterConfig.Left := Self.Left;
  frmMonsterConfig.Open;
  frmMonsterConfig.Free;
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_MONSTERSAYClick(Sender: TObject);
begin
  UserEngine.ClearMonSayMsg();
  LoadMonSayMsg();
  MainOutMessage('重新加载怪物说话配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_DISABLEMAKEClick(Sender: TObject);
begin
  LoadDisableTakeOffList();
  LoadDisableMakeItem();
  LoadEnableMakeItem();
  LoadDisableMoveMap();
  ItemUnit.LoadCustomItemName();
  LoadDisableSendMsgList();
  LoadGameLogItemNameList();
  LoadItemBindIPaddr();
  LoadItemBindAccount();
  LoadItemBindCharName();
  LoadUnMasterList();
  LoadUnForceMasterList();
  LoadDenyIPAddrList();
  LoadDenyAccountList();
  LoadDenyChrNameList();
  LoadNoClearMonList();
  LoadAllowSellOffItemList();
  LoadEnableUpgradeItem();

  LoadBoxList();
  LoadAICharNameList();
  LoadAIHeroNameList();
  g_GroupItems.LoadFromFile();
  FrmDB.LoadAdminList();
  MainOutMessage('重新加载列表配置完成...');
end;

procedure TFrmMain.MENU_CONTROL_RELOAD_STARTPOINTClick(Sender: TObject);
begin
  FrmDB.LoadStartPoint();
  MainOutMessage('重新地图安全区列表完成...');
end;

procedure TFrmMain.MENU_CONTROL_GATE_OPENClick(Sender: TObject);
resourcestring
  sGatePortOpen = '游戏网关端口(%s:%d)已打开...';
begin
  if not GateSocket.Active then begin
    GateSocket.Active := True;
    MainOutMessage(Format(sGatePortOpen, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROL_GATE_CLOSEClick(Sender: TObject);
begin
  CloseGateSocket();
end;

procedure TFrmMain.CloseGateSocket;
var
  I: Integer;
resourcestring
  sGatePortClose = '游戏网关端口(%s:%d)已关闭...';
begin
  if GateSocket.Active then begin
    for I := 0 to GateSocket.Socket.ActiveConnections - 1 do begin
      GateSocket.Socket.Connections[I].Close;
    end;
    GateSocket.Active := False;
    MainOutMessage(Format(sGatePortClose, [GateSocket.Address, GateSocket.Port]));
  end;
end;

procedure TFrmMain.MENU_CONTROLClick(Sender: TObject);
begin
  if GateSocket.Active then begin
    MENU_CONTROL_GATE_OPEN.Enabled := False;
    MENU_CONTROL_GATE_CLOSE.Enabled := True;
  end else begin
    MENU_CONTROL_GATE_OPEN.Enabled := True;
    MENU_CONTROL_GATE_CLOSE.Enabled := False;
  end;
end;

{procedure ProcessItemRun;
var
  I, nIdx, nError: Integer;
  ItemObject: TItemObject;
  dwCurTick, dwCheckTime: LongWord;
  boCheckTimeLimit: Boolean;
resourcestring
  sExceptionMsg1 = '[Exception] ProcessItemRun::Run';
  sExceptionMsg2 = '[Exception] ProcessItemRun::Run Free';
begin
  try
    nError := 0;
    boCheckTimeLimit := False;
    dwCheckTime := GetTickCount();
    dwCurTick := GetTickCount();
    nError := 1;
    nIdx := g_nProcItemIDx;
    nError := 2;

    nError := 3;
    while True do begin
      nError := 3;
      if g_ItemList.Count <= nIdx then Break;
      nError := 4;
      ItemObject := TItemObject(g_ItemList.Items[nIdx]);
      nError := 5;
      if (not ItemObject.m_boGhost) and ((GetTickCount - ItemObject.m_dwRunTick) > 250) then begin
        nError := 6;
        //MainOutMessage('ItemObject.Run');
        ItemObject.m_dwRunTick := GetTickCount();
        nError := 7;
        ItemObject.Run();
      end;
      nError := 8;
      if ItemObject.m_boGhost then begin
        nError := 9;
        //MainOutMessage('FFreeList.Add');
        g_FreeItemList.Add(ItemObject);
        g_ItemList.Delete(nIdx);
        nError := 10;
        Continue;
      end;
      nError := 11;
      Inc(nIdx);
      nError := 12;
      if (GetTickCount - dwCheckTime) > 10 then begin
        boCheckTimeLimit := True;
        g_nProcItemIDx := nIdx;
        Break;
      end;
      nError := 13;
    end; //while True do begin
    if not boCheckTimeLimit then g_nProcItemIDx := 0;
  except
    MainOutMessage(sExceptionMsg1 + ' ' + IntToStr(nError));
  end;

  try
    nError := 14;
    for I := 0 to g_FreeItemList.Count - 1 do begin
      nError := 15;
      ItemObject := TItemObject(g_FreeItemList.Items[I]);
      nError := 16;
      if (GetTickCount - ItemObject.m_dwGhostTick) > 5 * 60 * 1000 then begin
        nError := 17;
        //MainOutMessage('FFreeList.Delete');
        g_FreeItemList.Delete(I);
        nError := 18;
        ItemObject.Free;
        nError := 19;
        break;
      end;
      nError := 20;
    end;
  except
    MainOutMessage(sExceptionMsg2 + ' ' + IntToStr(nError));
  end;
end; }

procedure ProcessGameRun();
var
  I: Integer;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.PrcocessData;
    g_EventManager.Run;
    g_MapManager.Run;
    RobotManage.Run;
    g_ItemManager.Run;

    if GetTickCount - l_dwRunTimeTick > 10000 then begin
      l_dwRunTimeTick := GetTickCount();
      g_GuildManager.Run;
      g_CastleManager.Run;

      g_DenySayMsgList.Lock;
      try
        for I := g_DenySayMsgList.Count - 1 downto 0 do begin
          if GetTickCount > LongWord(g_DenySayMsgList.Objects[I]) then begin
            g_DenySayMsgList.Delete(I);
          end;
        end;
      finally
        g_DenySayMsgList.UnLock;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TFrmMain.MENU_VIEW_GATEClick(Sender: TObject);
begin
  {MENU_VIEW_GATE.Checked := not MENU_VIEW_GATE.Checked;
  GridGate.Visible := MENU_VIEW_GATE.Checked; }
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmViewSession := TfrmViewSession.Create(Owner);
  frmViewSession.Top := Top + 20;
  frmViewSession.Left := Left;
  frmViewSession.Open();
  frmViewSession.Free;
end;

procedure TFrmMain.MENU_VIEW_ONLINEHUMANClick(Sender: TObject);
begin
  frmViewOnlineHuman := TfrmViewOnlineHuman.Create(Owner);
  frmViewOnlineHuman.Top := Top + 20;
  frmViewOnlineHuman.Left := Left;
  frmViewOnlineHuman.Open(nil);
  frmViewOnlineHuman.Free;
end;

procedure TFrmMain.MENU_VIEW_LEVELClick(Sender: TObject);
begin
  frmViewLevel := TfrmViewLevel.Create(Owner);
  frmViewLevel.Top := Top + 20;
  frmViewLevel.Left := Left;
  frmViewLevel.Open();
  frmViewLevel.Free;
end;

procedure TFrmMain.MENU_VIEW_LISTClick(Sender: TObject);
begin
  frmViewList := TfrmViewList.Create(Owner);
  frmViewList.Top := Top + 20;
  frmViewList.Left := Left;
  frmViewList.Open();
  frmViewList.Free;
end;

procedure TFrmMain.MENU_MANAGE_ONLINEMSGClick(Sender: TObject);
begin
  frmOnlineMsg := TfrmOnlineMsg.Create(Owner);
  frmOnlineMsg.Top := Top + 20;
  frmOnlineMsg.Left := Left;
  frmOnlineMsg.Open();
  frmOnlineMsg.Free;
end;

procedure TFrmMain.MENU_MANAGE_PLUGClick(Sender: TObject);
begin
  ftmPlugInManage := TftmPlugInManage.Create(Owner);
  ftmPlugInManage.Top := Top + 20;
  ftmPlugInManage.Left := Left;
  ftmPlugInManage.Open();
  ftmPlugInManage.Free;
end;

procedure TFrmMain.SetMenu;
begin
  FrmMain.Menu := MainMenu;
end;

procedure TFrmMain.MENU_VIEW_KERNELINFOClick(Sender: TObject);
begin
  frmViewKernelInfo := TfrmViewKernelInfo.Create(Owner);
  frmViewKernelInfo.Top := Top + 20;
  frmViewKernelInfo.Left := Left;
  frmViewKernelInfo.Open();
  frmViewKernelInfo.Free;
end;

procedure TFrmMain.MENU_OPTION_ITEMFUNCClick(Sender: TObject);
begin
  frmItemSet := TfrmItemSet.Create(Owner);
  frmItemSet.Top := Top + 20;
  frmItemSet.Left := Left;
  frmItemSet.Open();
  frmItemSet.Free;
end;

procedure TFrmMain.ClearMemoLog;
begin
  if Application.MessageBox('是否确定清除日志信息！！！', '提示信息', MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    MemoLog.Clear;
  end;
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  //sData := StrPas(MsgData.CopyDataStruct^.lpData);
  sData := string(AnsiString(PAnsiChar(MsgData.CopyDataStruct^.lpData)));
  case wIdent of
    GS_QUIT: begin
        g_boExitServer := True;
        CloseGateSocket();
        g_Config.boKickAllUser := True;
        CloseTimer.Enabled := True;
      end;
    GS_GETM2SERVERVERSION: begin
        SendGameCenterMsg(SG_GETM2SERVERVERSION, IntToStr(HEROVERSION) + '/' + IntToStr(g_nUpDateVersion));
      end;
    1: ;
    2: ;
    3: ;
  end;
end;

procedure TFrmMain.MENU_TOOLS_IPSEARCHClick(Sender: TObject);
var
  sIPaddr: string;
begin
  try
    sIPaddr := '192.168.0.1';
    //sIPaddr := InputBox('IP所在地区查询', '输入IP地址:', '192.168.0.1');
    if not InputQuery('IP所在地区查询', '输入IP地址:', sIPaddr) then Exit;
    if not IsIPaddr(sIPaddr) then begin
      Application.MessageBox('输入的IP地址格式不正确！！！', '错误信息', MB_OK + MB_ICONERROR);
      Exit;
    end;
    if not IsIPaddr(sIPaddr) then begin
      Application.MessageBox('输入的IP地址格式不正确！！！', '错误信息', MB_OK + MB_ICONERROR);
      Exit;
    end;
    MemoLog.Lines.Add(Format('%s:%s', [sIPaddr, GetIPLocal(sIPaddr)]));
  except
    MemoLog.Lines.Add(Format('%s:%s', [sIPaddr, GetIPLocal(sIPaddr)]));
  end;
end;

procedure TFrmMain.MENU_MANAGE_CASTLEClick(Sender: TObject);
begin
  frmCastleManage := TfrmCastleManage.Create(Owner);
  frmCastleManage.Top := Top + 20;
  frmCastleManage.Left := Left;
  frmCastleManage.Open();
  frmCastleManage.Free;
end;

procedure TFrmMain.MENU_HELP_REGKEYClick(Sender: TObject);
var
  I: Integer;
  StartProc: TStartProc;
begin
  StartProc := nil;
  for I := 0 to PlugInEngine.PlugList.Count - 1 do begin
    if pTPlugInfo(PlugInEngine.PlugList.Objects[I]).SysPlug^ then begin
      StartProc := GetProcAddress(pTPlugInfo(PlugInEngine.PlugList.Objects[I]).Module, 'Config');
      break;
    end;
  end;
  if Assigned(StartProc) then StartProc;
end;

procedure TFrmMain.MonItemsClick(Sender: TObject);
var
  I: Integer;
  Monster: pTMonInfo;
begin
  try
    for I := 0 to UserEngine.MonsterList.Count - 1 do begin
      Monster := UserEngine.MonsterList.Items[I];
      FrmDB.LoadMonitems(Monster.sName, Monster.ItemList);
    end;
    MainOutMessage('怪物爆物品列表重加载完成...');
  except
    MainOutMessage('怪物爆物品列表重加载失败！！！');
  end;
end;

procedure TFrmMain.MENU_OPTION_HEROClick(Sender: TObject);
begin
  frmHeroConfig := TfrmHeroConfig.Create(Owner);
  frmHeroConfig.Top := Top;
  frmHeroConfig.Left := Left;
  frmHeroConfig.Open();
  frmHeroConfig.Free;
end;

procedure TFrmMain.MENU_MANAGE_SYSClick(Sender: TObject);
begin
  frmSysManager := TfrmSysManager.Create(Owner);
  frmSysManager.Top := Top + 20;
  frmSysManager.Left := Left;
  frmSysManager.Open();
  frmSysManager.Free;
end;

procedure TFrmMain.DBSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //MainOutMessage('数据库服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')连接断开...');
end;

initialization

finalization

end.

