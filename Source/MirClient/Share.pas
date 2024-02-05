unit Share;

interface
uses
  Windows, Classes, SysUtils, Graphics, Controls, Math, DIB, Textures, HUtil32;

type
  TBGRS = array[0..High(Word)] of TBGR;
  PBGRS = ^TBGRS;

  TRGBEffects = array[0..255, 0..255] of Byte;
  PRGBEffects = ^TRGBEffects;

  TRGBColors = array[0..255, 0..255, 0..255] of Word;
  PRGBColors = ^TRGBColors;

  TColorEffect = (ceNone, ceGrayScale, ceBright, ceBlack, ceWhite, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);
{===================================TGList===================================}
  TGList = class(TList)
  private
    CriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  {=================================TGStringList================================}
  TGStringList = class(TStringList)
  private
    CriticalSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TSortStringList = class(TStringList)
  public
    procedure NumberSort(Flag: Boolean);
    procedure DateTimeSort(Flag: Boolean);
    procedure StringSort(Flag: Boolean);
  end;

  TSysMsg = record
    sSysMsg: string;
    Color: TColor;
    nX: Integer;
    nY: Integer;
    dwSpellTime: LongWord;
  end;
  pTSysMsg = ^TSysMsg;

  TMoveMsg = record
    //sMsg: string;
    Texture: TTexture;
    //FColor: Byte;
    BColor: Byte;
    Count: Integer;
    X, Y: Integer;
  end;
  pTMoveMsg = ^TMoveMsg;

const
  CLIENTTEST = 1; //0��ʽ��   1����
  MIRSCLIENT = 0; //0���� 1�⴫  20120918
  sVERSION = '�汾�ţ� 20130118';

  GL_QUIT = 100;
  GL_FILTERMODULE = 101;

  CM_Initialize = 1000;
  CM_Finalize = 1001;
  CM_QUIT = 1100;


  LONGHEIGHT_IMAGE = 35;
  FLASHBASE = 410;
  AAX = 16;
  SOFFX = 0;
  SOFFY = 0;
  LMX = 30;
  LMY = 26;
  MAXLIGHT = 5;

  RUNLOGINCODE = 0; //������Ϸ״̬��,Ĭ��Ϊ0 ����Ϊ 9

  STDCLIENT = 0;
  RMCLIENT = 99;
  ClientType = 0; //��ͨ��Ϊ0 ,99 Ϊ����ͻ���

  RMCLIENTTITLE = 'MakeGM';
  DEBUG = 0;
  //SWH800 = 0;
  //SWH1024 = 1;
  //SWH = SWH800; //SWH800;

  CUSTOMLIBFILE = 0; //�Զ���ͼ��λ��

  WINLEFT = 60;
  WINTOP = 60;

  // Bottom WINBOTTOM

  MAPDIR = 'Map\'; //��ͼ�ļ�����Ŀ¼
  CONFIGFILE = 'Config\%s.%s.Set';
  ITEMFILTER = 'Config\%s.%s.ItemFilter.dat';
  ITEMDESCFILE = 'Data\ItemDesc.Dat';
  (*
{$IF CUSTOMLIBFILE = 1}
  EFFECTIMAGEDIR = 'Graphics\Effect\';
  MAINIMAGEFILE = 'Graphics\FrmMain\Main.wil';
  MAINIMAGEFILE2 = 'Graphics\FrmMain\Main2.wil';
  MAINIMAGEFILE3 = 'Graphics\FrmMain\Main3.wil';
{$ELSE}
  MAINIMAGEFILE = 'Data\Prguse.wil';
  MAINIMAGEFILE2 = 'Data\Prguse2.wil';
  MAINIMAGEFILE3 = 'Data\Prguse3.wil';

  EFFECTIMAGEDIR = 'Data\';
{$IFEND}
      *)


  EFFECTIMAGEDIR = 'Data\';
  NPCFACEIMAGEFILE = 'Data\NpcFace.wil';
  FNPCIMAGESFILE = 'Data\F-Npc.Data';

{$IF MIRSCLIENT = 0}
  MAINIMAGEFILE = 'Data\Prguse.wil';
  MAINIMAGEFILE2 = 'Data\Prguse2.wil';
  MAINIMAGEFILE3 = 'Data\Prguse3.wil';
{$ELSE}
  MAINIMAGEFILE = 'Data\Prguse_16.wil';
  MAINIMAGEFILE2 = 'Data\Prguse2_16.wil';
  MAINIMAGEFILE3 = 'Data\Prguse3_16.wil';
{$IFEND}


{$IF MIRSCLIENT = 0}
  CHRSELIMAGEFILE = 'Data\ChrSel.wil';
{$ELSE}
  CHRSELIMAGEFILE = 'Data\ChrSel_16.wil';
{$IFEND}

  MINMAPIMAGEFILE = 'Data\mmap.wil';
  TITLESIMAGEFILE = 'Data\Tiles.wil';
  SMLTITLESIMAGEFILE = 'Data\SmTiles.wil';
  HUMWINGIMAGESFILE = 'Data\HumEffect.wil';
  HUM1WINGIMAGESFILE = 'Data\HumEffect1.wil';
  HUM2WINGIMAGESFILE = 'Data\HumEffect2.wil';
  MAGICONIMAGESFILE = 'Data\MagIcon.wil';
  HUMIMGIMAGESFILE = 'Data\Hum.wil';
  HAIRIMGIMAGESFILE = 'Data\Hair.wil';
  HAIRIMGIMAGESFILE2 = 'Data\Hair2.wil';
  WEAPONIMAGESFILE = 'Data\Weapon.wil';
  NPCIMAGESFILE = 'Data\Npc.wil';
  MAGICIMAGESFILE = 'Data\Magic.wil';
  MAGIC2IMAGESFILE = 'Data\Magic2.wil';
  MAGIC3IMAGESFILE = 'Data\Magic3.wil';
  MAGIC4IMAGESFILE = 'Data\Magic4.wil';
  MAGIC5IMAGESFILE = 'Data\Magic5.wil';
  MAGIC6IMAGESFILE = 'Data\Magic6.wil';
  EVENTEFFECTIMAGESFILE = EFFECTIMAGEDIR + 'Event.wil';
  BAGITEMIMAGESFILE = 'Data\Items.wil';
  STATEITEMIMAGESFILE = 'Data\StateItem.wil';
  DNITEMIMAGESFILE = 'Data\DnItems.wil';
  OBJECTIMAGEFILE = 'Data\Objects.wil';
  OBJECTIMAGEFILE1 = 'Data\Objects%d.wil';
  MONIMAGEFILE = 'Data\Mon%d.wil';
  DRAGONIMAGEFILE = 'Data\Dragon.wil';
  EFFECTIMAGEFILE = 'Data\Effect.wil';

  MONIMAGEFILEEX = 'Graphics\Monster\%d.wil';
  MONPMFILE = 'Graphics\Monster\%d.pm';

  CQFIRIMAGESFILE = 'Data\F-Cqfir.Data';

  HORSEIMAGESFILE = 'Data\F-Horse.wil';
  HUMHORSEIMAGESFILE = 'Data\F-HumHorse.wil';
  HAIRHORSEIMAGESFILE = 'Data\F-HairHorse.wil';

  HUMIMGIMAGESFILES = 'Data\Hum%d.wil';
  WEAPONIMAGESFILES = 'Data\Weapon%d.wil';

  EXPLAIN2FILE = 'Data\explain2.dat';
  MAPDESC1FILE = 'Data\MapDesc1.dat';



  WISMAINIMAGEFILE = 'Data\Prguse.wis';
  WISMAINIMAGEFILE2 = 'Data\Prguse2.wis';
  WISMAINIMAGEFILE3 = 'Data\Prguse3.wis';
  CBOEFFECTIMAGEFILE = 'Data\cboEffect.wis';
  CBOHAIRIMGIMAGESFILE = 'Data\cboHair.wis';
  CBOHUMIMGIMAGESFILE = 'Data\cboHum.wis';
  CBOHUMWINGIMAGESFILE = 'Data\cboHumEffect.wis';
  CBOWEAPONIMAGESFILE = 'Data\cboWeapon.wis';

  WISDNITEMIMAGESFILE = 'Data\DnItems.wis';
  WISBAGITEMIMAGESFILE = 'Data\Items.wis';
  WISSTATEITEMIMAGESFILE = 'Data\StateItem.wis';
  WISEAPONIMAGESFILE = 'Data\Weapon2.wis';




  DEFAULTCURSOR = 0; //ϵͳĬ�Ϲ��
  IMAGECURSOR = 1; //ͼ�ι��

  USECURSOR = DEFAULTCURSOR; //ʹ��ʲô���͵Ĺ��

  MAXBAGITEMCL = 46;

  MAXFONT = 8;
  ENEMYCOLOR = 69;

  NEARESTPALETTEINDEXFILE = 'Data\npal.idx';

  MonImageDir = '.\Monster\';
  NpcImageDir = '.\Npc\';
  ItemImageDir = '.\Items\';
  WeaponImageDir = '\Weapon';
  HumImageDir = '.\Human\';



  sGameNoticeName = '������Ϸ����';
  sGameNoticeStr1 = '���Ʋ�����Ϸ���ܾ�������Ϸ��ע�����ұ�����������ƭ�ϵ����ʶ���Ϸ���ԣ�';
  sGameNoticeStr2 = '������Ϸ����������ʱ�䣬���ܽ��������������Ĳ���Ӫ���г������';
var

 //{$IF SWH = SWH800}
  SCREENWIDTH: Integer = 800;
  SCREENHEIGHT: Integer = 600;
//{$ELSEIF SWH = SWH1024}
  //SCREENWIDTH = 1024;
  //SCREENHEIGHT = 768;
//{$IFEND}

  MAPSURFACEWIDTH: Integer = 800;
  MAPSURFACEHEIGHT: Integer = 600;


  WINRIGHT: Integer = 520;
  BOTTOMEDGE: Integer = 570;

  MAXX: Integer = 40;
  MAXY: Integer = 40;

  BGRS: TBGRS;
  RGBEffects: TRGBEffects;
  //RGBColors: TRGBColors;
  //RGBColorsA: TRGBColors;
  //Module : Integer;
  //PFunc: procedure(AppHandle:Integer); stdcall;
  g_DefColorTable: array[0..255] of TRGBQuad;
  ColorArray: array[0..1023] of Byte = (
    $00, $00, $00, $00, $00, $00, $80, $00, $00, $80, $00, $00, $00, $80, $80, $00,
    $80, $00, $00, $00, $80, $00, $80, $00, $80, $80, $00, $00, $C0, $C0, $C0, $00,
    $97, $80, $55, $00, $C8, $B9, $9D, $00, $73, $73, $7B, $00, $29, $29, $2D, $00,
    $52, $52, $5A, $00, $5A, $5A, $63, $00, $39, $39, $42, $00, $18, $18, $1D, $00,
    $10, $10, $18, $00, $18, $18, $29, $00, $08, $08, $10, $00, $71, $79, $F2, $00,
    $5F, $67, $E1, $00, $5A, $5A, $FF, $00, $31, $31, $FF, $00, $52, $5A, $D6, $00,
    $00, $10, $94, $00, $18, $29, $94, $00, $00, $08, $39, $00, $00, $10, $73, $00,
    $00, $18, $B5, $00, $52, $63, $BD, $00, $10, $18, $42, $00, $99, $AA, $FF, $00,
    $00, $10, $5A, $00, $29, $39, $73, $00, $31, $4A, $A5, $00, $73, $7B, $94, $00,
    $31, $52, $BD, $00, $10, $21, $52, $00, $18, $31, $7B, $00, $10, $18, $2D, $00,
    $31, $4A, $8C, $00, $00, $29, $94, $00, $00, $31, $BD, $00, $52, $73, $C6, $00,
    $18, $31, $6B, $00, $42, $6B, $C6, $00, $00, $4A, $CE, $00, $39, $63, $A5, $00,
    $18, $31, $5A, $00, $00, $10, $2A, $00, $00, $08, $15, $00, $00, $18, $3A, $00,
    $00, $00, $08, $00, $00, $00, $29, $00, $00, $00, $4A, $00, $00, $00, $9D, $00,
    $00, $00, $DC, $00, $00, $00, $DE, $00, $00, $00, $FB, $00, $52, $73, $9C, $00,
    $4A, $6B, $94, $00, $29, $4A, $73, $00, $18, $31, $52, $00, $18, $4A, $8C, $00,
    $11, $44, $88, $00, $00, $21, $4A, $00, $10, $18, $21, $00, $5A, $94, $D6, $00,
    $21, $6B, $C6, $00, $00, $6B, $EF, $00, $00, $77, $FF, $00, $84, $94, $A5, $00,
    $21, $31, $42, $00, $08, $10, $18, $00, $08, $18, $29, $00, $00, $10, $21, $00,
    $18, $29, $39, $00, $39, $63, $8C, $00, $10, $29, $42, $00, $18, $42, $6B, $00,
    $18, $4A, $7B, $00, $00, $4A, $94, $00, $7B, $84, $8C, $00, $5A, $63, $6B, $00,
    $39, $42, $4A, $00, $18, $21, $29, $00, $29, $39, $46, $00, $94, $A5, $B5, $00,
    $5A, $6B, $7B, $00, $94, $B1, $CE, $00, $73, $8C, $A5, $00, $5A, $73, $8C, $00,
    $73, $94, $B5, $00, $73, $A5, $D6, $00, $4A, $A5, $EF, $00, $8C, $C6, $EF, $00,
    $42, $63, $7B, $00, $39, $56, $6B, $00, $5A, $94, $BD, $00, $00, $39, $63, $00,
    $AD, $C6, $D6, $00, $29, $42, $52, $00, $18, $63, $94, $00, $AD, $D6, $EF, $00,
    $63, $8C, $A5, $00, $4A, $5A, $63, $00, $7B, $A5, $BD, $00, $18, $42, $5A, $00,
    $31, $8C, $BD, $00, $29, $31, $35, $00, $63, $84, $94, $00, $4A, $6B, $7B, $00,
    $5A, $8C, $A5, $00, $29, $4A, $5A, $00, $39, $7B, $9C, $00, $10, $31, $42, $00,
    $21, $AD, $EF, $00, $00, $10, $18, $00, $00, $21, $29, $00, $00, $6B, $9C, $00,
    $5A, $84, $94, $00, $18, $42, $52, $00, $29, $5A, $6B, $00, $21, $63, $7B, $00,
    $21, $7B, $9C, $00, $00, $A5, $DE, $00, $39, $52, $5A, $00, $10, $29, $31, $00,
    $7B, $BD, $CE, $00, $39, $5A, $63, $00, $4A, $84, $94, $00, $29, $A5, $C6, $00,
    $18, $9C, $10, $00, $4A, $8C, $42, $00, $42, $8C, $31, $00, $29, $94, $10, $00,
    $10, $18, $08, $00, $18, $18, $08, $00, $10, $29, $08, $00, $29, $42, $18, $00,
    $AD, $B5, $A5, $00, $73, $73, $6B, $00, $29, $29, $18, $00, $4A, $42, $18, $00,
    $4A, $42, $31, $00, $DE, $C6, $63, $00, $FF, $DD, $44, $00, $EF, $D6, $8C, $00,
    $39, $6B, $73, $00, $39, $DE, $F7, $00, $8C, $EF, $F7, $00, $00, $E7, $F7, $00,
    $5A, $6B, $6B, $00, $A5, $8C, $5A, $00, $EF, $B5, $39, $00, $CE, $9C, $4A, $00,
    $B5, $84, $31, $00, $6B, $52, $31, $00, $D6, $DE, $DE, $00, $B5, $BD, $BD, $00,
    $84, $8C, $8C, $00, $DE, $F7, $F7, $00, $18, $08, $00, $00, $39, $18, $08, $00,
    $29, $10, $08, $00, $00, $18, $08, $00, $00, $29, $08, $00, $A5, $52, $00, $00,
    $DE, $7B, $00, $00, $4A, $29, $10, $00, $6B, $39, $10, $00, $8C, $52, $10, $00,
    $A5, $5A, $21, $00, $5A, $31, $10, $00, $84, $42, $10, $00, $84, $52, $31, $00,
    $31, $21, $18, $00, $7B, $5A, $4A, $00, $A5, $6B, $52, $00, $63, $39, $29, $00,
    $DE, $4A, $10, $00, $21, $29, $29, $00, $39, $4A, $4A, $00, $18, $29, $29, $00,
    $29, $4A, $4A, $00, $42, $7B, $7B, $00, $4A, $9C, $9C, $00, $29, $5A, $5A, $00,
    $14, $42, $42, $00, $00, $39, $39, $00, $00, $59, $59, $00, $2C, $35, $CA, $00,
    $21, $73, $6B, $00, $00, $31, $29, $00, $10, $39, $31, $00, $18, $39, $31, $00,
    $00, $4A, $42, $00, $18, $63, $52, $00, $29, $73, $5A, $00, $18, $4A, $31, $00,
    $00, $21, $18, $00, $00, $31, $18, $00, $10, $39, $18, $00, $4A, $84, $63, $00,
    $4A, $BD, $6B, $00, $4A, $B5, $63, $00, $4A, $BD, $63, $00, $4A, $9C, $5A, $00,
    $39, $8C, $4A, $00, $4A, $C6, $63, $00, $4A, $D6, $63, $00, $4A, $84, $52, $00,
    $29, $73, $31, $00, $5A, $C6, $63, $00, $4A, $BD, $52, $00, $00, $FF, $10, $00,
    $18, $29, $18, $00, $4A, $88, $4A, $00, $4A, $E7, $4A, $00, $00, $5A, $00, $00,
    $00, $88, $00, $00, $00, $94, $00, $00, $00, $DE, $00, $00, $00, $EE, $00, $00,
    $00, $FB, $00, $00, $94, $5A, $4A, $00, $B5, $73, $63, $00, $D6, $8C, $7B, $00,
    $D6, $7B, $6B, $00, $FF, $88, $77, $00, $CE, $C6, $C6, $00, $9C, $94, $94, $00,
    $C6, $94, $9C, $00, $39, $31, $31, $00, $84, $18, $29, $00, $84, $00, $18, $00,
    $52, $42, $4A, $00, $7B, $42, $52, $00, $73, $5A, $63, $00, $F7, $B5, $CE, $00,
    $9C, $7B, $8C, $00, $CC, $22, $77, $00, $FF, $AA, $DD, $00, $2A, $B4, $F0, $00,
    $9F, $00, $DF, $00, $B3, $17, $E3, $00, $F0, $FB, $FF, $00, $A4, $A0, $A0, $00,
    $80, $80, $80, $00, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $FF, $FF, $00,
    $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $FF, $FF, $00
    );
function GetRGB(c256: Byte): Integer;
function GetRGB16(c256, btBitCount: Byte): Integer;
procedure DrawBlend(dsuf: TTexture; X, Y: Integer; ssuf: TTexture);
procedure DrawBlendEx(dsuf: TTexture; X, Y: Integer; ssuf: TTexture; ssufleft, ssuftop, ssufwidth, ssufheight: Integer);
procedure DrawEffect(ssuf: TTexture; eff: TColorEffect);
implementation
uses GameImages;
var
  masknogreen: Int64;
  maskred: Int64 = $F800F800F800F800;
  maskblue: Int64 = $001F001F001F001F;
  maskgreen: Int64 = $07E007E007E007E0;
  maskbyte: Int64 = $7E0F81F;
  maskkey: Int64 = $0000000000000000;
  maskdate1: Int64 = $00FF00FF00FF00FF;
  maskdate2: Int64 = $FFFFFFFFFFFFFFFF;
  maskdate3: Int64 = $00F800F800F800F8;
  maskdate4: Int64 = $00FC00FC00FC00FC;
  maskdate5: Int64 = $0008000800080008;
  maskdate6: Int64 = $000C000C000C000C;

procedure DrawBlend(dsuf: TTexture; X, Y: Integer; ssuf: TTexture);
begin
  DrawBlendEx(dsuf, X, Y, ssuf, 0, 0, ssuf.Width, ssuf.Height);
end;

{procedure DrawBlendEx(dsuf: TTexture; X, Y: Integer; ssuf: TTexture; ssufleft, ssuftop, ssufwidth, ssufheight: Integer);
var
  ta, tb, tc, td, I, II, j, k, L, tmp, srcleft, srctop, srcwidth, srcbottom, sidx, didx: Integer;
  sptr, dptr, pmix: PWord;
  bitindex, scount, dcount, SrcLen, destlen, wcount, AWidth, bwidth: Integer;
  r, G, b, dr, dg, db, stmp, dtmp: Word;
begin
  if (dsuf = nil) or (ssuf = nil) then Exit;
  if X >= dsuf.Width then Exit;
  if Y >= dsuf.Height then Exit;

  if X < 0 then begin
    srcleft := -X;
    srcwidth := ssufwidth + X;
    X := 0;
  end else begin
    srcleft := ssufleft;
    srcwidth := ssufwidth;
  end;
  if Y < 0 then begin
    srctop := -Y;
    srcbottom := ssufheight;
    Y := 0;
  end else begin
    srctop := ssuftop;
    srcbottom := srctop + ssufheight;
  end;
  if srcleft + srcwidth > ssuf.Width then srcwidth := ssuf.Width - srcleft;
  if srcbottom > ssuf.Height then
    srcbottom := ssuf.Height; //-srcheight;
  if X + srcwidth > dsuf.Width then srcwidth := (dsuf.Width - X) div 4 * 4;
  if Y + srcbottom - srctop > dsuf.Height then
    srcbottom := dsuf.Height - Y + srctop;
  if (X + srcwidth) * (Y + srcbottom - srctop) > dsuf.Width * dsuf.Height then //�ӽ�..
    srcbottom := srctop + (srcbottom - srctop) div 2;

  if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= ssuf.Width) or (srctop >= ssuf.Height) then Exit;

  if srcwidth > SCREENWIDTH + 100 then Exit;

  AWidth := srcwidth div 4; //ssuf.Width div 4;
  bwidth := srcwidth; //ssuf.Width;
  SrcLen := srcwidth; //ssuf.Width;
  destlen := srcwidth; //ssuf.Width;

  for I := srctop to srcbottom - 1 do begin
    sptr := PWord(Integer(ssuf.PBits) + ssuf.Pitch * I + srcleft * 2);
    dptr := PWord(Integer(dsuf.PBits) + (Y + I - srctop) * dsuf.Pitch + X * 2);
    for II := 0 to srcwidth - 1 do begin
      dptr^ :=
        (RGBEffects[BGRS[dptr^].R, BGRS[sptr^].R] shl 8 and $F800) or
        (RGBEffects[BGRS[dptr^].G, BGRS[sptr^].G] shl 3 and $07E0) or
        (RGBEffects[BGRS[dptr^].B, BGRS[sptr^].B] shr 3 and $001F);

      Inc(sptr); Inc(dptr);
    end;
  end;
end;}

procedure DrawBlendEx(dsuf: TTexture; X, Y: Integer; ssuf: TTexture; ssufleft, ssuftop, ssufwidth, ssufheight: Integer);
var
  ta, tb, tc, td, I, j, k, L, tmp, srcleft, srctop, srcwidth, srcbottom, sidx, didx: Integer;
  sptr, dptr, pmix: PWord;
  bitindex, scount, dcount, SrcLen, destlen, wcount, AWidth, bwidth: Integer;
  r, G, b, dr, dg, db, stmp, dtmp: Word;
begin
  if (dsuf = nil) or (ssuf = nil) then Exit;
  if X >= dsuf.Width then Exit;
  if Y >= dsuf.Height then Exit;

  if X < 0 then begin
    srcleft := -X;
    srcwidth := ssufwidth + X;
    X := 0;
  end else begin
    srcleft := ssufleft;
    srcwidth := ssufwidth;
  end;
  if Y < 0 then begin
    srctop := -Y;
    srcbottom := ssufheight;
    Y := 0;
  end else begin
    srctop := ssuftop;
    srcbottom := srctop + ssufheight;
  end;
  if srcleft + srcwidth > ssuf.Width then srcwidth := ssuf.Width - srcleft;
  if srcbottom > ssuf.Height then
    srcbottom := ssuf.Height; //-srcheight;
  if X + srcwidth > dsuf.Width then srcwidth := (dsuf.Width - X) div 4 * 4;
  if Y + srcbottom - srctop > dsuf.Height then
    srcbottom := dsuf.Height - Y + srctop;
  if (X + srcwidth) * (Y + srcbottom - srctop) > dsuf.Width * dsuf.Height then //�ӽ�..
    srcbottom := srctop + (srcbottom - srctop) div 2;

  if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= ssuf.Width) or (srctop >= ssuf.Height) then Exit;

  if srcwidth > SCREENWIDTH + 100 then Exit;

  AWidth := srcwidth div 4; //ssuf.Width div 4;
  bwidth := srcwidth; //ssuf.Width;
  SrcLen := srcwidth; //ssuf.Width;
  destlen := srcwidth; //ssuf.Width;

  if IsSSE then begin
    for I := srctop to srcbottom - 1 do begin
      sptr := PWord(Integer(ssuf.PBits) + ssuf.Pitch * I + srcleft * 2);
      dptr := PWord(Integer(dsuf.PBits) + (Y + I - srctop) * dsuf.Pitch + X * 2);
      j := srcwidth div 4;
      k := srcwidth mod 4;
      asm
                                push edx
                                push ecx
                       //sse2����
                        @@SSE:
                                cmp j,0
                                jle @@Exit
                                cmp j,1
                                jle @@MMX

                                mov ecx,sptr
                                mov edx,dptr

                                movdqu xmm7,[ecx]
                                movlps xmm4,maskkey
                                movhps xmm4,maskkey
                                PCMPEQW xmm7,xmm4

                                movdqu xmm0,[ecx]
                                movdqu xmm1,[edx]
                                movlps xmm4,maskred
                                movhps xmm4,maskred
                                pand xmm0,xmm4
                                pand xmm1,xmm4
                                PSRLW xmm0,8
                                PSRLW xmm1,8
                                movlps xmm2,maskdate1
                                movhps xmm2,maskdate1
                                PSUBUSW xmm2,xmm0
                                PMULLW xmm2,xmm1
                                PSRLW xmm2,8      //�������ݵ��߼�����8
                                PADDUSW xmm2,xmm0
                                movlps xmm4,maskdate3
                                movhps xmm4,maskdate3
                                PMINSW xmm2,xmm4
                                movlps xmm4,maskdate5
                                movhps xmm4,maskdate5
                                PMAXSW xmm2,xmm4
                                PSLLW xmm2,8
                                movlps xmm4,maskred
                                movhps xmm4,maskred
                                pand xmm2,xmm4

                                movdqu xmm0,[ecx]
                                movdqu xmm1,[edx]
                                movlps xmm4,maskgreen
                                movhps xmm4,maskgreen
                                pand xmm0,xmm4
                                pand xmm1,xmm4
                                PSRLW xmm0,3
                                PSRLW xmm1,3
                                movlps xmm3,maskdate1
                                movhps xmm3,maskdate1
                                PSUBUSW xmm3,xmm0
                                PMULLW xmm3,xmm1
                                PSRLW xmm3,8
                                PADDUSW xmm3,xmm0
                                movlps xmm4,maskdate4
                                movhps xmm4,maskdate4
                                PMINSW xmm3,xmm4
                                movlps xmm4,maskdate6
                                movhps xmm4,maskdate6
                                PMAXSW xmm3,xmm4
                                PSLLW xmm3,3
                                movlps xmm4,maskgreen
                                movhps xmm4,maskgreen
                                pand xmm3,xmm4
                                por xmm2,xmm3

                                movdqu xmm0,[ecx]
                                movdqu xmm1,[edx]
                                movlps xmm4,maskblue
                                movhps xmm4,maskblue
                                pand xmm0,xmm4
                                pand xmm1,xmm4
                                PSLLW xmm0,3
                                PSLLW xmm1,3
                                movlps xmm3,maskdate1
                                movhps xmm3,maskdate1
                                PSUBUSW xmm3,xmm0
                                PMULLW xmm3,xmm1
                                PSRLW xmm3,8
                                PADDUSW xmm3,xmm0
                                movlps xmm4,maskdate3
                                movhps xmm4,maskdate3
                                PMINSW xmm3,xmm4
                                movlps xmm4,maskdate5
                                movhps xmm4,maskdate5
                                PMAXSW xmm3,xmm4
                                PSRLW xmm3,3
                                movlps xmm4,maskblue
                                movhps xmm4,maskblue
                                pand xmm3,xmm4
                                por xmm2,xmm3

                                movdqu xmm1,[edx]
                                pand xmm1,xmm7
                                movlps xmm4,maskdate2
                                movhps xmm4,maskdate2
                                pandn xmm7,xmm4
                                pand xmm2,xmm7

                                por xmm2,xmm1
                                movdqu [edx],xmm2

                                add ecx,16
                                add edx,16
                                mov sptr,ecx
                                mov dptr,edx

                                sub j,2
                                jmp @@SSE

                        //mmx����
                        @@MMX:
                                cmp j,0
                                jle @@Exit

                                mov ecx,sptr
                                mov edx,dptr

                                movq mm7,[ecx]
                                PCMPEQW mm7,maskkey

                                movq mm0,[ecx]
                                movq mm1,[edx]
                                pand mm0,maskred
                                pand mm1,maskred
                                PSRLW mm0,8
                                PSRLW mm1,8
                                movq mm2,maskdate1
                                PSUBUSW mm2,mm0
                                PMULLW mm2,mm1
                                PSRLW mm2,8      //�������ݵ��߼�����8
                                PADDUSW mm2,mm0
                                PMINSW mm2,maskdate3
                                PMAXSW mm2,maskdate5
                                PSLLW mm2,8
                                pand mm2,maskred

                                movq mm0,[ecx]
                                movq mm1,[edx]
                                pand mm0,maskgreen
                                pand mm1,maskgreen
                                PSRLW mm0,3
                                PSRLW mm1,3
                                movq mm3,maskdate1
                                PSUBUSW mm3,mm0
                                PMULLW mm3,mm1
                                PSRLW mm3,8
                                PADDUSW mm3,mm0
                                PMINSW mm3,maskdate4
                                PMAXSW mm3,maskdate6
                                PSLLW mm3,3
                                pand mm3,maskgreen
                                por mm2,mm3

                                movq mm0,[ecx]
                                movq mm1,[edx]
                                pand mm0,maskblue
                                pand mm1,maskblue
                                PSLLW mm0,3
                                PSLLW mm1,3
                                movq mm3,maskdate1
                                PSUBUSW mm3,mm0
                                PMULLW mm3,mm1
                                PSRLW mm3,8
                                PADDUSW mm3,mm0
                                PMINSW mm3,maskdate3
                                PMAXSW mm3,maskdate5
                                PSRLW mm3,3
                                pand mm3,maskblue
                                por mm2,mm3

                                movq mm1,[edx]
                                pand mm1,mm7
                                pandn mm7,maskdate2
                                pand mm2,mm7

                                por mm2,mm1
                                movq [edx],mm2
                        @@Nextflag:
                                add ecx,8
                                add edx,8
                                mov sptr,ecx
                                mov dptr,edx

                                sub j,1
                                jmp @@MMX

                        @@Exit:
                                emms
                                pop edx
                                pop ecx

      end;
      for L := 1 to k do begin //ʣ�����ش���
        r := (sptr^) and $F800 shr 8;
        G := (sptr^) and $07E0 shr 3;
        b := (sptr^) and $001F shl 3;

        dr := (dptr^) and $F800 shr 8;
        dg := (dptr^) and $07E0 shr 3;
        db := (dptr^) and $001F shl 3;

        r := _MIN(255, r + Round((255 - r) / 255 * dr));
        G := _MIN(255, G + Round((255 - G) / 255 * dg));
        b := _MIN(255, b + Round((255 - b) / 255 * db));

        dptr^ := (r shl 8 and $F800) or (G shl 3 and $07E0) or (b shr 3 and $001F);
        Inc(sptr, 1);
        Inc(dptr, 1);
      end;
    end;
  end else begin
    for I := srctop to srcbottom - 1 do begin
      sptr := PWord(Integer(ssuf.PBits) + ssuf.Pitch * I + srcleft * 2);
      dptr := PWord(Integer(dsuf.PBits) + (Y + I - srctop) * dsuf.Pitch + X * 2);
      j := srcwidth div 4;
      k := srcwidth mod 4;
      asm
                                push edx
                                push ecx
                        //mmx����
                        @@MMX:
                                cmp j,0
                                jle @@Exit

                                mov ecx,sptr
                                mov edx,dptr

                                movq mm7,[ecx]
                                PCMPEQW mm7,maskkey

                                movq mm0,[ecx]
                                movq mm1,[edx]
                                pand mm0,maskred
                                pand mm1,maskred
                                PSRLW mm0,8
                                PSRLW mm1,8
                                movq mm2,maskdate1
                                PSUBUSW mm2,mm0
                                PMULLW mm2,mm1
                                PSRLW mm2,8      //�������ݵ��߼�����8
                                PADDUSW mm2,mm0
                                PMINSW mm2,maskdate3
                                PMAXSW mm2,maskdate5
                                PSLLW mm2,8
                                pand mm2,maskred

                                movq mm0,[ecx]
                                movq mm1,[edx]
                                pand mm0,maskgreen
                                pand mm1,maskgreen
                                PSRLW mm0,3
                                PSRLW mm1,3
                                movq mm3,maskdate1
                                PSUBUSW mm3,mm0
                                PMULLW mm3,mm1
                                PSRLW mm3,8
                                PADDUSW mm3,mm0
                                PMINSW mm3,maskdate4
                                PMAXSW mm3,maskdate6
                                PSLLW mm3,3
                                pand mm3,maskgreen
                                por mm2,mm3

                                movq mm0,[ecx]
                                movq mm1,[edx]
                                pand mm0,maskblue
                                pand mm1,maskblue
                                PSLLW mm0,3
                                PSLLW mm1,3
                                movq mm3,maskdate1
                                PSUBUSW mm3,mm0
                                PMULLW mm3,mm1
                                PSRLW mm3,8
                                PADDUSW mm3,mm0
                                PMINSW mm3,maskdate3
                                PMAXSW mm3,maskdate5
                                PSRLW mm3,3
                                pand mm3,maskblue
                                por mm2,mm3

                                movq mm1,[edx]
                                pand mm1,mm7
                                pandn mm7,maskdate2
                                pand mm2,mm7

                                por mm2,mm1
                                movq [edx],mm2
                        @@Nextflag:
                                add ecx,8
                                add edx,8
                                mov sptr,ecx
                                mov dptr,edx

                                sub j,1
                                jmp @@MMX

                        @@Exit:
                                emms
                                pop edx
                                pop ecx

      end;
      for L := 1 to k do begin //ʣ�����ش���
        r := (sptr^) and $F800 shr 8;
        G := (sptr^) and $07E0 shr 3;
        b := (sptr^) and $001F shl 3;

        dr := (dptr^) and $F800 shr 8;
        dg := (dptr^) and $07E0 shr 3;
        db := (dptr^) and $001F shl 3;

        r := _MIN(255, r + Round((255 - r) / 255 * dr));
        G := _MIN(255, G + Round((255 - G) / 255 * dg));
        b := _MIN(255, b + Round((255 - b) / 255 * db));

        dptr^ := (r shl 8 and $F800) or (G shl 3 and $07E0) or (b shr 3 and $001F);
        Inc(sptr, 1);
        Inc(dptr, 1);
      end;
    end;
  end;
end;

procedure DrawEffect(ssuf: TTexture; eff: TColorEffect);
  procedure BlackEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        if (sptr^) <> 0 then
        begin
          tmp := sptr^;
          r := Word(_MAX(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3 * 0.6), 1));
          G := r;
          b := r;
          sptr^ := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));
        end;
        Inc(sptr);
      end;
    end;

  end;

  procedure WhiteEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    {for I := 0 to Height - 1 do begin
      sptr := PWord(Integer(ssuf.PBits) + (Y + I) * ssuf.Pitch + X * 2);
      for j := 0 to Width - 1 do begin
                                 //if not ((sptr^)=0) then
        begin
          tmp := sptr^;
          r := Word(_MIN(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3 * 1.6), 255));
          G := r;
          b := r;
          sptr^ := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));
        end;
        Inc(sptr);
      end;
    end; }
  end;

  procedure GreenEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b, n: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        sptr^ := ColorTableGreen_565[sptr^];
       { if (sptr^) <> 0 then
        begin
          tmp := sptr^;
          r := 0;
          G := Word(_MAX(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3), $20)); //max�������ɫ��ע��
          b := 0;
          sptr^ := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));
          sptr^ := G and $FC shl 3;
        end; }
        Inc(sptr);
      end;
    end;
  end;

  procedure BlueEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        sptr^ := ColorTableBlue_565[sptr^];
        {if (sptr^) <> 0 then begin
          tmp := sptr^;
          r := 0;
          G := 0;
          b := Word(_MAX(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3), $08)); //0x08����С����ɫֵ������������������ܻ��ɺ�ɫ������͸����
          sptr^ := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));
        end;}
        Inc(sptr);
      end;
    end;
  end;

  procedure YellowEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        sptr^ := ColorTableYellow_565[sptr^];
        {if (sptr^) <> 0 then begin
          tmp := sptr^;
          r := Word(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3));
          G := r;
          b := 0;
          sptr^ := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));
        end; }
        Inc(sptr);
      end;
    end;
  end;

  procedure FuchsiaEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        sptr^ := ColorTableFuchsia_565[sptr^];
        {if (sptr^) <> 0 then begin
          tmp := sptr^;
          r := Word(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3));
          G := 0;
          b := r;
          sptr^ := _MAX(Word((r and $F8 shl 8) or (b and $F8 shr 3)), $0801);
        end;}
        Inc(sptr);
      end;
    end;
  end;


//iamwgh����Ч��        psrlq mm1,1

  procedure BrightEffect();
  var
    I, j, k, L: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        sptr^ := ColorTableBright_565[sptr^];
        {if (sptr^) <> 0 then begin
          tmp := sptr^;
          r := _MIN(Round((tmp and $F800 shr 8) * 1.3), 255);
          G := _MIN(Round((tmp and $07E0 shr 3) * 1.3), 255);
          b := _MIN(Round((tmp and $001F shl 3) * 1.3), 255);
          sptr^ := Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3));
        end; }
        Inc(sptr);
      end;
    end;
  end;

//iamwgh�ڰ�Ч�����Ҷ�

  procedure GrayEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        sptr^ := ColorTableGray_565[sptr^];
        {if (sptr^) <> 0 then begin
          tmp := sptr^;
          r := Word(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3));
          G := r;
          b := r;
          sptr^ := _MAX(Word((r and $F8 shl 8) or (G and $FC shl 3) or (b and $F8 shr 3)), $0821);
        end;}
        Inc(sptr);
      end;
    end;
  end;

//iamwgh��ɫЧ��

  procedure RedEffect();
  var
    I, j: Integer;
    sptr: PWord;
    tmp: Word;
    r, G, b: byte;
  begin
    for I := 0 to ssuf.Height - 1 do begin
      sptr := PWord(ssuf.ScanLine[I]);
      for j := 0 to ssuf.Width - 1 do begin
        sptr^ := ColorTableRed_565[sptr^];
        {if (sptr^) <> 0 then begin
          tmp := sptr^;
          r := Word(Round(((tmp and $F800 shr 8) + (tmp and $07E0 shr 3) + (tmp and $001F shl 3)) / 3));
          G := 0;
          b := 0;
          sptr^ := _MAX(Word(r and $F8 shl 8), $0800);
                                                //sptr^ :=  word((r and $F8 shl 8) or (g and $FC shl 3) or (b and $F8 shr 3));
        end;}
        Inc(sptr);
      end;
    end;
  end;
begin
  if ssuf = nil then Exit;
  case eff of
    ceBright: BrightEffect();
    ceGrayScale: GrayEffect();
    ceBlack: BlackEffect();
    ceGreen: GreenEffect();

    ceWhite: WhiteEffect();
    ceRed: RedEffect();
    ceBlue: BlueEffect();
    ceYellow: YellowEffect();
    ceFuchsia: FuchsiaEffect();
  end;
end;


function GetRGB(c256: Byte): Integer;
begin
  Result := RGB(g_DefColorTable[c256].rgbRed,
    g_DefColorTable[c256].rgbGreen,
    g_DefColorTable[c256].rgbBlue);
end;

function GetRGB16(c256, btBitCount: Byte): Integer;
  function MakeColor(r, g, b, BitCount: Byte): dword;
  begin
    if BitCount = 16 then
      Result := Word((r and $F8 shl 8) or (g and $FC shl 3) or (b and $F8 shr 3))
    else
      Result := RGB(b, g, r);
  end;
begin
  Result := MakeColor(g_DefColorTable[c256].rgbRed,
    g_DefColorTable[c256].rgbGreen,
    g_DefColorTable[c256].rgbBlue, btBitCount);
end;

{ TGList }

constructor TGList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

{ TGStringList }

constructor TGStringList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TGStringList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

procedure TGStringList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TGStringList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

function NumberSort_1(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Value1 := StrToInt(List[Index1]);
    Value2 := StrToInt(List[Index2]);
    if Value1 > Value2 then
      Result := -1
    else if Value1 < Value2 then
      Result := 1
    else
      Result := 0;
  except
  end;
end;

//-------�������� 2

function NumberSort_2(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Value1 := StrToInt(List[Index1]);
    Value2 := StrToInt(List[Index2]);
    if Value1 > Value2 then
      Result := 1
    else if Value1 < Value2 then
      Result := -1
    else
      Result := 0;
  except
  end;
end;

//-------�������� 1

function DateTimeSort_1(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: TDateTime;
begin
  Result := 0;
  try
    Value1 := StrToDateTime(List[Index1]);
    Value2 := StrToDateTime(List[Index2]);
    if Value1 > Value2 then
      Result := -1
    else if Value1 < Value2 then
      Result := 1
    else
      Result := 0;
  except
  end;
end;

//-------�������� 2

function DateTimeSort_2(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: TDateTime;
begin
  Result := 0;
  try
    Value1 := StrToDateTime(List[Index1]);
    Value2 := StrToDateTime(List[Index2]);
    if Value1 > Value2 then
      Result := 1
    else if Value1 < Value2 then
      Result := -1
    else
      Result := 0;
  except
  end;
end;

//-------�ַ������� 1

function StrSort_1(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Result := -CompareStr(List[Index1], List[Index2]);
  except
  end;
end;

//-------�ַ������� 2

function StrSort_2(List: TStringList; Index1, Index2: Integer): Integer;
var
  Value1, Value2: Integer;
begin
  Result := 0;
  try
    Result := CompareStr(List[Index1], List[Index2]);
  except
  end;
end;



procedure TSortStringList.NumberSort(Flag: Boolean);
begin
  if Flag then
    CustomSort(NumberSort_1)
  else
    CustomSort(NumberSort_2);
end;

procedure TSortStringList.DateTimeSort(Flag: Boolean);
begin
  if Flag then
    CustomSort(DateTimeSort_1)
  else
    CustomSort(DateTimeSort_2);
end;

procedure TSortStringList.StringSort(Flag: Boolean);
begin
  if Flag then
    CustomSort(StrSort_1)
  else
    CustomSort(StrSort_2);
end;

procedure InitColorTable;
var
  I, II, III: Integer;
begin
  for I := 0 to High(Word) do begin
    BGRS[I].R := I and $F800 shr 8;
    BGRS[I].G := I and $07E0 shr 3;
    BGRS[I].B := I and $001F shl 3;
  end;

  for I := 0 to 255 do begin
    for II := 0 to 255 do begin
      RGBEffects[I, II] := Min(255, II + Round((255 - II) / 255 * I));
      {for III := 0 to 255 do begin
        //RGBColors[I, II, III] := Word((I shl 8 and $F800) or (II shl 3 and $07E0) or (III shr 3 and $001F));
        RGBColors[I, II, III] := Word((Max(I and $F8, 8) shl 8) or (Max(II and $FC, 8) shl 3) or (Max(III and $F8, 8) shr 3));
      end;}
    end;
  end;
end;

initialization
  begin
    InitColorTable;
    Move(ColorArray, g_DefColorTable, SizeOf(ColorArray));
  end;
end.

