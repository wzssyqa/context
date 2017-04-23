
;           Copyright Oliver Kowalke 2009.
;  Distributed under the Boost Software License, Version 1.0.
;     (See accompanying file LICENSE_1_0.txt or copy at
;           http://www.boost.org/LICENSE_1_0.txt)

;  ----------------------------------------------------------------------------------
;  |     0   |     1   |     2    |     3   |     4   |     5   |     6   |     7   |
;  ----------------------------------------------------------------------------------
;  |    0x0  |    0x4  |    0x8   |    0xc  |   0x10  |   0x14  |   0x18  |   0x1c  |
;  ----------------------------------------------------------------------------------
;  |                          SEE registers (XMM6-XMM15)                            |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |     8   |    9    |    10    |    11   |    12   |    13   |    14   |    15   |
;  ----------------------------------------------------------------------------------
;  |   0x20  |  0x24   |   0x28   |   0x2c  |   0x30  |   0x34  |   0x38  |   0x3c  |
;  ----------------------------------------------------------------------------------
;  |                          SEE registers (XMM6-XMM15)                            |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    16   |    17   |    18   |    19    |    20   |    21   |    22   |    23   |
;  ----------------------------------------------------------------------------------
;  |   0xe40  |   0x44 |   0x48  |   0x4c   |   0x50  |   0x54  |   0x58  |   0x5c  |
;  ----------------------------------------------------------------------------------
;  |                          SEE registers (XMM6-XMM15)                            |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    24   |   25    |    26    |   27    |    28   |    29   |    30   |    31   |
;  ----------------------------------------------------------------------------------
;  |   0x60  |   0x64  |   0x68   |   0x6c  |   0x70  |   0x74  |   0x78  |   0x7c  |
;  ----------------------------------------------------------------------------------
;  |                          SEE registers (XMM6-XMM15)                            |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    32   |   32    |    33    |   34    |    35   |    36   |    37   |    38   |
;  ----------------------------------------------------------------------------------
;  |   0x80  |   0x84  |   0x88   |   0x8c  |   0x90  |   0x94  |   0x98  |   0x9c  |
;  ----------------------------------------------------------------------------------
;  |                          SEE registers (XMM6-XMM15)                            |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    39   |   40    |    41    |   42    |    43   |    44   |    45   |    46   |
;  ----------------------------------------------------------------------------------
;  |   0xa0  |   0xa4  |   0xa8   |   0xac  |   0xb0  |   0xb4  |   0xb8  |   0xbc  |
;  ----------------------------------------------------------------------------------
;  | fc_mxcsr|fc_x87_cw|     <alignment>    |       fbr_strg    |      fc_dealloc   |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    47   |   48    |    49    |   50    |    51   |    52   |    53   |    54   |
;  ----------------------------------------------------------------------------------
;  |   0xc0  |   0xc4  |   0xc8   |   0xcc  |   0xd0  |   0xd4  |   0xd8  |   0xdc  |
;  ----------------------------------------------------------------------------------
;  |        limit      |         base       |         R12       |         R13       |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    55   |   56    |    57    |   58    |    59   |    60   |    61   |    62   |
;  ----------------------------------------------------------------------------------
;  |   0xe0  |   0xe4  |   0xe8   |   0xec  |   0xf0  |   0xf4  |   0xf8  |   0xfc  |
;  ----------------------------------------------------------------------------------
;  |        R14        |         R15        |         RDI       |        RSI        |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    63   |   64    |    65    |   66    |    67   |    68   |    69   |    70   |
;  ----------------------------------------------------------------------------------
;  |  0x100  |  0x104  |  0x108   |  0x10c  |  0x110  |  0x114  |  0x118  |  0x11c  |
;  ----------------------------------------------------------------------------------
;  |        RBX        |         RBP        |       hidden      |        RIP        |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    71   |   72    |    73    |   74    |    75   |    76   |    77   |    78   |
;  ----------------------------------------------------------------------------------
;  |  0x120  |  0x124  |  0x128   |  0x12c  |  0x130  |  0x134  |  0x138  |  0x13c  |
;  ----------------------------------------------------------------------------------
;  |                                   parameter area                               |
;  ----------------------------------------------------------------------------------
;  ----------------------------------------------------------------------------------
;  |    79   |   80    |    81    |   82    |    83   |    84   |    85   |    86   |
;  ----------------------------------------------------------------------------------
;  |  0x140  |  0x144  |  0x148   |  0x14c  |  0x150  |  0x154  |  0x158  |  0x15c  |
;  ----------------------------------------------------------------------------------
;  |       FCTX        |        DATA        |                                       |
;  ----------------------------------------------------------------------------------

.code

ontop_fcontext PROC BOOST_CONTEXT_EXPORT FRAME
    .endprolog

    ; prepare stack
    lea rsp, [rsp-0118h]

#if !defined(BOOST_USE_TSX)
    ; save XMM storage
    movaps  [rsp], xmm6
    movaps  [rsp+010h], xmm7
    movaps  [rsp+020h], xmm8
    movaps  [rsp+030h], xmm9
    movaps  [rsp+040h], xmm10
    movaps  [rsp+050h], xmm11
    movaps  [rsp+060h], xmm12
    movaps  [rsp+070h], xmm13
    movaps  [rsp+080h], xmm14
    movaps  [rsp+090h], xmm15
    ; save MMX control- and status-word
    stmxcsr  [rsp+0a0h]
    ; save x87 control-word
    fnstcw  [rsp+0a4h]
#endif

    ; load NT_TIB
    mov  r10,  gs:[030h]
    ; save fiber local storage
    mov  rax, [r10+018h]
    mov  [rsp+0b0h], rax
    ; save current deallocation stack
    mov  rax, [r10+01478h]
    mov  [rsp+0b8h], rax
    ; save current stack limit
    mov  rax, [r10+010h]
    mov  [rsp+0c0h], rax
    ; save current stack base
    mov  rax,  [r10+08h]
    mov  [rsp+0c8h], rax

    mov [rsp+0d0h], r12  ; save R12
    mov [rsp+0d8h], r13  ; save R13
    mov [rsp+0e0h], r14  ; save R14
    mov [rsp+0e8h], r15  ; save R15
    mov [rsp+0f0h], rdi  ; save RDI
    mov [rsp+0f8h], rsi  ; save RSI
    mov [rsp+0100h], rbx  ; save RBX
    mov [rsp+0108h], rbp  ; save RBP

    mov [rsp+0110h], rcx  ; save hidden address of transport_t

    ; preserve RSP (pointing to context-data) in RCX
    mov  rcx, rsp

    ; restore RSP (pointing to context-data) from RDX
    mov  rsp, rdx

#if !defined(BOOST_USE_TSX)
    ; restore XMM storage
    movaps  xmm6, [rsp]
    movaps  xmm7, [rsp+010h]
    movaps  xmm8, [rsp+020h]
    movaps  xmm9, [rsp+030h]
    movaps  xmm10, [rsp+040h]
    movaps  xmm11, [rsp+050h]
    movaps  xmm12, [rsp+060h]
    movaps  xmm13, [rsp+070h]
    movaps  xmm14, [rsp+080h]
    movaps  xmm15, [rsp+090h]
    ; restore MMX control- and status-word
    ldmxcsr  [rsp+0a0h]
    ; save x87 control-word
    fldcw   [rsp+0a4h]
#endif

    ; load NT_TIB
    mov  r10,  gs:[030h]
    ; restore fiber local storage
    mov  rax, [rsp+0b0h]
    mov  [r10+018h], rax
    ; restore current deallocation stack
    mov  rax, [rsp+0b8h]
    mov  [r10+01478h], rax
    ; restore current stack limit
    mov  rax, [rsp+0c0h]
    mov  [r10+010h], rax
    ; restore current stack base
    mov  rax, [rsp+0c8h]
    mov  [r10+08h], rax

    mov r12, [rsp+0d0h]  ; restore R12
    mov r13, [rsp+0d8h]  ; restore R13
    mov r14, [rsp+0e0h]  ; restore R14
    mov r15, [rsp+0e8h]  ; restore R15
    mov rdi, [rsp+0f0h]  ; restore RDI
    mov rsi, [rsp+0f8h]  ; restore RSI
    mov rbx, [rsp+0100h]  ; restore RBX
    mov rbp, [rsp+0108h]  ; restore RBP

    mov rax, [rsp+0110h] ; restore hidden address of transport_t

    ; prepare stack
    lea rsp, [rsp+0118h]

    ; keep return-address on stack

    ; transport_t returned in RAX
    ; return parent fcontext_t
    mov  [rax], rcx
    ; return data
    mov  [rax+08h], r8

    ; transport_t as 1.arg of context-function
    ; RCX contains address of returned (hidden) transfer_t
    mov rcx,  rax  
    ; RDX contains address of passed transfer_t
    mov rdx,  rax

    ; indirect jump to context
    jmp  r9
ontop_fcontext ENDP
END
