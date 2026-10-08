629E  90 0f 85  MOV    DPTR,#0x0F85
62A1  e0        MOVX   A,@DPTR
62A2  ff        MOV    R7,A
62A3  20 e0 0b  JB     0xE0,0x62B1
62A6  90 a4 0a  MOV    DPTR,#0xA40A
62A9  e4        CLR    A
62AA  93        MOVC   A,@A+DPTR
62AB  90 0f 82  MOV    DPTR,#0x0F82
62AE  f0        MOVX   @DPTR,A
62AF  80 07     SJMP   0x62B8
62B1  ef        MOV    A,R7
62B2  54 fe     ANL    A,#0xFE
62B4  90 0f 85  MOV    DPTR,#0x0F85
62B7  f0        MOVX   @DPTR,A
62B8  90 0f 82  MOV    DPTR,#0x0F82
62BB  e0        MOVX   A,@DPTR
62BC  fb        MOV    R3,A
62BD  75 f0 02  MOV    0xF0,#0x02
62C0  a4        MUL    AB
62C1  24 38     ADD    A,#0x38
62C3  f5 82     MOV    0x82,A
62C5  e5 f0     MOV    A,0xF0
62C7  34 a4     ADDC   A,#0xA4
62C9  f5 83     MOV    0x83,A
62CB  e4        CLR    A
62CC  93        MOVC   A,@A+DPTR
62CD  fe        MOV    R6,A
62CE  90 0f 85  MOV    DPTR,#0x0F85
62D1  e0        MOVX   A,@DPTR
62D2  fd        MOV    R5,A
62D3  20 e1 09  JB     0xE1,0x62DF
62D6  ee        MOV    A,R6
62D7  54 7f     ANL    A,#0x7F
62D9  90 0f 86  MOV    DPTR,#0x0F86
62DC  f0        MOVX   @DPTR,A
62DD  80 07     SJMP   0x62E6
62DF  ed        MOV    A,R5
62E0  54 fd     ANL    A,#0xFD
62E2  90 0f 85  MOV    DPTR,#0x0F85
62E5  f0        MOVX   @DPTR,A
62E6  90 0f 85  MOV    DPTR,#0x0F85
62E9  e0        MOVX   A,@DPTR
62EA  ff        MOV    R7,A
62EB  20 e4 06  JB     0xE4,0x62F4
62EE  ee        MOV    A,R6
62EF  33        RLC    A
62F0  92 3e     MOV    0x3E,C
62F2  80 07     SJMP   0x62FB
62F4  ef        MOV    A,R7
62F5  54 ef     ANL    A,#0xEF
62F7  90 0f 85  MOV    DPTR,#0x0F85
62FA  f0        MOVX   @DPTR,A
62FB  90 0f 86  MOV    DPTR,#0x0F86
62FE  e0        MOVX   A,@DPTR
62FF  ff        MOV    R7,A
6300  c3        CLR    C
6301  94 04     SUBB   A,#0x04
6303  50 04     JNC    0x6309
6305  e4        CLR    A
6306  f0        MOVX   @DPTR,A
6307  80 52     SJMP   0x635B
6309  ef        MOV    A,R7
630A  c3        CLR    C
630B  94 04     SUBB   A,#0x04
630D  40 0d     JC     0x631C
630F  ef        MOV    A,R7
6310  94 08     SUBB   A,#0x08
6312  50 08     JNC    0x631C
6314  90 0f 86  MOV    DPTR,#0x0F86
6317  74 04     MOV    A,#0x04
6319  f0        MOVX   @DPTR,A
631A  80 3f     SJMP   0x635B
631C  ef        MOV    A,R7
631D  c3        CLR    C
631E  94 08     SUBB   A,#0x08
6320  40 0d     JC     0x632F
6322  ef        MOV    A,R7
6323  94 0c     SUBB   A,#0x0C
6325  50 08     JNC    0x632F
6327  90 0f 86  MOV    DPTR,#0x0F86
632A  74 08     MOV    A,#0x08
632C  f0        MOVX   @DPTR,A
632D  80 2c     SJMP   0x635B
632F  ef        MOV    A,R7
6330  c3        CLR    C
6331  94 0c     SUBB   A,#0x0C
6333  40 0d     JC     0x6342
6335  ef        MOV    A,R7
6336  94 10     SUBB   A,#0x10
6338  50 08     JNC    0x6342
633A  90 0f 86  MOV    DPTR,#0x0F86
633D  74 0c     MOV    A,#0x0C
633F  f0        MOVX   @DPTR,A
6340  80 19     SJMP   0x635B
6342  ef        MOV    A,R7
6343  c3        CLR    C
6344  94 10     SUBB   A,#0x10
6346  40 0d     JC     0x6355
6348  ef        MOV    A,R7
6349  94 14     SUBB   A,#0x14
634B  50 08     JNC    0x6355
634D  90 0f 86  MOV    DPTR,#0x0F86
6350  74 10     MOV    A,#0x10
6352  f0        MOVX   @DPTR,A
6353  80 06     SJMP   0x635B
6355  90 0f 86  MOV    DPTR,#0x0F86
6358  74 14     MOV    A,#0x14
635A  f0        MOVX   @DPTR,A
635B  75 f0 02  MOV    0xF0,#0x02
635E  eb        MOV    A,R3
635F  a4        MUL    AB
6360  24 39     ADD    A,#0x39
6362  f5 82     MOV    0x82,A
6364  e5 f0     MOV    A,0xF0
6366  34 a4     ADDC   A,#0xA4
6368  f5 83     MOV    0x83,A
636A  e4        CLR    A
636B  93        MOVC   A,@A+DPTR
636C  fe        MOV    R6,A
636D  90 0f 85  MOV    DPTR,#0x0F85
6370  e0        MOVX   A,@DPTR
6371  fd        MOV    R5,A
6372  20 e2 09  JB     0xE2,0x637E
6375  ee        MOV    A,R6
6376  54 0f     ANL    A,#0x0F
6378  90 08 e8  MOV    DPTR,#0x08E8
637B  f0        MOVX   @DPTR,A
637C  80 07     SJMP   0x6385
637E  ed        MOV    A,R5
637F  54 fb     ANL    A,#0xFB
6381  90 0f 85  MOV    DPTR,#0x0F85
6384  f0        MOVX   @DPTR,A
6385  90 0f 85  MOV    DPTR,#0x0F85
6388  e0        MOVX   A,@DPTR
6389  fb        MOV    R3,A
638A  20 e3 2b  JB     0xE3,0x63B8
638D  af 06     MOV    R7,0x06
638F  ee        MOV    A,R6
6390  54 f0     ANL    A,#0xF0
6392  c4        SWAP   A
6393  54 0f     ANL    A,#0x0F
6395  ff        MOV    R7,A
6396  90 04 f3  MOV    DPTR,#0x04F3
6399  f0        MOVX   @DPTR,A
639A  c3        CLR    C
639B  e4        CLR    A
639C  9f        SUBB   A,R7
639D  ff        MOV    R7,A
639E  e4        CLR    A
639F  94 00     SUBB   A,#0x00
63A1  fe        MOV    R6,A
63A2  7c 00     MOV    R4,#0x00
63A4  7d 14     MOV    R5,#0x14
63A6  12 28 1f  LCALL  0x281F
63A9  ef        MOV    A,R7
63AA  24 96     ADD    A,#0x96
63AC  ff        MOV    R7,A
63AD  e4        CLR    A
63AE  3e        ADDC   A,R6
63AF  90 03 77  MOV    DPTR,#0x0377
63B2  f0        MOVX   @DPTR,A
63B3  a3        INC    DPTR
63B4  ef        MOV    A,R7
63B5  f0        MOVX   @DPTR,A
63B6  80 07     SJMP   0x63BF
63B8  eb        MOV    A,R3
63B9  54 f7     ANL    A,#0xF7
63BB  90 0f 85  MOV    DPTR,#0x0F85
63BE  f0        MOVX   @DPTR,A
63BF  90 a4 0d  MOV    DPTR,#0xA40D
63C2  e4        CLR    A
63C3  93        MOVC   A,@A+DPTR
63C4  90 0f 9a  MOV    DPTR,#0x0F9A
63C7  f0        MOVX   @DPTR,A
63C8  90 a4 0e  MOV    DPTR,#0xA40E
63CB  e4        CLR    A
63CC  93        MOVC   A,@A+DPTR
63CD  90 0f 99  MOV    DPTR,#0x0F99
63D0  f0        MOVX   @DPTR,A
63D1  90 a4 0f  MOV    DPTR,#0xA40F
63D4  e4        CLR    A
63D5  93        MOVC   A,@A+DPTR
63D6  90 0f a3  MOV    DPTR,#0x0FA3
63D9  f0        MOVX   @DPTR,A
63DA  90 a4 10  MOV    DPTR,#0xA410
63DD  e4        CLR    A
63DE  93        MOVC   A,@A+DPTR
63DF  90 0f 98  MOV    DPTR,#0x0F98
63E2  f0        MOVX   @DPTR,A
63E3  90 a4 11  MOV    DPTR,#0xA411
63E6  e4        CLR    A
63E7  93        MOVC   A,@A+DPTR
63E8  90 0f 9d  MOV    DPTR,#0x0F9D
63EB  f0        MOVX   @DPTR,A
63EC  90 a4 12  MOV    DPTR,#0xA412
63EF  e4        CLR    A
63F0  93        MOVC   A,@A+DPTR
63F1  90 0b c4  MOV    DPTR,#0x0BC4
63F4  f0        MOVX   @DPTR,A
63F5  90 a4 16  MOV    DPTR,#0xA416
63F8  e4        CLR    A
63F9  93        MOVC   A,@A+DPTR
63FA  90 0b c0  MOV    DPTR,#0x0BC0
63FD  f0        MOVX   @DPTR,A
63FE  90 a4 18  MOV    DPTR,#0xA418
6401  e4        CLR    A
6402  93        MOVC   A,@A+DPTR
6403  90 0f 55  MOV    DPTR,#0x0F55
6406  f0        MOVX   @DPTR,A
6407  90 a4 2c  MOV    DPTR,#0xA42C
640A  e4        CLR    A
640B  93        MOVC   A,@A+DPTR
640C  90 0b a6  MOV    DPTR,#0x0BA6
640F  f0        MOVX   @DPTR,A
6410  90 a4 26  MOV    DPTR,#0xA426
6413  e4        CLR    A
6414  93        MOVC   A,@A+DPTR
6415  90 0c c7  MOV    DPTR,#0x0CC7
6418  f0        MOVX   @DPTR,A
6419  22        RET    

8942  90 0f 58  MOV    DPTR,#0x0F58
8945  e0        MOVX   A,@DPTR
8946  60 03     JZ     0x894B
8948  02 8a 0d  LJMP   0x8A0D
894B  90 0e 33  MOV    DPTR,#0x0E33
894E  e0        MOVX   A,@DPTR
894F  b4 5a 06  CJNE   A,#0x5A,0x8958
8952  12 ee cf  LCALL  0xEECF
8955  02 8a 0b  LJMP   0x8A0B
8958  90 0f 82  MOV    DPTR,#0x0F82
895B  e0        MOVX   A,@DPTR
895C  b4 14 00  CJNE   A,#0x14,0x895F
895F  40 03     JC     0x8964
8961  02 8a 0b  LJMP   0x8A0B
8964  90 89 6b  MOV    DPTR,#0x896B
8967  f8        MOV    R0,A
8968  28        ADD    A,R0
8969  28        ADD    A,R0
896A  73        JMP    @A+DPTR
896B  02 89 a7  LJMP   0x89A7
896E  02 89 a7  LJMP   0x89A7
8971  02 89 ac  LJMP   0x89AC
8974  02 89 b1  LJMP   0x89B1
8977  02 89 b6  LJMP   0x89B6
897A  02 89 be  LJMP   0x89BE
897D  02 89 c3  LJMP   0x89C3
8980  02 89 c8  LJMP   0x89C8
8983  02 89 d0  LJMP   0x89D0
8986  02 89 d5  LJMP   0x89D5
8989  02 89 dd  LJMP   0x89DD
898C  02 89 e2  LJMP   0x89E2
898F  02 89 e7  LJMP   0x89E7
8992  02 89 ef  LJMP   0x89EF
8995  02 89 f4  LJMP   0x89F4
8998  02 89 f9  LJMP   0x89F9
899B  02 89 fe  LJMP   0x89FE
899E  02 8a 03  LJMP   0x8A03
89A1  02 8a 0b  LJMP   0x8A0B
89A4  02 8a 08  LJMP   0x8A08
89A7  12 d9 3c  LCALL  0xD93C
89AA  80 5f     SJMP   0x8A0B
89AC  12 d3 8b  LCALL  0xD38B
89AF  80 5a     SJMP   0x8A0B
89B1  12 ee 62  LCALL  0xEE62
89B4  80 55     SJMP   0x8A0B
89B6  30 56 52  JNB    0x56,0x8A0B
89B9  12 ee b7  LCALL  0xEEB7
89BC  80 4d     SJMP   0x8A0B
89BE  12 ed ca  LCALL  0xEDCA
89C1  80 48     SJMP   0x8A0B
89C3  12 b1 69  LCALL  0xB169
89C6  80 43     SJMP   0x8A0B
89C8  30 56 40  JNB    0x56,0x8A0B
89CB  12 ee bd  LCALL  0xEEBD
89CE  80 3b     SJMP   0x8A0B
89D0  12 ee c3  LCALL  0xEEC3
89D3  80 36     SJMP   0x8A0B
89D5  30 56 33  JNB    0x56,0x8A0B
89D8  12 b9 70  LCALL  0xB970
89DB  80 2e     SJMP   0x8A0B
89DD  12 ec 97  LCALL  0xEC97
89E0  80 29     SJMP   0x8A0B
89E2  12 ee 6d  LCALL  0xEE6D
89E5  80 24     SJMP   0x8A0B
89E7  30 56 21  JNB    0x56,0x8A0B
89EA  12 ee c9  LCALL  0xEEC9
89ED  80 1c     SJMP   0x8A0B
89EF  12 db 32  LCALL  0xDB32
89F2  80 17     SJMP   0x8A0B
89F4  12 ed db  LCALL  0xEDDB
89F7  80 12     SJMP   0x8A0B
89F9  12 90 b2  LCALL  0x90B2
89FC  80 0d     SJMP   0x8A0B
89FE  12 ee 78  LCALL  0xEE78
8A01  80 08     SJMP   0x8A0B
8A03  12 ee 83  LCALL  0xEE83
8A06  80 03     SJMP   0x8A0B
8A08  12 8b 9b  LCALL  0x8B9B
8A0B  c2 56     CLR    0x56
8A0D  22        RET    

5C96  90 0e e0  MOV    DPTR,#0x0EE0
5C99  ef        MOV    A,R7
5C9A  f0        MOVX   @DPTR,A
5C9B  a3        INC    DPTR
5C9C  ed        MOV    A,R5
5C9D  f0        MOVX   @DPTR,A
5C9E  90 08 e8  MOV    DPTR,#0x08E8
5CA1  e0        MOVX   A,@DPTR
5CA2  64 07     XRL    A,#0x07
5CA4  60 03     JZ     0x5CA9
5CA6  02 5d 49  LJMP   0x5D49
5CA9  12 b6 69  LCALL  0xB669
5CAC  ef        MOV    A,R7
5CAD  54 7f     ANL    A,#0x7F
5CAF  ff        MOV    R7,A
5CB0  75 f0 03  MOV    0xF0,#0x03
5CB3  a4        MUL    AB
5CB4  24 86     ADD    A,#0x86
5CB6  f5 82     MOV    0x82,A
5CB8  e5 f0     MOV    A,0xF0
5CBA  34 07     ADDC   A,#0x07
5CBC  f5 83     MOV    0x83,A
5CBE  e4        CLR    A
5CBF  93        MOVC   A,@A+DPTR
5CC0  fe        MOV    R6,A
5CC1  90 0e e1  MOV    DPTR,#0x0EE1
5CC4  e0        MOVX   A,@DPTR
5CC5  fd        MOV    R5,A
5CC6  75 f0 12  MOV    0xF0,#0x12
5CC9  a4        MUL    AB
5CCA  24 79     ADD    A,#0x79
5CCC  f5 82     MOV    0x82,A
5CCE  e5 f0     MOV    A,0xF0
5CD0  34 03     ADDC   A,#0x03
5CD2  f5 83     MOV    0x83,A
5CD4  c0 83     PUSH   0x83
5CD6  c0 82     PUSH   0x82
5CD8  90 0e e0  MOV    DPTR,#0x0EE0
5CDB  e0        MOVX   A,@DPTR
5CDC  fc        MOV    R4,A
5CDD  d0 82     POP    0x82
5CDF  d0 83     POP    0x83
5CE1  75 f0 03  MOV    0xF0,#0x03
5CE4  12 29 03  LCALL  0x2903
5CE7  ee        MOV    A,R6
5CE8  f0        MOVX   @DPTR,A
5CE9  75 f0 03  MOV    0xF0,#0x03
5CEC  ef        MOV    A,R7
5CED  a4        MUL    AB
5CEE  24 87     ADD    A,#0x87
5CF0  f5 82     MOV    0x82,A
5CF2  e5 f0     MOV    A,0xF0
5CF4  34 07     ADDC   A,#0x07
5CF6  f5 83     MOV    0x83,A
5CF8  e4        CLR    A
5CF9  93        MOVC   A,@A+DPTR
5CFA  fe        MOV    R6,A
5CFB  75 f0 12  MOV    0xF0,#0x12
5CFE  ed        MOV    A,R5
5CFF  a4        MUL    AB
5D00  24 7a     ADD    A,#0x7A
5D02  f5 82     MOV    0x82,A
5D04  e5 f0     MOV    A,0xF0
5D06  34 03     ADDC   A,#0x03
5D08  f5 83     MOV    0x83,A
5D0A  75 f0 03  MOV    0xF0,#0x03
5D0D  ec        MOV    A,R4
5D0E  12 29 03  LCALL  0x2903
5D11  ee        MOV    A,R6
5D12  f0        MOVX   @DPTR,A
5D13  75 f0 03  MOV    0xF0,#0x03
5D16  ef        MOV    A,R7
5D17  a4        MUL    AB
5D18  24 88     ADD    A,#0x88
5D1A  f5 82     MOV    0x82,A
5D1C  e5 f0     MOV    A,0xF0
5D1E  34 07     ADDC   A,#0x07
5D20  f5 83     MOV    0x83,A
5D22  e4        CLR    A
5D23  93        MOVC   A,@A+DPTR
5D24  ff        MOV    R7,A
5D25  90 0e e1  MOV    DPTR,#0x0EE1
5D28  e0        MOVX   A,@DPTR
5D29  75 f0 12  MOV    0xF0,#0x12
5D2C  a4        MUL    AB
5D2D  24 7b     ADD    A,#0x7B
5D2F  f5 82     MOV    0x82,A
5D31  e5 f0     MOV    A,0xF0
5D33  34 03     ADDC   A,#0x03
5D35  f5 83     MOV    0x83,A
5D37  c0 83     PUSH   0x83
5D39  c0 82     PUSH   0x82
5D3B  90 0e e0  MOV    DPTR,#0x0EE0
5D3E  e0        MOVX   A,@DPTR
5D3F  d0 82     POP    0x82
5D41  d0 83     POP    0x83
5D43  75 f0 03  MOV    0xF0,#0x03
5D46  02 5e 13  LJMP   0x5E13
5D49  90 0f 82  MOV    DPTR,#0x0F82
5D4C  e0        MOVX   A,@DPTR
5D4D  ff        MOV    R7,A
5D4E  75 f0 15  MOV    0xF0,#0x15
5D51  a4        MUL    AB
5D52  24 00     ADD    A,#0x00
5D54  f5 82     MOV    0x82,A
5D56  e5 f0     MOV    A,0xF0
5D58  34 a8     ADDC   A,#0xA8
5D5A  f5 83     MOV    0x83,A
5D5C  c0 83     PUSH   0x83
5D5E  c0 82     PUSH   0x82
5D60  90 08 e8  MOV    DPTR,#0x08E8
5D63  e0        MOVX   A,@DPTR
5D64  fe        MOV    R6,A
5D65  d0 82     POP    0x82
5D67  d0 83     POP    0x83
5D69  75 f0 03  MOV    0xF0,#0x03
5D6C  12 29 03  LCALL  0x2903
5D6F  e4        CLR    A
5D70  93        MOVC   A,@A+DPTR
5D71  fd        MOV    R5,A
5D72  90 0e e1  MOV    DPTR,#0x0EE1
5D75  e0        MOVX   A,@DPTR
5D76  75 f0 12  MOV    0xF0,#0x12
5D79  a4        MUL    AB
5D7A  24 79     ADD    A,#0x79
5D7C  f5 82     MOV    0x82,A
5D7E  e5 f0     MOV    A,0xF0
5D80  34 03     ADDC   A,#0x03
5D82  f5 83     MOV    0x83,A
5D84  c0 83     PUSH   0x83
5D86  c0 82     PUSH   0x82
5D88  90 0e e0  MOV    DPTR,#0x0EE0
5D8B  e0        MOVX   A,@DPTR
5D8C  d0 82     POP    0x82
5D8E  d0 83     POP    0x83
5D90  75 f0 03  MOV    0xF0,#0x03
5D93  12 29 03  LCALL  0x2903
5D96  ed        MOV    A,R5
5D97  f0        MOVX   @DPTR,A
5D98  75 f0 15  MOV    0xF0,#0x15
5D9B  ef        MOV    A,R7
5D9C  a4        MUL    AB
5D9D  24 01     ADD    A,#0x01
5D9F  f5 82     MOV    0x82,A
5DA1  e5 f0     MOV    A,0xF0
5DA3  34 a8     ADDC   A,#0xA8
5DA5  f5 83     MOV    0x83,A
5DA7  75 f0 03  MOV    0xF0,#0x03
5DAA  ee        MOV    A,R6
5DAB  12 29 03  LCALL  0x2903
5DAE  e4        CLR    A
5DAF  93        MOVC   A,@A+DPTR
5DB0  ff        MOV    R7,A
5DB1  90 0e e1  MOV    DPTR,#0x0EE1
5DB4  e0        MOVX   A,@DPTR
5DB5  fe        MOV    R6,A
5DB6  75 f0 12  MOV    0xF0,#0x12
5DB9  a4        MUL    AB
5DBA  24 7a     ADD    A,#0x7A
5DBC  f5 82     MOV    0x82,A
5DBE  e5 f0     MOV    A,0xF0
5DC0  34 03     ADDC   A,#0x03
5DC2  f5 83     MOV    0x83,A
5DC4  c0 83     PUSH   0x83
5DC6  c0 82     PUSH   0x82
5DC8  90 0e e0  MOV    DPTR,#0x0EE0
5DCB  e0        MOVX   A,@DPTR
5DCC  fd        MOV    R5,A
5DCD  d0 82     POP    0x82
5DCF  d0 83     POP    0x83
5DD1  75 f0 03  MOV    0xF0,#0x03
5DD4  12 29 03  LCALL  0x2903
5DD7  ef        MOV    A,R7
5DD8  f0        MOVX   @DPTR,A
5DD9  90 0f 82  MOV    DPTR,#0x0F82
5DDC  e0        MOVX   A,@DPTR
5DDD  75 f0 15  MOV    0xF0,#0x15
5DE0  a4        MUL    AB
5DE1  24 02     ADD    A,#0x02
5DE3  f5 82     MOV    0x82,A
5DE5  e5 f0     MOV    A,0xF0
5DE7  34 a8     ADDC   A,#0xA8
5DE9  f5 83     MOV    0x83,A
5DEB  c0 83     PUSH   0x83
5DED  c0 82     PUSH   0x82
5DEF  90 08 e8  MOV    DPTR,#0x08E8
5DF2  e0        MOVX   A,@DPTR
5DF3  d0 82     POP    0x82
5DF5  d0 83     POP    0x83
5DF7  75 f0 03  MOV    0xF0,#0x03
5DFA  12 29 03  LCALL  0x2903
5DFD  e4        CLR    A
5DFE  93        MOVC   A,@A+DPTR
5DFF  ff        MOV    R7,A

851E  90 0e df  MOV    DPTR,#0x0EDF
8521  ed        MOV    A,R5
8522  f0        MOVX   @DPTR,A
8523  90 0e de  MOV    DPTR,#0x0EDE
8526  ef        MOV    A,R7
8527  f0        MOVX   @DPTR,A
8528  c3        CLR    C
8529  94 15     SUBB   A,#0x15
852B  40 03     JC     0x8530
852D  02 85 f4  LJMP   0x85F4
8530  a3        INC    DPTR
8531  e0        MOVX   A,@DPTR
8532  c3        CLR    C
8533  94 06     SUBB   A,#0x06
8535  40 03     JC     0x853A
8537  02 85 f4  LJMP   0x85F4
853A  90 0f 86  MOV    DPTR,#0x0F86
853D  e0        MOVX   A,@DPTR
853E  ff        MOV    R7,A
853F  eb        MOV    A,R3
8540  8f f0     MOV    0xF0,R7
8542  a4        MUL    AB
8543  ff        MOV    R7,A
8544  ae f0     MOV    R6,0xF0
8546  7c 00     MOV    R4,#0x00
8548  7d 05     MOV    R5,#0x05
854A  12 28 31  LCALL  0x2831
854D  90 0e de  MOV    DPTR,#0x0EDE
8550  e0        MOVX   A,@DPTR
8551  75 f0 24  MOV    0xF0,#0x24
8554  a4        MUL    AB
8555  24 f4     ADD    A,#0xF4
8557  f5 82     MOV    0x82,A
8559  e5 f0     MOV    A,0xF0
855B  34 05     ADDC   A,#0x05
855D  f5 83     MOV    0x83,A
855F  c0 83     PUSH   0x83
8561  c0 82     PUSH   0x82
8563  90 0e df  MOV    DPTR,#0x0EDF
8566  e0        MOVX   A,@DPTR
8567  d0 82     POP    0x82
8569  d0 83     POP    0x83
856B  75 f0 06  MOV    0xF0,#0x06
856E  12 29 03  LCALL  0x2903
8571  ee        MOV    A,R6
8572  f0        MOVX   @DPTR,A
8573  a3        INC    DPTR
8574  ef        MOV    A,R7
8575  f0        MOVX   @DPTR,A
8576  90 0f 86  MOV    DPTR,#0x0F86
8579  e0        MOVX   A,@DPTR
857A  ff        MOV    R7,A
857B  90 0e e1  MOV    DPTR,#0x0EE1
857E  e0        MOVX   A,@DPTR
857F  8f f0     MOV    0xF0,R7
8581  a4        MUL    AB
8582  ff        MOV    R7,A
8583  ae f0     MOV    R6,0xF0
8585  7c 00     MOV    R4,#0x00
8587  7d 05     MOV    R5,#0x05
8589  12 28 31  LCALL  0x2831
858C  90 0e de  MOV    DPTR,#0x0EDE
858F  e0        MOVX   A,@DPTR
8590  75 f0 24  MOV    0xF0,#0x24
8593  a4        MUL    AB
8594  24 f6     ADD    A,#0xF6
8596  f5 82     MOV    0x82,A
8598  e5 f0     MOV    A,0xF0
859A  34 05     ADDC   A,#0x05
859C  f5 83     MOV    0x83,A
859E  c0 83     PUSH   0x83
85A0  c0 82     PUSH   0x82
85A2  90 0e df  MOV    DPTR,#0x0EDF
85A5  e0        MOVX   A,@DPTR
85A6  d0 82     POP    0x82
85A8  d0 83     POP    0x83
85AA  75 f0 06  MOV    0xF0,#0x06
85AD  12 29 03  LCALL  0x2903
85B0  ee        MOV    A,R6
85B1  f0        MOVX   @DPTR,A
85B2  a3        INC    DPTR
85B3  ef        MOV    A,R7
85B4  f0        MOVX   @DPTR,A
85B5  90 0f 86  MOV    DPTR,#0x0F86
85B8  e0        MOVX   A,@DPTR
85B9  ff        MOV    R7,A
85BA  90 0e e2  MOV    DPTR,#0x0EE2
85BD  e0        MOVX   A,@DPTR
85BE  8f f0     MOV    0xF0,R7

9108  90 0e ed  MOV    DPTR,#0x0EED
910B  ee        MOV    A,R6
910C  f0        MOVX   @DPTR,A
910D  a3        INC    DPTR
910E  ef        MOV    A,R7
910F  f0        MOVX   @DPTR,A
9110  a3        INC    DPTR
9111  eb        MOV    A,R3
9112  f0        MOVX   @DPTR,A
9113  90 0f 5a  MOV    DPTR,#0x0F5A
9116  e0        MOVX   A,@DPTR
9117  64 5a     XRL    A,#0x5A
9119  70 03     JNZ    0x911E
911B  02 91 bb  LJMP   0x91BB
911E  ed        MOV    A,R5
911F  24 6e     ADD    A,#0x6E
9121  90 0e 34  MOV    DPTR,#0x0E34
9124  f0        MOVX   @DPTR,A
9125  c3        CLR    C
9126  94 6e     SUBB   A,#0x6E
9128  50 03     JNC    0x912D
912A  02 91 b6  LJMP   0x91B6
912D  e0        MOVX   A,@DPTR
912E  ff        MOV    R7,A
912F  94 76     SUBB   A,#0x76
9131  40 03     JC     0x9136
9133  02 91 b6  LJMP   0x91B6
9136  90 0f 7f  MOV    DPTR,#0x0F7F
9139  ef        MOV    A,R7
913A  f0        MOVX   @DPTR,A
913B  90 0f 5a  MOV    DPTR,#0x0F5A
913E  74 5a     MOV    A,#0x5A
9140  f0        MOVX   @DPTR,A
9141  e4        CLR    A
9142  90 0f 8b  MOV    DPTR,#0x0F8B
9145  f0        MOVX   @DPTR,A
9146  90 0f 7f  MOV    DPTR,#0x0F7F
9149  e0        MOVX   A,@DPTR
914A  60 13     JZ     0x915F
914C  90 0f 8b  MOV    DPTR,#0x0F8B
914F  e0        MOVX   A,@DPTR
9150  d3        SETB   C
9151  94 32     SUBB   A,#0x32
9153  40 05     JC     0x915A
9155  e4        CLR    A
9156  90 0f 7f  MOV    DPTR,#0x0F7F
9159  f0        MOVX   @DPTR,A
915A  e4        CLR    A
915B  f5 b1     MOV    0xB1,A
915D  80 e7     SJMP   0x9146
915F  e4        CLR    A
9160  90 0e f0  MOV    DPTR,#0x0EF0
9163  f0        MOVX   @DPTR,A
9164  a3        INC    DPTR
9165  f0        MOVX   @DPTR,A
9166  90 0f b2  MOV    DPTR,#0x0FB2
9169  74 05     MOV    A,#0x05
916B  f0        MOVX   @DPTR,A
916C  90 0f b3  MOV    DPTR,#0x0FB3
916F  74 0a     MOV    A,#0x0A
