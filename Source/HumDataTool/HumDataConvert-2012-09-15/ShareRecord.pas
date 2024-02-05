unit ShareRecord;

interface
uses
  Windows, Classes, Controls;
const
  ACCOUNTLEN = 30;
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;
  MAPNAMELEN = 16;
  ACTORNAMELEN = 14;
  DEFBLOCKSIZE = 16;
  BUFFERSIZE = 10000;
  DATA_BUFSIZE2 = 16348; //8192;
  DATA_BUFSIZE = 8192; //8192;
  GROUPMAX = 11;
  BAGGOLD = 5000000;
  BODYLUCKUNIT = 10;
  MAX_STATUS_ATTRIBUTE = 12;
type
  TValue = array[0..13] of Byte;
  TValueA = array[0..1] of Byte;
  TNewStatus = (sNone, sBlind, sConfusion); //ʧ�� ���� ״̬]
  
  TOAbility = packed record  //Size = 40
    Level: LongInt; //0x198  //0x34  0x00
    AC: Word;
    MAC: Word;
    DC: Word;
    MC: Word;
    SC: Word;
    HP: LongInt; //0x1A4  //0x40  0x0C
    MP: LongInt; //0x1A6  //0x42  0x0E
    MaxHP: LongInt; //0x1A8  //0x44  0x10
    MaxMP: LongInt; //0x1AA  //0x46  0x12
    btReserved1: Byte;
    btReserved2: Byte;
    btReserved3: Byte;
    btReserved4: Byte;
    Exp: LongWord;
    MaxExp: LongWord;
    Weight: Word;
    MaxWeight: Word; //����
    WearWeight: Byte;
    MaxWearWeight: Byte; //����
    HandWeight: Byte;
    MaxHandWeight: Byte; //����
  end;
  pTOAbility = ^TOAbility;

  TNakedAbility = packed record //Size 20
    DC: word;
    MC: word;
    SC: word;
    AC: word;
    MAC: word;
    HP: word;
    MP: word;
    Hit: word;
    Speed: word;
    X2: word;
  end;
  pTNakedAbility = ^TNakedAbility;

  THumMagic = record
    wMagIdx: word;
    btLevel: Byte;
    btKey: Byte;
    nTranPoint: Integer; //��ǰ�־�ֵ
  end;
  pTHumMagic = ^THumMagic;


  TUserItem = packed record
    MakeIndex: Integer;
    wIndex: Word; //��Ʒid
    Dura: Word; //��ǰ�־�ֵ
    DuraMax: Word; //���־�ֵ
    btValue: TValue; //array[0..13] of Byte;

    AddValue: TValue; //12=װ������(1,2,3)
    AddPoint: TValue; //1=����������(1=�����˺����� 2=ħ���˺����� 3=����Ŀ����� 4=�����˺����� 5=���ӹ����˺�) 2=������ֵ
                      //3=���������ǿ 4=ħ��������ǿ 5=��������ǿ 6=ħ��������ǿ 7=����������ǿ 8=���ӽ���ʧ��״̬ 9=���ӽ������״̬ 10=���ٽ���ʧ��״̬ 11=���ٽ������״̬ 12=�ƶ����� 13=��������
    btColor: Byte;
    btValue2: array[0..12] of Byte;
    MaxDate: TDateTime;
  end;
  pTUserItem = ^TUserItem;

  TRecordHeader = packed record //Size 12
    boDeleted: Boolean;
    nSelectID: Byte;
    boIsHero: Boolean;
    bt2: Byte;
    dCreateDate: TDateTime; //����ʱ��
    sName: string[15]; //0x15  //��ɫ����   28
  end;
  pTRecordHeader = ^TRecordHeader;

  TUnKnow = array[0..35] of Byte;

  TAddByte = array[0..16] of Byte;


  TOQuestFlag = array[0..127] of Byte;
  TQuestFlag = array[0..128 * 2 - 1] of Byte;

  TStatusTime = array[0..MAX_STATUS_ATTRIBUTE - 1] of Word;


  TOHumAddItems = array[9..12] of TUserItem;

  THumItems = array[0..8] of TUserItem;
  THumAddItems = array[9..15] of TUserItem;
  TBagItems = array[0..45] of TUserItem;
  TStorageItems = array[0..45] of TUserItem;
  THumMagics = array[0..29] of THumMagic;
  THumanUseItems = array[0..12] of TUserItem;


  pTHumItems = ^THumItems;
  pTBagItems = ^TBagItems;
  pTStorageItems = ^TStorageItems;
  pTHumAddItems = ^THumAddItems;
  pTHumMagics = ^THumMagics;
  pTOHumAddItems = ^TOHumAddItems;

  TOHumData = packed record //Size = 3164
    sChrName: string[ACTORNAMELEN];
    sCurMap: string[MAPNAMELEN];
    wCurX: Word;
    wCurY: Word;
    btDir: Byte;
    btHair: Byte;
    btSex: Byte;
    btJob: Byte;
    nGold: Integer;
    Abil: TOAbility; //+40
    wStatusTimeArr: TStatusTime; //+24
    sHomeMap: string[MAPNAMELEN];
    wHomeX: Word;
    wHomeY: Word;
    sDearName: string[ACTORNAMELEN];
    sMasterName: string[ACTORNAMELEN];
    boMaster: Boolean;
    btCreditPoint: Integer;
    btDivorce: Byte; //�Ƿ���
    btMarryCount: Byte; //������
    sStoragePwd: string[7];
    btReLevel: Byte;
    boOnHorse: Boolean;
    BonusAbil: TNakedAbility; //+20
    nBonusPoint: Integer;
    nGameGold: Integer;
    nGamePoint: Integer;
    nGameDiamond: Integer; //���ʯ
    nGameGird: Integer; //���
    nGameGlory: Integer; //����
    nPayMentPoint: Integer; //��ֵ��
    nPKPOINT: Integer;
    btAllowGroup: Byte;
    btF9: Byte;
    btAttatckMode: Byte;
    btIncHealth: Byte;
    btIncSpell: Byte;
    btIncHealing: Byte;
    btFightZoneDieCount: Byte;
    sAccount: string[ACCOUNTLEN];
    btEE: Byte;
    btEF: Byte;
    boLockLogon: Boolean;
    wContribution: Word;
    nHungerStatus: Integer;
    boAllowGuildReCall: Boolean; //  �Ƿ������л��һ
    wGroupRcallTime: Word; //�Ӵ���ʱ��
    dBodyLuck: Double; //���˶�  8
    boAllowGroupReCall: Boolean; // �Ƿ�������غ�һ
    nEXPRATE: Integer; //���鱶��
    nExpTime: Integer; //���鱶��ʱ��
    btLastOutStatus: Byte; //2006-01-12���� �˳�״̬ 1Ϊ�����˳�
    wMasterCount: Word; //��ʦͽ����
    boHasHero: Boolean; //�Ƿ���Ӣ��
    boIsHero: Boolean; //�Ƿ���Ӣ��
    btStatus: Byte; //״̬
    sHeroChrName: string[ACTORNAMELEN];
    nGrudge: Integer;
    QuestFlag: TOQuestFlag; //�ű�����
    NewStatus: TNewStatus; //1ʧ�� 2���� ״̬
    wStatusDelayTime: Word; //ʧ������ʱ��
    AddByte: TAddByte;
    HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
    BagItems: TBagItems; //����װ��
    HumMagics: THumMagics; //ħ��
    StorageItems: TStorageItems; //�ֿ���Ʒ
    HumAddItems: TOHumAddItems; //����4�� ����� ���� Ь�� ��ʯ
  end;
  pTOHumData = ^TOHumData;

  THumData = packed record //Size = 3164
    sChrName: string[ACTORNAMELEN];
    sCurMap: string[MAPNAMELEN];
    wCurX: Word;
    wCurY: Word;
    btDir: Byte;
    btHair: Byte;
    btSex: Byte;
    btJob: Byte;
    nGold: Integer;
    Abil: TOAbility; //+40
    wStatusTimeArr: TStatusTime; //+24
    sHomeMap: string[MAPNAMELEN];
    wHomeX: Word;
    wHomeY: Word;
    sDearName: string[ACTORNAMELEN];
    sMasterName: string[ACTORNAMELEN];
    boMaster: Boolean;
    btCreditPoint: Integer;
    btDivorce: Byte; //�Ƿ���
    btMarryCount: Byte; //������
    sStoragePwd: string[7];
    btReLevel: Byte;
    boOnHorse: Boolean;
    BonusAbil: TNakedAbility; //+20
    nBonusPoint: Integer;
    nGameGold: Integer;
    nGamePoint: Integer;
    nGameDiamond: Integer; //���ʯ
    nGameGird: Integer; //���
    nGameGlory: Integer; //����
    nPayMentPoint: Integer; //��ֵ��
    nPKPOINT: Integer;
    btAllowGroup: Byte;
    btF9: Byte;
    btAttatckMode: Byte;
    btIncHealth: Byte;
    btIncSpell: Byte;
    btIncHealing: Byte;
    btFightZoneDieCount: Byte;
    sAccount: string[ACCOUNTLEN];
    btEE: Byte;
    btEF: Byte;
    boLockLogon: Boolean;
    wContribution: Word;
    nHungerStatus: Integer;
    boAllowGuildReCall: Boolean; //  �Ƿ������л��һ
    wGroupRcallTime: Word; //�Ӵ���ʱ��
    dBodyLuck: Double; //���˶�  8
    boAllowGroupReCall: Boolean; // �Ƿ�������غ�һ
    nEXPRATE: Integer; //���鱶��
    nExpTime: Integer; //���鱶��ʱ��
    btLastOutStatus: Byte; //2006-01-12���� �˳�״̬ 1Ϊ�����˳�
    wMasterCount: Word; //��ʦͽ����
    boHasHero: Boolean; //�Ƿ���Ӣ��
    boIsHero: Boolean; //�Ƿ���Ӣ��
    btStatus: Byte; //״̬
    sHeroChrName: string[ACTORNAMELEN];
    nGrudge: Integer;
    QuestFlag: TQuestFlag; //�ű�����
    NewStatus: TNewStatus; //1ʧ�� 2���� ״̬
    wStatusDelayTime: Word; //ʧ������ʱ��
    AddByte: TAddByte;
    HumItems: THumItems; //9��װ�� �·�  ����  ���� ͷ�� ���� ���� ���� ��ָ ��ָ
    BagItems: TBagItems; //����װ��
    HumMagics: THumMagics; //ħ��
    StorageItems: TStorageItems; //�ֿ���Ʒ
    HumAddItems: THumAddItems; //����4�� ����� ���� Ь�� ��ʯ
  end;
  pTHumData = ^THumData;

  THumDataInfo = packed record //Size 3164
    Header: TRecordHeader;
    Data: THumData;
  end;
  pTHumDataInfo = ^THumDataInfo;

  TOHumDataInfo = packed record //Size 3164
    Header: TRecordHeader;
    Data: TOHumData;
  end;
  pTOHumDataInfo = ^TOHumDataInfo;
implementation

end.

