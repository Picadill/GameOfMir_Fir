unit Grobal;

interface
uses
  windows, Classes, Grobal2;
const
  MAXBAGITEMCL = 46;

  BLUE_SEND_1050 = 1050; //�ٻ�Ӣ��
  BLUE_SEND_1051 = 1051; //Ӣ���˳�

  BLUE_SEND_1061 = 1061; //����װ��

  BLUE_SEND_1080 = 1080; //��Կ�״򿪱���
  BLUE_SEND_1081 = 1081; //��ʼת���� Ident: 1081 Recog: 2 Param: 0 Tag: 0 Series: 0
  BLUE_SEND_1082 = 1082; //˫����ȡ����ѡ�����Ʒ

  BLUE_SEND_1107 = 1107; //��ʦӢ���Ƿ��������
  BLUE_SEND_1100 = 1100; //���˰�����Ʒ�ŵ�Ӣ�۰���
  BLUE_SEND_1101 = 1101; //Ӣ�۰�����Ʒ�ŵ����˰���

  BLUE_SEND_1102 = 1102; //Ӣ�۴�װ��
  BLUE_SEND_1103 = 1103; //Ӣ����װ��
  BLUE_SEND_1104 = 1104; //Ӣ�۳�ҩ

  BLUE_SEND_1105 = 1105; //����//Ident: 1105 Recog: 260806992 Param: 0 Tag: 32 Series: 0   Recog= ��������   Param=X  Tag=Y
  BLUE_SEND_1106 = 1106; //Ӣ������Ʒ
  BLUE_SEND_1108 = 1108; //�ϻ�

  //BLUE_READ_656 = 656;
  //BLUE_READ_657 = 657; //Ident: 657 Recog: 759418336 Param: 0 Tag: 32 Series: 0
  BLUE_READ_817 = 817; //���˰�����Ʒ�ŵ�Ӣ�۰����ɹ�
  BLUE_READ_818 = 818; //���˰�����Ʒ�ŵ�Ӣ�۰���ʧ��

  BLUE_READ_819 = 819; //Ӣ�۰�����Ʒ�ŵ����˰����ɹ�
  BLUE_READ_820 = 820; //Ӣ�۰�����Ʒ�ŵ����˰���ʧ��

  BLUE_READ_896 = 896; //��ȡӢ�� TMessageBodyWL ����Ӣ���˳�Ч��
  BLUE_READ_897 = 897; //��ȡӢ�� TMessageBodyWL ����Ӣ�۵�½Ч��
  BLUE_READ_898 = 898; //��ȡӢ���ҳ�  10001(��00.00%)
  BLUE_READ_899 = 899; //��ȡӢ����Ϣ
  BLUE_READ_900 = 900; //��ȡӢ��Abil
  BLUE_READ_901 = 901; //Ӣ��SUBABILITY
  BLUE_READ_902 = 902; //��ȡӢ�۰���     Tag:������Ʒ���� 2 Series: ������Ʒ������10
  BLUE_READ_903 = 903; //��ȡӢ������װ��
  BLUE_READ_904 = 904; //��ȡӢ��ħ��
  BLUE_READ_905 = 905; //Ӣ�� Ident: 905 Recog: 738569296 Param: 0 Tag: 0 Series: 1   AddItem
  BLUE_READ_906 = 906; //Ӣ�� Ident: 906 Recog: 738569296 Param: 0 Tag: 0 Series: 1   delItem
  BLUE_READ_907 = 907; //Ӣ�۴�װ��OK Ident: 907 Recog: 742933632 Param: 0 Tag: 0 Series: 0
  BLUE_READ_908 = 908; //Ӣ�۴�װ��FAIL

  BLUE_READ_909 = 909; //Ӣ����װ��OK
  BLUE_READ_910 = 910; //Ӣ����װ��FAIL
  BLUE_READ_911 = 911; //Ӣ�۳�ҩOK
  BLUE_READ_912 = 912; //Ӣ�۳�ҩFAIL
  BLUE_READ_913 = 913; //Ӣ������ħ��
  BLUE_READ_914 = 914; //Ӣ��ɾ��ħ��

  BLUE_READ_916 = 916; //Ӣ��ŭֵ�ı� Ident: 916 Recog: 5 Param: 2 Tag: 102 Series: 0
  BLUE_READ_918 = 918; // Ӣ���˳�OK
  BLUE_READ_919 = 919; //Ӣ����Ʒ�־øı�
  BLUE_READ_920 = 920; //Ӣ������ƷOK
  BLUE_READ_921 = 921; //Ӣ������ƷFAIL

  BLUE_READ_923 = 923; //Ӣ��ŭֵ�ı� Ident: 923 Recog: 52 Param: 0 Tag: 200 Series: 0 Recog= ��ǰֵ Tag=���ֵ
  BLUE_READ_950 = 950; //��ȡ�����9��װ���ɹ� OK
  BLUE_READ_951 = 951; //��ȡ�����9��װ��ʧ�� Fail Ident: 951 Recog: 3 Param: 0 Tag: 0 Series: 0  Recog= 3 �򿪱���ʧ�ܣ�����û��Ԥ��6���ո�
  BLUE_READ_953 = 953; //��ȡ����ѡ�����ƷOK Ident: 953 Recog: 1 Param: 0 Tag: 0 Series: 0  Recog=1 OK Recog=0 Fail

  //CM_SAY @RestHero �ı�Ӣ��״̬

  CM_IGE_2008 = 2008;

  CM_IGE_5000 = 5000; //�ٻ�Ӣ��      Recog: 0; Ident: 5000; Param: 0; Tag: 0; Series: 0; Param1: 2;
  SM_IGE_5001 = 5001; //�ٻ�Ӣ�۳ɹ�      Recog: 226218672; Ident: 5001; Param: 0; Tag: 0; Series: 0; Param1: 0;
  CM_IGE_5002 = 5002; //�˳�Ӣ��      Recog: 0; Ident: 5002; Param: 0; Tag: 0; Series: 0; Param1: 2;

  SM_IGE_5004 = 5004; //Ӣ�۵�½Ч��Recog: 226218672; Ident: 5004; Param: 319; Tag: 360; Series: 1; Param1: 0; TMessageBodyW.Param1: 257; TMessageBodyW.Param1: 263;
  SM_IGE_5005 = 5005; //Ӣ���˳� Recog: 226218672; Ident: 5005; Param: 0; Tag: 0; Series: 0; Param1: 0;

  CM_IGE_5006 = 5006; //�ı�Ӣ��״̬  Recog: 226218672; Ident: 5006; Param: 0; Tag: 0; Series: 0; Param1: 2;
  CM_IGE_5007 = 5007; //Ӣ������  Recog: 226218672; Ident: 5007; Param: 343; Tag: 363; Series: 0; Param1: 2;
  CM_IGE_5008 = 5008; //Ӣ���ػ�  Recog: 0; Ident: 5008; Param: 343; Tag: 363; Series: 0; Param1: 2;


  CM_IGE_5009 = 5009; //Ӣ�۴�װ��      Recog: 226218672; Ident: 5009; Param: 0; Tag: 0; Series: 0; Param1: 2;
  CM_IGE_5010 = 5010; //Ӣ����װ��      Recog: 226218672; Ident: 5010; Param: 0; Tag: 0; Series: 0; Param1: 2;
  SM_IGE_5015 = 5015; //Ӣ�۴�װ��OK    Recog: 226218672; Ident: 5015; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5016 = 5016; //Ӣ�۴�װ��FAIL  Recog: -2; Ident: 5016; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5017 = 5017; //Ӣ����װ��OK    Recog: 226218672; Ident: 5017; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5018 = 5018; //Ӣ����װ��FAIL  Recog: 226218672; Ident: 5018; Param: 0; Tag: 0; Series: 0; Param1: 0;


  CM_IGE_5031 = 5031; //�����ǲ�ѯӢ�۰���    Recog: 0; Ident: 5031; Param: 0; Tag: 0; Series: 0; Param1: 2;

  SM_IGE_5032 = 5032; //Ӣ��װ�� Recog: 0; Ident: 5032; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5033 = 5033; //Ӣ�۰��� Recog: 196763812; Ident: 5033; Param: 0; Tag: 0; Series: 2; Param1: 0;

  SM_IGE_5034 = 5034; //ADDӢ�۰��� Recog: 196763812; Ident: 5034; Param: 0; Tag: 0; Series: 1; Param1: 0;
  SM_IGE_5035 = 5035; //DELӢ�۰��� Recog: 196763812; Ident: 5035; Param: 0; Tag: 0; Series: 1; Param1: 0;

  SM_IGE_5038 = 5038; //Recog: 0; Ident: 5038; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5030 = 5030; //Ӣ�۰������� Recog: 10; Ident: 5030; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5040 = 5040; //Ӣ��SM_ABILITY Recog: 1; Ident: 5040; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5041 = 5041; //Ӣ��SM_SUBABILITY Recog: 1; Ident: 5041; Param: 3857; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5042 = 5042; //Ӣ��δ֪ Recog: 12������������; Ident: 5042; Param: 14������������; Tag: 40��������; Series: 0; Param1: 0;

  CM_IGE_5043 = 5043; //Ӣ��ʹ����Ʒ     Recog: 0; Ident: 5043; Param: 0; Tag: 0; Series: 0; Param1: 2;
  SM_IGE_5044 = 5044; //Ӣ��ʹ����ƷOK   Recog: 0; Ident: 5044; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5045 = 5045; //Ӣ��ʹ����ƷFAIL Recog: 0; Ident: 5045; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5047 = 5047; //Ӣ��ʹ����ƷFAIL Recog: 9510; Ident: 5047; Param: 12; Tag: 10000; Series: 0; Param1: 0;

  SM_IGE_5049 = 5049; //Ӣ������ Recog: 16329; Ident: 5049; Param: 100���ȼ���; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_10055 = 10055; //Ӣ��SM_HEALTHSPELLCHANGED Recog: 1; Ident: 10055; Param: 5(HP); Tag: 0(MP); Series: 37(MAXHP); Param1: 0;

  SM_IGE_10059 = 10059; //Ӣ��SM_HEALTHSPELLCHANGED Recog: 229463448; Ident: 10059; Param: 0; Tag: 361(MAXMP); Series: 6807(MAXHP); Param1: 0;

  SM_IGE_20012 = 20012; //Ӣ��δ֪ Recog: 226218672; Ident: 20012; Param: 0; Tag: 0; Series: 0; Param1: 0;  82170/3333000

  SM_IGE_20021 = 20021; //Ӣ���˳�Ч�� Recog: 226218672; Ident: 20021; Param: 43128; Tag: 0; Series: 0; Param1: 0;


//5001�����ʼ����5031

//F^dlH?<lGo<lH?<kHnxuH_<lJ?<qHODkH<  **0000/0000/3/920080512/0

  SM_IGE_20024 = 20024; //Recog: 228442876; Ident: 20024; Param: 20038; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_20098 = 20098; //Recog: 0; Ident: 20098; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_20099 = 20099; //Recog: 0; Ident: 20099; Param: 0; Tag: 0; Series: 0; Param1: 3;
  CM_IGE_20097 = 20097; //Recog: 0; Ident: 20099; Param: 0; Tag: 0; Series: 0; Param1: 3;

  CM_IGE_5013 = 5013; //Ӣ�۰�����Ʒ�ŵ��������    Recog: 0; Ident: 5013; Param: 253; Tag: 0; Series: 0; Param1: 3;
  CM_IGE_5014 = 5014; //���������Ʒ�ŵ�Ӣ�۰���    Recog: 0; Ident: 5014; Param: 0; Tag: 0; Series: 0; Param1: 3;

  SM_IGE_5025 = 5025; //Ӣ�۰�����Ʒ�ŵ��������OK  Recog: 0; Ident: 5025; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5026 = 5026; //Ӣ�۰�����Ʒ�ŵ��������FAIL  Recog: -3; Ident: 5025; Param: 0; Tag: 0; Series: 0; Param1: 0;

  SM_IGE_5027 = 5027; //���������Ʒ�ŵ�Ӣ�۰���OK  Recog: 0; Ident: 5027; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5028 = 5028; //���������Ʒ�ŵ�Ӣ�۰���FAIL  Recog: -3; Ident: 5027; Param: 0; Tag: 0; Series: 0; Param1: 0;
  CM_IGE_5052 = 5052; //Ӣ������Ʒ      Recog: 226218672��װ��MAKEIDEX��; Ident: 5052; Param: 0; Tag: 0; Series: 0; Param1: 3;
  SM_IGE_5053 = 5053; //Ӣ������ƷOK    Recog: 226218672��װ��MAKEIDEX��; Ident: 5053; Param: 0; Tag: 0; Series: 0; Param1: 0;
  SM_IGE_5054 = 5054; //Ӣ������ƷFAIL  Recog: 226218672��װ��MAKEIDEX��; Ident: 5054; Param: 0; Tag: 0; Series: 0; Param1: 0;
type
  TDefaultMessage_IGE = record
    Recog: Integer;
    Ident: Word;
    Param: Word;
    Tag: Word;
    Series: Word;
    Param1: Integer;
  end;
  pTDefaultMessage_IGE = ^TDefaultMessage_IGE;

  TUpdateItem_BLUE = record //BLUE����װ��
    MakeIndex: Integer;
    ItemName: string[14];
  end;
  pTUpdateItem_BLUE = ^TUpdateItem_BLUE;
  TUpdateItemArray_BLUE = array[0..2] of TUpdateItem_BLUE;
  TBoxItemArray_BLUE = array[0..1] of TUpdateItem_BLUE;

  TOCharDesc = record
    feature: Integer;
    Status: Integer;
  end;

  TStdItem_IGE = packed record
    Name: string[14];
    StdMode: Byte;
    Shape: Byte;
    Weight: Byte;
    AniCount: Byte;
    Source: ShortInt;
    Reserved: Byte;
    NeedIdentify: Byte;
    Looks: Word;
    DuraMax: Word;
    Reserved1: Word;
    AC: Integer;
    MAC: Integer;
    DC: Integer;
    MC: Integer;
    SC: Integer;
    Need: Integer;
    NeedLevel: Integer;
    Price: Integer;
    n: Integer;
  end;
  pTStdItem_IGE = ^TStdItem_IGE;

  TStdItem_BLUE = packed record //OK
    Name: string[14];
    StdMode: BYTE;
    Shape: BYTE;
    Weight: BYTE;
    AniCount: BYTE;
    Source: ShortInt;
    Reserved: BYTE;
    NeedIdentify: BYTE;
    Looks: Word;
    DuraMax: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    Need: BYTE;
    NeedLevel: BYTE;
    w26: Word;
    Price: Integer;
  end;
  pTStdItem_BLUE = ^TStdItem_BLUE;

  TClientItem_BLUE = record //OK
    s: TStdItem_BLUE;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTClientItem_BLUE = ^TClientItem_BLUE;

  TClientItem_IGE = record //OK
    s: TStdItem_IGE;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  pTClientItem_IGE = ^TClientItem_IGE;


  TUserEatItems = record
    boHero: Boolean;
    boAuto: Boolean;
    boSend: Boolean;
    boBind: Boolean;
    nIndex: Integer;
    dwEatTime: LongWord;
    IGE: TClientItem_IGE;
    BLUE: TClientItem_BLUE;
  end;
  pTUserEatItems = ^TUserEatItems;

  TAbility_IGE = packed record //OK    //Size 40
    Level: Word; //0x198  //0x34  0x00
    AC: Integer; //0x19A  //0x36  0x02
    MAC: Integer; //0x19C  //0x38  0x04
    DC: Integer; //0x19E  //0x3A  0x06
    MC: Integer; //0x1A0  //0x3C  0x08
    SC: Integer; //0x1A2  //0x3E  0x0A
    HP: Word; //0x1A4  //0x40  0x0C
    MP: Word; //0x1A6  //0x42  0x0E
    MaxHP: Word; //0x1A8  //0x44  0x10
    MaxMP: Word; //0x1AA  //0x46  0x12
    Exp: LongWord; //0x1B0  //0x4C 0x18
    MaxExp: LongWord; //0x1B4  //0x50 0x1C
    Weight: Word; //0x1B8   //0x54 0x20
    MaxWeight: Word; //0x1BA   //0x56 0x22  ����
    WearWeight: Word; //0x1BC   //0x58 0x24
    MaxWearWeight: Word; //0x1BD   //0x59 0x25  ����
    HandWeight: Word; //0x1BE   //0x5A 0x26
    MaxHandWeight: Word; //0x1BF   //0x5B 0x27  ����
  end;
  pTAbility_IGE = ^TAbility_IGE;

  TAbility_BLUE = packed record
    Level: Word;
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    HP: Word;
    MP: Word;
    MaxHP: Word;
    MaxMP: Word;
    btReserved1: BYTE;
    btReserved2: BYTE;
    btReserved3: BYTE;
    btReserved4: BYTE;
    Exp: LongWORD;
    MaxExp: LongWORD;
    Weight: Word;
    MaxWeight: Word; //����
    WearWeight: BYTE;
    MaxWearWeight: BYTE; //����
    HandWeight: BYTE;
    MaxHandWeight: BYTE; //����
  end;
  pTAbility_BLUE = ^TAbility_BLUE;

  TUserItem_BLUE = packed record
    MakeIndex: Integer;
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    btValue: TValue; //array[0..13] of Byte;
  end;
  pTUserItem_BLUE = ^TUserItem_BLUE;

  TUserItem_IGE = packed record
    MakeIndex: Integer;
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    btValue: TValue; //array[0..13] of Byte;
  end;
  pTUserItem_IGE = ^TUserItem_IGE;

  TUserStateInfo_BLUE = packed record //OK
    feature: Integer;
    UserName: string[15]; // 15
    GuildName: string[14]; //14
    GuildRankName: string[16]; //15
    NAMECOLOR: Word;
    UseItems: array[0..8] of TClientItem_BLUE;
  end;

  TUserStateInfo_IGE = record
    feature: Integer;
    UserName: string[ACTORNAMELEN];
    NAMECOLOR: Integer;
    GuildName: string[ACTORNAMELEN];
    GuildRankName: string[16];
    UseItems: array[0..12] of TClientItem_IGE;
  end;
  pTUserStateInfo_IGE = ^TUserStateInfo_IGE;

  //  [ҩƷ] [����][�·�][ͷ��][����][����]

  TBindClientItem = record
    btItemType: BYTE;
    sItemName: string;
    sBindItemName: string;
  end;
  pTBindClientItem = ^TBindClientItem;


  TMapWalkXY = record
    nWalkStep: Integer;
    nMonCount: Integer;
    nX: Integer;
    nY: Integer;
  end;
  pTMapWalkXY = ^TMapWalkXY;


  TShowBoss = record
    sBossName: string[14];
    boShowName: Boolean;
    boHintMsg: Boolean;
    //btColor: Byte;
  end;
  pTShowBoss = ^TShowBoss;


  TMovingItem_IGE = record
    Index: Integer;
    Item: TClientItem_IGE;
    Owner: TObject;
  end;
  pTMovingItem_IGE = ^TMovingItem_IGE;

  TMovingItem_BLUE = record
    Index: Integer;
    Item: TClientItem_BLUE;
    Owner: TObject;
  end;
  pTMovingItem_BLUE = ^TMovingItem_BLUE;


  TUseItems_IGE = array[0..12] of TClientItem_IGE;
  TItemArr_IGE = array[0..46 - 1] of TClientItem_IGE;
  THeroItemArr_IGE = array[0..46 - 1 - 6] of TClientItem_IGE;
  TUpgradeItemArr_IGE = array[0..2] of TClientItem_IGE;

  pTUseItems_IGE = ^TUseItems_IGE;
  pTItemArr_IGE = ^TItemArr_IGE;
  pTHeroItemArr_IGE = ^THeroItemArr_IGE;


  TUseItems_BLUE = array[0..12] of TClientItem_BLUE;
  TItemArr_BLUE = array[0..46 - 1] of TClientItem_BLUE;
  THeroItemArr_BLUE = array[0..46 - 1 - 6] of TClientItem_BLUE;
  TUpgradeItemArr_BLUE = array[0..2] of TClientItem_BLUE;

  pTUseItems_BLUE = ^TUseItems_BLUE;
  pTItemArr_BLUE = ^TItemArr_BLUE;
  pTHeroItemArr_BLUE = ^THeroItemArr_BLUE;



  {TUpgradeItem = record
    sName: string[30];
    nMakeIndex: Integer;
  end;

  TClientUpgradeItem = array[0..2] of TUpgradeItem;

  TUpgradeItemIndexs = array[0..2] of Integer;
  TUpgradeItemNames = array[0..2] of string[20];
  pTUpgradeItemIndexs = ^TUpgradeItemIndexs;

  TUpgradeClientItem = record
    UpgradeItemIndexs: TUpgradeItemIndexs;
    UpgradeItemNames: TUpgradeItemNames;
  end;
  pTUpgradeClientItem = ^TUpgradeClientItem;


  THintItem = record
    boHint: Boolean;
    DropItem: pTDropItem;
  end;
  pTHintItem = ^THintItem;
    }

  THero_BLUE = record
    UnByte: array[0..16] of BYTE;
  end;
  pTHero_BLUE = ^THero_BLUE;


{function APPRfeature(cfeature: Integer): Word;
function RACEfeature(cfeature: Integer): BYTE;
function HAIRfeature(cfeature: Integer): BYTE;
function DRESSfeature(cfeature: Integer): BYTE;
function WEAPONfeature(cfeature: Integer): BYTE;
function Horsefeature(cfeature: Integer): BYTE;
function Effectfeature(cfeature: Integer): BYTE;
function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: BYTE): Integer;
function MakeMonsterFeature(btRaceImg, btWeapon: BYTE; wAppr: Word): Integer;}
implementation
{function WEAPONfeature(cfeature: Integer): BYTE;
begin
  Result := HiByte(cfeature);
end;
function DRESSfeature(cfeature: Integer): BYTE;
begin
  Result := HiByte(HiWord(cfeature));
end;
function APPRfeature(cfeature: Integer): Word;
begin
  Result := HiWord(cfeature);
end;
function HAIRfeature(cfeature: Integer): BYTE;
begin
  Result := HiWord(cfeature);
end;

function RACEfeature(cfeature: Integer): BYTE;
begin
  Result := cfeature;
end;

function Horsefeature(cfeature: Integer): BYTE;
begin
  Result := LoByte(LoWord(cfeature));
end;
function Effectfeature(cfeature: Integer): BYTE;
begin
  Result := HiByte(LoWord(cfeature));
end;

function MakeHumanFeature(btRaceImg, btDress, btWeapon, btHair: BYTE): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), MakeWord(btHair, btDress));
end;
function MakeMonsterFeature(btRaceImg, btWeapon: BYTE; wAppr: Word): Integer;
begin
  Result := MakeLong(MakeWord(btRaceImg, btWeapon), wAppr);
end;}
end.

