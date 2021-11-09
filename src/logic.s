.data

    underscore: .ascii "_"
    dashes:     .ascii "-"
    spaces:     .byte 0x20

    wrongguess: .asciz "You have guessed wrong %d times."
    wronglttrs: .asciz "The incorrect letters are as follows: "
    PUformat:   .asciz "%c "
    charsform:  .asciz "%c,"
    charform:   .asciz "%c"

    scorebtxt:  .asciz "LEADERBOARD"  
    userscore:  .asciz ": %hhd"  
    initials:   .asciz "%c"

    initialstest:   .asciz "ABC0DEF0GHI0VVV0SSS0"
    scorestest:     .byte 0x01
                    .byte 0x02
                    .byte 0x03
                    .byte 0x04
                    .byte 0x05


.text

    .global createuser

    createuser:     #the location of the first character of the 
                    #word string has to be stored in rdi
                    #and the location of the first character of the 
                    #user string has to be stored in rsi

            #prologue
            pushq   %rbp
            movq    %rsp, %rbp

            movq    underscore, %r10 
            movq    $0, %rdx            #the counter is set to 0

        loopCU:

            movq    %rdi, %r8           #rdi is stored in r8 so we don't overwrite rdi
            addq    %rdx, %r8           #the offset is added to r8
            movq    (%r8), %r8          #the addres of r8 is replaced with its own content
            cmpb    $0, %r8b            #the character in r8 is compared to 0 to check if it is the end of the word
            je      terminateCU

            movq    %rsi, %r9           #rsi is stored in r9 so we don't overwrite rsi
            addq    %rdx, %r9           #the offset is added to r9          
            movb    %r10b, (%r9)        #the character '_' is added to the address in r9

            incq    %rdx                #the offset is incremented by one to check the next character
            jmp     loopCU   


        terminateCU:

            #we add a 0 byte at the end of the string
            movb    %r10b, (%r9)        
            incq    %r9
            movb    $0, (%r9)

            #epilogue
            movq    %rbp, %rsp
            popq    %rbp

            movq    $0, %rdi    
            ret                         #returns to main

    #############################################################################################################################################
    #############################################################################################################################################

    .global createwhitespaces

    createwhitespaces:  #the location of the first character of the 
                        #word string has to be stored in rdi
                        #and the location of the first character of the 
                        #user string has to be stored in rsi

            #prologue
            pushq   %rbp
            movq    %rsp, %rbp

            movq    $0, %rdx            #the counter is set to 0

        loopCW:

            movq    %rdi, %r8           #rdi is stored in r8 so we don't overwrite rdi
            addq    %rdx, %r8           #the offset is added to r8
            movq    (%r8), %r8          #the addres of r8 is replaced with its own content
            cmpb    $0, %r8b            #the character in r8 is compared to 0 to check if it is the end of the word
            je      terminateCW

            movq    dashes, %r10
            cmpb    %r10b, %r8b         #compare the character in r8 to '-' if it is equal we jump to replace
            je      replaceCW

            movq    spaces, %r10            
            cmpb    %r10b, %r8b         #compare the character in r8 to '-' if it is equal we jump to replace
            je      replaceCW

            incq    %rdx                #the offset is incremented by one to check the next character
            jmp     loopCW 

        replaceCW:

            movq    %rdi, %r8           #rdi is stored in r8 so we don't overwrite rdi
            addq    %rdx, %r8           #the offset is added to r8

            movq    %rsi, %r9           #rsi is stored in r9 so we don't overwrite rsi
            addq    %rdx, %r9           #the offset is added to r9
            
            movq    spaces, %r10
            movb    %r10b, (%r8)        #the '-' character in the string word is replaced by a (white)space
            movb    %r10b, (%r9)        #the '-' character in the string user is replaced by a (white)space

            incq    %rdx                #the offset is incremented by one to check the next character
            jmp     loopCW

        terminateCW:

            #epilogue
            movq    %rbp, %rsp
            popq    %rbp

            movq    $0, %rdi    
            ret                         #returns to main

    #############################################################################################################################################
    #############################################################################################################################################

    .global emptyfails

    emptyfails:     #the location of the first character of the 
                    #fails string has to be stored in rdi

            #prologue
            pushq   %rbp
            movq    %rsp, %rbp

            movq    $0, %r10            #a null byte is loaded into r10
            movq    $0, %rdx            #the counter is set to 0

        loopEF:

            movq    %rdi, %r8           #rdi is stored in r8 so we don't overwrite rdi
            addq    %rdx, %r8           #the offset is added to r8
            movb    %r10b, (%r8)        #the addres of r8 is replaced with its own content

            cmpq    $8, %rdx            #the character in r8 is compared to 0 to check if it is the end of the word
            je      terminateEF

            incq    %rdx                #the offset is incremented by one to check the next character
            jmp     loopEF   

        terminateEF:

            #epilogue
            movq    %rbp, %rsp
            popq    %rbp

            movq    $0, %rdi    
            ret                         #returns to main


    #############################################################################################################################################
    #############################################################################################################################################

    .global contains

    contains:   #the location of the first character of word has to be stored in rdi,
                #the guessed character in rsi
                #and the offset in rdx
            
            #prologue
            pushq   %rbp
            movq    %rsp, %rbp

            movq    $(-1), %rax         #if the character isn't found the function will return -1

        loopC:

            movq    %rdi, %r8           #rdi is stored in r8 so we don't overwrite rdi
            addq    %rdx, %r8           #the offset is added to r8
            movq    (%r8), %r8          #the addres of r8 is replaced with its own content
            cmpb    $0, %r8b            #the character in r8 is compared to 0 to check if it is the end of the word
            je      terminateC
            cmpb    %sil, %r8b          #the character in r8 is compared to the character in rsi to check if it matches the user input
            je      foundC
            incq    %rdx                #the offset is incremented by one to check the next character
            jmp     loopC   


        foundC: 

            movq    %rdx, %rax          #the offset is added so rax will point to the right character in the string

        terminateC:

            #epilogue
            movq    %rbp, %rsp
            popq    %rbp

            movq    $0, %rdi    
            ret                         #returns to main with returnvalue in rax

    #############################################################################################################################################
    #############################################################################################################################################

    .global windowreset

    windowreset:

        #prologue
        pushq   %rbp
        movq    %rsp, %rbp

        #the user window gets emptied
        movq %r14, %rdi
        call werase

        #the borders for the user window get redrawn
        movq %r14, %rdi
        movq $0, %rsi
        movq $0, %rdx
        movq $0, %rcx
        movq $0, %r8
        movq $0, %r9
        pushq $0
        pushq $0
        pushq $0
        call wborder

        movq %r14, %rdi
        call wrefresh  

        #the bin window gets emptied
        movq %r15, %rdi
        call werase

        #the borders for the bin window get redrawn
        movq %r15, %rdi
        movq $0, %rsi
        movq $0, %rdx
        movq $0, %rcx
        movq $0, %r8
        movq $0, %r9
        pushq $0
        pushq $0
        pushq $0
        call wborder
 
        movq %r15, %rdi
        call wrefresh

        movq stdscr, %rdi
        call wrefresh

        #epilogue
        movq    %rbp, %rsp
        popq    %rbp

        movq    $0, %rdi    
        ret                             #returns to main

    #############################################################################################################################################
    #############################################################################################################################################

    .global printuser

    printuser:      #the location of the first character of the 
                    #user string has to be stored in rdi
                    #the location of the top window has to be stored in rsi

            #prologue
            pushq   %rbp
            movq    %rsp, %rbp

            movq    $0, %rdx            #the counter is set to 0

        loopPU:

            movq    %rdi, %r8           #rdi is stored in r8 so we don't overwrite rdi
            addq    %rdx, %r8           #the offset is added to r8
            movq    (%r8), %r8          #the addres of r8 is replaced with its own content
            cmpb    $0, %r8b            #the character in r8 is compared to 0 to check if it is the end of the word
            je      terminatePU

            #save the needed registers on the stack
            pushq   %rdi
            pushq   %rsi
            pushq   %rdx

            #print the character from location rdx in user
            movq    %rsi, %rdi          #the window
            movq    $2, %rsi            #row number
            movq    $2, %rax            #the calculation for the column number
            mulq    %rdx
            movq    $2, %rdx
            addq    %rax, %rdx
            movq    $PUformat, %rcx     #the formatstring for the print, the char for %c will be stored in r8
            movq    $0, %rax
            call    mvwprintw

            #retreive the needed registers from the stack
            popq    %rdx
            popq    %rsi
            popq    %rdi

            incq    %rdx                #the offset is incremented by one to check the next character
            jmp     loopPU   


        terminatePU:

            movq    %rsi, %rdi          #refresh window
            call    wrefresh            
            movq    stdscr, %rdi        #refresh screen to show changes
            call    wrefresh

            #epilogue
            movq    %rbp, %rsp
            popq    %rbp

            movq    $0, %rdi    
            ret                         #returns to main

    #############################################################################################################################################
    #############################################################################################################################################

    .global printwrongguesses

    printwrongguesses:

        #prologue
        pushq   %rbp
        movq    %rsp, %rbp

        movq    %rdi, %rbx

        #print "You have guessed wrong %d times."
        movq    %r15, %rdi              #bin window
        movq    $4, %rsi                #row number for mvprintw
        movq    $1, %rdx                #col number for mvprintw
        movq    $wrongguess, %rcx
        movq    %r12, %r8
        movq    $0, %rax
        call    mvwprintw

        #when there are no wrong guesses yet, the next part gets skipped
        cmpq    $0, %r12                
        je      nowrongguesses

        #print "The incorrect letters are as follows: "
        movq    %r15, %rdi              #bin window
        movq    $5, %rsi                #row number for mvprintw
        movq    $1, %rdx                #col number for mvprintw
        movq    $wronglttrs, %rcx
        movq    $0, %rax
        call    mvwprintw

        pushq   %r12                    #save number of fails on the stack
        decq    %r12                    #decrement number of fails so we stop one before reaching the end
        pushq   %rbx                    #put the location of the fails string on the stack
        movq    $0, %rbx                #create a counter in rbx

        wrongguessessloop:

            #check if the counter is equal to one less then the number of fails
            cmpq    %rbx, %r12
            je      finalchar

            #print fails in the form "%c, %c, %c..."
            movq    %r15, %rdi          #bin window
            movq    $6, %rsi            #row number for mvprintw
            movq    $2, %rax            #the calculation for the column number
            mulq    %rbx
            movq    $1, %rdx
            addq    %rax, %rdx
            movq    $charsform, %rcx           
            movq    (%rsp), %r8         #gets the location of the fails string from the stack
            addq    %rbx, %r8           #adds the offset to this location
            movq    (%r8), %r8          #loads the content at r8 into r8
            movq    $0, %rax
            call    mvwprintw

            incq    %rbx                #increment the counter
            jmp     wrongguessessloop

        finalchar:

        #print the final char in fails in the form "%c"
        movq    %r15, %rdi              #bin window
        movq    $6, %rsi                #row number for mvprintw
        movq    $2, %rax                #the calculation for the column number
        mulq    %r12
        movq    $1, %rdx
        addq    %rax, %rdx
        movq    $charform, %rcx
        movq    (%rsp), %r8             #gets the location of the fails string from the stack
        addq    %r12, %r8               #adds the offset to this location
        movq    (%r8), %r8              #loads the content at r8 into r8
        movq    $0, %rax
        call    mvwprintw

        #keep the stack aligned
        popq    %rdi
        popq    %r12

        nowrongguesses:

        movq    %r15, %rdi              #refresh window
        call    wrefresh           
        movq    stdscr, %rdi            #refresh screen to show changes
        call    wrefresh            

        #epilogue
        movq    %rbp, %rsp
        popq    %rbp

        movq    $0, %rdi    
        ret                             #returns to main

    #############################################################################################################################################
    #############################################################################################################################################

    .global printSB

    printSB:    

        #prologue
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %rbx
        pushq   %r12
        pushq   %r13
        pushq   %r14

        #read the scoreboardfile
        call    readscores               #read the scoreboardfile
        movq    (%rax), %r12             #stores the location of the initials in r12
        movq    8(%rax), %r13            #stores the location of the scores in r13

        #print "LEADERBOARD"
        movq    stdscr, %rdi 
        movq    $2, %rsi                    #row number for mvprintw
        movq    $20, %rdx                   #col number for mvprintw
        movq    $scorebtxt, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    $0, %rbx                    #create a counter for the number of scores in rbx

        loopPSB:

            pushq   %r12            
            
            movq    $4, %rax
            mulq    %rbx
            addq    %rax, %r12

            movq    $0, %r14                #create a counter for the number of initials in r14

            loopPSBinitials:

                pushq   %r12 

                #print "%c%c%c"
                movq    stdscr, %rdi 
                movq    %rbx, %rsi          #row number for mvprintw
                addq    $4, %rsi
                movq    $22, %rdx           #col number for mvprintw
                addq    %r14, %rdx
                movq    $initials, %rcx
                addq    %r14, %r12
                movq    (%r12), %r8
                movq    $0, %rax
                call    mvwprintw

                popq    %r12

                #check if all the initials have been printed
                cmpq    $3, %r14
                je      continueloopPSB

                incq    %r14                #increment the counter
                jmp     loopPSBinitials

            continueloopPSB:

            pushq   %r13

            #print ": %hhd"
            movq    stdscr, %rdi 
            movq    %rbx, %rsi              #row number for mvprintw
            addq    $4, %rsi
            movq    $25, %rdx               #col number for mvprintw
            movq    $userscore, %rcx
            addq    %rbx, %r13
            movb    (%r13), %r8b
            movq    $0, %rax
            call    mvwprintw

            popq    %r13
            popq    %r12

            #check if all the scores have been printed
            cmpq    $4, %rbx
            je      terminatePSB

            incq    %rbx                #increment the counter
            jmp     loopPSB

        terminatePSB:

        #refresh screen to show changes
        movq    stdscr, %rdi
        call    wrefresh

        #epilogue
        popq    %r14
        popq    %r13
        popq    %r12
        popq    %rbx
        movq    %rbp, %rsp
        popq    %rbp

        movq    $0, %rdi    
        ret   
