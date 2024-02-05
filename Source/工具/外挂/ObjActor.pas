unit ObjActor;

interface
uses
  SysUtils, Classes, windows, Graphics, Controls, Grobal, Grobal2, ClFunc;
type
  TMagicType = (mtReady, mtFly, mtExplosion,
    mtFlyAxe, mtFireWind, mtFireGun,
    mtLightingThunder, mtThunder, mtExploBujauk,
    mtBujaukGroundEffect, mtKyulKai, mtFlyArrow,
    mt12, mt13, mt14,
    mt15, mt16, mHeroMagic
    );

  TUseMagicInfo = record
    ServerMagicCode: Integer;
    MagicSerial: Integer;
    target: Integer; //recogcode
    EffectType: TMagicType;
    EffectNumber: Integer;
    targx: Integer;
    targy: Integer;
    Recusion: Boolean;
    anitime: Integer;
  end;
  PTUseMagicInfo = ^TUseMagicInfo;

  TActor = class //Size 0x240
    m_nRecogId: Integer; //��ɫ��ʶ 0x4
    m_nCurrX: Integer; //��ǰ���ڵ�ͼ����X 0x08
    m_nCurrY: Integer; //��ǰ���ڵ�ͼ����Y 0x0A
    m_btDir: BYTE; //��ǰվ������ 0x0C
    m_btSex: BYTE; //�Ա� 0x0D
    m_btRace: BYTE; //0x0E
    m_btHair: BYTE; //ͷ������ 0x0F
    m_btDress: BYTE; //�·����� 0x10
    m_btWeapon: BYTE; //��������
    m_btHorse: BYTE; //������
    m_btEffect: BYTE; //��ʹ����

    m_btJob: BYTE; //ְҵ 0:��ʿ  1:��ʦ  2:��ʿ

    m_btDeathState: BYTE;

    m_nState: Integer; //0x1C
    m_boDeath: Boolean; //0x20
    m_boGrouped: Boolean; //0x22
    m_boDelActor: Boolean; //0x22

    m_nFeature: Integer;
    m_wAppearance: Integer;


    m_boVisible: Boolean; //0x22
    m_boHoldPlace: Boolean; //0x22

    m_sDescUserName: string; //�������ƣ���׺
    m_sUserName: string; //0x28
    m_nNameColor: Integer; //0x2C
    m_Abil_IGE: TAbility_IGE; //0x30
    m_Abil_BLUE: TAbility_BLUE; //0x30
    m_nGold: Integer; //�������0x58
    m_nGameGold: Integer; //��Ϸ������
    m_nGamePoint: Integer; //��Ϸ������

    m_nShiftX: Integer; //0x98
    m_nShiftY: Integer; //0x9C

    m_nPx: Integer; //0xA0
    m_nHpx: Integer; //0xA4
    m_nWpx: Integer; //0xA8
    m_nSpx: Integer; //0xAC

    m_nPy: Integer;
    m_nHpy: Integer;
    m_nWpy: Integer;
    m_nSpy: Integer; //0xB0 0xB4 0xB8 0xBC

    m_nRx: Integer;
    m_nRy: Integer; //0xC0 0xC4

    m_dwDeleteTime: LongWORD;

    m_boDelActionAfterFinished: Boolean; //0x22
    m_nWaitForRecogId: Integer; //0xC0 0xC4
    m_boSkeleton: Boolean; //0x22

    m_CurMagic: TUseMagicInfo; //0x118  //m_CurMagic.EffectNumber 0x110
    m_MsgList: TList;

    m_nCurrentAction: Integer;
    RealActionMsg: TChrMsg;

    m_nTargetX: Integer;
    m_nTargetY: Integer;
    m_nTargetRecog: Integer;

    m_nWaitForFeature: Integer;
    m_nWaitForStatus: Integer;
    m_dwSayMsgTick: LongWORD;
    m_nHitSpeed: Integer;

    m_nCurrentFrame: Integer;
    m_nStartFrame: Integer;
    m_nEndFrame: Integer;
    m_dwFrameTime: LongWORD;
    m_dwStartTime: LongWORD;
    m_nCurEffFrame: Integer;
    m_nSpellFrame: Integer;


    m_boLockEndFrame: Boolean;
    m_dwWaitMagicRequest: LongWORD;
    m_boUseMagic: Boolean;


    m_nMaxTick: Integer; //0x1E4
    m_nCurTick: Integer; //0x1E8
    m_nMoveStep: Integer; //0x1EC
    m_boMsgMuch: Boolean; //0x1F0
    m_dwStruckFrameTime: LongWord; //0x1F4
    m_nCurrentDefFrame: Integer; //0x1F8          //0x1E4
    m_dwDefFrameTime: LongWord; //0x1FC       //0x1E8
    m_nDefFrameCount: Integer; //0x200        //0x1EC
    m_nSkipTick: Integer; //0x204
    m_dwSmoothMoveTime: LongWord; //0x208
    m_dwGenAnicountTime: LongWord; //0x20C

    m_nOldx: Integer;
    m_nOldy: Integer;
    m_nOldDir: Integer; //0x214 0x218 0x21C
    m_nActBeforeX: Integer;
    m_nActBeforeY: Integer; //0x220 0x224
    m_nWpord: Integer; //0x228       virtual;


    m_boReverseFrame: Boolean;
    m_boWarMode: Boolean;
    m_dwWarModeTime: LongWord;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SendMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
    procedure UpdateMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
    procedure CalcActorFrame;
    procedure FeatureChanged;
    procedure ReadyAction(Msg: TChrMsg);
    procedure Shift(dir, step, cur, Max: Integer);
    function GetMessage(ChrMsg: pTChrMsg): Boolean;
    procedure ProcMsg;
    procedure ProcHurryMsg;
    function IsIdle: Boolean;
    function ActionFinished: Boolean;
    function Move(step: Integer): Boolean;
    procedure MoveFail;
    procedure Run;
    procedure DefaultMotion;
    function GetDefaultFrame(wmode: Boolean): Integer;
  end;



implementation
uses Common;

constructor TActor.Create;
begin
  inherited Create;
  FillChar(m_Abil_BLUE, SizeOf(TAbility_BLUE), 0);
  FillChar(m_Abil_IGE, SizeOf(TAbility_IGE), 0);
  m_nGold := 0;
  m_sUserName := '';
  m_nNameColor := clWhite;
  m_boDeath := False;
  m_boGrouped := False;
  m_boDelActor := False;
  m_MsgList := TList.Create;
  m_dwSayMsgTick := GetTickCount;
end;

destructor TActor.Destroy;
begin
  m_MsgList.Free;
  inherited;
end;

procedure TActor.SendMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
var
  Msg: pTChrMsg;
begin
  New(Msg);
  Msg.ident := wIdent;
  Msg.X := nX;
  Msg.Y := nY;
  Msg.dir := ndir;
  Msg.feature := nFeature;
  Msg.State := nState;
  Msg.saying := sStr;
  Msg.Sound := nSound;
  m_MsgList.Add(Msg);
end;

procedure TActor.UpdateMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
var
  I: Integer;
  Msg: pTChrMsg;
begin
  I := 0;
  while True do begin
    if I >= m_MsgList.Count then Break;
    Msg := m_MsgList.Items[I];
    if ((Self = GameEngine.m_MySelf) and (Msg.ident >= 3000) and (Msg.ident <= 3099)) or (Msg.ident = wIdent) then begin
      Dispose(Msg);
      m_MsgList.Delete(I);
      Continue;
    end;
    Inc(I);
  end;
  SendMsg(wIdent, nX, nY, ndir, nFeature, nState, sStr, nSound);
end;

procedure TActor.Shift(dir, step, cur, Max: Integer);
var
  unx, uny, ss, v: Integer;
begin
  unx := UNITX * step;
  uny := UNITY * step;
  if cur > Max then cur := Max;
  m_nRx := m_nCurrX;
  m_nRy := m_nCurrY;
  ss := Round((Max - cur - 1) / Max) * step;
  case dir of
    DR_UP: begin
        ss := Round((Max - cur) / Max) * step;
        m_nShiftX := 0;
        m_nRy := m_nCurrY + ss;
        if ss = step then m_nShiftY := -Round(uny / Max * cur)
        else m_nShiftY := Round(uny / Max * (Max - cur));
      end;
    DR_UPRIGHT:
      begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur + v) / Max) * step;
        m_nRx := m_nCurrX - ss;
        m_nRy := m_nCurrY + ss;
        if ss = step then begin
          m_nShiftX := Round(unx / Max * cur);
          m_nShiftY := -Round(uny / Max * cur);
        end else begin
          m_nShiftX := -Round(unx / Max * (Max - cur));
          m_nShiftY := Round(uny / Max * (Max - cur));
        end;
      end;
    DR_RIGHT:
      begin
        ss := Round((Max - cur) / Max) * step;
        m_nRx := m_nCurrX - ss;
        if ss = step then m_nShiftX := Round(unx / Max * cur)
        else m_nShiftX := -Round(unx / Max * (Max - cur));
        m_nShiftY := 0;
      end;
    DR_DOWNRIGHT:
      begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur - v) / Max) * step;
        m_nRx := m_nCurrX - ss;
        m_nRy := m_nCurrY - ss;
        if ss = step then begin
          m_nShiftX := Round(unx / Max * cur);
          m_nShiftY := Round(uny / Max * cur);
        end else begin
          m_nShiftX := -Round(unx / Max * (Max - cur));
          m_nShiftY := -Round(uny / Max * (Max - cur));
        end;
      end;
    DR_DOWN:
      begin
        if Max >= 6 then v := 1
        else v := 0;
        ss := Round((Max - cur - v) / Max) * step;
        m_nShiftX := 0;
        m_nRy := m_nCurrY - ss;
        if ss = step then m_nShiftY := Round(uny / Max * cur)
        else m_nShiftY := -Round(uny / Max * (Max - cur));
      end;
    DR_DOWNLEFT:
      begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur - v) / Max) * step;
        m_nRx := m_nCurrX + ss;
        m_nRy := m_nCurrY - ss;
        if ss = step then begin
          m_nShiftX := -Round(unx / Max * cur);
          m_nShiftY := Round(uny / Max * cur);
        end else begin
          m_nShiftX := Round(unx / Max * (Max - cur));
          m_nShiftY := -Round(uny / Max * (Max - cur));
        end;
      end;
    DR_LEFT:
      begin
        ss := Round((Max - cur) / Max) * step;
        m_nRx := m_nCurrX + ss;
        if ss = step then m_nShiftX := -Round(unx / Max * cur)
        else m_nShiftX := Round(unx / Max * (Max - cur));
        m_nShiftY := 0;
      end;
    DR_UPLEFT:
      begin
        if Max >= 6 then v := 2
        else v := 0;
        ss := Round((Max - cur + v) / Max) * step;
        m_nRx := m_nCurrX + ss;
        m_nRy := m_nCurrY + ss;
        if ss = step then begin
          m_nShiftX := -Round(unx / Max * cur);
          m_nShiftY := -Round(uny / Max * cur);
        end else begin
          m_nShiftX := Round(unx / Max * (Max - cur));
          m_nShiftY := Round(uny / Max * (Max - cur));
        end;
      end;
  end;
end;

procedure TActor.FeatureChanged;
begin
  case m_btRace of
    0: begin
        m_btHair := HAIRfeature(m_nFeature);
        m_btDress := DRESSfeature(m_nFeature);
        m_btWeapon := WEAPONfeature(m_nFeature);
      end;
  end;
end;

procedure TActor.CalcActorFrame;
var
  haircount: Integer;
begin
  case m_nCurrentAction of
    SM_TURN: begin

      end;
    SM_WALK, SM_RUSH, SM_RUSHKUNG, SM_BACKSTEP: begin

      end;

    SM_HIT: begin

      end;
    SM_STRUCK: begin


      end;
    SM_DEATH: begin

      end;
    SM_NOWDEATH: begin

      end;
    SM_SKELETON: begin

      end;
  end;
end;

procedure TActor.ReadyAction(Msg: TChrMsg);
var
  n: Integer;
  UseMagic: PTUseMagicInfo;
begin
  m_nActBeforeX := m_nCurrX;
  m_nActBeforeY := m_nCurrY;

  if Msg.ident = SM_ALIVE then begin
    m_boDeath := False;
    m_boSkeleton := False;
  end;
  if not m_boDeath then begin
    case Msg.ident of
      SM_TURN, SM_WALK, SM_BACKSTEP, SM_RUSH, SM_RUSHKUNG, SM_RUN, SM_HORSERUN, SM_DIGUP, SM_ALIVE:
        begin
          m_nFeature := Msg.feature;
          m_nState := Msg.State;
        end;
    end;
    if Msg.ident = SM_LIGHTING then
      n := 0;
    if GameEngine.m_MySelf = Self then begin
     { if (Msg.ident = CM_WALK) then
        if not PlayScene.CanWalk(Msg.x, Msg.y) then
          Exit; //�̵� �Ұ�
      if (Msg.ident = CM_RUN) then
        if not PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Msg.x, Msg.y) then
          Exit; //�̵� �Ұ�
      if (Msg.ident = CM_HORSERUN) then
        if not PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, Msg.x, Msg.y) then
          Exit; //�̵� �Ұ�
       }
         //msg
      case Msg.ident of
        CM_TURN,
          CM_WALK,
          CM_SITDOWN,
          CM_RUN,
          CM_HIT,
          CM_HEAVYHIT,
          CM_BIGHIT,
          CM_POWERHIT,
          CM_LONGHIT,
          CM_WIDEHIT,
          CM_CRSHIT:
          begin
            RealActionMsg := Msg; //���� ����ǰ� �ִ� �ൿ, ������ �޼����� ����.
            Msg.ident := Msg.ident - 3000; //SM_?? ���� ��ȯ ��
          end;
        CM_HORSERUN: begin
            RealActionMsg := Msg;
            Msg.ident := SM_HORSERUN;
          end;
        CM_THROW: begin
            if m_nFeature <> 0 then begin
              m_nTargetX := TActor(Msg.feature).m_nCurrX; //x ������ ��ǥ
              m_nTargetY := TActor(Msg.feature).m_nCurrY; //y
              m_nTargetRecog := TActor(Msg.feature).m_nRecogId;
            end;
            RealActionMsg := Msg;
            Msg.ident := SM_THROW;
          end;
        CM_FIREHIT: begin
            RealActionMsg := Msg;
            Msg.ident := SM_FIREHIT;
          end;
        CM_3037: begin
            RealActionMsg := Msg;
            Msg.ident := SM_41;
          end;
        CM_SPELL: begin
            RealActionMsg := Msg;
            UseMagic := PTUseMagicInfo(Msg.feature);
            RealActionMsg.dir := UseMagic.MagicSerial;
            Msg.ident := Msg.ident - 3000; //SM_?? ���� ��ȯ ��
          end;
      end;

      m_nOldX := m_nCurrX;
      m_nOldY := m_nCurrY;
      m_nOldDir := m_btDir;
    end;
    {
    if Msg.ident = SM_WALK then
      GameEngine.AddChatBoardString('1 ' + m_sUserName + ' m_nCurrX:' + IntToStr(m_nCurrX) + ' m_nCurrY:' + IntToStr(m_nCurrY) + ' nX:' + IntToStr(Msg.X) + ' nY:' + IntToStr(Msg.Y), 255, 253);

    }
    case Msg.ident of
      SM_SPELL: begin
          m_btDir := Msg.dir;
               //msg.x  :targetx
               //msg.y  :targety
          UseMagic := PTUseMagicInfo(Msg.feature);
          if UseMagic <> nil then begin
            m_CurMagic := UseMagic^;
            m_CurMagic.ServerMagicCode := -1; //FIRE ���
                  //CurMagic.MagicSerial := 0;
            m_CurMagic.targx := Msg.X;
            m_CurMagic.targy := Msg.Y;
            Dispose(UseMagic);
          end;
               //DScreen.AddSysMsg ('SM_SPELL');
        end;
    else begin
        if (Msg.ident <> SM_MAGICFIRE) and (Msg.ident <> SM_MAGICFIRE_FAIL) then begin
          m_nCurrX := Msg.X;
          m_nCurrY := Msg.Y;
          m_btDir := Msg.dir;
          //GameEngine.AddChatBoardString(m_sUserName + ' X:' + IntToStr(m_nCurrX) + ' Y:' + IntToStr(m_nCurrY), 255, 253);
        end;
      end;
    end;
   { if Msg.ident = SM_WALK then
      GameEngine.AddChatBoardString('2 ' + m_sUserName + ' m_nCurrX:' + IntToStr(m_nCurrX) + ' m_nCurrY:' + IntToStr(m_nCurrY) + ' nX:' + IntToStr(Msg.X) + ' nY:' + IntToStr(Msg.Y), 255, 253);
     }
    //m_nCurrentAction := Msg.ident;
    CalcActorFrame;
      //DScreen.AddSysMsg (IntToStr(msg.Ident) + ' ' + IntToStr(XX) + ' ' + IntToStr(YY) + ' : ' + IntToStr(msg.x) + ' ' + IntToStr(msg.y));
  end else begin
    if Msg.ident = SM_SKELETON then begin
      //m_nCurrentAction := Msg.ident;
      CalcActorFrame;
      m_boSkeleton := True;
    end;
  end;
  if (Msg.ident = SM_DEATH) or (Msg.ident = SM_NOWDEATH) then begin
    m_boDeath := True;
    if GameEngine.m_MagicTarget = Self then GameEngine.m_MagicTarget := nil;
    GameEngine.ActorDied(Self);
  end;
 { if Msg.ident = SM_WALK then
    GameEngine.AddChatBoardString('3 ' + m_sUserName + ' m_nCurrX:' + IntToStr(m_nCurrX) + ' m_nCurrY:' + IntToStr(m_nCurrY) + ' nX:' + IntToStr(Msg.X) + ' nY:' + IntToStr(Msg.Y), 255, 253);
   }
end;

function TActor.GetMessage(ChrMsg: pTChrMsg): Boolean;
var
  Msg: pTChrMsg;
begin
  Result := False;
  if m_MsgList.Count > 0 then begin
    Msg := m_MsgList.Items[0];
    ChrMsg.ident := Msg.ident;
    ChrMsg.X := Msg.X;
    ChrMsg.Y := Msg.Y;
    ChrMsg.dir := Msg.dir;
    ChrMsg.State := Msg.State;
    ChrMsg.feature := Msg.feature;
    ChrMsg.saying := Msg.saying;
    ChrMsg.Sound := Msg.Sound;
    Dispose(Msg);
    m_MsgList.Delete(0);
    Result := True;
  end;
end;

procedure TActor.ProcMsg;
var
  Msg: TChrMsg;
  //meff: TMagicEff;
begin
  while (m_nCurrentAction = 0) and GetMessage(@Msg) do begin
    {if Msg.ident = SM_WALK then
      GameEngine.AddChatBoardString('TActor.ProcMsg: ' + m_sUserName + ' m_nCurrX:' + IntToStr(m_nCurrX) + ' m_nCurrY:' + IntToStr(m_nCurrY) + ' nX:' + IntToStr(Msg.X) + ' nY:' + IntToStr(Msg.Y), 255, 253);
    }
    case Msg.ident of
      SM_STRUCK: begin
          //m_nHiterCode := Msg.sound;
          ReadyAction(Msg);
        end;
      SM_DEATH, //27
        SM_NOWDEATH,
        SM_SKELETON,
        SM_ALIVE,
        SM_ACTION_MIN..SM_ACTION_MAX, //26
        SM_ACTION2_MIN..SM_ACTION2_MAX, //35   2293    293
        3000..3099: begin
          ReadyAction(Msg);
        end;

      SM_SPACEMOVE_SHOW: begin
          //meff := TCharEffect.Create(260, 10, Self);
          //PlayScene.m_EffectList.Add(meff);
          Msg.ident := SM_TURN;
          ReadyAction(Msg);
          //PlaySound(s_spacemove_in);
        end;
      SM_SPACEMOVE_SHOW2: begin
          //meff := TCharEffect.Create(1600, 10, Self);
          //PlayScene.m_EffectList.Add(meff);
          Msg.ident := SM_TURN;
          ReadyAction(Msg);
          //PlaySound(s_spacemove_in);
        end;
    else begin

        ReadyAction(Msg); //Damian

      end;
    end;
  end;
end;

procedure TActor.ProcHurryMsg;
var
  n: Integer;
  Msg: TChrMsg;
  fin: Boolean;
begin
  n := 0;
  while True do begin
    if m_MsgList.Count <= n then Break;
    Msg := pTChrMsg(m_MsgList[n])^;
    fin := False;
    case Msg.ident of
      SM_MAGICFIRE:
        if m_CurMagic.ServerMagicCode <> 0 then begin
          m_CurMagic.ServerMagicCode := 111;
          m_CurMagic.target := Msg.X;

          m_CurMagic.EffectType := TMagicType(Msg.Y); //EffectType
          m_CurMagic.EffectNumber := Msg.dir; //Effect
          m_CurMagic.targx := Msg.feature;
          m_CurMagic.targy := Msg.State;
          m_CurMagic.Recusion := True;
          fin := True;
//               DScreen.AddSysMsg ('SM_MAGICFIRE GOOD');
        end;
      SM_MAGICFIRE_FAIL:
        if m_CurMagic.ServerMagicCode <> 0 then begin
          m_CurMagic.ServerMagicCode := 0;
          fin := True;
        end;
    end;
    if fin then begin
      Dispose(pTChrMsg(m_MsgList[n]));
      m_MsgList.Delete(n);
    end else Inc(n);
  end;
end;

function TActor.IsIdle: Boolean;
begin
  if (m_nCurrentAction = 0) and (m_MsgList.Count = 0) then
    Result := True
  else Result := False;
end;

function TActor.ActionFinished: Boolean;
begin

end;

procedure TActor.Run;
begin

end;


function TActor.GetDefaultFrame(wmode: Boolean): Integer;
begin

end;

procedure TActor.DefaultMotion;
begin

end;

function TActor.Move(step: Integer): Boolean;
begin

end;

procedure TActor.MoveFail;
begin
  m_nCurrentAction := 0;
  m_boLockEndFrame := True;
  GameEngine.m_MySelf.m_nCurrX := m_nOldx;
  GameEngine.m_MySelf.m_nCurrY := m_nOldy;
  GameEngine.m_MySelf.m_btDir := m_nOldDir;
end;

end.

