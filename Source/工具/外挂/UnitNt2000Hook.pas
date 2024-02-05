unit UnitNt2000Hook;

interface

uses Classes, Windows;

const
  cOsUnknown: Integer = -1;
  cOsWin95: Integer = 0;
  cOsWin98: Integer = 1;
  cOsWin98SE: Integer = 2;
  cOsWinME: Integer = 3;
  cOsWinNT: Integer = 4;
  cOsWin2000: Integer = 5;
  cOsWhistler: Integer = 6;

type
  TImportCode = packed record
    JumpInstruction: Word;
    AddressOfPointerToFunction: PPointer;
  end;
  PImage_Import_Entry = ^Image_Import_Entry;
  Image_Import_Entry = record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    Name: DWORD;
    LookupTable: DWORD;
  end;
  PImportCode = ^TImportCode;
  TLongJmp = packed record
    JmpCode: ShortInt; {ָ���$E9������ϵͳ��ָ��}
    FuncAddr: DWORD; {������ַ}
  end;

  THookClass = class
  private
    Trap: boolean; {���÷�ʽ��True����ʽ��False�������ʽ}
    hProcess: Cardinal; {���̾����ֻ��������ʽ}
    AlreadyHook: boolean; {�Ƿ��Ѱ�װHook��ֻ��������ʽ}
    AllowChange: boolean; {�Ƿ�����װ��ж��Hook��ֻ���ڸ������ʽ}
    Oldcode: array[0..4] of byte; {ϵͳ����ԭ����ǰ5���ֽ�}
    Newcode: TLongJmp; {��Ҫд��ϵͳ������ǰ5���ֽ�}
  private
  public
    OldFunction, NewFunction: Pointer; {���غ������Զ��庯��}
    constructor Create(IsTrap: boolean; OldFun, NewFun: Pointer);
    constructor Destroy;
    procedure Restore;
    procedure Change;
  published
  end;
function GetOSVersion: Integer; //��ȡϵͳ�汾
function GetTrap: boolean;
implementation
function GetOSVersion: Integer; //��ȡϵͳ�汾
var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: Integer;
begin
  Result := cOsUnknown;
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if (GetVersionEx(osVerInfo)) then begin
    majorVer := osVerInfo.dwMajorVersion;
    minorVer := osVerInfo.dwMinorVersion;
    case (osVerInfo.dwPlatformId) of
      VER_PLATFORM_WIN32_NT: { Windows NT/2000 }
        begin
          if (majorVer <= 4) then
            Result := cOsWinNT
          else
            if ((majorVer = 5) and (minorVer = 0)) then
            Result := cOsWin2000
          else
            if ((majorVer = 5) and (minorVer = 1)) then
            Result := cOsWhistler
          else
            Result := cOsUnknown;
        end;
      VER_PLATFORM_WIN32_WINDOWS: { Windows 9x/ME }
        begin
          if ((majorVer = 4) and (minorVer = 0)) then
            Result := cOsWin95
          else if ((majorVer = 4) and (minorVer = 10)) then begin
            if (osVerInfo.szCSDVersion[1] = 'A') then
              Result := cOsWin98SE
            else
              Result := cOsWin98;
          end else if ((majorVer = 4) and (minorVer = 90)) then
            Result := cOsWinME
          else
            Result := cOsUnknown;
        end;
    else
      Result := cOsUnknown;
    end;
  end else
    Result := cOsUnknown;
end;

function GetTrap: boolean;
begin
  Result := GetOSVersion in [0..3];
end;

{ȡ������ʵ�ʵ�ַ����������ĵ�һ��ָ����Jmp����ȡ��������ת��ַ��ʵ�ʵ�ַ���������������ڳ����к���Debug������Ϣ�����}
function FinalFunctionAddress(code: Pointer): Pointer;
var
  func: PImportCode;
begin
  Result := code;
  if code = nil then Exit;
  try
    func := code;
    if (func.JumpInstruction = $25FF) then
      {ָ���������FF 25  ���ָ��jmp [...]}
      func := func.AddressOfPointerToFunction^;
    Result := func;
  except
    Result := nil;
  end;
end;

{�����������ָ�������ĵ�ַ��ֻ���ڸ������ʽ}
function PatchAddressInModule(BeenDone: TList; hModule: THandle; OldFunc, NewFunc: Pointer): Integer;
const
  SIZE = 4;
var
  Dos: PImageDosHeader;
  NT: PImageNTHeaders;
  ImportDesc: PImage_Import_Entry;
  rva: DWORD;
  func: PPointer;
  DLL: string;
  f: Pointer;
  written: DWORD;
  mbi_thunk: TMemoryBasicInformation;
  dwOldProtect: DWORD;
begin
  Result := 0;
  if hModule = 0 then Exit;
  Dos := Pointer(hModule);
  {������DLLģ���Ѿ�����������˳���BeenDone�����Ѵ����DLLģ��}
  if BeenDone.IndexOf(Dos) >= 0 then Exit;
  BeenDone.Add(Dos); {��DLLģ��������BeenDone}
  OldFunc := FinalFunctionAddress(OldFunc); {ȡ������ʵ�ʵ�ַ}

  {������DLLģ��ĵ�ַ���ܷ��ʣ����˳�}
  if IsBadReadPtr(Dos, SizeOf(TImageDosHeader)) then Exit;
  {������ģ�鲻����'MZ'��ͷ����������DLL�����˳�}
  if Dos.e_magic <> IMAGE_DOS_SIGNATURE then Exit; {IMAGE_DOS_SIGNATURE='MZ'}

  {��λ��NT Header}
  NT := Pointer(Integer(Dos) + Dos._lfanew);
  {��λ�����뺯����}
  rva := NT^.OptionalHeader.
    DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
  if rva = 0 then Exit; {������뺯����Ϊ�գ����˳�}
  {�Ѻ�����������Ե�ַRVAת��Ϊ���Ե�ַ}
  ImportDesc := Pointer(DWORD(Dos) + rva); {Dos�Ǵ�DLLģ����׵�ַ}

  {�������б�������¼�DLLģ��}
  while (ImportDesc^.Name <> 0) do
  begin
    {��������¼�DLLģ������}
    DLL := pchar(DWORD(Dos) + ImportDesc^.Name);
    {�ѱ�������¼�DLLģ�鵱����ǰģ�飬���еݹ����}
    PatchAddressInModule(BeenDone, GetModuleHandle(pchar(DLL)), OldFunc, NewFunc);

    {��λ����������¼�DLLģ��ĺ�����}
    func := Pointer(DWORD(Dos) + ImportDesc.LookupTable);
    {������������¼�DLLģ������к���}
    while func^ <> nil do
    begin
      f := FinalFunctionAddress(func^); {ȡʵ�ʵ�ַ}
      if f = OldFunc then {�������ʵ�ʵ�ַ������Ҫ�ҵĵ�ַ}
      begin
        VirtualQuery(func, mbi_thunk, SizeOf(TMemoryBasicInformation));
        VirtualProtect(func, SIZE, PAGE_EXECUTE_WRITECOPY, mbi_thunk.Protect); {�����ڴ�����}
        WriteProcessMemory(GetCurrentProcess, func, @NewFunc, SIZE, written); {���º�����ַ������}
        VirtualProtect(func, SIZE, mbi_thunk.Protect, dwOldProtect); {�ָ��ڴ�����}
      end;
      if written = 4 then Inc(Result);
//      else showmessagefmt('error:%d',[Written]);
      Inc(func); {��һ�����ܺ���}
    end;
    Inc(ImportDesc); {��һ����������¼�DLLģ��}
  end;
end;

{HOOK����ڣ�����IsTrap��ʾ�Ƿ��������ʽ}
constructor THookClass.Create(IsTrap: boolean; OldFun, NewFun: Pointer);
begin
   {�󱻽غ������Զ��庯����ʵ�ʵ�ַ}
  OldFunction := FinalFunctionAddress(OldFun);
  NewFunction := FinalFunctionAddress(NewFun);

  Trap := IsTrap;
  if Trap then {���������ʽ}
  begin
      {����Ȩ�ķ�ʽ���򿪵�ǰ����}
    hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, GetCurrentProcessId);
      {����jmp xxxx�Ĵ��룬��5�ֽ�}
    Newcode.JmpCode := ShortInt($E9); {jmpָ���ʮ�����ƴ�����E9}
    Newcode.FuncAddr := DWORD(NewFunction) - DWORD(OldFunction) - 5;
      {���汻�غ�����ǰ5���ֽ�}
    Move(OldFunction^, Oldcode, 5);
      {����Ϊ��û�п�ʼHOOK}
    AlreadyHook := False;
  end;
   {����Ǹ������ʽ��������HOOK}
  if not Trap then AllowChange := True;
  Change; {��ʼHOOK}
   {����Ǹ������ʽ������ʱ������HOOK}
  if not Trap then AllowChange := False;
end;

{HOOK�ĳ���}
constructor THookClass.Destroy;
begin
   {����Ǹ������ʽ��������HOOK}
  if not Trap then AllowChange := True;
  Restore; {ֹͣHOOK}
  if Trap then {���������ʽ}
    CloseHandle(hProcess);
end;

{��ʼHOOK}
procedure THookClass.Change;
var
  nCount: DWORD;
  BeenDone: TList;
begin
  if Trap then {���������ʽ}
  begin
    if (AlreadyHook) or (hProcess = 0) or (OldFunction = nil) or (NewFunction = nil) then
      Exit;
    AlreadyHook := True; {��ʾ�Ѿ�HOOK}
    WriteProcessMemory(hProcess, OldFunction, @(Newcode), 5, nCount);
  end
  else begin {����Ǹ������ʽ}
    if (not AllowChange) or (OldFunction = nil) or (NewFunction = nil) then Exit;
    BeenDone := TList.Create; {���ڴ�ŵ�ǰ��������DLLģ�������}
    try
      PatchAddressInModule(BeenDone, GetModuleHandle(nil), OldFunction, NewFunction);
    finally
      BeenDone.Free;
    end;
  end;
end;

{�ָ�ϵͳ�����ĵ���}
procedure THookClass.Restore;
var
  nCount: DWORD;
  BeenDone: TList;
begin
  if Trap then {���������ʽ}
  begin
    if (not AlreadyHook) or (hProcess = 0) or (OldFunction = nil) or (NewFunction = nil) then
      Exit;
    WriteProcessMemory(hProcess, OldFunction, @(Oldcode), 5, nCount);
    AlreadyHook := False; {��ʾ�˳�HOOK}
  end
  else begin {����Ǹ������ʽ}
    if (not AllowChange) or (OldFunction = nil) or (NewFunction = nil) then Exit;
    BeenDone := TList.Create; {���ڴ�ŵ�ǰ��������DLLģ�������}
    try
      PatchAddressInModule(BeenDone, GetModuleHandle(nil), NewFunction, OldFunction);
    finally
      BeenDone.Free;
    end;
  end;
end;

end.

