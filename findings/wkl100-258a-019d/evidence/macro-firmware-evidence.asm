4139  90 0b b2  MOV    DPTR,#0x0BB2
413C  e0        MOVX   A,@DPTR
413D  70 02     JNZ    0x4141
413F  a3        INC    DPTR
4140  e0        MOVX   A,@DPTR
4141  60 03     JZ     0x4146
4143  02 43 5d  LJMP   0x435D
4146  90 0b b2  MOV    DPTR,#0x0BB2
4149  f0        MOVX   @DPTR,A
414A  a3        INC    DPTR
414B  f0        MOVX   @DPTR,A
414C  90 0b ad  MOV    DPTR,#0x0BAD
414F  e0        MOVX   A,@DPTR
4150  70 02     JNZ    0x4154
4152  a3        INC    DPTR
4153  e0        MOVX   A,@DPTR
4154  60 03     JZ     0x4159
4156  02 42 21  LJMP   0x4221
4159  ef        MOV    A,R7
415A  90 0b a8  MOV    DPTR,#0x0BA8
415D  70 02     JNZ    0x4161
415F  f0        MOVX   @DPTR,A
4160  22        RET    
4161  74 01     MOV    A,#0x01
4163  f0        MOVX   @DPTR,A
4164  90 0b ac  MOV    DPTR,#0x0BAC
4167  e0        MOVX   A,@DPTR
4168  fd        MOV    R5,A
4169  75 f0 04  MOV    0xF0,#0x04
416C  a4        MUL    AB
416D  24 03     ADD    A,#0x03
416F  f5 82     MOV    0x82,A
4171  e5 f0     MOV    A,0xF0
4173  34 dc     ADDC   A,#0xDC
4175  f5 83     MOV    0x83,A
4177  e4        CLR    A
4178  93        MOVC   A,@A+DPTR
4179  fe        MOV    R6,A
417A  75 f0 04  MOV    0xF0,#0x04
417D  ed        MOV    A,R5
417E  a4        MUL    AB
417F  24 02     ADD    A,#0x02
4181  f5 82     MOV    0x82,A
4183  e5 f0     MOV    A,0xF0
4185  34 dc     ADDC   A,#0xDC
4187  f5 83     MOV    0x83,A
4189  e4        CLR    A
418A  93        MOVC   A,@A+DPTR
418B  fd        MOV    R5,A
418C  ed        MOV    A,R5
418D  ff        MOV    R7,A
418E  90 0b ad  MOV    DPTR,#0x0BAD
4191  ee        MOV    A,R6
4192  f0        MOVX   @DPTR,A
4193  a3        INC    DPTR
4194  ef        MOV    A,R7
4195  f0        MOVX   @DPTR,A
4196  90 0b ac  MOV    DPTR,#0x0BAC
4199  e0        MOVX   A,@DPTR
419A  fd        MOV    R5,A
419B  75 f0 04  MOV    0xF0,#0x04
419E  a4        MUL    AB
419F  24 01     ADD    A,#0x01
41A1  f5 82     MOV    0x82,A
41A3  e5 f0     MOV    A,0xF0
41A5  34 dc     ADDC   A,#0xDC
41A7  f5 83     MOV    0x83,A
41A9  e4        CLR    A
41AA  93        MOVC   A,@A+DPTR
41AB  fe        MOV    R6,A
41AC  75 f0 04  MOV    0xF0,#0x04
41AF  ed        MOV    A,R5
41B0  a4        MUL    AB
41B1  24 00     ADD    A,#0x00
41B3  f5 82     MOV    0x82,A
41B5  e5 f0     MOV    A,0xF0
41B7  34 dc     ADDC   A,#0xDC
41B9  f5 83     MOV    0x83,A
41BB  e4        CLR    A
41BC  93        MOVC   A,@A+DPTR
41BD  fd        MOV    R5,A
41BE  ed        MOV    A,R5
41BF  24 00     ADD    A,#0x00
41C1  ff        MOV    R7,A
41C2  ee        MOV    A,R6
41C3  34 dc     ADDC   A,#0xDC
41C5  90 0b af  MOV    DPTR,#0x0BAF
41C8  f0        MOVX   @DPTR,A
41C9  a3        INC    DPTR
41CA  ef        MOV    A,R7
41CB  f0        MOVX   @DPTR,A
41CC  90 0b af  MOV    DPTR,#0x0BAF
41CF  e0        MOVX   A,@DPTR
41D0  fe        MOV    R6,A
41D1  a3        INC    DPTR
41D2  e0        MOVX   A,@DPTR
41D3  f5 82     MOV    0x82,A
41D5  8e 83     MOV    0x83,R6
41D7  e4        CLR    A
41D8  93        MOVC   A,@A+DPTR
41D9  fb        MOV    R3,A
41DA  fd        MOV    R5,A
41DB  c3        CLR    C
41DC  90 0b ae  MOV    DPTR,#0x0BAE
41DF  e0        MOVX   A,@DPTR
41E0  9d        SUBB   A,R5
41E1  fd        MOV    R5,A
41E2  90 0b ad  MOV    DPTR,#0x0BAD
41E5  e0        MOVX   A,@DPTR
41E6  94 00     SUBB   A,#0x00
41E8  cd        XCH    A,R5
41E9  24 ff     ADD    A,#0xFF
41EB  fe        MOV    R6,A
41EC  ed        MOV    A,R5
41ED  34 ff     ADDC   A,#0xFF
41EF  f0        MOVX   @DPTR,A
41F0  a3        INC    DPTR
41F1  ce        XCH    A,R6
41F2  f0        MOVX   @DPTR,A
41F3  af 03     MOV    R7,0x03
41F5  90 0b b0  MOV    DPTR,#0x0BB0
41F8  e0        MOVX   A,@DPTR
41F9  2b        ADD    A,R3
41FA  ff        MOV    R7,A
41FB  90 0b af  MOV    DPTR,#0x0BAF
41FE  e0        MOVX   A,@DPTR
41FF  34 00     ADDC   A,#0x00
4201  cf        XCH    A,R7
4202  24 01     ADD    A,#0x01
4204  cf        XCH    A,R7
4205  34 00     ADDC   A,#0x00
4207  f0        MOVX   @DPTR,A
4208  a3        INC    DPTR
4209  ef        MOV    A,R7
420A  f0        MOVX   @DPTR,A
420B  90 0b ab  MOV    DPTR,#0x0BAB
420E  e0        MOVX   A,@DPTR
420F  24 ff     ADD    A,#0xFF
4211  f0        MOVX   @DPTR,A
4212  90 0b aa  MOV    DPTR,#0x0BAA
4215  e0        MOVX   A,@DPTR
4216  34 ff     ADDC   A,#0xFF
4218  f0        MOVX   @DPTR,A
4219  e4        CLR    A
421A  90 0b b2  MOV    DPTR,#0x0BB2
421D  f0        MOVX   @DPTR,A
421E  a3        INC    DPTR
421F  f0        MOVX   @DPTR,A
4220  22        RET    
4221  90 0b af  MOV    DPTR,#0x0BAF
4224  e0        MOVX   A,@DPTR
4225  fe        MOV    R6,A
4226  a3        INC    DPTR
4227  e0        MOVX   A,@DPTR
4228  f5 82     MOV    0x82,A
422A  8e 83     MOV    0x83,R6
422C  74 03     MOV    A,#0x03
422E  93        MOVC   A,@A+DPTR
422F  90 0b b1  MOV    DPTR,#0x0BB1
4232  f0        MOVX   @DPTR,A
4233  90 0b af  MOV    DPTR,#0x0BAF
4236  e0        MOVX   A,@DPTR
4237  fc        MOV    R4,A
4238  a3        INC    DPTR
4239  e0        MOVX   A,@DPTR
423A  f5 82     MOV    0x82,A
423C  8c 83     MOV    0x83,R4
423E  74 01     MOV    A,#0x01
4240  93        MOVC   A,@A+DPTR
4241  fe        MOV    R6,A
4242  74 02     MOV    A,#0x02
4244  93        MOVC   A,@A+DPTR
4245  fd        MOV    R5,A
4246  ed        MOV    A,R5
4247  ff        MOV    R7,A
4248  90 0b b2  MOV    DPTR,#0x0BB2
424B  ee        MOV    A,R6
424C  f0        MOVX   @DPTR,A
424D  a3        INC    DPTR
424E  ef        MOV    A,R7
424F  f0        MOVX   @DPTR,A
4250  90 0b af  MOV    DPTR,#0x0BAF
4253  e0        MOVX   A,@DPTR
4254  fe        MOV    R6,A
4255  a3        INC    DPTR
4256  e0        MOVX   A,@DPTR
4257  f5 82     MOV    0x82,A
4259  8e 83     MOV    0x83,R6
425B  e4        CLR    A
425C  93        MOVC   A,@A+DPTR
425D  ff        MOV    R7,A
425E  90 0b b4  MOV    DPTR,#0x0BB4
4261  e4        CLR    A
4262  f0        MOVX   @DPTR,A
4263  a3        INC    DPTR
4264  ef        MOV    A,R7
4265  f0        MOVX   @DPTR,A
4266  90 0b b0  MOV    DPTR,#0x0BB0
4269  e0        MOVX   A,@DPTR
426A  24 04     ADD    A,#0x04
426C  f0        MOVX   @DPTR,A
426D  90 0b af  MOV    DPTR,#0x0BAF
4270  e0        MOVX   A,@DPTR
4271  34 00     ADDC   A,#0x00
4273  f0        MOVX   @DPTR,A
4274  c3        CLR    C
4275  90 0b ae  MOV    DPTR,#0x0BAE
4278  e0        MOVX   A,@DPTR
4279  94 04     SUBB   A,#0x04
427B  90 0b ad  MOV    DPTR,#0x0BAD
427E  e0        MOVX   A,@DPTR
427F  94 00     SUBB   A,#0x00
4281  40 0e     JC     0x4291
4283  a3        INC    DPTR
4284  e0        MOVX   A,@DPTR
4285  24 fc     ADD    A,#0xFC
4287  f0        MOVX   @DPTR,A
4288  90 0b ad  MOV    DPTR,#0x0BAD
428B  e0        MOVX   A,@DPTR
428C  34 ff     ADDC   A,#0xFF
428E  f0        MOVX   @DPTR,A
428F  80 07     SJMP   0x4298
4291  e4        CLR    A
4292  90 0b ad  MOV    DPTR,#0x0BAD
4295  f0        MOVX   @DPTR,A
4296  a3        INC    DPTR
4297  f0        MOVX   @DPTR,A
4298  90 0b b4  MOV    DPTR,#0x0BB4
429B  e0        MOVX   A,@DPTR
429C  fe        MOV    R6,A
429D  a3        INC    DPTR
429E  e0        MOVX   A,@DPTR
429F  ff        MOV    R7,A
42A0  54 70     ANL    A,#0x70
42A2  fd        MOV    R5,A
42A3  24 f0     ADD    A,#0xF0
42A5  60 38     JZ     0x42DF
42A7  24 f0     ADD    A,#0xF0
42A9  60 63     JZ     0x430E
42AB  24 f0     ADD    A,#0xF0
42AD  60 73     JZ     0x4322
42AF  24 f0     ADD    A,#0xF0
42B1  70 03     JNZ    0x42B6
42B3  02 43 36  LJMP   0x4336
42B6  24 f0     ADD    A,#0xF0
42B8  70 03     JNZ    0x42BD
42BA  02 43 4a  LJMP   0x434A
42BD  24 50     ADD    A,#0x50
42BF  60 03     JZ     0x42C4
42C1  02 43 5d  LJMP   0x435D
42C4  e4        CLR    A
42C5  90 0e e7  MOV    DPTR,#0x0EE7
42C8  f0        MOVX   @DPTR,A
42C9  a3        INC    DPTR
42CA  f0        MOVX   @DPTR,A
42CB  90 0b b1  MOV    DPTR,#0x0BB1
42CE  e0        MOVX   A,@DPTR
42CF  90 0e e9  MOV    DPTR,#0x0EE9
42D2  f0        MOVX   @DPTR,A
42D3  ef        MOV    A,R7
42D4  7b 01     MOV    R3,#0x01
42D6  7a 0e     MOV    R2,#0x0E
42D8  79 e6     MOV    R1,#0xE6
42DA  30 e7 2e  JNB    0xE7,0x430B
42DD  80 29     SJMP   0x4308
42DF  e4        CLR    A
42E0  90 0e e8  MOV    DPTR,#0x0EE8
42E3  f0        MOVX   @DPTR,A
42E4  a3        INC    DPTR
42E5  f0        MOVX   @DPTR,A
42E6  90 0b b1  MOV    DPTR,#0x0BB1
42E9  e0        MOVX   A,@DPTR
42EA  54 0f     ANL    A,#0x0F
42EC  ff        MOV    R7,A
42ED  f8        MOV    R0,A
42EE  74 01     MOV    A,#0x01
42F0  08        INC    R0
42F1  80 02     SJMP   0x42F5
42F3  c3        CLR    C
42F4  33        RLC    A
42F5  d8 fc     DJNZ   R0,0x42F3
42F7  90 0e e7  MOV    DPTR,#0x0EE7
42FA  f0        MOVX   @DPTR,A
42FB  90 0b b5  MOV    DPTR,#0x0BB5
42FE  e0        MOVX   A,@DPTR
42FF  7b 01     MOV    R3,#0x01
4301  7a 0e     MOV    R2,#0x0E
4303  79 e6     MOV    R1,#0xE6
4305  30 e7 03  JNB    0xE7,0x430B
4308  02 69 cd  LJMP   0x69CD
430B  02 56 3a  LJMP   0x563A
430E  90 0b b5  MOV    DPTR,#0x0BB5
4311  e0        MOVX   A,@DPTR
4312  30 e7 03  JNB    0xE7,0x4318
4315  e4        CLR    A
4316  80 04     SJMP   0x431C
4318  90 0b b1  MOV    DPTR,#0x0BB1
431B  e0        MOVX   A,@DPTR
431C  78 78     MOV    R0,#0x78
431E  f6        MOV    @R0,A
431F  d2 0c     SETB   0x0C
4321  22        RET    
4322  90 0b b5  MOV    DPTR,#0x0BB5
4325  e0        MOVX   A,@DPTR
4326  30 e7 03  JNB    0xE7,0x432C
4329  e4        CLR    A
432A  80 04     SJMP   0x4330
432C  90 0b b1  MOV    DPTR,#0x0BB1
432F  e0        MOVX   A,@DPTR
4330  78 79     MOV    R0,#0x79
4332  f6        MOV    @R0,A
4333  d2 0c     SETB   0x0C
4335  22        RET    
4336  90 0b b5  MOV    DPTR,#0x0BB5
4339  e0        MOVX   A,@DPTR
433A  30 e7 03  JNB    0xE7,0x4340
433D  e4        CLR    A
433E  80 04     SJMP   0x4344
4340  90 0b b1  MOV    DPTR,#0x0BB1
4343  e0        MOVX   A,@DPTR
4344  78 7b     MOV    R0,#0x7B
4346  f6        MOV    @R0,A
4347  d2 0c     SETB   0x0C
4349  22        RET    
434A  90 0b b5  MOV    DPTR,#0x0BB5
434D  e0        MOVX   A,@DPTR
434E  30 e7 03  JNB    0xE7,0x4354
4351  e4        CLR    A
4352  80 04     SJMP   0x4358
4354  90 0b b1  MOV    DPTR,#0x0BB1
4357  e0        MOVX   A,@DPTR
4358  78 7d     MOV    R0,#0x7D
435A  f6        MOV    @R0,A
435B  d2 0c     SETB   0x0C
435D  22        RET    

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
9171  f0        MOVX   @DPTR,A
9172  90 0e f0  MOV    DPTR,#0x0EF0
9175  e0        MOVX   A,@DPTR
9176  fe        MOV    R6,A
9177  a3        INC    DPTR
9178  e0        MOVX   A,@DPTR
9179  ff        MOV    R7,A
917A  90 0e ef  MOV    DPTR,#0x0EEF
917D  e0        MOVX   A,@DPTR
917E  fd        MOV    R5,A
917F  7c 00     MOV    R4,#0x00
9181  ef        MOV    A,R7
9182  2d        ADD    A,R5
9183  fd        MOV    R5,A
9184  ec        MOV    A,R4
9185  3e        ADDC   A,R6
9186  fc        MOV    R4,A
9187  90 0e ed  MOV    DPTR,#0x0EED
918A  e0        MOVX   A,@DPTR
918B  fa        MOV    R2,A
918C  a3        INC    DPTR
918D  e0        MOVX   A,@DPTR
918E  2d        ADD    A,R5
918F  f5 82     MOV    0x82,A
9191  ea        MOV    A,R2
9192  3c        ADDC   A,R4
9193  f5 83     MOV    0x83,A
9195  e0        MOVX   A,@DPTR
9196  fd        MOV    R5,A
9197  90 0e 34  MOV    DPTR,#0x0E34
919A  e0        MOVX   A,@DPTR
919B  fb        MOV    R3,A
919C  12 db c5  LCALL  0xDBC5
919F  90 0e f1  MOV    DPTR,#0x0EF1
91A2  e0        MOVX   A,@DPTR
91A3  04        INC    A
91A4  f0        MOVX   @DPTR,A
91A5  70 06     JNZ    0x91AD
91A7  90 0e f0  MOV    DPTR,#0x0EF0
91AA  e0        MOVX   A,@DPTR
91AB  04        INC    A
91AC  f0        MOVX   @DPTR,A
91AD  c3        CLR    C
91AE  90 0e f0  MOV    DPTR,#0x0EF0
91B1  e0        MOVX   A,@DPTR
91B2  94 02     SUBB   A,#0x02
91B4  40 b0     JC     0x9166
91B6  e4        CLR    A
91B7  90 0f 5a  MOV    DPTR,#0x0F5A
91BA  f0        MOVX   @DPTR,A
91BB  22        RET    

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

D2E0  90 0b b6  MOV    DPTR,#0x0BB6
D2E3  74 01     MOV    A,#0x01
D2E5  f0        MOVX   @DPTR,A
D2E6  90 0b a9  MOV    DPTR,#0x0BA9
D2E9  e0        MOVX   A,@DPTR
D2EA  14        DEC    A
D2EB  60 15     JZ     0xD302
D2ED  14        DEC    A
D2EE  60 08     JZ     0xD2F8
D2F0  14        DEC    A
D2F1  60 05     JZ     0xD2F8
D2F3  14        DEC    A
D2F4  70 15     JNZ    0xD30B
D2F6  80 00     SJMP   0xD2F8
D2F8  90 0b aa  MOV    DPTR,#0x0BAA
D2FB  e4        CLR    A
D2FC  f0        MOVX   @DPTR,A
D2FD  a3        INC    DPTR
D2FE  04        INC    A
D2FF  f0        MOVX   @DPTR,A
D300  80 00     SJMP   0xD302
D302  90 0b aa  MOV    DPTR,#0x0BAA
D305  a3        INC    DPTR
D306  e0        MOVX   A,@DPTR
D307  ff        MOV    R7,A
D308  12 41 39  LCALL  0x4139
D30B  22        RET    
