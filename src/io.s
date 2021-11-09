.data

    readperm:           .asciz  "r"
    writeperm:          .asciz  "a"
    overwriteperm:      .asciz "w"
    readstring:         .asciz  "%s"
    scoreboard:         .asciz "scoreboard.txt"
    scoreboard_perm:    .asciz "rw"
    scoreboard_format:  .asciz "%s %d\n"
    scoreboard_readformat: .asciz "%s%hhd"
    scoreboard_empty:   .asciz "--- 0\n--- 0\n--- 0\n--- 0\n--- 0\n"
    emptyuser:          .long 0x2d2d2d00 #store "---\0"

.text

    .global getrandword

    getrandword:
    
        #prologue
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx #callee-saved register
        pushq %r12 #callee-saved register
        pushq %rdi #-24(%rbp), address of the filename, already in RDI, used for fopen

        #Open file
        #fopen(filename, mode)
        movq -24(%rbp), %rdi    #filename
        movq $readperm, %rsi    #mode (read)
        call fopen
        pushq %rax              #file descriptor, -32(%rbp)

        #count the number of characters in the file
        movq %rax, %rdi
        call findfileend
        incq %rax
        pushq %rax #number of bytes in the file, -40(%rbp)
        
        #allocate space for entire file
        movq %rax, %rdi
        call malloc
        pushq %rax #handle to the array for the word, -48(%RBP)
        movq %rax, %rdx

        #Read the entire file (address of filename is in %rax)
        #fread()
        movq -48(%rbp), %rdi #array in which the text will be stored
        movq $1, %rsi        #size of words to be read (in this case, single ASCII characters, so 1 byte)
        movq -40(%rbp), %rdx #number of bytes to be read
        decq %rdx            #remove the added byte for the null terminator
        movq -32(%rbp), %rcx #file handle
        call fread

        #Close the file
        movq -32(%rbp), %rdi
        call fclose

        #Get number of words
        movq -48(%rbp), %rdi #buffer containing the file info
        call getwordcount
        pushq %rax          #number of lines in the file, -56(%rbp)

        #take the random number modulo number of lines in the file
        movq %rax, %r8    #get the divisor in r8  
        movq $0, %rdx   #clear RDX for upcoming division
        rdrand %rax     #Get a random value for the line number
        pushq %rax
        divq %r8        #divide
        mulq %r8        #multiply
        popq %rdx       #get back the original number
        subq %rax, %rdx #get the modulo into RDX
        pushq %rdx      #push RDX onto the stack, calloc will mess it up
        
        movq $21, %rdi  #number of elements to be allocated
        movq $1, %rsi   #size of elements in bytes
        call calloc
        
        popq %rdx       #get back the index of the word to be guessed
        pushq %rax      #buffer where word is stored, -64(%rbp)
        pushq %rdx      #index of the word, -72(%rbp)
        movq $0, %r12   #store number of lines
        movq -48(%rbp), %rdi    #buffer containing file contents
        movq %rdi, %rcx   #store address of the first character to be used
        #we will use r8 for dereferencing the address and r9 for the conditional addition of 1
        movq $1, %r9      
        movq $0, %rax   #will be used to increment the line counter
        movq (%rdi), %r8
    reachword:
        cmpq %r12, %rdx     #check if we have reached the desired word
        je fetchword
        cmpb $0x0a, %r8b    #check if newline
        cmoveq %r9, %rax
        addq %rax, %r12
        movq $0, %rax
        incq %rdi
        incq %rcx
        movq (%rdi), %r8
        jmp reachword
    fetchword:
        movq -64(%rbp), %rsi    #get the address of the buffer for the desired word
        addq %rdi, %rsi         #get current address so as to generate the address in the buffer for the desired word
        subq %rcx, %rsi         #get the address of the byte to be copied to the buffer into RSI 
                                #(we solve the equation (<address of buffer>+(<address of the wanted character>-<address of the last character to be ignored)))
        movb (%rdi), %r8b
        cmpb $0x0a, %r8b        #check if we have reached the end of the line
        je getrandword_end
        cmpb $0x00, %r8b        #check if we have reached the end of the buffer
        je getrandword_end
        movb %r8b, (%rsi)       #move string
        #incq %rdi
        #movb (%rdi), %r8b
        incq %rdi
        incq %rsi
        jmp fetchword
        
    getrandword_end:

        #return handle to word
        #movq $42, %rax

        #add null terminator
        movb $0, (%rsi)
        #Free the buffer in which the file was stored
        movq -48(%rbp), %rdi
        call free

        movq -64(%rbp), %rax
        #epilogue
        movq -16(%rbp), %r12
        movq -8(%rbp), %rbx #callee-saved register
        movq %rbp, %rsp
        popq %rbp

        ret
############################################


    findfileend:
        #prologue
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        pushq %rdi #-16(%rdi)


        #Seek to end of the file
        #fseek(file, )
        #rdi already contains the file handle
        movq $0, %rsi
        movq $2, %rdx #seek to the end
        call fseek
        movq $0, %rax
        pushq %rax


        movq -16(%rbp), %rdi
        movq $0, %rax
        call ftell
        pushq %rax #position in file, -32(%rbp)

        movq -16(%rbp), %rdi
        movq $0, %rax
        movq $0, %rsi
        movq $0, %rdx #seek to the beginning
        call fseek

        movq -32(%rbp), %rax
        #epilogue
        movq -8(%rbp), %rbx
        movq %rbp, %rsp
        popq %rbp

        ret

############################################

    getwordcount:
        #prologue
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        pushq %rdi #-16(%rbp) the address of the buffer

        movq %rdi, %r8      #r8 will store the address of the currently read byte, which will be dereferenced in r9
        movq $1, %rbx       #1 word is always expected, no trailing newline
        movq $0, %rax       #register to be used when counting newlines 
        movq $1, %rsi       #used for conditional move
        movq $0, %rdx       #used to keep track of how many bytes of the file we have alreay read

    getwordcount_loop:
        movq (%r8), %r9     #dereference address
        cmpb $0x0a, %r9b    #check for newline
        cmoveq %rsi, %rax   #if yes, store 1 into RAX
        add %rax, %rbx      #add 0 or 1 to RBX
        movq $0, %rax       #clear RAX for subsequent runs
        incq %r8            #increment address of the next byte
        cmpb $0x00, %r9b    #check if string is null
        jne getwordcount_loop   #if not, jump back; else - return
        
    getwordcount_end:
        #epilogue
        movq %rbx, %rax
        movq -8(%rbp), %rbx
        movq %rbp, %rsp
        popq %rbp

        ret

############################################

    .global getemptyuser
    getemptyuser:
        #prologue
        pushq %rbp
        movq %rsp, %rbp

        movq $42, %rax

        #epilogue
        movq %rbp, %rsp
        popq %rbp

        ret

    .global appendscore
    appendscore:
        #prologue
        pushq %rbp
        movq %rsp, %rbp

        pushq %rdi  #player name, -8(%rbp)
        pushq %rsi  #score, -16(%rbp)

        movq $scoreboard, %rdi
        call readscores
        movq -8(%rbp), %rdi
        movq -16(%rbp), %rsi
        pushq %rax  #results read from the scoreboard file, -24(%rbp)
        movq (%rax), %rdx #handle to array with initials
        pushq %rdx #handle to array with initials, -32(%rbp)
        addq $8, %rax   #calculate the address to the handle to array with scores
        movq (%rax), %rcx #handle to array with scores, -40(%rbp)
        pushq %rcx      #handle to array with scores, -40(%rbp)s
        subq $8, %rax
        pushq (%rax)    #handle to array wiht scores, -48(%rbp)
        pushq %rbx      #callee-saved register, -56(%rbp)

        movq $0, %rbx   #keep track of the index of the result in the scoreboard
        movq $0, %rax   #used for calculating offsets
        movq $4, %r9    #used for calculating offsets
        movq -8(%rbp), %rdi 
        movl (%rdi), %edi   #what the? just kidding, I fetch 4 bytes at a time since the initials take up 4 bytes
        findsameplayer:
            cmpq $5, %rbx
            jg findlowestscore
            movl (%rdx), %r8d #read one entry in the list of initials
            cmpl %edi, %r8d #check if this slot is by the same player
            je replaceplayer
            incq %rbx
            movq %rbx, %rax
            #pushq %rdx 
            #movq $0, %rdx
            #movq %rbx, %rax
            #mulq %r9
            #popq %rdx
            #addq %rax, %rdx     #increment index in initials array
            addq $4, %rdx       #increment index in initials array
            addq $1, %rcx     #increment index in scores array
            jmp findsameplayer

            findlowestscore: #prep work for this
                movq -32(%rbp), %rdx      #move back to the beginning of the arrays 
                movq $0, %rbx
                movq -40(%rbp), %rcx
                movq -8(%rbp), %rdi 
                movl (%rdi), %edi   #what the? just kidding, I fetch 4 bytes at a time since the initials take up 4 bytes
                movq $255, %rsi       #that will store the lowest score
                movq $0, %r10
                findlowestscoreloop: #TODO: implement CORRECT functionality
                    cmpq $4, %rbx
                    jg checkforsameuser
                    movb (%rcx), %r8b #read the current score at index %rcx
                    cmpb %r8b, %sil #check if this score is lower than the maximum
                    cmova %r8, %rsi    #store the lowest score
                    incq %rbx
                    movq %rbx, %rax
                    #pushq %rdx 
                    #movq $0, %rdx
                    #movq %rbx, %rax
                    #mulq %r9
                    #popq %rdx
                    #addq %rax, %rdx     #increment index in initials array
                    addq $4, %rdx       #increment index in initials array
                    addq $1, %rcx     #increment index in scores array
                    jmp findlowestscoreloop
                    checkforsameuser: #check if the same user has the lowest score
                        movq -32(%rbp), %rdx      #move back to the beginning of the arrays 
                        movq $0, %rbx
                        movq -40(%rbp), %rcx
                        #decq %rcx
                        movq -8(%rbp), %rdi 
                        movl (%rdi), %edi   #what the? just kidding, I fetch 4 bytes at a time since the initials take up 4 bytes
                        checkforsameuserloop:
                            cmpq $5, %rbx
                            jg gotothefirstwithlowest
                            movb (%rcx), %r8b #read the current score at index %rbx
                            cmpb %sil, %r8b #check if this score is lower than the maximum
                            jne checkforsameuserloop_postcond
                            movl (%rdx), %r8d #read one entry in the list of initials
                            cmpl %edi, %r8d #check if this slot is by the same player
                            je replaceplayer
                        checkforsameuserloop_postcond:
                            incq %rbx
                            movq %rbx, %rax
                            #pushq %rdx 
                            #movq $0, %rdx
                            #movq %rbx, %rax
                            #mulq %r9
                            #popq %rdx
                            #addq %rax, %rdx     #increment index in initials array
                            addq $4, %rdx       #increment index in initials array
                            addq $1, %rcx     #increment index in scores array
                            jmp checkforsameuserloop
                        gotothefirstwithlowest:#if no entry with the same user has the lowest score, we go to the first one we find that has the lowest score
                            movq -32(%rbp), %rdx      #move back to the beginning of the arrays 
                            movq $0, %rbx
                            movq -40(%rbp), %rcx
                            gotothefirstwithlowestloop:
                                cmpq $5, %rbx
                                jg checkforempty
                                movb (%rcx), %r8b #read the current score at index %rbx
                                cmpb %sil, %r8b #check if this score is lower than the maximum
                                je replaceplayer
                                incq %rbx
                                movq %rbx, %rax
                                #pushq %rdx 
                                #movq $0, %rdx
                                #movq %rbx, %rax
                                #mulq %r9
                                #popq %rdx
                                #addq %rax, %rdx     #increment index in initials array
                                addq $4, %rdx       #increment index in initials array
                                addq $1, %rcx     #increment index in scores array
                                jmp gotothefirstwithlowestloop
                checkforempty:
                    movq -32(%rbp), %rdx      #move back to the beginning of the arrays 
                    movq $0, %rbx
                    movq -40(%rbp), %rcx
                    movq -8(%rbp), %rdi 
                    movl (%rdi), %edi   #what the? just kidding, I fetch 4 bytes at a time since the initials take up 4 bytes
                    checkforemptyloop:
                        cmpq $5, %rbx
                        jg appendscore_end
                        movl (%rdx), %r8d #read one entry in the list of initials
                        cmpl $0x002d2d2d, %r8d #check if this slot is empty
                        je replaceplayer
                        incq %rbx
                        movq %rbx, %rax
                        #pushq %rdx 
                        #movq $0, %rdx
                        #movq %rbx, %rax
                        #mulq %r9
                        #popq %rdx
                        #addq %rax, %rdx     #increment index in initials array
                        addq $4, %rdx       #increment index in initials array
                        addq $1, %rcx     #increment index in scores array
                        jmp checkforemptyloop
    replaceplayer:
        movq $0, %rax
        movb (%rcx), %r8b
        cmpb %r8b, %sil     #check if current score is lower
        jl appendscore_end
        movq -8(%rbp), %rdi 
        movl (%rdi), %edi   #what the? just kidding, I fetch 4 bytes at a time since the initials take up 4 bytes
                            #Store results in the respective array
        movl %edi, (%rdx)   #store initials
        movq -16(%rbp), %rsi
        movb %sil, (%rcx)   #store score
        movq -24(%rbp), %rdi
        call writescoreboard    # write the scoreboard to the file
        movq $1, %rax
        jmp appendscore_end
    

    appendscore_end:
        pushq %rax
        #Free buffers
        movq -40(%rbp), %rdi
        call free           #free buffer for initials
        #movq -32(%rbp), %rdi
        #call free           #free buffer for scores
        movq -24(%rbp), %rdi
        call free           #free array containing handles for the two previous ones
        movq (%rsp), %rax   #return 0 if no score was added, 1 if a score was added
        movq -48(%rbp), %rbx
        #epilogue
        movq %rbp, %rsp
        popq %rbp

        ret

############################################
    .global readscores

    readscores: #Read the scores stored in the file (those are the 5 highest highscores)

        #prologue
        pushq %rbp
        movq %rsp, %rbp
        
        #Open file
        #fopen(filename, mode)
        movq $scoreboard, %rdi    #filename
        movq $scoreboard_perm, %rsi    #mode (read)
        call fopen
        pushq %rax #handle to file -8(%rbp)

        jnz touchscoreboard #if file not found, create an empty one
    scoreboardcreated:
        # Read the entire file
        #Find the size of the file
        movq %rax, %rdi
        call findfileend
        pushq %rax  #size of file in bytes -16(%rbp)

        #Allocate sufficient memory for the file
        movq %rax, %rdi
        incq %rdi   #null terminator
        call malloc
        pushq %rax  #handle to array with file contents -24(%rbp)

        #Read the entire file (address of filename is in %rax)
        #fread()
        movq %rax, %rdi #array in which the text will be stored
        movq $1, %rsi        #size of words to be read (in this case, single ASCII characters, so 1 byte)
        movq -16(%rbp), %rdx #number of bytes to be read
        #decq %rdx            #remove the added byte for the null terminator
        movq -8(%rbp), %rcx #file handle
        call fread

        #Close the file
        movq -8(%rbp), %rdi
        call fclose
        
        #Reopen file, this time read-only
        #fopen(filename, mode)
        movq $scoreboard, %rdi    #filename
        movq $readperm, %rsi    #mode (read)
        call fopen
        movq %rax, -8(%rbp)     #handle to file -8(%rbp)


        #Create arrays for the data 
        #for the initials - 4 bytes/initials(3 letters + null terminator); 5 entries - 20 bytes
        movq $5, %rdi
        movq $4, %rsi
        call calloc
        pushq %rax #handle to array for initials, -32(%rbp)

        #for the points - 1 byte/score, 5 entries - 5 bytes
        movq $5, %rdi
        movq $1, %rsi
        call calloc
        pushq %rax #handle to array for scores, -40(%rbp)

        #array for a single line, maximum length is 3+1+3+1+1=9 bytes (3 initials, 1 space, 3 digits, 1 newline, 1 null terminator)
        movq $9, %rdi
        movq $1, %rsi
        call calloc 
        pushq %rax #handle to currently read string, -48(%rbp)

        pushq %rbx #store callee-saved register, -56(%rbp)
        pushq %r12 #store callee-saved register, -64(%rbp)
        movq $0, %rbx   #number of lines read from the file 
        movq %rax, %r12 #number of characters currently read
        movq -24(%rbp), %rdi #address of the array in which file contents are stored
        movq -48(%rbp), %rsi #address of the array in which the line is to be stored
    geteachline:
        movb (%rdi), %r8b    #read current character
        cmpb $0x0a, %r8b    #check for newline
        je fetchdataline
        #cmpb $0x00, %r8b    #check for end of string
        #je fetchdata
        movb %r8b, (%rsi)   #store the currently read character in the buffer
        incq %rsi
        incq %rdi
        jmp geteachline
    fetchdataline:
        pushq %rdi
        subq $8, %rsp
        movq -48(%rbp), %rdi
        movq $scoreboard_readformat, %rsi
        movq -40(%rbp), %rcx    #address of element for score
        addq %rbx, %rcx
        movq %rbx, %rax         #address of element in string array
        movq $0, %rdx
        movq $4, %r8
        mulq %r8
        movq -32(%rbp), %rdx
        addq %rax, %rdx         #prepared address
        call sscanf
        incq %rbx               #1 more line read
        movq -48(%rbp), %rsi #address of the array in which the line is to be stored
        incq %rdi
        addq $8, %rsp
        popq %rdi
        incq %rdi
        cmpq $5, %rbx           #check if we have the 5 entries in the scoreboard already
        jne geteachline


        #Close the file
        movq -8(%rbp), %rdi
        call fclose

        movq -48(%rbp), %rdi    #freeing the buffer for line reading
        call free
        #return something resembling a tuple
        #allocate memory (2x8 bytes = 16 bytes)
        movq $2, %rdi
        movq $8, %rsi
        call calloc

        movq -32(%rbp), %r8
        movq %r8,(%rax) #copy addresses of names
        movq -40(%rbp), %r8
        addq $8, %rax
        movq %r8, (%rax)#copy addresses of scores
        subq $8, %rax
        
        #epilogue
        movq -56(%rbp), %rbx #restore callee-saved register
        movq -64(%rbp), %r12 #restore callee-saved register
        movq %rbp, %rsp
        popq %rbp

        ret
    
    #Create an empty scoreboard if none is found
    touchscoreboard:
        ##Close the file
        #movq -8(%rbp), %rdi
        #call fclose

        #Open file
        #fopen(filename, mode)
        movq $scoreboard, %rdi    #filename
        movq $writeperm, %rsi    #mode (append)
        call fopen
        movq %rax, -8(%rbp) #handle to file -8(%rbp)

        movq $0, %rax
        movq -8(%rbp), %rdi #handle to file 
        movq $scoreboard_empty, %rsi    #handle to empty scoreboard
        call fprintf

        #Close the file
        movq -8(%rbp), %rdi
        call fclose

        #Open file
        #fopen(filename, mode)
        movq $scoreboard, %rdi    #filename
        movq $scoreboard_perm, %rsi    #mode (read)
        call fopen
        movq %rax, -8(%rbp) #handle to file -8(%rbp)
        jmp scoreboardcreated

    .global writescoreboard
    writescoreboard:
        #epilogue
        pushq %rbp
        movq %rsp, %rbp

        pushq %rdi          #handle to the array holding the handles to the arrays for initials and for scores, -8(%rbp)
        movq (%rdi), %rdx   #handle to array with initials
        pushq %rdx          #handle to array with initials, -16(%rbp)
        addq $8, %rdi       #calculate the address to the handle to array with scores
        movq (%rdi), %rdx   #handle to array with scores
        pushq %rdx          #handle to array with scores, -24(%rbp)

        #Open file
        #fopen(filename, mode)
        movq $scoreboard, %rdi    #filename
        movq $overwriteperm, %rsi    #mode (read)
        call fopen
        pushq %rax                  #handle to file, -32(%rbp)

        pushq %rbx                  #save callee-saved register, -40(%rbp)
        movq $0, %rbx               #count the numver of entries already written
        movq -16(%rbp), %r8        #handle to initials array
        movq -24(%rbp), %r9        #handle to scores array
    writeloop:
        movq $4, %rax
        mulq %rbx
        movq %r8, %rdx
        addq %rax, %rdx
        movq %r9, %rcx
        addq %rbx, %rcx
        
        movq $0, %rax
        movq -32(%rbp), %rdi #handle to file 
        movq $scoreboard_format, %rsi    #handle to empty scoreboard
        #rdx already holds reference to string
        movzbq (%rcx), %rcx         #score
        call fprintf

        movq -16(%rbp), %r8        #handle to initials array
        movq -24(%rbp), %r9        #handle to scores array
        incq %rbx
        cmpq $5, %rbx
        jl writeloop

        #Close the file
        movq -32(%rbp), %rdi
        call fclose

        movq -40(%rbp), %rbx        #restore contents of callee-saved register
        #epilogue
        movq %rbp, %rsp
        popq %rbp
        ret
