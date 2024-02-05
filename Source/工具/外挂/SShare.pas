unit SShare;

interface
uses
  Windows, SysUtils, Classes, Dialogs, JSocket, SDK, CShare, HUtil32, ComCtrls,
  IniFiles, QQWry;
const
  CM_GETCLIENTCONFIG = 1;
  CM_GETBADADDRESS = 2;

  SM_CLIENTCONFIG = 11;
  SM_BADADDRESS = 12;
  SM_UPGRADE = 13;
  SM_UPGRADEDATA = 14;



  MAXSESSION = 2000;


{$IF USERVERSION = 0}
  IPADDRESS = 93851257;
{$IFEND}

{$IF USERVERSION = 1}
  IPADDRESS = -495973767;
{$IFEND}

{$IF USERVERSION = 2}
  IPADDRESS = 93851257;
{$IFEND}

{$IF USERVERSION = 3}
  IPADDRESS = 1854803577;
{$IFEND}

{$IF USERVERSION = 4}
  IPADDRESS = -1323049670;
{$IFEND}

{$IF USERVERSION = 5}
  IPADDRESS = -1945771910;
{$IFEND}

{$IF USERVERSION = 6}
  IPADDRESS = -539685255;
{$IFEND}

{$IF USERVERSION = 7}
  IPADDRESS = 74124409;
{$IFEND}

{$IF USERVERSION = 10}
  IPADDRESS = 16777343;
{$IFEND}
type
  TListViewA = class;

  TSession = record
    Socket: TCustomWinSocket;
    dDateTime: TDateTime;
    sReviceMsg: string;
    sRemoteAddress: string;
    nRemoteAddr: Integer;
    dwStartTick: LongWord;
    CheckStep: TCheckStep;
    SessionStatus: TSessionStatus;
    ClientInfo: TClientInfo;
    dwClientTick: LongWord;
    dwServerTick: LongWord;
    nCount: Integer;
    dwUserTimeOutTick: LongWord;
    dwSendUserLienseTick: LongWord;
  end;
  pTSession = ^TSession;


  TUserList = class(TStringList)

  private
  public
    constructor Create();
    destructor Destroy; override;
    function Get(sUserIpAddr: string): pTSession;
    function Add(Session: pTSession): Boolean;
    procedure DeleteOfIp(sUserIpAddr: string);
    procedure SortString(nMIN, nMax: Integer);
  end;

  TUserConfig = record
    sUserDirectory: string;
    ServerConfig: TServerConfig;
    SessionList: TUserList;
    MemoryStream: TMemoryStream;
    TabSheet: TTabSheet;
    ListView: TListViewA;
  end;
  pTUserConfig = ^TUserConfig;

  TListViewA = class(TListView)
  public
    UserConfig: pTUserConfig;
    constructor Create(AOwner: TComponent); override;
  end;

  TUserSession = class(TObject)
    m_ConfigList: TGStringList;
  private
    FFileName: string;
    procedure UnLoad;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    function Get(sConfig: string): pTUserConfig;

    function Find(sConfig: string): Boolean;
    function IndexOf(sConfig: string): Integer;
    function Address(sConfig: string): string;

    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    function CreateUserConfig(): pTUserConfig;
    procedure FreeUserConfig(UserConfig: pTUserConfig);

    function Add(ServerConfig: pTServerConfig): Boolean;

    procedure Delete(sUserLiense: string);
    property Name: string read FFileName write FFileName;
  end;
  pTUserSession = ^TUserSession;

var
  g_CS: TRTLCriticalSection;
  MainLogMsgList: TGStringList;
  LogMsgList: TStringList;
  g_SessionList: TSStringList;
  g_BlockIPList: TStringList;
  //g_ConfigList: TGStringList;
  g_UserSession: TUserSession;
  g_SessionArray: array[0..MAXSESSION - 1] of TSession;

  g_sAddress: string;
  g_nAddressHash: Integer;

  g_boShowLog: Boolean = True;

  g_QQWry: TQQWry;
  //g_MemoryStream: TMemoryStream;
procedure MainOutMessage(Msg: string);
function GetUserWebAddr(sAddr: string): string;
implementation

function AnsiReplaceText(const AText, AFromText, AToText: string): string;
begin
  Result := StringReplace(AText, AFromText, AToText, [rfReplaceAll, rfIgnoreCase]);
end;

function GetUserWebAddr(sAddr: string): string;
begin
  Result := sAddr;
  if Pos('://', sAddr) > 0 then begin //http    uppercase
    if (UpperCase(sAddr[1]) = 'H') and (UpperCase(sAddr[2]) = 'T') and (UpperCase(sAddr[3]) = 'T') and (UpperCase(sAddr[4]) = 'P') then begin
      sAddr := Copy(sAddr, 8, Length(sAddr));
    end else begin
      sAddr := Copy(sAddr, Pos('://', sAddr) + 1, Length(sAddr));
    end;
  end;
  while (sAddr <> '') and (sAddr[Length(sAddr)] = '/') do sAddr := Copy(sAddr, 1, Length(sAddr) - 1);
  Result := sAddr;
end;

procedure MainOutMessage(Msg: string);
begin
  MainLogMsgList.Lock;
  try
    MainLogMsgList.Add('[' + DateTimeToStr(Now) + '] ' + Msg);
  finally
    MainLogMsgList.UnLock;
  end;
end;



constructor TListViewA.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UserConfig := nil;
end;



function TUserSession.Get(sConfig: string): pTUserConfig;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_ConfigList.Count - 1 do begin
    if CompareText(m_ConfigList.Strings[I], sConfig) = 0 then begin
      Result := pTUserConfig(m_ConfigList.Objects[I]);
      Break;
    end;
  end;
end;

function TUserSession.Find(sConfig: string): Boolean;
begin
  Result := Get(sConfig) <> nil;
end;

function TUserSession.IndexOf(sConfig: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to m_ConfigList.Count - 1 do begin
    if CompareText(m_ConfigList.Strings[I], sConfig) = 0 then begin
      Result := I;
      Break;
    end;
  end;
end;

function TUserSession.Address(sConfig: string): string;
var
  I: Integer;
  UserConfig: pTUserConfig;
begin
  Result := '';
  for I := 0 to m_ConfigList.Count - 1 do begin
    if CompareText(m_ConfigList.Strings[I], sConfig) = 0 then begin
      Result := pTUserConfig(m_ConfigList.Objects[I]).ServerConfig.sUserLiense;
      Break;
    end;
  end;
end;

function TUserSession.CreateUserConfig(): pTUserConfig;
begin
  New(Result);
  Result.SessionList := TUserList.Create;
  Result.MemoryStream := TMemoryStream.Create;
end;

procedure TUserSession.FreeUserConfig(UserConfig: pTUserConfig);
var
  I: Integer;
begin
  for I := 0 to UserConfig.SessionList.Count - 1 do begin
    Dispose(pTSession(UserConfig.SessionList.Objects[I]));
  end;
  UserConfig.SessionList.Free;
  UserConfig.MemoryStream.Free;
  Dispose(UserConfig);
end;

procedure TUserSession.UnLoad;
var
  I: Integer;
  UserConfig: pTUserConfig;
begin
  for I := 0 to m_ConfigList.Count - 1 do begin
    UserConfig := pTUserConfig(m_ConfigList.Objects[I]);
    UserConfig.SessionList.Free;
    UserConfig.MemoryStream.Free;
    Dispose(UserConfig);
  end;
  m_ConfigList.Clear;
end;

procedure TUserSession.LoadFromFile(const FileName: string);
var
  I: Integer;
  sFileName: string;
  LoadList: TStringList;
  UserConfig: pTUserConfig;
  sLineText: string;
  sUserDirectory: string;
  IniFile: TIniFile;
begin
  UnLoad;
  sUserDirectory := ExtractFilePath(ParamStr(0)) + 'UserConfig\';
  if not DirectoryExists(sUserDirectory) then begin
    CreateDir(sUserDirectory);
  end;

  sFileName := FileName;
  if FileExists(sFileName) then begin

    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if (sLineText = '') then Continue;
      if sLineText[1] = ';' then Continue;
      sLineText := GetUserWebAddr(LoadList.Strings[I]);
      if sLineText <> '' then begin
        IniFile := TIniFile.Create(sUserDirectory + sLineText + '.ini');
        UserConfig := CreateUserConfig;
        UserConfig.sUserDirectory := sUserDirectory + sLineText;
        UserConfig.ServerConfig.sUserLiense := LoadList.Strings[I];

        UserConfig.ServerConfig.boAllowUpData := IniFile.ReadBool('�Զ�����', '�������', True);
        UserConfig.ServerConfig.boCompulsiveUpdata := IniFile.ReadBool('�Զ�����', '������ʾ', False);
        UserConfig.ServerConfig.sMD5 := IniFile.ReadString('�Զ�����', 'MD5', '');
        UserConfig.ServerConfig.sUpdataAddr := IniFile.ReadString('�Զ�����', '���µ�ַ', '');


        UserConfig.ServerConfig.sHomePage := IniFile.ReadString('�������', '��Ƕ���', LoadList.Strings[I]);

        UserConfig.ServerConfig.sOpenPage1 := IniFile.ReadString('�������', '��������1', LoadList.Strings[I]);
        UserConfig.ServerConfig.sOpenPage2 := IniFile.ReadString('�������', '��������2', LoadList.Strings[I]);
        UserConfig.ServerConfig.sClosePage1 := IniFile.ReadString('�������', '�رյ���1', LoadList.Strings[I]);
        UserConfig.ServerConfig.sClosePage2 := IniFile.ReadString('�������', '�رյ���2', LoadList.Strings[I]);

        UserConfig.ServerConfig.boOpenPage1 := IniFile.ReadBool('�������', '��������1', True);
        UserConfig.ServerConfig.boOpenPage2 := IniFile.ReadBool('�������', '��������2', False);
        UserConfig.ServerConfig.boClosePage1 := IniFile.ReadBool('�������', '�����ر�1', True);
        UserConfig.ServerConfig.boClosePage2 := IniFile.ReadBool('�������', '�����ر�2', False);

        UserConfig.ServerConfig.sSayMessage1 := IniFile.ReadString('��������', '��������1', '');
        UserConfig.ServerConfig.sSayMessage2 := IniFile.ReadString('��������', '��������2', '');

        UserConfig.ServerConfig.nSayMsgTime := IniFile.ReadInteger('��������', '�������', 5000);


        UserConfig.ServerConfig.boCheckNoticeUrl := IniFile.ReadBool('��������', '��⹫���ַ', True);
        UserConfig.ServerConfig.boWriteHosts := IniFile.ReadBool('��������', 'д��HOSTS', True);
        UserConfig.ServerConfig.nHostsAddress := MakeIPToInt(IniFile.ReadString('��������', 'IP��ַ', ''));
        UserConfig.ServerConfig.boWriteUrlEntry := IniFile.ReadBool('��������', 'д�뻺��', True);
        UserConfig.ServerConfig.boCheckOpenPage := IniFile.ReadBool('��������', '��ⵯ����ַ', True);
        UserConfig.ServerConfig.boCheckConnectPage := IniFile.ReadBool('��������', '������ӵ�ַ', True);
        UserConfig.ServerConfig.boUseServerUpgrade := IniFile.ReadBool('��������', 'ʹ����֤�����͸����ļ�', False);


        UserConfig.ServerConfig.boCheckParent := IniFile.ReadBool('��������', '���Parent', False);
        UserConfig.ServerConfig.boCheck1 := IniFile.ReadBool('��������', '���1', False);
        UserConfig.ServerConfig.boCheck2 := IniFile.ReadBool('��������', '���2', False);
        UserConfig.ServerConfig.boCheck3 := IniFile.ReadBool('��������', '���3', False);
        UserConfig.ServerConfig.boCheck4 := IniFile.ReadBool('��������', '���4', False);
        UserConfig.ServerConfig.boCheck5 := IniFile.ReadBool('��������', '���5', False);
        UserConfig.ServerConfig.boCheck6 := IniFile.ReadBool('��������', '���6', False);
        UserConfig.ServerConfig.boCheck7 := IniFile.ReadBool('��������', '���7', False);
        UserConfig.ServerConfig.boCheck8 := IniFile.ReadBool('��������', '���8', False);
        UserConfig.ServerConfig.boCheck9 := IniFile.ReadBool('��������', '���9', False);
        UserConfig.ServerConfig.boCheck10 := IniFile.ReadBool('��������', '���10', False);

        if FileExists(UserConfig.sUserDirectory + '.exe') then UserConfig.MemoryStream.LoadFromFile(UserConfig.sUserDirectory + '.exe');

        m_ConfigList.AddObject(LoadList.Strings[I], TObject(UserConfig));

        IniFile.Free;
      end;
    end;
    LoadList.Free;
  end;
end;

procedure TUserSession.SaveToFile(const FileName: string);
var
  I: Integer;
  UserConfig: pTUserConfig;
  sUserLiense, sFileName: string;
  sUserDirectory: string;
  IniFile: TIniFile;
begin
  sUserDirectory := ExtractFilePath(ParamStr(0)) + 'UserConfig\';
  if not DirectoryExists(sUserDirectory) then begin
    CreateDir(sUserDirectory);
  end;

  for I := 0 to m_ConfigList.Count - 1 do begin
    UserConfig := pTUserConfig(m_ConfigList.Objects[I]);
    sUserLiense := GetUserWebAddr(UserConfig.ServerConfig.sUserLiense);
    IniFile := TIniFile.Create(sUserDirectory + sUserLiense + '.ini');

    IniFile.WriteBool('�Զ�����', '�������', UserConfig.ServerConfig.boAllowUpData);
    IniFile.WriteBool('�Զ�����', '������ʾ', UserConfig.ServerConfig.boCompulsiveUpdata);
    IniFile.WriteString('�Զ�����', 'MD5', UserConfig.ServerConfig.sMD5);
    IniFile.WriteString('�Զ�����', '���µ�ַ', UserConfig.ServerConfig.sUpdataAddr);

    IniFile.WriteString('�������', '��Ƕ���', UserConfig.ServerConfig.sHomePage);

    IniFile.WriteString('�������', '��������1', UserConfig.ServerConfig.sOpenPage1);
    IniFile.WriteString('�������', '��������2', UserConfig.ServerConfig.sOpenPage2);
    IniFile.WriteString('�������', '�رյ���1', UserConfig.ServerConfig.sClosePage1);
    IniFile.WriteString('�������', '�رյ���2', UserConfig.ServerConfig.sClosePage2);

    IniFile.WriteBool('�������', '��������1', UserConfig.ServerConfig.boOpenPage1);
    IniFile.WriteBool('�������', '��������2', UserConfig.ServerConfig.boOpenPage2);
    IniFile.WriteBool('�������', '�����ر�1', UserConfig.ServerConfig.boClosePage1);
    IniFile.WriteBool('�������', '�����ر�2', UserConfig.ServerConfig.boClosePage2);

    IniFile.WriteString('��������', '��������1', UserConfig.ServerConfig.sSayMessage1);
    IniFile.WriteString('��������', '��������2', UserConfig.ServerConfig.sSayMessage2);

    IniFile.WriteInteger('��������', '�������', UserConfig.ServerConfig.nSayMsgTime);


    IniFile.WriteBool('��������', '��⹫���ַ', UserConfig.ServerConfig.boCheckNoticeUrl);
    IniFile.WriteBool('��������', 'д��HOSTS', UserConfig.ServerConfig.boWriteHosts);
    IniFile.WriteString('��������', 'IP��ַ', MakeIntToIP(UserConfig.ServerConfig.nHostsAddress));
    IniFile.WriteBool('��������', 'д�뻺��', UserConfig.ServerConfig.boWriteUrlEntry);
    IniFile.WriteBool('��������', '��ⵯ����ַ', UserConfig.ServerConfig.boCheckOpenPage);
    IniFile.WriteBool('��������', '������ӵ�ַ', UserConfig.ServerConfig.boCheckConnectPage);
    IniFile.WriteBool('��������', 'ʹ����֤�����͸����ļ�', UserConfig.ServerConfig.boUseServerUpgrade);

    IniFile.WriteBool('��������', '���Parent', UserConfig.ServerConfig.boCheckParent);
    IniFile.WriteBool('��������', '���1', UserConfig.ServerConfig.boCheck1);
    IniFile.WriteBool('��������', '���2', UserConfig.ServerConfig.boCheck2);
    IniFile.WriteBool('��������', '���3', UserConfig.ServerConfig.boCheck3);
    IniFile.WriteBool('��������', '���4', UserConfig.ServerConfig.boCheck4);
    IniFile.WriteBool('��������', '���5', UserConfig.ServerConfig.boCheck5);
    IniFile.WriteBool('��������', '���6', UserConfig.ServerConfig.boCheck6);
    IniFile.WriteBool('��������', '���7', UserConfig.ServerConfig.boCheck7);
    IniFile.WriteBool('��������', '���8', UserConfig.ServerConfig.boCheck8);
    IniFile.WriteBool('��������', '���9', UserConfig.ServerConfig.boCheck9);
    IniFile.WriteBool('��������', '���10', UserConfig.ServerConfig.boCheck10);

    IniFile.Free;
  end;
  try
    m_ConfigList.SaveToFile(FileName);
  except

  end;
end;

function TUserSession.Add(ServerConfig: pTServerConfig): Boolean;
var
  UserConfig: pTUserConfig;
begin
  Result := False;
  if Find(ServerConfig.sUserLiense) then Exit;
  UserConfig := CreateUserConfig;
  UserConfig.TabSheet := nil;
  UserConfig.ListView := nil;
  UserConfig.ServerConfig := ServerConfig^;
  m_ConfigList.AddObject(ServerConfig.sUserLiense, TObject(UserConfig));
  SaveToFile(FFileName);
  Result := True;
end;

procedure TUserSession.Delete(sUserLiense: string);
var
  I: Integer;
  UserConfig: pTUserConfig;
begin
  for I := 0 to m_ConfigList.Count - 1 do begin
    if CompareText(m_ConfigList.Strings[I], sUserLiense) = 0 then begin
      UserConfig := pTUserConfig(m_ConfigList.Objects[I]);
      m_ConfigList.Delete(I);
      if UserConfig.ListView <> nil then UserConfig.ListView.Free;
      if UserConfig.TabSheet <> nil then UserConfig.TabSheet.Free;
      UserConfig.SessionList.Free;
      Dispose(UserConfig);
      Break;
    end;
  end;
end;

constructor TUserSession.Create(const FileName: string);
begin
  inherited Create;
  FFileName := FileName;
  m_ConfigList := TGStringList.Create;
end;

destructor TUserSession.Destroy;
begin
  UnLoad;
  m_ConfigList.Free;
  inherited;
end;


constructor TUserList.Create();
begin
  inherited;
end;

destructor TUserList.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do begin
    Dispose(pTSession(Objects[I]));
  end;
  inherited;
end;

procedure TUserList.SortString(nMIN, nMax: Integer);
var
  ntMin, ntMax: Integer;
  s18: string;
begin
  if Self.Count > 0 then
    while (True) do begin
      ntMin := nMIN;
      ntMax := nMax;
      s18 := Self.Strings[(nMIN + nMax) shr 1];
      while (True) do begin
        while (CompareText(Self.Strings[ntMin], s18) < 0) do Inc(ntMin);
        while (CompareText(Self.Strings[ntMax], s18) > 0) do Dec(ntMax);
        if ntMin <= ntMax then begin
          Self.Exchange(ntMin, ntMax);
          Inc(ntMin);
          Dec(ntMax);
        end;
        if ntMin > ntMax then Break
      end;
      if nMIN < ntMax then SortString(nMIN, ntMax);
      nMIN := ntMin;
      if ntMin >= nMax then Break;
    end;
end;

function TUserList.Get(sUserIpAddr: string): pTSession;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do begin
    if Strings[I] = sUserIpAddr then begin
      Result := pTSession(Objects[I]);
      Break;
    end;
  end;
end;

function TUserList.Add(Session: pTSession): Boolean;
begin
  AddObject(Session.sRemoteAddress, TObject(Session));
  SortString(0, Count - 1);
end;

procedure TUserList.DeleteOfIp(sUserIpAddr: string);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do begin
    if Strings[I] = sUserIpAddr then begin
      Dispose(pTSession(Objects[I]));
      Delete(I);
      Break;
    end;
  end;
end;

initialization
  begin
    InitializeCriticalSection(g_CS);
    MainLogMsgList := TGStringList.Create;
    LogMsgList := TStringList.Create;
  end;
finalization
  begin
    MainLogMsgList.Free;
    LogMsgList.Free;
    DeleteCriticalSection(g_CS);
  end;

end.

