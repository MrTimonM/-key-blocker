; WKL-100 LCD clock route: offline analysis, no device commands sent.
; Source SHA256 f9a7e1b1abf47c1a9b8b545eae1a0467c5f8086f05d28fb6bf1ee096eac37a64

7BA4  90 0d ad  MOV    DPTR,#0x0DAD
7BA7  e0        MOVX   A,@DPTR
7BA8  64 01     XRL    A,#0x01
7BAA  60 03     JZ     0x7BAF
7BAC  02 7c ad  LJMP   0x7CAD
7BAF  90 0f b2  MOV    DPTR,#0x0FB2
7BB2  74 05     MOV    A,#0x05
7BB4  f0        MOVX   @DPTR,A
7BB5  90 08 fb  MOV    DPTR,#0x08FB
7BB8  e0        MOVX   A,@DPTR
7BB9  24 fd     ADD    A,#0xFD
7BBB  b4 0b 00  CJNE   A,#0x0B,0x7BBE
7BBE  40 03     JC     0x7BC3
7BC0  02 7c 97  LJMP   0x7C97
7BC3  90 7b d1  MOV    DPTR,#0x7BD1
7BC6  75 f0 03  MOV    0xF0,#0x03
7BC9  a4        MUL    AB
7BCA  c5 83     XCH    A,0x83
7BCC  25 f0     ADD    A,0xF0
7BCE  c5 83     XCH    A,0x83
7BD0  73        JMP    @A+DPTR
7BD1  02 7c 01  LJMP   0x7C01
7BD4  02 7b f5  LJMP   0x7BF5
7BD7  02 7c 41  LJMP   0x7C41
7BDA  02 7c 51  LJMP   0x7C51
7BDD  02 7c 97  LJMP   0x7C97
7BE0  02 7c 67  LJMP   0x7C67
7BE3  02 7c 97  LJMP   0x7C97
7BE6  02 7c 5c  LJMP   0x7C5C
7BE9  02 7c 72  LJMP   0x7C72
7BEC  02 7c 72  LJMP   0x7C72
7BEF  02 7c 72  LJMP   0x7C72
7BF2  02 7c 97  LJMP   0x7C97
7BF5  7e 08     MOV    R6,#0x08
7BF7  7f fa     MOV    R7,#0xFA
7BF9  7d 08     MOV    R5,#0x08
7BFB  12 84 3e  LCALL  0x843E
7BFE  02 7c 97  LJMP   0x7C97
7C01  90 08 fc  MOV    DPTR,#0x08FC
7C04  e0        MOVX   A,@DPTR
7C05  14        DEC    A
7C06  60 18     JZ     0x7C20
7C08  14        DEC    A
7C09  60 20     JZ     0x7C2B
7C0B  14        DEC    A
7C0C  60 28     JZ     0x7C36
7C0E  24 03     ADD    A,#0x03
7C10  60 03     JZ     0x7C15
7C12  02 7c 97  LJMP   0x7C97
7C15  7e 08     MOV    R6,#0x08
7C17  7f fa     MOV    R7,#0xFA
7C19  7d 08     MOV    R5,#0x08
7C1B  12 96 46  LCALL  0x9646
7C1E  80 77     SJMP   0x7C97
7C20  7e 08     MOV    R6,#0x08
7C22  7f fa     MOV    R7,#0xFA
7C24  7d 08     MOV    R5,#0x08
7C26  12 9b 35  LCALL  0x9B35
7C29  80 6c     SJMP   0x7C97
7C2B  7e 08     MOV    R6,#0x08
7C2D  7f fa     MOV    R7,#0xFA
7C2F  7d 08     MOV    R5,#0x08
7C31  12 9b cf  LCALL  0x9BCF
7C34  80 61     SJMP   0x7C97
7C36  7e 08     MOV    R6,#0x08
7C38  7f fa     MOV    R7,#0xFA
7C3A  7d 08     MOV    R5,#0x08
7C3C  12 96 e6  LCALL  0x96E6
7C3F  80 56     SJMP   0x7C97
7C41  7e 08     MOV    R6,#0x08
7C43  7f fa     MOV    R7,#0xFA
7C45  90 08 ff  MOV    DPTR,#0x08FF
7C48  e0        MOVX   A,@DPTR
7C49  fd        MOV    R5,A
7C4A  7b 08     MOV    R3,#0x08
7C4C  12 91 08  LCALL  0x9108
7C4F  80 46     SJMP   0x7C97
7C51  7e 08     MOV    R6,#0x08
7C53  7f fa     MOV    R7,#0xFA
7C55  7d 08     MOV    R5,#0x08
7C57  12 73 93  LCALL  0x7393
7C5A  80 3b     SJMP   0x7C97
7C5C  7e 08     MOV    R6,#0x08
7C5E  7f fa     MOV    R7,#0xFA
7C60  7d 08     MOV    R5,#0x08
7C62  12 94 5f  LCALL  0x945F
7C65  80 30     SJMP   0x7C97
7C67  7e 08     MOV    R6,#0x08
7C69  7f fa     MOV    R7,#0xFA
7C6B  7d 08     MOV    R5,#0x08
7C6D  12 71 08  LCALL  0x7108
7C70  80 25     SJMP   0x7C97
7C72  90 0f 1c  MOV    DPTR,#0x0F1C
7C75  e0        MOVX   A,@DPTR
7C76  fc        MOV    R4,A
7C77  a3        INC    DPTR
7C78  e0        MOVX   A,@DPTR
7C79  fd        MOV    R5,A
7C7A  a3        INC    DPTR
7C7B  e0        MOVX   A,@DPTR
7C7C  fe        MOV    R6,A
7C7D  a3        INC    DPTR
7C7E  e0        MOVX   A,@DPTR
7C7F  ff        MOV    R7,A
7C80  ed        MOV    A,R5
7C81  44 01     ORL    A,#0x01
7C83  fd        MOV    R5,A
7C84  ec        MOV    A,R4
7C85  90 0f 1c  MOV    DPTR,#0x0F1C
7C88  12 28 f7  LCALL  0x28F7
7C8B  90 0e 32  MOV    DPTR,#0x0E32
7C8E  74 01     MOV    A,#0x01
7C90  f0        MOVX   @DPTR,A
7C91  90 0f 57  MOV    DPTR,#0x0F57
7C94  74 19     MOV    A,#0x19
7C96  f0        MOVX   @DPTR,A
7C97  e4        CLR    A
7C98  90 0d ad  MOV    DPTR,#0x0DAD
7C9B  f0        MOVX   @DPTR,A
7C9C  90 0e 35  MOV    DPTR,#0x0E35
7C9F  e0        MOVX   A,@DPTR
7CA0  b4 01 05  CJNE   A,#0x01,0x7CA8
7CA3  e4        CLR    A
7CA4  f0        MOVX   @DPTR,A
7CA5  43 97 01  ORL    0x97,#0x01
7CA8  e4        CLR    A
7CA9  90 0f b2  MOV    DPTR,#0x0FB2
7CAC  f0        MOVX   @DPTR,A
7CAD  22        RET    

05FA  90 0f 1c  MOV    DPTR,#0x0F1C
05FD  a3        INC    DPTR
05FE  e0        MOVX   A,@DPTR
05FF  fd        MOV    R5,A
0600  a3        INC    DPTR
0601  a3        INC    DPTR
0602  e4        CLR    A
0603  ff        MOV    R7,A
0604  fe        MOV    R6,A
0605  ed        MOV    A,R5
0606  54 01     ANL    A,#0x01
0608  fd        MOV    R5,A
0609  e4        CLR    A
060A  fc        MOV    R4,A
060B  fb        MOV    R3,A
060C  fa        MOV    R2,A
060D  f9        MOV    R1,A
060E  f8        MOV    R0,A
060F  c3        CLR    C
0610  12 28 9c  LCALL  0x289C
0613  60 3c     JZ     0x0651
0615  e4        CLR    A
0616  90 0f 4b  MOV    DPTR,#0x0F4B
0619  f0        MOVX   @DPTR,A
061A  a3        INC    DPTR
061B  f0        MOVX   @DPTR,A
061C  0b        INC    R3
061D  7a 08     MOV    R2,#0x08
061F  79 fa     MOV    R1,#0xFA
0621  7d 08     MOV    R5,#0x08
0623  7c 02     MOV    R4,#0x02
0625  12 ba b1  LCALL  0xBAB1
0628  90 0f 54  MOV    DPTR,#0x0F54
062B  74 01     MOV    A,#0x01
062D  f0        MOVX   @DPTR,A
062E  90 0f 1c  MOV    DPTR,#0x0F1C
0631  e0        MOVX   A,@DPTR
0632  fc        MOV    R4,A
0633  a3        INC    DPTR
0634  e0        MOVX   A,@DPTR
0635  fd        MOV    R5,A
0636  a3        INC    DPTR
0637  e0        MOVX   A,@DPTR
0638  fe        MOV    R6,A
0639  a3        INC    DPTR
063A  e0        MOVX   A,@DPTR
063B  ff        MOV    R7,A
063C  ed        MOV    A,R5
063D  54 fe     ANL    A,#0xFE
063F  fd        MOV    R5,A
0640  ec        MOV    A,R4
0641  90 0f 1c  MOV    DPTR,#0x0F1C
0644  12 28 f7  LCALL  0x28F7
0647  90 08 fe  MOV    DPTR,#0x08FE
064A  e0        MOVX   A,@DPTR
064B  90 0f 20  MOV    DPTR,#0x0F20
064E  f0        MOVX   @DPTR,A
064F  80 4e     SJMP   0x069F

BAB1  90 0e e6  MOV    DPTR,#0x0EE6
BAB4  eb        MOV    A,R3
BAB5  f0        MOVX   @DPTR,A
BAB6  a3        INC    DPTR
BAB7  ea        MOV    A,R2
BAB8  f0        MOVX   @DPTR,A
BAB9  a3        INC    DPTR
BABA  e9        MOV    A,R1
BABB  f0        MOVX   @DPTR,A
BABC  90 08 f6  MOV    DPTR,#0x08F6
BABF  74 50     MOV    A,#0x50
BAC1  f0        MOVX   @DPTR,A
BAC2  a3        INC    DPTR
BAC3  74 81     MOV    A,#0x81
BAC5  f0        MOVX   @DPTR,A
BAC6  a3        INC    DPTR
BAC7  ec        MOV    A,R4
BAC8  f0        MOVX   @DPTR,A
BAC9  a3        INC    DPTR
BACA  ed        MOV    A,R5
BACB  f0        MOVX   @DPTR,A
BACC  90 0f 79  MOV    DPTR,#0x0F79
BACF  74 01     MOV    A,#0x01
BAD1  f0        MOVX   @DPTR,A
BAD2  a3        INC    DPTR
BAD3  74 08     MOV    A,#0x08
BAD5  f0        MOVX   @DPTR,A
BAD6  a3        INC    DPTR
BAD7  74 f6     MOV    A,#0xF6
BAD9  f0        MOVX   @DPTR,A
BADA  ed        MOV    A,R5
BADB  24 04     ADD    A,#0x04
BADD  fe        MOV    R6,A
BADE  e4        CLR    A
BADF  3c        ADDC   A,R4
BAE0  90 0f 7c  MOV    DPTR,#0x0F7C
BAE3  f0        MOVX   @DPTR,A
BAE4  ce        XCH    A,R6
BAE5  12 d2 88  LCALL  0xD288
BAE8  53 b9 bf  ANL    0xB9,#0xBF
BAEB  43 b5 40  ORL    0xB5,#0x40
BAEE  22        RET    

D288  a3        INC    DPTR
D289  f0        MOVX   @DPTR,A
D28A  e4        CLR    A
D28B  ff        MOV    R7,A
D28C  fe        MOV    R6,A
D28D  12 ba 94  LCALL  0xBA94
D290  90 0f 7d  MOV    DPTR,#0x0F7D
D293  e0        MOVX   A,@DPTR
D294  24 ff     ADD    A,#0xFF
D296  f0        MOVX   @DPTR,A
D297  90 0f 7c  MOV    DPTR,#0x0F7C
D29A  e0        MOVX   A,@DPTR
D29B  34 ff     ADDC   A,#0xFF
D29D  f0        MOVX   @DPTR,A
D29E  90 0f 79  MOV    DPTR,#0x0F79
D2A1  e0        MOVX   A,@DPTR
D2A2  fb        MOV    R3,A
D2A3  a3        INC    DPTR
D2A4  e4        CLR    A
D2A5  75 f0 01  MOV    0xF0,#0x01
D2A8  12 28 86  LCALL  0x2886
D2AB  a9 f0     MOV    R1,0xF0
D2AD  fa        MOV    R2,A
D2AE  12 27 c7  LCALL  0x27C7
D2B1  f5 aa     MOV    0xAA,A
D2B3  22        RET    

9825  90 0e f5  MOV    DPTR,#0x0EF5
9828  e5 aa     MOV    A,0xAA
982A  f0        MOVX   @DPTR,A
982B  20 85 4b  JB     0x85,0x9879
982E  c3        CLR    C
982F  90 0f 78  MOV    DPTR,#0x0F78
9832  e0        MOVX   A,@DPTR
9833  94 1e     SUBB   A,#0x1E
9835  90 0f 77  MOV    DPTR,#0x0F77
9838  e0        MOVX   A,@DPTR
9839  94 00     SUBB   A,#0x00
983B  50 19     JNC    0x9856
983D  90 0e f5  MOV    DPTR,#0x0EF5
9840  e0        MOVX   A,@DPTR
9841  ff        MOV    R7,A
9842  90 0f 74  MOV    DPTR,#0x0F74
9845  e0        MOVX   A,@DPTR
9846  fb        MOV    R3,A
9847  a3        INC    DPTR
9848  e4        CLR    A
9849  75 f0 01  MOV    0xF0,#0x01
984C  12 28 86  LCALL  0x2886
984F  a9 f0     MOV    R1,0xF0
9851  fa        MOV    R2,A
9852  ef        MOV    A,R7
9853  12 28 0d  LCALL  0x280D
9856  90 0f 78  MOV    DPTR,#0x0F78
9859  e0        MOVX   A,@DPTR
985A  04        INC    A
985B  f0        MOVX   @DPTR,A
985C  70 06     JNZ    0x9864
985E  90 0f 77  MOV    DPTR,#0x0F77
9861  e0        MOVX   A,@DPTR
9862  04        INC    A
9863  f0        MOVX   @DPTR,A
9864  90 0f 72  MOV    DPTR,#0x0F72
9867  e0        MOVX   A,@DPTR
9868  ff        MOV    R7,A
9869  90 0f 77  MOV    DPTR,#0x0F77
986C  e0        MOVX   A,@DPTR
986D  b4 00 07  CJNE   A,#0x00,0x9877
9870  a3        INC    DPTR
9871  e0        MOVX   A,@DPTR
9872  b5 07 02  CJNE   A,0x07,0x9877
9875  d2 51     SETB   0x51
9877  80 3d     SJMP   0x98B6
9879  90 0f 3e  MOV    DPTR,#0x0F3E
987C  e0        MOVX   A,@DPTR
987D  64 22     XRL    A,#0x22
987F  70 38     JNZ    0x98B9
9881  90 0f 53  MOV    DPTR,#0x0F53
9884  e0        MOVX   A,@DPTR
9885  64 01     XRL    A,#0x01
9887  60 30     JZ     0x98B9
9889  90 0f 73  MOV    DPTR,#0x0F73
988C  e0        MOVX   A,@DPTR
988D  ff        MOV    R7,A
988E  c3        CLR    C
988F  94 14     SUBB   A,#0x14
9891  50 11     JNC    0x98A4
9893  90 0e f5  MOV    DPTR,#0x0EF5
9896  e0        MOVX   A,@DPTR
9897  fe        MOV    R6,A
9898  74 30     MOV    A,#0x30
989A  2f        ADD    A,R7
989B  f5 82     MOV    0x82,A
989D  e4        CLR    A
989E  34 11     ADDC   A,#0x11
98A0  f5 83     MOV    0x83,A
98A2  ee        MOV    A,R6
98A3  f0        MOVX   @DPTR,A
98A4  90 0f 73  MOV    DPTR,#0x0F73
98A7  e0        MOVX   A,@DPTR
98A8  04        INC    A
98A9  f0        MOVX   @DPTR,A
98AA  e0        MOVX   A,@DPTR
98AB  c3        CLR    C
98AC  94 14     SUBB   A,#0x14
98AE  40 12     JC     0x98C2
98B0  90 0f 7e  MOV    DPTR,#0x0F7E
98B3  74 01     MOV    A,#0x01
98B5  f0        MOVX   @DPTR,A
98B6  e4        CLR    A
98B7  80 05     SJMP   0x98BE
98B9  e4        CLR    A
98BA  90 0f 7e  MOV    DPTR,#0x0F7E
98BD  f0        MOVX   @DPTR,A
98BE  90 0f 73  MOV    DPTR,#0x0F73
98C1  f0        MOVX   @DPTR,A
98C2  22        RET    

6BC3  ed        MOV    A,R5
6BC4  24 7d     ADD    A,#0x7D
6BC6  60 54     JZ     0x6C1C
6BC8  14        DEC    A
6BC9  60 39     JZ     0x6C04
6BCB  14        DEC    A
6BCC  70 03     JNZ    0x6BD1
6BCE  02 6c 52  LJMP   0x6C52
6BD1  24 fb     ADD    A,#0xFB
6BD3  60 3b     JZ     0x6C10
6BD5  24 08     ADD    A,#0x08
6BD7  60 03     JZ     0x6BDC
6BD9  02 6c 6c  LJMP   0x6C6C
6BDC  90 09 00  MOV    DPTR,#0x0900
6BDF  e0        MOVX   A,@DPTR
6BE0  f9        MOV    R1,A
6BE1  90 08 fc  MOV    DPTR,#0x08FC
6BE4  e0        MOVX   A,@DPTR
6BE5  90 0f a7  MOV    DPTR,#0x0FA7
6BE8  b4 01 10  CJNE   A,#0x01,0x6BFB
6BEB  74 ab     MOV    A,#0xAB
6BED  f0        MOVX   @DPTR,A
6BEE  a3        INC    DPTR
6BEF  74 e3     MOV    A,#0xE3
6BF1  f0        MOVX   @DPTR,A
6BF2  90 0f 4e  MOV    DPTR,#0x0F4E
6BF5  e0        MOVX   A,@DPTR
6BF6  44 01     ORL    A,#0x01
6BF8  f0        MOVX   @DPTR,A
6BF9  80 71     SJMP   0x6C6C
6BFB  74 ab     MOV    A,#0xAB
6BFD  f0        MOVX   @DPTR,A
6BFE  a3        INC    DPTR
6BFF  74 fc     MOV    A,#0xFC
6C01  f0        MOVX   @DPTR,A
6C02  80 68     SJMP   0x6C6C
6C04  90 09 00  MOV    DPTR,#0x0900
6C07  e0        MOVX   A,@DPTR
6C08  f9        MOV    R1,A
6C09  90 0f a7  MOV    DPTR,#0x0FA7
6C0C  74 a4     MOV    A,#0xA4
6C0E  80 3c     SJMP   0x6C4C
6C10  90 09 00  MOV    DPTR,#0x0900
6C13  e0        MOVX   A,@DPTR
6C14  f9        MOV    R1,A
6C15  90 0f a7  MOV    DPTR,#0x0FA7
6C18  74 a8     MOV    A,#0xA8
6C1A  80 30     SJMP   0x6C4C
6C1C  90 09 00  MOV    DPTR,#0x0900
6C1F  e0        MOVX   A,@DPTR
6C20  f9        MOV    R1,A
6C21  90 08 fc  MOV    DPTR,#0x08FC
6C24  e0        MOVX   A,@DPTR
6C25  14        DEC    A
6C26  60 11     JZ     0x6C39
6C28  14        DEC    A
6C29  60 15     JZ     0x6C40
6C2B  14        DEC    A
6C2C  60 19     JZ     0x6C47
6C2E  24 03     ADD    A,#0x03
6C30  70 3a     JNZ    0x6C6C
6C32  90 0f a7  MOV    DPTR,#0x0FA7
6C35  74 bc     MOV    A,#0xBC
6C37  80 13     SJMP   0x6C4C
6C39  90 0f a7  MOV    DPTR,#0x0FA7
6C3C  74 c4     MOV    A,#0xC4
6C3E  80 0c     SJMP   0x6C4C
6C40  90 0f a7  MOV    DPTR,#0x0FA7
6C43  74 cc     MOV    A,#0xCC
6C45  80 05     SJMP   0x6C4C
6C47  90 0f a7  MOV    DPTR,#0x0FA7
6C4A  74 d4     MOV    A,#0xD4
6C4C  f0        MOVX   @DPTR,A
6C4D  a3        INC    DPTR
6C4E  e4        CLR    A
6C4F  f0        MOVX   @DPTR,A
6C50  80 1a     SJMP   0x6C6C
6C52  90 09 00  MOV    DPTR,#0x0900
6C55  e0        MOVX   A,@DPTR
6C56  f9        MOV    R1,A
6C57  90 08 ff  MOV    DPTR,#0x08FF
6C5A  e0        MOVX   A,@DPTR
6C5B  25 e0     ADD    A,0xE0
6C5D  fe        MOV    R6,A
6C5E  e4        CLR    A
6C5F  24 00     ADD    A,#0x00
6C61  ff        MOV    R7,A
6C62  ee        MOV    A,R6
6C63  34 dc     ADDC   A,#0xDC
6C65  90 0f a7  MOV    DPTR,#0x0FA7
6C68  f0        MOVX   @DPTR,A
6C69  a3        INC    DPTR
6C6A  ef        MOV    A,R7
6C6B  f0        MOVX   @DPTR,A
6C6C  53 9b f0  ANL    0x9B,#0xF0
6C6F  43 9b 08  ORL    0x9B,#0x08
6C72  43 97 04  ORL    0x97,#0x04
6C75  e9        MOV    A,R1
6C76  ff        MOV    R7,A
6C77  90 11 51  MOV    DPTR,#0x1151
6C7A  e4        CLR    A
6C7B  f0        MOVX   @DPTR,A
6C7C  a3        INC    DPTR
6C7D  ef        MOV    A,R7
6C7E  f0        MOVX   @DPTR,A
6C7F  90 11 50  MOV    DPTR,#0x1150
6C82  74 01     MOV    A,#0x01
6C84  f0        MOVX   @DPTR,A
6C85  22        RET    