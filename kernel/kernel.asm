[BITS 16]
[ORG 0X7E00]

start:
  mov [bootDrive], dl
  call jumpLine
  mov bp, msg
  mov cx, msgLen
  call printMessage

checkCPU:
  mov eax, 0x80000000
  cpuid
  cmp eax, 0x80000001
  jb notSupported

  mov eax, 0x80000001
  cpuid
  test edx, (1<<29)
  jz notSupported
  
  test edx, (1<<26)
  jz notSupported 

main:
  hlt
  jmp $

notSupported:
  mov bp, notSupportedMessage
  mov cx, notSupportedMessageLen
  call printMessage
  jmp main 

%include "libs/bios/printMessage.asm"

bootDrive db 0
msg db 'Kernel loaded'
msgLen equ $-msg
notSupportedMessage db 'Long mode not supported'
notSupportedMessageLen equ $-notSupportedMessage
