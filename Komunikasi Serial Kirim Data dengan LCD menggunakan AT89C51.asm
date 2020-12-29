;Komunikasi Serial Kirim Data dengan LCD menggunakan AT89C51
start:

;=======INISIALISASI HURUF========
R equ 01010010b
E equ 01000101b
Z equ 01011010b
I equ 01001001b

;=======INISIALISASI LCD============
mov R0,#00111000b ;function set
acall instlcd
mov R0,#00000110b ;entry mode
acall instlcd
mov R0,#00001100b ;no cursor, blink off
acall instlcd
mov R0,#00000001b ;clear display
acall instlcd

;======INISIALISASI KOMUNIKASI SERIAL======
baud EQU 0E8h ; 1200 bps
MOV SCON,#01010000b
MOV TMOD,#00100000b
MOV TCON,#01000000b
MOV TH1 ,#baud

;=======TAMPILAN HURUF "REZI"============
mov R0,#80h
acall instlcd
mov R0,#R
acall datalcd
mov R0,#81h
acall instlcd
mov R0,#E
acall datalcd
mov R0,#82h
acall instlcd
mov R0,#Z
acall datalcd
mov R0,#83h
acall instlcd
mov R0,#I
acall datalcd

;====TAMPILKAN ANGKA "3 DIGIT" SECARA MANUAL===
mov R2,#00
loop2:
mov a,R2
;====Kirim data ke serial port====
;JNB TI,$ ;Tunggu data sebelumnya selesai
MOV SBUF,a ;Kirim data baru
;CLR TI ;Sinyal ada pengiriman baru

;====Serial End=====
mov b,#100
div ab
mov R0,#086h
acall instlcd
add a,#30h
mov R0,a
acall datalcd

mov a,b
mov b,#10
div ab
mov R0,#087h
acall instlcd
add a,#30h
mov R0,a
acall datalcd

mov a,b
mov R0,#088h
acall instlcd
add a,#30h
mov R0,a
acall datalcd
acall delay
inc R2
sjmp loop2

;=======PROSEDUR IRLCD===============
instlcd:setb p3.3
clr p3.2 ; RS=0 E=1
acall delaylcd

mov P1,R0 ;send instruksi
acall delaylcd

clr p3.3 ; RS=0 E=0
acall delaylcd

setb p3.2 ; RS=0 E=1
acall delaylcd
ret

;=======PROCEDURE DTLCD===============
datalcd:setb p3.2
setb p3.3 ; RS=1 E=1
acall delaylcd

mov P1,R0 ; send data
acall delaylcd

clr p3.3 ; RS=1 E=0
call delaylcd

setb p3.3 ; RS=1 E=1
call delaylcd
ret

;=======PROSEDUR DELAYLCD===============
delaylcd:mov R1,#00
loop: inc R1
cjne R1,#99h,loop
ret

delay: mov r7,#00h
ulang2: mov r6,#00h
ulang1: mov r5,#00h
ulang: inc r5
cjne r5,#40h,ulang
inc r6
cjne r6,#40h,ulang1
inc r7
cjne r7,#40h,ulang2
ret

end