0047fcc0 sub      esp, 0x41c
0047fcc6 mov      eax, dword ptr [0x6236a4]
0047fccb xor      eax, esp
0047fccd mov      dword ptr [esp + 0x418], eax
0047fcd4 push     ebx
0047fcd5 xor      ebx, ebx
0047fcd7 push     ebx
0047fcd8 xor      eax, eax
0047fcda push     ebx
0047fcdb push     ebx
0047fcdc push     ebx
0047fcdd mov      dword ptr [esp + 0x18], eax
0047fce1 mov      dword ptr [esp + 0x1c], eax
0047fce5 mov      dword ptr [esp + 0x20], eax
0047fce9 mov      dword ptr [esp + 0x24], eax
0047fced mov      dword ptr [esp + 0x28], eax
0047fcf1 call     dword ptr [0x5bd33c]
0047fcf7 mov      dword ptr [esp + 0x18], eax
0047fcfb lea      eax, [esp + 8]
0047fcff push     eax
0047fd00 lea      ecx, [esp + 8]
0047fd04 push     ecx
0047fd05 push     8
0047fd07 lea      edx, [esp + 0x28]
0047fd0b push     edx
0047fd0c push     esi
0047fd0d mov      dword ptr [esp + 0x18], ebx
0047fd11 mov      byte ptr [esp + 0x30], 0xa
0047fd16 call     dword ptr [0x5bd234]
0047fd1c test     eax, eax
0047fd1e je       0x47fd3a
0047fd20 cmp      edi, ebx
0047fd22 je       0x47fde7
0047fd28 mov      eax, dword ptr [esp + 0x1c]
0047fd2c mov      ecx, dword ptr [esp + 0x20]
0047fd30 mov      dword ptr [edi], eax
0047fd32 mov      dword ptr [edi + 4], ecx
0047fd35 jmp      0x47fde7
0047fd3a push     ebp
0047fd3b mov      ebp, dword ptr [0x5bd220]
0047fd41 call     ebp
0047fd43 cmp      eax, 0x3e5
0047fd48 jne      0x47fdb7
0047fd4a mov      edx, dword ptr [esp + 0x1c]
0047fd4e push     0x7d0
0047fd53 push     edx
0047fd54 call     dword ptr [0x5bd224]
0047fd5a test     eax, eax
0047fd5c jne      0x47fd75
0047fd5e test     edi, edi
0047fd60 je       0x47fde6
0047fd66 mov      eax, dword ptr [esp + 0x20]
0047fd6a mov      ecx, dword ptr [esp + 0x24]
0047fd6e mov      dword ptr [edi], eax
0047fd70 mov      dword ptr [edi + 4], ecx
0047fd73 jmp      0x47fde6
0047fd75 push     esi
0047fd76 cmp      eax, 0x102
0047fd7b jne      0x47fda1
0047fd7d call     dword ptr [0x5bd228]
0047fd83 test     eax, eax
0047fd85 je       0x47fd9a
0047fd87 push     1
0047fd89 lea      edx, [esp + 0xc]
0047fd8d push     edx
0047fd8e lea      eax, [esp + 0x14]
0047fd92 push     eax
0047fd93 push     esi
0047fd94 call     dword ptr [0x5bd22c]
0047fd9a mov      ebx, 0xfffffffe
0047fd9f jmp      0x47fde6
0047fda1 call     ebp
0047fda3 push     eax
0047fda4 push     0x5f874c
0047fda9 call     dword ptr [0x632af0]
0047fdaf add      esp, 0xc
0047fdb2 or       ebx, 0xffffffff
0047fdb5 jmp      0x47fde6
0047fdb7 or       ebx, 0xffffffff
0047fdba push     esi
0047fdbb cmp      eax, 0x48f
0047fdc0 jne      0x47fdd7
0047fdc2 push     0x5f8790
0047fdc7 mov      ebx, 0xfffffffd
0047fdcc call     dword ptr [0x632af0]
0047fdd2 add      esp, 8
0047fdd5 jmp      0x47fde6
0047fdd7 push     eax
0047fdd8 push     0x5f874c
0047fddd call     dword ptr [0x632af0]
0047fde3 add      esp, 0xc
0047fde6 pop      ebp
0047fde7 mov      ecx, dword ptr [esp + 0x18]
0047fdeb push     ecx
0047fdec call     dword ptr [0x5bd230]
0047fdf2 mov      ecx, dword ptr [esp + 0x41c]
0047fdf9 mov      eax, ebx
0047fdfb pop      ebx
0047fdfc xor      ecx, esp
0047fdfe call     0x587fe9
0047fe03 add      esp, 0x41c
0047fe09 ret      
0047fe0a int3     
0047fe0b int3     
0047fe0c int3     
0047fe0d int3     
0047fe0e int3     
0047fe0f int3     
0047fe10 sub      esp, 0x254
0047fe16 mov      eax, dword ptr [0x6236a4]
0047fe1b xor      eax, esp
0047fe1d mov      dword ptr [esp + 0x250], eax
0047fe24 mov      eax, dword ptr [esp + 0x258]
0047fe2b mov      dword ptr [esp + 0x14], eax
0047fe2f mov      eax, dword ptr [esp + 0x260]
0047fe36 push     esi
0047fe37 mov      esi, edx
0047fe39 mov      dword ptr [esp + 0x24], eax
0047fe3d mov      dword ptr [esp + 0x30], ecx
0047fe41 test     eax, eax
0047fe43 je       0x480168
0047fe49 mov      ecx, dword ptr [esp + 0x268]
0047fe50 test     ecx, ecx
0047fe52 jle      0x480168
0047fe58 mov      eax, ecx
0047fe5a cdq      
0047fe5b and      edx, 0xfff
0047fe61 add      edx, eax
0047fe63 sar      edx, 0xc
0047fe66 and      ecx, 0x80000fff
0047fe6c mov      dword ptr [esp + 0x20], edx
0047fe70 jns      0x47fe7a
0047fe72 dec      ecx
0047fe73 or       ecx, 0xfffff000
0047fe79 inc      ecx
0047fe7a mov      dword ptr [esp + 0x2c], ecx
0047fe7e je       0x47fe85
0047fe80 inc      edx
0047fe81 mov      dword ptr [esp + 0x20], edx
0047fe85 push     ebx
0047fe86 push     ebp
0047fe87 push     edi
0047fe88 xor      edi, edi
0047fe8a xor      ebp, ebp
0047fe8c mov      dword ptr [esp + 0x10], edi
0047fe90 test     edx, edx
0047fe92 jg       0x47fea4
0047fe94 lea      eax, [ebp + 1]
0047fe97 jmp      0x48011c
0047fe9c lea      esp, [esp]
0047fea0 mov      ecx, dword ptr [esp + 0x38]
0047fea4 mov      eax, 0x1000
0047fea9 test     ecx, ecx
0047feab je       0x47feb4
0047fead dec      edx
0047feae cmp      edi, edx
0047feb0 jne      0x47feb4
0047feb2 mov      eax, ecx
0047feb4 mov      ebx, eax
0047feb6 and      ebx, 0x800001ff
0047febc mov      dword ptr [esp + 0x20], 3
0047fec4 jns      0x47fece
0047fec6 dec      ebx
0047fec7 or       ebx, 0xfffffe00
0047fecd inc      ebx
0047fece cdq      
0047fecf and      edx, 0x1ff
0047fed5 add      eax, edx
0047fed7 sar      eax, 9
0047feda mov      dword ptr [esp + 0x28], ebx
0047fede mov      dword ptr [esp + 0x34], eax
0047fee2 xor      ecx, ecx
0047fee4 mov      dword ptr [esp + 0x14], eax
0047fee8 cmp      ebx, ecx
0047feea je       0x47fef1
0047feec inc      eax
0047feed mov      dword ptr [esp + 0x14], eax
0047fef1 cmp      eax, ecx
0047fef3 mov      dword ptr [esp + 0x1c], ecx
0047fef7 mov      dword ptr [esp + 0x18], ecx
0047fefb jle      0x48002a
0047ff01 jmp      0x47ff07
0047ff03 mov      eax, dword ptr [esp + 0x14]
0047ff07 mov      ecx, dword ptr [esp + 0x28]
0047ff0b mov      ebx, 0x200
0047ff10 test     ecx, ecx
0047ff12 je       0x47ff1d
0047ff14 dec      eax
0047ff15 cmp      dword ptr [esp + 0x18], eax
0047ff19 jne      0x47ff1d
0047ff1b mov      ebx, ecx
0047ff1d test     esi, esi
0047ff1f je       0x47ff2b
0047ff21 push     0xf
0047ff23 call     0x404e70
0047ff28 add      esp, 4
0047ff2b push     0x208
0047ff30 lea      edx, [esp + 0x5c]
0047ff34 push     0
0047ff36 push     edx
0047ff37 call     0x58c050
0047ff3c mov      eax, dword ptr [esp + 0x30]
0047ff40 mov      ecx, dword ptr [eax + 0xc]
0047ff43 cmp      dword ptr [ecx + 0x14], 0x18
0047ff47 mov      al, byte ptr [esp + 0x278]
0047ff4e mov      cl, byte ptr [esp + 0x1c]
0047ff52 setne    dl
0047ff55 dec      dl
0047ff57 and      dl, 0xfd
0047ff5a add      dl, 9
0047ff5d mov      byte ptr [esp + 0x64], dl
0047ff61 mov      dl, byte ptr [esp + 0x20]
0047ff65 mov      byte ptr [esp + 0x66], al
0047ff69 movzx    eax, byte ptr [esp + 0x24]
0047ff6e mov      byte ptr [esp + 0x68], dl
0047ff72 mov      edx, dword ptr [esp + 0x3c]
0047ff76 mov      byte ptr [esp + 0x67], cl
0047ff7a push     ebx
0047ff7b add      edx, ebp
0047ff7d mov      byte ptr [esp + 0x6d], al
0047ff81 mov      ecx, ebx
0047ff83 push     edx
0047ff84 lea      eax, [esp + 0x74]
0047ff88 sar      ecx, 8
0047ff8b push     eax
0047ff8c mov      byte ptr [esp + 0x71], 0xc
0047ff91 mov      byte ptr [esp + 0x76], bl
0047ff95 mov      byte ptr [esp + 0x77], cl
0047ff99 call     0x58f650
0047ff9e add      esp, 0x18
0047ffa1 test     esi, esi
0047ffa3 je       0x47ffdb
0047ffa5 mov      edi, 3
0047ffaa lea      ebx, [ebx]
0047ffb0 push     0x208
0047ffb5 lea      ecx, [esp + 0x5c]
0047ffb9 push     ecx
0047ffba push     esi
0047ffbb call     0x5a685c
0047ffc0 test     al, al
0047ffc2 jne      0x47ffd3
0047ffc4 push     0x64
0047ffc6 dec      edi
0047ffc7 call     0x404e70
0047ffcc add      esp, 4
0047ffcf test     edi, edi
0047ffd1 jg       0x47ffb0
0047ffd3 test     edi, edi
0047ffd5 jl       0x480105
0047ffdb mov      eax, dword ptr [esp + 0x3c]
0047ffdf add      dword ptr [esp + 0x1c], ebx
0047ffe3 add      ebp, ebx
0047ffe5 test     eax, eax
0047ffe7 je       0x47ffff
0047ffe9 mov      edx, dword ptr [esp + 0x274]
0047fff0 mov      ecx, dword ptr [esp + 0x26c]
0047fff7 push     ebp
0047fff8 push     edx
0047fff9 push     ecx
0047fffa call     eax
0047fffc add      esp, 0xc
0047ffff mov      edx, dword ptr [esp + 0x10]
00480003 mov      edi, dword ptr [esp + 0x18]
00480007 push     edx
00480008 push     edi
00480009 push     0x5f9c40
0048000e call     dword ptr [0x632af0]
00480014 inc      edi
00480015 add      esp, 0xc
00480018 cmp      edi, dword ptr [esp + 0x14]
0048001c mov      dword ptr [esp + 0x18], edi
00480020 jl       0x47ff03
00480026 mov      ebx, dword ptr [esp + 0x28]
0048002a test     esi, esi
0048002c je       0x4800e9
00480032 push     0x208
00480037 lea      eax, [esp + 0x5c]
0048003b push     0
0048003d push     eax
0048003e call     0x58c050
00480043 mov      ecx, dword ptr [esp + 0x30]
00480047 mov      edx, dword ptr [ecx + 0xc]
0048004a add      esp, 0xc
0048004d cmp      dword ptr [edx + 0x14], 0x18
00480051 lea      edi, [esp + 0x40]
00480055 setne    al
00480058 dec      al
0048005a and      al, 0xfd
0048005c add      al, 9
0048005e mov      byte ptr [esp + 0x58], al
00480062 xor      eax, eax
00480064 mov      byte ptr [esp + 0x40], 0
00480069 mov      dword ptr [esp + 0x41], eax
0048006d mov      dword ptr [esp + 0x45], eax
00480071 mov      dword ptr [esp + 0x49], eax
00480075 mov      dword ptr [esp + 0x4d], eax
00480079 mov      dword ptr [esp + 0x51], eax
0048007d mov      word ptr [esp + 0x55], ax
00480082 mov      byte ptr [esp + 0x57], al
00480086 call     0x47fcc0
0048008b test     eax, eax
0048008d jge      0x4800b0
0048008f cmp      eax, -1
00480092 jne      0x48011a
00480098 cmp      dword ptr [esp + 0x20], 0
0048009d jle      0x48011a
0048009f sub      ebp, dword ptr [esp + 0x1c]
004800a3 dec      dword ptr [esp + 0x20]
004800a7 mov      eax, dword ptr [esp + 0x34]
004800ab jmp      0x47fee2
004800b0 movzx    ecx, byte ptr [esp + 0x5c]
004800b5 movzx    edx, byte ptr [esp + 0x5b]
004800ba movzx    eax, byte ptr [esp + 0x5a]
004800bf push     ecx
004800c0 movzx    ecx, byte ptr [esp + 0x5d]
004800c5 push     edx
004800c6 movzx    edx, byte ptr [esp + 0x60]
004800cb push     eax
004800cc push     ecx
004800cd push     edx
004800ce push     0x5f9cb0
004800d3 call     dword ptr [0x632af0]
004800d9 mov      al, byte ptr [esp + 0x5a]
004800dd movzx    ecx, al
004800e0 add      esp, 0x18
004800e3 cmp      dword ptr [esp + 0x10], ecx
004800e7 jne      0x480137
004800e9 mov      edi, dword ptr [esp + 0x10]
004800ed mov      edx, dword ptr [esp + 0x2c]
004800f1 inc      edi
004800f2 cmp      edi, edx
004800f4 mov      dword ptr [esp + 0x10], edi
004800f8 jl       0x47fea0
004800fe mov      eax, 1
00480103 jmp      0x48011c
00480105 call     dword ptr [0x5bd220]
0048010b push     eax
0048010c push     0x5f9bf8
00480111 call     dword ptr [0x632af0]
00480117 add      esp, 8
0048011a xor      eax, eax
0048011c pop      edi
0048011d pop      ebp
0048011e pop      ebx
0048011f pop      esi
00480120 mov      ecx, dword ptr [esp + 0x250]
00480127 xor      ecx, esp
00480129 call     0x587fe9
0048012e add      esp, 0x254
00480134 ret      0x10
00480137 movzx    edx, byte ptr [esp + 0x5c]
0048013c movzx    ecx, byte ptr [esp + 0x43]
00480141 push     edx
00480142 push     ecx
00480143 movzx    ecx, byte ptr [esp + 0x48]
00480148 movzx    edx, al
0048014b movzx    eax, byte ptr [esp + 0x49]
00480150 push     edx
00480151 mov      edx, dword ptr [esp + 0x1c]
00480155 push     eax
00480156 push     ecx
00480157 push     edx
00480158 push     0x5f9d20
0048015d call     dword ptr [0x632af0]
00480163 add      esp, 0x1c
00480166 jmp      0x48011a
00480168 push     0x5f9bb0
0048016d call     dword ptr [0x632af0]
00480173 mov      ecx, dword ptr [esp + 0x258]
0048017a add      esp, 4
0048017d pop      esi
0048017e xor      ecx, esp
00480180 xor      eax, eax
00480182 call     0x587fe9
00480187 add      esp, 0x254
0048018d ret      0x10
00480190 mov      edx, dword ptr [esp + 4]
00480194 mov      eax, ecx
00480196 mov      ecx, dword ptr [esp + 8]
0048019a push     ecx
0048019b mov      ecx, dword ptr [esp + 0x10]
0048019f push     edx
004801a0 mov      edx, dword ptr [eax + 0x23c]
004801a6 push     ecx
004801a7 mov      ecx, dword ptr [esp + 0x1c]
004801ab push     eax
004801ac call     0x47fe10
004801b1 ret      0x10
004801b4 int3     
004801b5 int3     
004801b6 int3     
004801b7 int3     
004801b8 int3     
004801b9 int3     
004801ba int3     
004801bb int3     
004801bc int3     
004801bd int3     
004801be int3     
004801bf int3     
004833d0 sub      esp, 0x20
004833d3 push     ebp
004833d4 push     esi
004833d5 mov      esi, dword ptr [esp + 0x2c]
004833d9 xor      ebp, ebp
004833db cmp      esi, ebp
004833dd je       0x48352c
004833e3 mov      ecx, dword ptr [esi + 4]
004833e6 lea      eax, [esp + 8]
004833ea push     eax
004833eb push     ecx
004833ec mov      dword ptr [esp + 0x10], ebp
004833f0 call     0x5a668a
004833f5 cmp      eax, ebp
004833f7 je       0x4833fc
004833f9 mov      dword ptr [esi + 8], eax
004833fc cmp      dword ptr [esp + 8], ebp
00483400 jbe      0x48352c
00483406 mov      eax, dword ptr [esi + 4]
00483409 lea      edx, [esp + 8]
0048340d push     edx
0048340e push     eax
0048340f mov      dword ptr [esp + 0x10], ebp
00483413 call     0x5a6684
00483418 cmp      eax, ebp
0048341a je       0x48341f
0048341c mov      dword ptr [esi + 8], eax
0048341f mov      edx, dword ptr [esi + 4]
00483422 lea      ecx, [esp + 0xc]
00483426 push     ecx
00483427 push     edx
00483428 mov      dword ptr [esp + 0x14], ebp
0048342c call     0x5a668a
00483431 cmp      eax, ebp
00483433 je       0x483438
00483435 mov      dword ptr [esi + 8], eax
00483438 push     edi
00483439 mov      edi, dword ptr [esp + 0x10]
0048343d mov      esi, edi
0048343f imul     esi, dword ptr [esp + 0xc]
00483444 add      esi, esi
00483446 push     esi
00483447 mov      dword ptr [esp + 0x18], edi
0048344b mov      dword ptr [esp + 0x2c], esi
0048344f call     0x58883a
00483454 add      esp, 4
00483457 mov      dword ptr [esp + 0x20], eax
0048345b cmp      eax, ebp
0048345d jne      0x483468
0048345f xor      eax, eax
00483461 pop      edi
00483462 pop      esi
00483463 pop      ebp
00483464 add      esp, 0x20
00483467 ret      
00483468 cmp      dword ptr [esp + 0xc], ebp
0048346c push     ebx
0048346d mov      ebx, 0xff000000
00483472 jle      0x483516
00483478 lea      ecx, [edi + edi]
0048347b mov      dword ptr [esp + 0x28], ecx
0048347f mov      edi, eax
00483481 mov      dword ptr [esp + 0x1c], eax
00483485 xor      esi, esi
00483487 cmp      dword ptr [esp + 0x18], esi
0048348b jle      0x4834f9
0048348d lea      ecx, [ecx]
00483490 mov      eax, dword ptr [esp + 0x34]
00483494 mov      ecx, dword ptr [eax + 4]
00483497 lea      edx, [esp + 0x20]
0048349b push     edx
0048349c push     ebp
0048349d push     esi
0048349e push     ecx
0048349f call     0x5a66fc
004834a4 test     eax, eax
004834a6 je       0x4834b1
004834a8 mov      edx, dword ptr [esp + 0x34]
004834ac mov      dword ptr [edx + 8], eax
004834af jmp      0x4834b5
004834b1 mov      ebx, dword ptr [esp + 0x20]
004834b5 mov      eax, ebx
004834b7 shr      eax, 0x10
004834ba shr      al, 3
004834bd mov      edx, ebx
004834bf shr      edx, 8
004834c2 shr      dl, 2
004834c5 movzx    cx, al
004834c9 movzx    ax, dl
004834cd shl      cx, 6
004834d1 or       cx, ax
004834d4 mov      dl, bl
004834d6 shr      dl, 3
004834d9 shl      cx, 5
004834dd movzx    ax, dl
004834e1 or       cx, ax
004834e4 rol      cx, 8
004834e8 mov      word ptr [edi], cx
004834eb inc      esi
004834ec add      edi, 2
004834ef cmp      esi, dword ptr [esp + 0x18]
004834f3 jl       0x483490
004834f5 mov      eax, dword ptr [esp + 0x24]
004834f9 mov      edi, dword ptr [esp + 0x1c]
004834fd add      edi, dword ptr [esp + 0x28]
00483501 inc      ebp
00483502 cmp      ebp, dword ptr [esp + 0x10]
00483506 mov      dword ptr [esp + 0x1c], edi
0048350a jl       0x483485
00483510 mov      esi, dword ptr [esp + 0x2c]
00483514 xor      ebp, ebp
00483516 mov      ecx, dword ptr [esp + 0x38]
0048351a pop      ebx
0048351b cmp      ecx, ebp
0048351d je       0x483461
00483523 pop      edi
00483524 mov      dword ptr [ecx], esi
00483526 pop      esi
00483527 pop      ebp
00483528 add      esp, 0x20
0048352b ret      
0048352c pop      esi
0048352d xor      eax, eax
0048352f pop      ebp
00483530 add      esp, 0x20
00483533 ret      
00483534 int3     
00483535 int3     
00483536 int3     
00483537 int3     
00483538 int3     
00483539 int3     
0048353a int3     
0048353b int3     
0048353c int3     
0048353d int3     
0048353e int3     
0048353f int3     
00483540 sub      esp, 0x14
00483543 push     esi
00483544 mov      esi, dword ptr [0x63faa0]
0048354a mov      eax, dword ptr [esi + 0x38c]
00483550 mov      ecx, dword ptr [esi + 0x388]
00483556 mov      dword ptr [esp + 0xc], eax
0048355a mov      eax, dword ptr [esi + 0x390]
00483560 mov      dword ptr [esp + 0x10], eax
00483564 sub      eax, ecx
00483566 mov      dword ptr [esp + 4], eax
0048356a fild     dword ptr [esp + 4]
0048356e mov      edx, dword ptr [esi + 0x394]
00483574 mov      dword ptr [esp + 8], ecx
00483578 mov      dword ptr [esp + 0x14], edx
0048357c fidiv    dword ptr [esi + 0x3a8]
00483582 fstp     dword ptr [esp + 4]
00483586 fild     dword ptr [esp + 0x24]
0048358a fidiv    dword ptr [esp + 0x20]
0048358e fstp     dword ptr [esp + 0x24]
00483592 fld      dword ptr [esp + 0x24]
00483596 fld      dword ptr [esp + 4]
0048359a fld      st(0)
0048359c fmulp    st(2)
0048359e fxch     st(1)
004835a0 fstp     dword ptr [esp + 0x24]
004835a4 fild     dword ptr [esp + 0x1c]
004835a8 fmulp    st(1)
004835aa fadd     dword ptr [esp + 0x24]
004835ae call     0x58ef30
004835b3 mov      ecx, dword ptr [esi + 0x20]
004835b6 mov      dword ptr [esi + 0x3a0], eax
004835bc push     1
004835be lea      eax, [esp + 0xc]
004835c2 push     eax
004835c3 push     ecx
004835c4 call     dword ptr [0x5bd708]
004835ca pop      esi
004835cb add      esp, 0x14
004835ce ret      
004835cf int3     
004835d0 sub      esp, 8
004835d3 push     ebx
004835d4 mov      ebx, dword ptr [esp + 0x10]
004835d8 push     ebp
004835d9 mov      ebp, dword ptr [ebx + 0x398]
004835df test     ebp, ebp
004835e1 je       0x4835f7
004835e3 cmp      dword ptr [ebp + 0x18], 0
004835e7 je       0x4835f7
004835e9 mov      ecx, dword ptr [ebp + 0x18]
004835ec mov      eax, dword ptr [ecx]
004835ee mov      edx, dword ptr [eax + 0x14]
004835f1 call     edx
004835f3 test     eax, eax
004835f5 jne      0x48360e
004835f7 mov      dword ptr [ebx + 0x3a4], 0xffffffff
00483601 cmp      dword ptr [0x62c1e4], 0
00483608 je       0x4836ad
0048360e mov      eax, dword ptr [ebp + 0x18]
00483611 push     edi
00483612 push     0x32
00483614 mov      dword ptr [eax + 0x18], 1
0048361b call     dword ptr [0x5bd238]
00483621 lea      ecx, [ebx + 0x3ac]
00483627 xor      edi, edi
00483629 mov      dword ptr [esp + 0xc], ecx
0048362d push     esi
0048362e mov      edi, edi
00483630 mov      edx, dword ptr [esp + 0x10]
00483634 mov      eax, dword ptr [edx]
00483636 test     eax, eax
00483638 je       0x4836ab
0048363a cmp      dword ptr [ebx + 0x39c], 0
00483641 jne      0x4836ab
00483643 lea      ecx, [esp + 0x14]
00483647 push     ecx
00483648 push     eax
00483649 mov      dword ptr [esp + 0x1c], 0
00483651 call     0x4833d0
00483656 mov      esi, eax
00483658 add      esp, 8
0048365b test     esi, esi
0048365d je       0x483688
0048365f mov      ecx, dword ptr [ebp + 0x18]
00483662 mov      eax, dword ptr [esp + 0x14]
00483666 mov      edx, dword ptr [ecx]
00483668 mov      edx, dword ptr [edx + 0x34]
0048366b push     0x483540
00483670 push     edi
00483671 push     eax
00483672 push     esi
00483673 call     edx
00483675 push     esi
00483676 mov      ebx, eax
00483678 call     0x588904
0048367d add      esp, 4
00483680 test     ebx, ebx
00483682 je       0x483695
00483684 mov      ebx, dword ptr [esp + 0x1c]
00483688 add      dword ptr [esp + 0x10], 4
0048368d inc      edi
0048368e cmp      edi, 0x20
00483691 jl       0x483630
00483693 jmp      0x4836ab
00483695 mov      eax, dword ptr [esp + 0x1c]
00483699 push     eax
0048369a mov      ecx, 0x5fa458
0048369f call     0x43fe30
004836a4 mov      ebx, dword ptr [esp + 0x20]
004836a8 add      esp, 4
004836ab pop      esi
004836ac pop      edi
004836ad mov      ecx, dword ptr [ebp + 0x18]
004836b0 push     0x3e8
004836b5 mov      dword ptr [ecx + 0x18], 0
004836bc call     dword ptr [0x5bd238]
004836c2 mov      edx, dword ptr [ebx + 0x20]
004836c5 push     0
004836c7 push     0
004836c9 push     0x10
004836cb push     edx
004836cc call     dword ptr [0x5bd720]
004836d2 pop      ebp
004836d3 pop      ebx
004836d4 add      esp, 8
004836d7 ret      
004836d8 int3     
004836d9 int3     
004836da int3     
004836db int3     
004836dc int3     
004836dd int3     
004836de int3     
004836df int3     
