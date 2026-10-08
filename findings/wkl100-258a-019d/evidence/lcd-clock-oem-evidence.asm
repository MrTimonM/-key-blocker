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
0047d8c9 cmp      dword ptr [edx + 0x14], 0x18
0047d8cd mov      dl, byte ptr [esp + 0x244]
0047d8d4 setne    al
0047d8d7 dec      al
0047d8d9 and      al, 0xfd
0047d8db add      al, 9
0047d8dd mov      byte ptr [esp + 0x24], al
0047d8e1 mov      al, byte ptr [esp + 0x1c]
0047d8e5 mov      byte ptr [esp + 0x28], al
0047d8e9 mov      eax, dword ptr [esp + 0x18]
0047d8ed mov      byte ptr [esp + 0x25], cl
0047d8f1 mov      ecx, ebx
0047d8f3 mov      byte ptr [esp + 0x29], al
0047d8f7 inc      eax
0047d8f8 sar      ecx, 8
0047d8fb mov      byte ptr [esp + 0x26], dl
0047d8ff mov      byte ptr [esp + 0x27], 0
0047d904 mov      dword ptr [esp + 0x18], eax
0047d908 mov      byte ptr [esp + 0x2a], bl
0047d90c mov      byte ptr [esp + 0x2b], cl
0047d910 cmp      ebp, 1
