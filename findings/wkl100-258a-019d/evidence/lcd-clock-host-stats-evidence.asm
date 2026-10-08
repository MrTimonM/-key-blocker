0045bf00 call     dword ptr [0x5bd7c4]
0045bf06 test     eax, eax
0045bf08 je       0x45c044
0045bf0e mov      eax, dword ptr [esi + 0x31c0]
0045bf14 push     eax
0045bf15 call     dword ptr [0x5bd238]
0045bf1b cmp      dword ptr [esp + 0x28], 0
0045bf20 je       0x45bf31
0045bf22 lea      esi, [esp + 0x28]
0045bf26 call     0x466680
0045bf2b mov      esi, dword ptr [esp + 0x24]
0045bf2f jmp      0x45bf3a
0045bf31 lea      eax, [esp + 0x28]
0045bf35 call     0x466790
0045bf3a lea      ecx, [esp + 0x10]
0045bf3e push     ecx
0045bf3f mov      ebx, eax
0045bf41 mov      dword ptr [esp + 0x14], 0
0045bf49 call     0x466850
0045bf4e add      esp, 4
0045bf51 lea      edx, [esp + 0x70]
0045bf55 push     edx
0045bf56 mov      dword ptr [esp + 0x74], 0x40
0045bf5e call     dword ptr [0x5bd2f8]
0045bf64 lea      eax, [esp + 0x14]
0045bf68 push     eax
0045bf69 call     dword ptr [0x5bd268]
0045bf6f mov      eax, dword ptr [esp + 0x14]
0045bf73 movzx    ecx, byte ptr [esp + 0x10]
0045bf78 movzx    edx, byte ptr [esp + 0x74]
0045bf7d mov      byte ptr [esp + 0xb7], al
0045bf84 shr      eax, 8
0045bf87 mov      byte ptr [esp + 0xb8], al
0045bf8e movzx    eax, byte ptr [esp + 0x16]
0045bf93 mov      byte ptr [esp + 0xb9], al
0045bf9a movzx    eax, byte ptr [esp + 0x1e]
0045bf9f mov      byte ptr [esp + 0xb4], cl
0045bfa6 movzx    ecx, byte ptr [esp + 0x1a]
0045bfab mov      byte ptr [esp + 0xb6], dl
0045bfb2 movzx    edx, byte ptr [esp + 0x1c]
0045bfb7 mov      byte ptr [esp + 0xbc], al
0045bfbe mov      eax, dword ptr [edi + 0xc0]
0045bfc4 mov      eax, dword ptr [eax + 0x18]
0045bfc7 mov      byte ptr [esp + 0xba], cl
0045bfce movzx    ecx, byte ptr [esp + 0x20]
0045bfd3 mov      byte ptr [esp + 0xbb], dl
0045bfda movzx    edx, byte ptr [esp + 0x18]
0045bfdf mov      byte ptr [esp + 0xb5], bl
0045bfe6 mov      byte ptr [esp + 0xbd], cl
0045bfed mov      byte ptr [esp + 0xbe], dl
0045bff4 test     eax, eax
0045bff6 je       0x45c02e
0045bff8 cmp      dword ptr [eax + 0x18], 0
0045bffc jne      0x45c02e
0045bffe mov      ecx, dword ptr [eax + 0x23c]
0045c004 push     0x14
0045c006 push     0xb
0045c008 push     0
0045c00a push     0xb
0045c00c push     1
0045c00e push     ecx
0045c00f push     eax
0045c010 lea      ecx, [esp + 0xd0]
0045c017 call     0x47d7d0
0045c01c test     eax, eax
0045c01e jne      0x45c02e
0045c020 push     0x5f9830
0045c025 call     dword ptr [0x632af0]
0045c02b add      esp, 4
0045c02e mov      ecx, edi
0045c030 call     0x402d50
0045c035 push     eax
0045c036 call     dword ptr [0x5bd7c4]
0045c03c test     eax, eax
0045c03e jne      0x45bf0e
0045c044 call     dword ptr [0x5bdab0]
0045c04a mov      ecx, dword ptr [esp + 0xdc]
0045c051 pop      edi
0045c052 pop      esi
0045c053 pop      ebx
0045c054 xor      ecx, esp
0045c056 xor      eax, eax
0045c058 call     0x587fe9
0045c05d mov      esp, ebp
0045c05f pop      ebp
0045c060 ret      4
00466790 sub      esp, 0x48
00466793 push     ebx
00466794 push     esi
00466795 push     edi
00466796 mov      esi, eax
00466798 lea      eax, [esp + 0xc]
0046679c push     eax
0046679d xor      ebx, ebx
0046679f push     ebx
004667a0 push     ebx
004667a1 call     0x5a6868
004667a6 call     0x458b10
004667ab cmp      eax, 7
004667ae mov      eax, 0x5f6460
004667b3 jge      0x4667ba
004667b5 mov      eax, 0x5f64c8
004667ba mov      edx, dword ptr [esp + 0xc]
004667be lea      ecx, [esp + 0x10]
004667c2 push     ecx
004667c3 push     ebx
004667c4 push     eax
004667c5 push     edx
004667c6 call     0x5a686e
004667cb mov      eax, dword ptr [esp + 0xc]
004667cf push     eax
004667d0 call     0x5a6874
004667d5 mov      eax, dword ptr [esp + 0x10]
004667d9 lea      ecx, [esp + 0x28]
004667dd push     ecx
004667de lea      edx, [esp + 0x18]
004667e2 push     edx
004667e3 push     eax
004667e4 call     0x5a687a
004667e9 cmp      dword ptr [esi + 0x1c], ebx
004667ec je       0x4667f3
004667ee mov      dword ptr [esi + 0x1c], ebx
004667f1 jmp      0x466825
004667f3 lea      ecx, [esp + 0x18]
004667f7 push     ecx
004667f8 mov      ecx, dword ptr [esp + 0x14]
004667fc lea      edx, [esi + 0x20]
004667ff push     edx
00466800 lea      eax, [esp + 0x30]
00466804 push     eax
00466805 push     0x200
0046680a push     ecx
0046680b call     0x5a6880
00466810 fld      qword ptr [esp + 0x20]
00466814 call     0x58ef30
00466819 mov      ebx, eax
0046681b cmp      ebx, 0x64
0046681e jle      0x466825
00466820 mov      ebx, 0x64
00466825 mov      edx, dword ptr [esp + 0xc]
00466829 lea      edi, [esi + 0x20]
0046682c mov      ecx, 0xa
00466831 lea      esi, [esp + 0x28]
00466835 push     edx
00466836 rep movsd dword ptr es:[edi], dword ptr [esi]
00466838 call     0x5a6886
0046683d pop      edi
0046683e pop      esi
0046683f mov      eax, ebx
00466841 pop      ebx
00466842 add      esp, 0x48
00466845 ret
00466850 sub      esp, 0x10
00466853 push     esi
00466854 lea      eax, [esp + 4]
00466858 push     eax
00466859 push     0x62552c
0046685e xor      esi, esi
00466860 push     0x17
00466862 push     esi
00466863 push     0x62551c
00466868 mov      dword ptr [esp + 0x18], esi
0046686c mov      dword ptr [esp + 0x20], esi
00466870 mov      dword ptr [esp + 0x24], esi
00466874 call     dword ptr [0x5bdab4]
0046687a cmp      eax, esi
0046687c jge      0x466894
0046687e push     eax
0046687f push     0x5f6528
00466884 call     dword ptr [0x632af0]
0046688a add      esp, 8
0046688d xor      eax, eax
0046688f pop      esi
00466890 add      esp, 0x10
00466893 ret
00466894 mov      eax, dword ptr [esp + 4]
00466898 mov      ecx, dword ptr [eax]
0046689a lea      edx, [esp + 0xc]
0046689e push     edx
0046689f push     esi
004668a0 push     esi
004668a1 push     eax
004668a2 mov      eax, dword ptr [ecx + 0x10]
004668a5 call     eax
004668a7 cmp      eax, esi
004668a9 mov      ecx, dword ptr [esp + 0xc]
004668ad jl       0x466909
004668af cmp      ecx, esi
004668b1 je       0x466909
004668b3 mov      edx, dword ptr [ecx]
004668b5 lea      eax, [esp + 0x10]
004668b9 push     eax
004668ba push     esi
004668bb push     0x17
004668bd push     0x5f661c
004668c2 push     ecx
004668c3 mov      ecx, dword ptr [edx + 0xc]
004668c6 call     ecx
004668c8 cmp      eax, esi
004668ca mov      ecx, dword ptr [esp + 0x10]
004668ce jl       0x466900
004668d0 cmp      ecx, esi
004668d2 je       0x466900
004668d4 mov      edx, dword ptr [ecx]
004668d6 lea      eax, [esp + 8]
004668da push     eax
004668db push     ecx
004668dc mov      ecx, dword ptr [edx + 0x24]
004668df call     ecx
004668e1 fld      dword ptr [esp + 8]
004668e5 fmul     qword ptr [0x5fb380]
004668eb fstp     dword ptr [esp + 8]
004668ef fld      dword ptr [esp + 8]
004668f3 call     0x58ef30
004668f8 mov      edx, dword ptr [esp + 0x18]
004668fc mov      dword ptr [edx], eax
004668fe jmp      0x466919
00466900 push     ecx
00466901 push     eax
00466902 push     0x5f65b8
00466907 jmp      0x466910
00466909 push     ecx
0046690a push     eax
0046690b push     0x5f6560
00466910 call     dword ptr [0x632af0]
00466916 add      esp, 0xc
00466919 mov      eax, dword ptr [esp + 4]
0046691d cmp      eax, esi
0046691f je       0x46692d
00466921 mov      ecx, dword ptr [eax]
00466923 mov      edx, dword ptr [ecx + 8]
00466926 push     eax
00466927 call     edx
00466929 mov      dword ptr [esp + 4], esi
0046692d mov      eax, dword ptr [esp + 0xc]
