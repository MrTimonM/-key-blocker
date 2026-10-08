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
8276  90 0d ac  MOV    DPTR,#0x0DAC
8279  e0        MOVX   A,@DPTR
827A  60 0e     JZ     0x828A
827C  90 0f 31  MOV    DPTR,#0x0F31
827F  f0        MOVX   @DPTR,A
8280  e4        CLR    A
8281  90 0e 32  MOV    DPTR,#0x0E32
8284  f0        MOVX   @DPTR,A
8285  90 0d ac  MOV    DPTR,#0x0DAC
8288  f0        MOVX   @DPTR,A
8289  22        RET    
828A  90 0f 31  MOV    DPTR,#0x0F31
828D  e0        MOVX   A,@DPTR
828E  ff        MOV    R7,A
828F  60 6b     JZ     0x82FC
8291  30 55 03  JNB    0x55,0x8297
8294  02 83 5a  LJMP   0x835A
8297  f4        CPL    A
8298  60 5c     JZ     0x82F6
829A  90 0b 95  MOV    DPTR,#0x0B95
829D  74 09     MOV    A,#0x09
829F  f0        MOVX   @DPTR,A
82A0  a3        INC    DPTR
82A1  04        INC    A
82A2  f0        MOVX   @DPTR,A
82A3  a3        INC    DPTR
82A4  74 06     MOV    A,#0x06
82A6  f0        MOVX   @DPTR,A
82A7  ef        MOV    A,R7
82A8  b4 aa 12  CJNE   A,#0xAA,0x82BD
82AB  a3        INC    DPTR
82AC  74 01     MOV    A,#0x01
82AE  f0        MOVX   @DPTR,A
82AF  90 0f 20  MOV    DPTR,#0x0F20
82B2  e0        MOVX   A,@DPTR
82B3  90 0b 99  MOV    DPTR,#0x0B99
82B6  f0        MOVX   @DPTR,A
82B7  90 0f 33  MOV    DPTR,#0x0F33
82BA  f0        MOVX   @DPTR,A
82BB  80 0e     SJMP   0x82CB
82BD  e4        CLR    A
82BE  90 0b 98  MOV    DPTR,#0x0B98
82C1  f0        MOVX   @DPTR,A
82C2  90 0f 33  MOV    DPTR,#0x0F33
82C5  e0        MOVX   A,@DPTR
82C6  04        INC    A
82C7  90 0b 99  MOV    DPTR,#0x0B99
82CA  f0        MOVX   @DPTR,A
82CB  e4        CLR    A
82CC  90 0b 9a  MOV    DPTR,#0x0B9A
82CF  f0        MOVX   @DPTR,A
82D0  a3        INC    DPTR
82D1  f0        MOVX   @DPTR,A
82D2  a3        INC    DPTR
82D3  f0        MOVX   @DPTR,A
82D4  7b 01     MOV    R3,#0x01
82D6  7a 0b     MOV    R2,#0x0B
82D8  79 95     MOV    R1,#0x95
82DA  7d 08     MOV    R5,#0x08
82DC  12 da 11  LCALL  0xDA11
82DF  43 9a 04  ORL    0x9A,#0x04
82E2  90 0f 31  MOV    DPTR,#0x0F31
82E5  74 ff     MOV    A,#0xFF
82E7  f0        MOVX   @DPTR,A
82E8  e4        CLR    A
82E9  90 0f 61  MOV    DPTR,#0x0F61
82EC  f0        MOVX   @DPTR,A
82ED  a3        INC    DPTR
82EE  f0        MOVX   @DPTR,A
82EF  90 0f 41  MOV    DPTR,#0x0F41
82F2  f0        MOVX   @DPTR,A
82F3  a3        INC    DPTR
82F4  f0        MOVX   @DPTR,A
82F5  22        RET    
82F6  e4        CLR    A
82F7  90 0f 31  MOV    DPTR,#0x0F31
82FA  f0        MOVX   @DPTR,A
82FB  22        RET    
82FC  90 0f 4e  MOV    DPTR,#0x0F4E
82FF  e0        MOVX   A,@DPTR
8300  ff        MOV    R7,A
8301  60 57     JZ     0x835A
8303  20 55 54  JB     0x55,0x835A
8306  90 0f 57  MOV    DPTR,#0x0F57
8309  e0        MOVX   A,@DPTR
830A  70 4e     JNZ    0x835A
830C  90 0b 95  MOV    DPTR,#0x0B95
830F  74 09     MOV    A,#0x09
8311  f0        MOVX   @DPTR,A
8312  a3        INC    DPTR
8313  04        INC    A
8314  f0        MOVX   @DPTR,A
8315  ef        MOV    A,R7
8316  30 e0 41  JNB    0xE0,0x835A
8319  90 0f 4e  MOV    DPTR,#0x0F4E
831C  54 fe     ANL    A,#0xFE
831E  f0        MOVX   @DPTR,A
831F  90 0b 97  MOV    DPTR,#0x0B97
8322  74 05     MOV    A,#0x05
8324  f0        MOVX   @DPTR,A
8325  90 0f 4a  MOV    DPTR,#0x0F4A
8328  e0        MOVX   A,@DPTR
8329  90 0b 98  MOV    DPTR,#0x0B98
832C  f0        MOVX   @DPTR,A
832D  e4        CLR    A
832E  a3        INC    DPTR
832F  f0        MOVX   @DPTR,A
8330  90 0f 40  MOV    DPTR,#0x0F40
8333  e0        MOVX   A,@DPTR
8334  b4 01 07  CJNE   A,#0x01,0x833E
8337  90 0b 99  MOV    DPTR,#0x0B99
833A  e0        MOVX   A,@DPTR
833B  44 10     ORL    A,#0x10
833D  f0        MOVX   @DPTR,A
833E  90 0f b7  MOV    DPTR,#0x0FB7
8341  e0        MOVX   A,@DPTR
8342  b4 01 07  CJNE   A,#0x01,0x834C
8345  90 0b 99  MOV    DPTR,#0x0B99
8348  e0        MOVX   A,@DPTR
8349  44 01     ORL    A,#0x01
834B  f0        MOVX   @DPTR,A
834C  7b 01     MOV    R3,#0x01
834E  7a 0b     MOV    R2,#0x0B
8350  79 95     MOV    R1,#0x95
8352  7d 08     MOV    R5,#0x08
8354  12 da 11  LCALL  0xDA11
8357  43 9a 04  ORL    0x9A,#0x04
A300  a3        INC    DPTR
A301  e0        MOVX   A,@DPTR
A302  fa        MOV    R2,A
A303  a3        INC    DPTR
A304  e0        MOVX   A,@DPTR
A305  fb        MOV    R3,A
A306  c3        CLR    C
A307  12 28 9c  LCALL  0x289C
A30A  60 03     JZ     0xA30F
A30C  02 00 6e  LJMP   0x006E
A30F  90 0f 3d  MOV    DPTR,#0x0F3D
A312  e0        MOVX   A,@DPTR
A313  ff        MOV    R7,A
A314  60 03     JZ     0xA319
A316  02 74 cd  LJMP   0x74CD
A319  90 0f 3c  MOV    DPTR,#0x0F3C
A31C  e0        MOVX   A,@DPTR
A31D  ff        MOV    R7,A
A31E  60 03     JZ     0xA323
A320  02 8f fe  LJMP   0x8FFE
A323  90 0f 49  MOV    DPTR,#0x0F49
A326  e0        MOVX   A,@DPTR
A327  60 03     JZ     0xA32C
A329  02 9e 2f  LJMP   0x9E2F
A32C  c3        CLR    C
A32D  90 0f 4c  MOV    DPTR,#0x0F4C
A330  e0        MOVX   A,@DPTR
A331  94 f4     SUBB   A,#0xF4
A333  90 0f 4b  MOV    DPTR,#0x0F4B
A336  e0        MOVX   A,@DPTR
A337  94 01     SUBB   A,#0x01
A339  40 03     JC     0xA33E
A33B  02 d3 de  LJMP   0xD3DE
A33E  90 0f 4e  MOV    DPTR,#0x0F4E
A341  e0        MOVX   A,@DPTR
A342  60 03     JZ     0xA347
A344  02 b2 81  LJMP   0xB281
A347  90 0e d9  MOV    DPTR,#0x0ED9
A34A  e0        MOVX   A,@DPTR
A34B  ff        MOV    R7,A
A34C  60 03     JZ     0xA351
A34E  02 d2 2d  LJMP   0xD22D
A351  12 d1 3b  LCALL  0xD13B
A354  22        RET    
A355  30 52 2d  JNB    0x52,0xA385
A358  c2 52     CLR    0x52
A35A  90 0f 72  MOV    DPTR,#0x0F72
A35D  e0        MOVX   A,@DPTR
A35E  60 07     JZ     0xA367
A360  90 0f 54  MOV    DPTR,#0x0F54
A363  74 02     MOV    A,#0x02
A365  80 04     SJMP   0xA36B
A367  e4        CLR    A
A368  90 0f 54  MOV    DPTR,#0x0F54
A36B  f0        MOVX   @DPTR,A
A36C  53 e5 fd  ANL    0xE5,#0xFD
A36F  e4        CLR    A
A370  90 0f 3a  MOV    DPTR,#0x0F3A
A373  f0        MOVX   @DPTR,A
A374  a3        INC    DPTR
A375  f0        MOVX   @DPTR,A
A376  90 0e 32  MOV    DPTR,#0x0E32
A379  e0        MOVX   A,@DPTR
A37A  64 01     XRL    A,#0x01
A37C  70 51     JNZ    0xA3CF
A37E  90 0d ac  MOV    DPTR,#0x0DAC
A381  74 aa     MOV    A,#0xAA
A383  80 29     SJMP   0xA3AE
A385  90 0e 32  MOV    DPTR,#0x0E32
A388  e0        MOVX   A,@DPTR
A389  b4 01 26  CJNE   A,#0x01,0xA3B2
A38C  d3        SETB   C
A38D  90 0f 3b  MOV    DPTR,#0x0F3B
A390  e0        MOVX   A,@DPTR
A391  94 d0     SUBB   A,#0xD0
A393  90 0f 3a  MOV    DPTR,#0x0F3A
A396  e0        MOVX   A,@DPTR
A397  94 07     SUBB   A,#0x07
A399  40 34     JC     0xA3CF
A39B  e4        CLR    A
A39C  90 0f 54  MOV    DPTR,#0x0F54
A39F  f0        MOVX   @DPTR,A
A3A0  90 0f 3a  MOV    DPTR,#0x0F3A
A3A3  f0        MOVX   @DPTR,A
A3A4  a3        INC    DPTR
A3A5  f0        MOVX   @DPTR,A
A3A6  53 e5 fd  ANL    0xE5,#0xFD
A3A9  90 0d ac  MOV    DPTR,#0x0DAC
A3AC  74 55     MOV    A,#0x55
A3AE  f0        MOVX   @DPTR,A
A3AF  c2 5a     CLR    0x5A
A3B1  22        RET    
A3B2  d3        SETB   C
A3B3  90 0f 3b  MOV    DPTR,#0x0F3B
A3B6  e0        MOVX   A,@DPTR
A3B7  94 c8     SUBB   A,#0xC8
A3B9  90 0f 3a  MOV    DPTR,#0x0F3A
A3BC  e0        MOVX   A,@DPTR
A3BD  94 00     SUBB   A,#0x00
A3BF  40 0e     JC     0xA3CF
A3C1  e4        CLR    A
A3C2  90 0f 54  MOV    DPTR,#0x0F54
A3C5  f0        MOVX   @DPTR,A
A3C6  90 0f 3a  MOV    DPTR,#0x0F3A
A3C9  f0        MOVX   @DPTR,A
A3CA  a3        INC    DPTR
A3CB  f0        MOVX   @DPTR,A
A3CC  53 e5 fd  ANL    0xE5,#0xFD
A3CF  22        RET    
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
