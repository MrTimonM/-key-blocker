0040b4b1 push     eax
0040b4b2 call     dword ptr [0x5bd230]
0040b4b8 mov      eax, dword ptr [esi + 0x18]
0040b4bb cmp      eax, ebp
0040b4bd je       0x40b4cc
0040b4bf cmp      dword ptr [eax + 0x230], 1
0040b4c6 je       0x40b6bf
0040b4cc mov      eax, dword ptr [esi + 0x14]
0040b4cf cmp      eax, 0x18
0040b4d2 je       0x40b51e
0040b4d4 cmp      eax, 0x1a
0040b4d7 je       0x40b51e
0040b4d9 cmp      eax, 0x19
0040b4dc jne      0x40b4fd
0040b4de push     0x24c
0040b4e3 call     0x489d92
0040b4e8 add      esp, 4
0040b4eb cmp      eax, ebp
0040b4ed je       0x40b58c
0040b4f3 call     0x4801c0
0040b4f8 jmp      0x40b58e
0040b4fd cmp      eax, 0x16
0040b500 jne      0x40b6bf
0040b506 push     0x25c
0040b50b call     0x489d92
0047a170 xor      eax, eax
0047a172 ret      0x10
0047a175 int3     
0047a176 int3     
0047a177 int3     
0047a178 int3     
0047a179 int3     
0047a17a int3     
0047a17b int3     
0047a17c int3     
0047a17d int3     
0047a17e int3     
0047a17f int3     
0047a180 test     byte ptr [esp + 4], 1
0047a185 push     esi
0047a186 mov      esi, ecx
0047a188 mov      dword ptr [esi], 0x5f8b8c
0047a18e je       0x47a199
004801c0 xor      ecx, ecx
004801c2 xor      edx, edx
004801c4 mov      dword ptr [eax + 0x14], ecx
004801c7 mov      dword ptr [eax + 0x10], ecx
004801ca mov      dword ptr [eax + 0x18], ecx
004801cd mov      dword ptr [eax + 0x230], ecx
004801d3 mov      dword ptr [eax + 8], ecx
004801d6 mov      dword ptr [eax + 0x234], 1
004801e0 mov      dword ptr [eax], 0x5fa03c
004801e6 mov      dword ptr [eax + 4], 0x8805
004801ed mov      dword ptr [eax + 0x248], ecx
004801f3 mov      dword ptr [eax + 0x240], ecx
004801f9 mov      dword ptr [eax + 0x23c], ecx
004801ff mov      dword ptr [eax + 0xc], ecx
00480202 mov      dword ptr [eax + 0x244], 0x15
0048020c mov      word ptr [eax + 0x28], dx
00480210 mov      dword ptr [eax + 0x238], ecx
00480216 ret      
004802a0 sub      esp, 0x10
004802a3 push     ebp
004802a4 mov      ebp, ecx
004802a6 mov      eax, dword ptr [ebp + 0xc]
004802a9 push     edi
004802aa xor      edi, edi
004802ac cmp      eax, edi
004802ae jne      0x4802b8
004802b0 pop      edi
004802b1 xor      eax, eax
004802b3 pop      ebp
004802b4 add      esp, 0x10
004802b7 ret      
004802b8 movzx    ecx, word ptr [eax]
004802bb movzx    edx, word ptr [eax + 2]
004802bf push     ebx
004802c0 push     esi
004802c1 mov      dword ptr [esp + 0x18], ecx
004802c5 mov      dword ptr [esp + 0x14], edx
004802c9 mov      dword ptr [ebp + 0x24], edi
004802cc mov      dword ptr [ebp + 0x20], edi
004802cf mov      dword ptr [ebp + 0x14], edi
004802d2 mov      dword ptr [ebp + 0x10], edi
004802d5 mov      dword ptr [esp + 0x1c], 0xffffffff
004802dd xor      ebx, ebx
004802df mov      dword ptr [esp + 0x10], edi
004802e3 mov      esi, 0x63419c
004802e8 jmp      0x4802f0
004802ea lea      ebx, [ebx]
004802f0 mov      eax, dword ptr [esp + 0x18]
004802f4 cmp      eax, dword ptr [esi - 4]
004802f7 jne      0x48035e
004802f9 mov      ecx, dword ptr [esp + 0x14]
004802fd cmp      ecx, dword ptr [esi]
004802ff jne      0x48035e
00480301 cmp      dword ptr [esi + 4], 1
00480305 je       0x48035e
00480307 cmp      dword ptr [esi - 0xc], 0xff02
0048030e jne      0x48035e
00480310 cmp      dword ptr [esi - 8], 2
00480314 jne      0x48035e
00480316 cmp      dword ptr [esi - 0x10], 0x208
0048031d jne      0x48035e
0048031f cmp      dword ptr [esi - 0x18], 8
00480323 jne      0x48035e
00480325 push     0
00480327 push     0x40000000
0048032c push     3
0048032e push     0
00480330 push     3
00480332 push     0x12019f
00480337 lea      edi, [esi - 0x224]
0048033d push     edi
0048033e call     dword ptr [0x5bd270]
00480344 push     edi
00480345 push     0x5f9654
0048034a mov      ebx, eax
0048034c call     dword ptr [0x632af0]
00480352 add      esp, 8
00480355 cmp      ebx, -1
00480358 jne      0x480372
0048035a xor      ebx, ebx
0048035c xor      edi, edi
0048035e inc      dword ptr [esp + 0x10]
00480362 add      esi, 0x22c
00480368 cmp      esi, 0x63987c
0048036e jl       0x4802f0
00480370 jmp      0x48037c
00480372 mov      edx, dword ptr [esp + 0x10]
00480376 mov      dword ptr [esp + 0x1c], edx
0048037a xor      edi, edi
0048037c mov      eax, dword ptr [esp + 0x14]
00480380 mov      ecx, dword ptr [esp + 0x18]
00480384 mov      edx, dword ptr [ebp + 0xc]
00480387 push     eax
00480388 push     ecx
00480389 push     ebx
0048038a add      edx, 0x24
0048038d push     edx
0048038e push     0x5f9e00
00480393 call     dword ptr [0x632af0]
00480399 add      esp, 0x14
0048039c cmp      ebx, edi
0048039e jne      0x4803aa
004803a0 pop      esi
004803a1 pop      ebx
004803a2 pop      edi
004803a3 xor      eax, eax
004803a5 pop      ebp
004803a6 add      esp, 0x10
004803a9 ret      
004803aa mov      esi, dword ptr [esp + 0x1c]
004803ae imul     esi, esi, 0x22c
004803b4 mov      dword ptr [esi + 0x6341a0], 1
004803be mov      eax, dword ptr [ebp]
004803c1 mov      edx, dword ptr [eax + 0x18]
004803c4 mov      ecx, ebp
004803c6 call     edx
004803c8 push     -1
004803ca lea      eax, [esi + 0x633f78]
004803d0 push     eax
004803d1 mov      dword ptr [ebp + 0x23c], ebx
004803d7 push     0x104
004803dc add      ebp, 0x28
004803df push     ebp
004803e0 call     0x589c9a
004803e5 add      esp, 0x10
004803e8 pop      esi
004803e9 pop      ebx
004803ea pop      edi
004803eb mov      eax, 1
004803f0 pop      ebp
004803f1 add      esp, 0x10
004803f4 ret      
