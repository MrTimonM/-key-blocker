0C09  90 0e db  MOV    DPTR,#0x0EDB
0C0C  e0        MOVX   A,@DPTR
0C0D  fe        MOV    R6,A
0C0E  a3        INC    DPTR
0C0F  e0        MOVX   A,@DPTR
0C10  ff        MOV    R7,A
0C11  e4        CLR    A
0C12  2f        ADD    A,R7
0C13  f5 82     MOV    0x82,A
0C15  74 c0     MOV    A,#0xC0
0C17  3e        ADDC   A,R6
0C18  f5 83     MOV    0x83,A
0C1A  e4        CLR    A
0C1B  93        MOVC   A,@A+DPTR
0C1C  90 0e dd  MOV    DPTR,#0x0EDD
0C1F  f0        MOVX   @DPTR,A
0C20  e0        MOVX   A,@DPTR
0C21  fd        MOV    R5,A
0C22  7b 5e     MOV    R3,#0x5E
0C24  12 db e0  LCALL  0xDBE0
0C27  90 0f b2  MOV    DPTR,#0x0FB2
0C2A  74 05     MOV    A,#0x05
0C2C  f0        MOVX   @DPTR,A
0C2D  90 0f b3  MOV    DPTR,#0x0FB3
0C30  74 0a     MOV    A,#0x0A
0C32  f0        MOVX   @DPTR,A
0C33  90 0e db  MOV    DPTR,#0x0EDB
0C36  e0        MOVX   A,@DPTR
0C37  fe        MOV    R6,A
0C38  a3        INC    DPTR
0C39  e0        MOVX   A,@DPTR
0C3A  ff        MOV    R7,A
0C3B  e4        CLR    A
0C3C  2f        ADD    A,R7
0C3D  f5 82     MOV    0x82,A
0C3F  74 c2     MOV    A,#0xC2
0C41  3e        ADDC   A,R6
0C42  f5 83     MOV    0x83,A
0C44  e4        CLR    A
0C45  93        MOVC   A,@A+DPTR
0C46  90 0e dd  MOV    DPTR,#0x0EDD
0C49  f0        MOVX   @DPTR,A
0C4A  e0        MOVX   A,@DPTR
0C4B  fd        MOV    R5,A
0C4C  7b 5f     MOV    R3,#0x5F
0C4E  12 db e0  LCALL  0xDBE0
0C51  90 0e dc  MOV    DPTR,#0x0EDC
0C54  e0        MOVX   A,@DPTR
0C55  04        INC    A
0C56  f0        MOVX   @DPTR,A
0C57  70 06     JNZ    0x0C5F
0C59  90 0e db  MOV    DPTR,#0x0EDB
0C5C  e0        MOVX   A,@DPTR
0C5D  04        INC    A
0C5E  f0        MOVX   @DPTR,A
0C5F  c3        CLR    C

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

9646  90 0e ed  MOV    DPTR,#0x0EED
9649  ee        MOV    A,R6
964A  f0        MOVX   @DPTR,A
964B  a3        INC    DPTR
964C  ef        MOV    A,R7
964D  f0        MOVX   @DPTR,A
964E  a3        INC    DPTR
964F  ed        MOV    A,R5
9650  f0        MOVX   @DPTR,A
9651  90 0f 5a  MOV    DPTR,#0x0F5A
9654  e0        MOVX   A,@DPTR
9655  64 5a     XRL    A,#0x5A
9657  70 03     JNZ    0x965C
9659  02 96 e5  LJMP   0x96E5
965C  90 0f 7f  MOV    DPTR,#0x0F7F
965F  74 5e     MOV    A,#0x5E
9661  f0        MOVX   @DPTR,A
9662  90 0f 5a  MOV    DPTR,#0x0F5A
9665  74 5a     MOV    A,#0x5A
9667  f0        MOVX   @DPTR,A
9668  e4        CLR    A
9669  90 0f 8b  MOV    DPTR,#0x0F8B
966C  f0        MOVX   @DPTR,A
966D  90 0f 7f  MOV    DPTR,#0x0F7F
9670  e0        MOVX   A,@DPTR
9671  60 13     JZ     0x9686
9673  90 0f 8b  MOV    DPTR,#0x0F8B
9676  e0        MOVX   A,@DPTR
9677  d3        SETB   C
9678  94 32     SUBB   A,#0x32
967A  40 05     JC     0x9681
967C  e4        CLR    A
967D  90 0f 7f  MOV    DPTR,#0x0F7F
9680  f0        MOVX   @DPTR,A
9681  e4        CLR    A
9682  f5 b1     MOV    0xB1,A
9684  80 e7     SJMP   0x966D
9686  e4        CLR    A
9687  90 0e f0  MOV    DPTR,#0x0EF0
968A  f0        MOVX   @DPTR,A
968B  a3        INC    DPTR
968C  f0        MOVX   @DPTR,A
968D  90 0f b2  MOV    DPTR,#0x0FB2
9690  74 05     MOV    A,#0x05
9692  f0        MOVX   @DPTR,A
9693  90 0f b3  MOV    DPTR,#0x0FB3
9696  74 0a     MOV    A,#0x0A
9698  f0        MOVX   @DPTR,A
9699  90 0e f0  MOV    DPTR,#0x0EF0
969C  e0        MOVX   A,@DPTR
969D  fe        MOV    R6,A
969E  a3        INC    DPTR
969F  e0        MOVX   A,@DPTR
96A0  ff        MOV    R7,A
96A1  90 0e ef  MOV    DPTR,#0x0EEF
96A4  e0        MOVX   A,@DPTR
96A5  fd        MOV    R5,A
96A6  7c 00     MOV    R4,#0x00
96A8  ef        MOV    A,R7
96A9  2d        ADD    A,R5
96AA  fd        MOV    R5,A
96AB  ec        MOV    A,R4
96AC  3e        ADDC   A,R6
96AD  fc        MOV    R4,A
96AE  90 0e ed  MOV    DPTR,#0x0EED
96B1  e0        MOVX   A,@DPTR
96B2  fa        MOV    R2,A
96B3  a3        INC    DPTR
96B4  e0        MOVX   A,@DPTR
96B5  2d        ADD    A,R5
96B6  f5 82     MOV    0x82,A
96B8  ea        MOV    A,R2
96B9  3c        ADDC   A,R4
96BA  f5 83     MOV    0x83,A
96BC  e0        MOVX   A,@DPTR
96BD  fd        MOV    R5,A
96BE  7b 5e     MOV    R3,#0x5E
96C0  12 db c5  LCALL  0xDBC5
96C3  90 0e f1  MOV    DPTR,#0x0EF1
96C6  e0        MOVX   A,@DPTR
96C7  04        INC    A
96C8  f0        MOVX   @DPTR,A
96C9  70 06     JNZ    0x96D1
96CB  90 0e f0  MOV    DPTR,#0x0EF0
96CE  e0        MOVX   A,@DPTR
96CF  04        INC    A
96D0  f0        MOVX   @DPTR,A
96D1  c3        CLR    C
96D2  90 0e f0  MOV    DPTR,#0x0EF0
96D5  e0        MOVX   A,@DPTR
96D6  94 02     SUBB   A,#0x02
96D8  40 b3     JC     0x968D
96DA  90 0d ae  MOV    DPTR,#0x0DAE
96DD  74 55     MOV    A,#0x55
96DF  f0        MOVX   @DPTR,A
96E0  e4        CLR    A
96E1  90 0f 5a  MOV    DPTR,#0x0F5A
96E4  f0        MOVX   @DPTR,A
96E5  22        RET

79A0  03        RR     A
79A1  02 7a 63  LJMP   0x7A63
79A4  24 03     ADD    A,#0x03
79A6  60 03     JZ     0x79AB
79A8  02 7a 99  LJMP   0x7A99
79AB  02 7a 51  LJMP   0x7A51
79AE  90 0f 4f  MOV    DPTR,#0x0F4F
79B1  e0        MOVX   A,@DPTR
79B2  7f 00     MOV    R7,#0x00
79B4  25 e0     ADD    A,0xE0
79B6  fe        MOV    R6,A
79B7  ef        MOV    A,R7
79B8  24 00     ADD    A,#0x00
79BA  f5 82     MOV    0x82,A
79BC  74 c4     MOV    A,#0xC4
79BE  3e        ADDC   A,R6
79BF  f5 83     MOV    0x83,A
79C1  c0 83     PUSH   0x83
79C3  c0 82     PUSH   0x82
79C5  90 0e ed  MOV    DPTR,#0x0EED
79C8  e0        MOVX   A,@DPTR
79C9  d0 82     POP    0x82
79CB  d0 83     POP    0x83
79CD  75 f0 04  MOV    0xF0,#0x04
79D0  12 29 03  LCALL  0x2903
79D3  12 28 e7  LCALL  0x28E7
79D6  90 0e ea  MOV    DPTR,#0x0EEA
79D9  e0        MOVX   A,@DPTR
79DA  fb        MOV    R3,A
79DB  a3        INC    DPTR
79DC  e0        MOVX   A,@DPTR
79DD  fa        MOV    R2,A
79DE  a3        INC    DPTR
79DF  e0        MOVX   A,@DPTR
79E0  f9        MOV    R1,A
79E1  12 28 cd  LCALL  0x28CD
79E4  90 0e ea  MOV    DPTR,#0x0EEA
79E7  e0        MOVX   A,@DPTR
79E8  fb        MOV    R3,A
79E9  a3        INC    DPTR
79EA  e0        MOVX   A,@DPTR
79EB  fa        MOV    R2,A
79EC  a3        INC    DPTR
79ED  e0        MOVX   A,@DPTR
79EE  f9        MOV    R1,A

7A51  90 0f 4f  MOV    DPTR,#0x0F4F
7A54  e0        MOVX   A,@DPTR
7A55  7f 00     MOV    R7,#0x00
7A57  25 e0     ADD    A,0xE0
7A59  fe        MOV    R6,A
7A5A  ef        MOV    A,R7
7A5B  24 00     ADD    A,#0x00
7A5D  f5 82     MOV    0x82,A
7A5F  74 bc     MOV    A,#0xBC
7A61  80 10     SJMP   0x7A73
7A63  90 0f 4f  MOV    DPTR,#0x0F4F
7A66  e0        MOVX   A,@DPTR
7A67  7f 00     MOV    R7,#0x00
7A69  25 e0     ADD    A,0xE0
7A6B  fe        MOV    R6,A
7A6C  ef        MOV    A,R7
7A6D  24 00     ADD    A,#0x00
7A6F  f5 82     MOV    0x82,A
7A71  74 d4     MOV    A,#0xD4
7A73  3e        ADDC   A,R6
7A74  f5 83     MOV    0x83,A
7A76  c0 83     PUSH   0x83
7A78  c0 82     PUSH   0x82
7A7A  90 0e ed  MOV    DPTR,#0x0EED
7A7D  e0        MOVX   A,@DPTR
7A7E  d0 82     POP    0x82
7A80  d0 83     POP    0x83
7A82  75 f0 04  MOV    0xF0,#0x04
7A85  12 29 03  LCALL  0x2903
7A88  12 28 e7  LCALL  0x28E7
7A8B  90 0e ea  MOV    DPTR,#0x0EEA
7A8E  e0        MOVX   A,@DPTR
7A8F  fb        MOV    R3,A
7A90  a3        INC    DPTR
7A91  e0        MOVX   A,@DPTR
7A92  fa        MOV    R2,A
7A93  a3        INC    DPTR
7A94  e0        MOVX   A,@DPTR
7A95  f9        MOV    R1,A
7A96  12 28 cd  LCALL  0x28CD
7A99  22        RET
