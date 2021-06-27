;	Brandon Cobb
;	Project 1
;	Computer Architecture & Assembly Language

			; OPEN FILE
ldr r0, =FileName			; get file name
mov r1, #0					; input mode
swi 0x66					; open file
bcs OpenFileFail
mov r3, r0					; store file handle in r3

ldr r0, =openingString		; display "Opening"
swi 0x02
ldr r0, =FileName			; display FileName "integers.dat"
swi 0x02



			; READ INTS FROM FILE
mov r0, r3					; put file handle into r0
swi 0x6c					; read 1st int
mov r9, r0					; store it into r9
add r7,r7,#1				; add 1 to the total int counter (r7)

mov r0, r3
swi 0x6c					; read 2nd int
mov r8, r0					; store it into r8
add r7,r7,#1				; add 1 to the total int counter (r7)
cmp	r8,r9					; is new int(r8) < i(r9)?
bcs false1
add r6,r6,#1				; if r8 > i then increment the # of #'s > i (r6)
false1:
;cmpeq r8,r8					; since int j appears once then increment "j appear counter" (r5)
add r5,r5,#1


loop:
mov r0, r3				
swi 0x6c					; read next int
bcs display					; is carry bit 1? If so jump out of loop to display
add r7,r7,#1				; add 1 to the total int counter (r7)
cmp	r0,r9					; compare new int(r0) to int i
add r6,r6,#1				; if r0 > i then increment the # of #'s > i (r6)
cmpeq r0,r8					; if r0 = int j then increment "j appear counter"(r5)
add r5,r5,#1
bal loop





			; DISPLAY 1ST & 2ND NUM IN FILE
display:
ldr r0, =the1stIntStr		; display string
swi 0x02
mov r0,#1					; put file handle # into r0 (#1 is console file handle)
mov r1, r9					; move 1st num into r0 and print it
swi 0x6b

ldr r0, =the2ndIntStr
swi 0x02
mov r0,#1					; put file handle # into r0 (#1 is console file handle)
mov r1, r8					; move 2nd num into r0 and print it
swi 0x6b



			; DISPLAY TOTAL INTS IN FILE
ldr r0, =totalNumsStr		; display the string
swi 0x02
mov r0,#1					; put file handle # into r0 (#1 is console file handle)
mov r1, r7					; put the total # of ints(r7) into r1, then print
swi 0x6b



			; DISPLAY # OF INTS > i
ldr r0, =numsGreaterThanI	; display string
swi 0x02
mov r0,#1					; put file handle # into r0 (#1 is console file handle)
mov r1,r6					; put # of ints > i(r6) into r1 and print
swi 0x6b



			; DISPLAY # OF TIMES INT j APPEARS
ldr r0, =timesIntJAppears	; display string
swi 0x02
mov r0,#1					; put file handle # into r0 (#1 is console file handle)
mov r1,r6					; put # of ints > i(r6) into r1 and print
swi 0x6b


				
			; CLOSE FILE
mov r0, r3					; move file handle into r0
swi 0x68

swi 0x011



OpenFileFail:				; if the file failed to open...
ldr r0, =OpenFileFailStr
swi 0x02
swi 0x011

FileEmpty:					; if the file is empty...
ldr r0, =FileEmptyStr
swi 0x02
swi 0x011


openingString: .asciz "Opening "
FileName: .asciz "integers.dat"
OpenFileFailStr: .asciz "Cannot open file"
FileEmptyStr: .asciz "The file is empty"
address: .word 0
the1stIntStr: .asciz "\nThe 1st integer (value i) in the file is:"
the2ndIntStr: .asciz "\nThe 2nd integer (value j)in the file is:"
totalNumsStr: .asciz "\nThe total amount of integers in the file is:"
numsGreaterThanI: .asciz "\nThe total number of integers greater than the value 'i' is:"
timesIntJAppears: .asciz "\nThe total number of times integer j appears in the file :"