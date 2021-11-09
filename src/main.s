.data

    greeter:    .asciz "Welcome to Hangman!"
    authors:    .asciz "Authors:"
    simo:       .asciz "Simeon Atanasov (satanasov)"
    vic:        .asciz "Vic Vansteelant (vvansteelant)"
    begin:      .asciz "Press any key to begin"

    wronginput: .asciz "Please give a correct input!"
    triedF1:    .asciz "You already tried the letter '%c' and it "
    triedF2:    .asciz "was WRONG, please try another letter!"
    triedT1:    .asciz "You already tried the letter '%c' and it "
    triedT2:    .asciz "was CORRECT, please try another letter!"
    failmsg1:   .asciz "You have guessed wrong 7 times."
    failmsg2:   .asciz "This is to much, you lost."
    failmsg3:   .asciz "The answer was: %s."
    succesmsg1: .asciz "Congratulations!"
    succesmsg2: .asciz "You have correctly guessed the word!"
    succesmsg3: .asciz "Your current streak is %d"
    againmsg:   .asciz "Try again (y/n)?"
    correctmsg: .asciz "The letter '%c' is correct!"
    wrongmsg:   .asciz "The letter '%c' is wrong!"
    initials1:  .asciz "Please enter 3 characters to"
    initials2:  .asciz "represent your name on the scoreboard"
    initialform:.asciz "%c"
    initsave:   .asciz "XDD"

    underscore: .ascii "_"
    ystring:    .ascii "y"
    nstring:    .ascii "n"

    user:       .skip 50

    fails:      .skip 8

    gallows0:   .ascii "   +------\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .asciz "---------"

    gallows00:   .ascii "   +------\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .asciz "---------"

    gallows1:   .ascii "   +------\n"
                .ascii "    | /   |\n"
                .ascii "    |/\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .asciz "---------"


    gallows2:   .ascii "   +------\n"
                .ascii "    | /   |\n"
                .ascii "    |/   ---\n"
                .ascii "    |   /   \\\n"
                .ascii "    |  |     |\n"
                .ascii "    |   \\   /\n"
                .ascii "    |    ---\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .asciz "---------"

    gallows3:   .ascii "   +------\n"
                .ascii "    | /   |\n"
                .ascii "    |/   ---\n"
                .ascii "    |   /   \\\n"
                .ascii "    |  |     |\n"
                .ascii "    |   \\   /\n"
                .ascii "    |    ---\n"
                .ascii "    |     |  \n"
                .ascii "    |     | \n"
                .ascii "    |     |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .asciz "---------"

    gallows4:   .ascii "   +------\n"
                .ascii "    | /   |\n"
                .ascii "    |/   ---\n"
                .ascii "    |   /   \\\n"
                .ascii "    |  |     |\n"
                .ascii "    |   \\   /\n"
                .ascii "    |    ---\n"
                .ascii "    |   \\ |  \n"
                .ascii "    |    \\| \n"
                .ascii "    |     |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .asciz "---------"

    gallows5:   .ascii "   +------\n"
                .ascii "    | /   |\n"
                .ascii "    |/   ---\n"
                .ascii "    |   /   \\\n"
                .ascii "    |  |     |\n"
                .ascii "    |   \\   /\n"
                .ascii "    |    ---\n"
                .ascii "    |   \\ | /\n"
                .ascii "    |    \\|/\n"
                .ascii "    |     |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .ascii "    |\n"
                .asciz "---------"

    gallows6:   .ascii "   +------\n"
                .ascii "    | /   |\n"
                .ascii "    |/   ---\n"
                .ascii "    |   /   \\\n"
                .ascii "    |  |     |\n"
                .ascii "    |   \\   /\n"
                .ascii "    |    ---\n"
                .ascii "    |   \\ | /\n"
                .ascii "    |    \\|/\n"
                .ascii "    |     |\n"
                .ascii "    |    /\n"
                .ascii "    |   /\n"
                .ascii "    |\n"
                .asciz "---------"
    
    gallows7:   .ascii "   +------\n"
                .ascii "    | /   |\n"
                .ascii "    |/   ---\n"
                .ascii "    |   /   \\\n"
                .ascii "    |  |     |\n"
                .ascii "    |   \\   /\n"
                .ascii "    |    ---\n"
                .ascii "    |   \\ | /\n"
                .ascii "    |    \\|/\n"
                .ascii "    |     |\n"
                .ascii "    |    / \\\n"
                .ascii "    |   /   \\\n"
                .ascii "    |\n"
                .asciz "---------"
    

.text
    .global main

    main:
        #prologue
        pushq   %rbp
        movq    %rsp, %rbp

        pushq   %rdi                #store the number of command-line arguments              -8(%rbp)
        pushq   %rsi                #store the address of the first command-line argument    -16(%rbp)

        #initialize the screen
        call    initscr
        call    noecho


        ######################################################################
        # Print greeting (5 mvwprintw calls for 5 different lines)
        movq    stdscr, %rdi 
        movq    $2, %rsi           #row number for mvprintw
        movq    $20, %rdx          #col number for mvprintw
        movq    $greeter, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    stdscr, %rdi 
        movq    $3, %rsi           #row number for mvprintw
        movq    $25, %rdx          #col number for mvprintw
        movq    $authors, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    stdscr, %rdi 
        movq    $4, %rsi           #row number for mvprintw
        movq    $16, %rdx          #col number for mvprintw
        movq    $simo, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    stdscr, %rdi 
        movq    $5, %rsi           #row number for mvprintw
        movq    $14, %rdx          #col number for mvprintw
        movq    $vic, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    stdscr, %rdi 
        movq    $6, %rsi           #row number for mvprintw
        movq    $18, %rdx          #col number for mvprintw
        movq    $begin, %rcx
        movq    $0, %rax
        call    mvwprintw

        #Refresh screen to show changes
        movq    stdscr, %rdi
        call    wrefresh
        ######################################################################


        #Wait for key press (pause)
        movq    stdscr, %rdi
        call    wgetch

        #clear screen
        movq    stdscr, %rdi
        call    wclear


        ######################################################################
        # Create the three windows that constitute the game screen
        # Total window size is rows=16, columns=17+42=59
        # newwin(rows, cols, startrow, startcol)

        #Create the window where the gallows are to be drawn 
        movq    $16, %rdi
        movq    $17, %rsi
        movq    $0, %rdx
        movq    $0, %rcx
        call    newwin
        pushq   %rax                    #STACK push the returned memory address to the window onto the stack -24(%rbp), window "hangman"

        #Create the window where the empty word is to be printed
        movq    $8, %rdi
        movq    $42, %rsi
        movq    $0, %rdx
        movq    $18, %rcx
        call    newwin
        pushq   %rax                    #STACK push the returned memory address to the window onto the stack -32(%rbp), window "userwin"

        #Create the window where the bin of incorrect guesses is stored
        movq    $8, %rdi
        movq    $42, %rsi
        movq    $8, %rdx
        movq    $18, %rcx
        call    newwin
        pushq   %rax                    #STACK push the returned memory address to the window onto the stack -40(%rbp), window "bin"

        #Draw the window borders wborder(window, 0,0,0,0,0,0,0,0)

        #for window "hangman" (-24(%rbp))
        movq    -24(%rbp), %rdi
        movq    $0, %rsi
        movq    $0, %rdx
        movq    $0, %rcx
        movq    $0, %r8
        movq    $0, %r9
        pushq   $0
        pushq   $0
        pushq   $0
        call    wborder
        addq    $24, %rsp
        #Refresh window "hangman" (-24(%rbp)) to show changes
        movq    -24(%rbp), %rdi
        call    wrefresh
        #Refresh screen to show changes
        movq    stdscr, %rdi
        call    wrefresh

        #for window "user" (-32(%rbp))
        movq    -32(%rbp), %rdi
        movq    $0, %rsi
        movq    $0, %rdx
        movq    $0, %rcx
        movq    $0, %r8
        movq    $0, %r9
        pushq   $0
        pushq   $0
        pushq   $0
        call    wborder
        addq    $24, %rsp
        #Refresh window "user" (-32(%rbp)) to show changes
        movq    -32(%rbp), %rdi
        call    wrefresh
        #Refresh screen to show changes
        movq    stdscr, %rdi
        call    wrefresh

        #for window "bin" (-40(%rbp))
        movq    -40(%rbp), %rdi
        movq    $0, %rsi
        movq    $0, %rdx
        movq    $0, %rcx
        movq    $0, %r8
        movq    $0, %r9
        pushq   $0
        pushq   $0
        pushq   $0
        call    wborder
        addq    $24, %rsp
        #Refresh window "bin" (-40(%rbp)) to show changes
        movq    -40(%rbp), %rdi
        call    wrefresh
        #Refresh screen to show changes
        movq    stdscr, %rdi
        call    wrefresh

        #Refresh screen to show changes
        movq    stdscr, %rdi
        call    wrefresh
        ######################################################################


        pushq   $0                  #current streak (-48(%rbp))
        movq    -24(%rbp), %r13     #hangman
        movq    -32(%rbp), %r14     #user
        movq    -40(%rbp), %r15     #bin

        jmp     startround

    ##################################################################################################################
    ##################################################################################################################

    startround:

    movq    $0, %r12            #failcounter

    #clear the gallows
    movq    %r13, %rdi
    call    werase

    #print empty gallows
    movq    %r13, %rdi 
    movq    $1, %rsi            #row number for mvprintw
    movq    $1, %rdx            #col number for mvprintw
    movq    $gallows00, %rcx
    movq    $0, %rax
    call    mvwprintw
    
    movq    %r13, %rdi
    call    wrefresh 
    movq    stdscr, %rdi
    call    wrefresh           

    #get the word for this round of the game
    # # char* getrandword(char* filename), returns a handle to the allocated buffer with the word to be guessed
    # # Read dictionary file provided by command-line arguments
    movq    -16(%rbp), %rdi    #get the address of the argument array
    addq    $8, %rdi           #get the address of the second command-line argument (filename)
    movq    (%rdi), %rdi       #load the address pointed to by rsi
    call    getrandword
    pushq   %rax

    #create a string of underscores with the correct lenght
    movq    (%rsp), %rdi
    movq    $user, %rsi
    call    createuser

    #replace the '-' with whitespaces
    movq    (%rsp), %rdi
    movq    $user, %rsi
    call    createwhitespaces  

    #reset the fails string
    movq    $fails, %rdi
    call    emptyfails

    ##################################################################################################################
    ##################################################################################################################

    guessingloop:

        #print the user string
        movq    $user, %rdi
        movq    %r14, %rsi          #user window
        call    printuser   
        
        #print all current wrong guesses
        movq    $fails, %rdi
        call    printwrongguesses

        #get user input
        movq    stdscr, %rdi        
        call    wgetch  
        movq    %rax, %rbx          #store user input in a callee-saved register

        #clear the user and bin windows
        call    windowreset         

        #check wether the user input already has been tried and was false
        movq    $fails, %rdi
        movq    %rbx, %rsi
        movq    $0, %rdx
        call    contains

        cmpq    $(-1), %rax
        jne     triedfalse

        #check wether the user input already has been tried and was right
        movq    $user, %rdi
        movq    %rbx, %rsi
        movq    $0, %rdx
        call    contains      

        cmpq    $(-1), %rax
        jne     triedtrue

        #check wether the user input is contained in the word
        movq    (%rsp), %rdi
        movq    %rbx, %rsi
        movq    $0, %rdx
        call    contains      

        cmpq    $(-1), %rax
        je      fail

        pushq   %rax                    #store rax on the stack so it doesn't get overwritten

        #print "The letter '%c' is correct!"
        movq    %r15, %rdi              #bin window
        movq    $1, %rsi                #row number for mvprintw
        movq    $1, %rdx                #col number for mvprintw
        movq    $correctmsg, %rcx
        movq    %rbx, %r8
        movq    $0, %rax
        call    mvwprintw

        movq    %r15, %rdi              #refresh window
        call    wrefresh            
        movq    stdscr, %rdi            #refresh screen to show changes
        call    wrefresh 

        popq    %rdx                    #retreive the location of the letter

        multiplelettersloop:
            
            #place the character at the corect location in the user string
            movq    $user, %rax
            addq    %rdx, %rax
            movb    %bl, (%rax)        

            #check wether the user input is contained in the word after the current character
            movq    (%rsp), %rdi
            movq    %rbx, %rsi
            incq    %rdx
            call    contains

            movq    %rax, %rdx  #set the location of the last letter as the new offset for contains

            cmpq    $(-1), %rax
            jne     multiplelettersloop 

        checkend:

        #check wether there is still an '_' in user
        movq    $user, %rdi
        movq    underscore, %rsi
        movq    $0, %rdx
        call    contains

        cmpq    $(-1), %rax
        je      succeeded

        jmp     guessingloop

        ##################################################################################################################

        triedfalse:

            #print "You already tried the letter '%c' and it"
            movq    %r15, %rdi          #bin window
            movq    $1, %rsi            #row number for mvprintw
            movq    $1, %rdx            #col number for mvprintw
            movq    $triedF1, %rcx
            movq    %rbx, %r8
            movq    $0, %rax
            call    mvwprintw

            #print "was WRONG, please try another letter!"
            movq    %r15, %rdi          #bin window
            movq    $2, %rsi            #row number for mvprintw
            movq    $1, %rdx            #col number for mvprintw
            movq    $triedF2, %rcx
            movq    $0, %rax
            call    mvwprintw

            movq    %r15, %rdi          #refresh window
            call    wrefresh                
            movq    stdscr, %rdi        #refresh screen to show changes
            call    wrefresh 

            jmp     guessingloop        #return to the start

        ##################################################################################################################

        triedtrue:

            #print "You already tried the letter '%c' and it "
            movq    %r15, %rdi          #bin window
            movq    $1, %rsi            #row number for mvprintw
            movq    $1, %rdx            #col number for mvprintw
            movq    $triedT1, %rcx
            movq    %rbx, %r8
            movq    $0, %rax
            call    mvwprintw

            #print " was CORRECT, please try another letter!"
            movq    %r15, %rdi          #bin window
            movq    $2, %rsi            #row number for mvprintw
            movq    $1, %rdx            #col number for mvprintw
            movq    $triedT2, %rcx
            movq    $0, %rax
            call    mvwprintw

            movq    %r15, %rdi          #refresh window
            call    wrefresh               
            movq    stdscr, %rdi        #refresh screen to show changes
            call    wrefresh 

            jmp     guessingloop        #return to the start

        ##################################################################################################################

        fail:

            #print "The letter '%c' is wrong!"
            movq    %r15, %rdi          #bin window
            movq    $1, %rsi            #row number for mvprintw
            movq    $1, %rdx            #col number for mvprintw
            movq    $wrongmsg, %rcx
            movq    %rbx, %r8
            movq    $0, %rax
            call    mvwprintw

            movq    %r15, %rdi          #refresh window
            call    wrefresh

            #adds the wrong character to the fails string
            movq    $fails, %rdx
            addq    %r12, %rdx
            movb    %bl, (%rdx)

            incq    %r12                #increments the fails counter
            cmpq    $7, %r12            #check if the maximum amount of fails has been met
            je      failed

            #moves the string for the gallows which matches the number of fails into rcx
            movq    $gallows1, %rdx
            cmpq    $1, %r12
            cmoveq  %rdx, %rcx

            movq    $gallows2, %rdx
            cmpq    $2, %r12
            cmoveq  %rdx, %rcx

            movq    $gallows3, %rdx
            cmpq    $3, %r12
            cmoveq  %rdx, %rcx

            movq    $gallows4, %rdx
            cmpq    $4, %r12
            cmoveq  %rdx, %rcx

            movq    $gallows5, %rdx
            cmpq    $5, %r12
            cmoveq  %rdx, %rcx

            movq    $gallows6, %rdx
            cmpq    $6, %r12
            cmoveq  %rdx, %rcx

            #prints the gallows
            movq    %r13, %rdi          #bin window
            movq    $1, %rsi            #row number for mvprintw
            movq    $1, %rdx            #col number for mvprintw
            movq    %rcx, %rcx
            movq    $0, %rax
            call    mvwprintw
            
            movq    %r13, %rdi          #refresh window
            call    wrefresh              
            movq    stdscr, %rdi        #refresh screen to show changes
            call    wrefresh 

            jmp     guessingloop        #return to the start

    #here the guessing loop ends
    ##################################################################################################################
    ##################################################################################################################


    failed:

        #prints the final gallow
        movq    %r13, %rdi          #bin window
        movq    $1, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $gallows7, %rcx
        movq    $0, %rax
        call    mvwprintw
        
        movq    %r13, %rdi          #refresh window
        call    wrefresh            
        movq    stdscr, %rdi        #refresh screen to show changes
        call    wrefresh

        #reset streak to 0
        movq    $0, -48(%rbp)  

        #clear the user and bin windows
        call    windowreset

        #print the user string
        movq    $user, %rdi
        movq    %r14, %rsi          #user window
        call    printuser 

        #print "You have guessed wrong 7 times."
        movq    %r15, %rdi          #bin window
        movq    $1, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $failmsg1, %rcx
        movq    $0, %rax
        call    mvwprintw

        #print "This is to much, you lost."
        movq    %r15, %rdi          #bin window
        movq    $2, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $failmsg2, %rcx
        movq    $0, %rax
        call    mvwprintw

        #print "The answer was: %s."
        movq    %r15, %rdi          #bin window
        movq    $3, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $failmsg3, %rcx
        movq    (%rsp), %r8
        movq    $0, %rax
        call    mvwprintw

        jmp     endround

    ##################################################################################################################

    succeeded:

        #clear the user and bin windows
        call    windowreset

        #print the user string
        movq    $user, %rdi
        movq    %r14, %rsi          #user window
        call    printuser 

        #get the streak and increment it
        movq    -48(%rbp), %rbx     #get the streak into a callee-saved reg
        incq    %rbx                #increase the streak by 1
        movq    %rbx, -48(%rbp)     #put the streak back in the stack

        #print "Congratulations!"
        movq    %r15, %rdi          #bin window
        movq    $1, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $succesmsg1, %rcx
        movq    $0, %rax
        call    mvwprintw

        #print "You have correctly guessed the word!"
        movq    %r15, %rdi          #bin window
        movq    $2, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $succesmsg2, %rcx
        movq    $0, %rax
        call    mvwprintw

        #print "Your current streak is %d"
        movq    %r15, %rdi          #bin window
        movq    $3, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $succesmsg3, %rcx
        movq    %rbx, %r8
        movq    $0, %rax
        call    mvwprintw
    
    ##################################################################################################################
    
    endround: 

        #free the malloc for the random word
        movq    (%rsp), %rdi
        call    free
        addq    $8, %rsp #pop the value off of the stack

        repeattryagain:

        #print "Try again (y/n)?"
        movq    %r15, %rdi          #bin window
        movq    $5, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $againmsg, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    %r15, %rdi          #refresh window
        call    wrefresh
        movq    stdscr, %rdi        #refresh screen to show changes
        call    wrefresh 

        #get user input for try again
        movq    stdscr, %rdi        #get user input
        call    wgetch
        movq    %rax, %rbx

        #clear the user and bin windows
        call    windowreset

        #compares the user input to the character 'y', if equal jump to gameloop
        movq    ystring, %r10
        cmpb    %r10b, %bl           
        je      startround 

        #compares the user input to the character 'n', if equal jump to endgame
        movq    nstring, %r10
        cmpb    %r10b, %bl           
        je      endgame

        #deal with wrong input
        #print "Please give a correct input!"
        movq    %r15, %rdi          #bin window
        movq    $1, %rsi            #row number for mvprintw
        movq    $1, %rdx            #col number for mvprintw
        movq    $wronginput, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    %r15, %rdi          #refresh window
        call    wrefresh            
        movq    stdscr, %rdi        #refresh screen to show changes
        call    wrefresh

        jmp     repeattryagain

    ##################################################################################################################
    ##################################################################################################################

    endgame:

        #clear gallows window
        movq    %r13, %rdi
        call    wclear

        #ask player for his initials

        #print "Please enter 3 characters to"
        movq    %r15, %rdi          #bin window
        movq    $2, %rsi            #row number for mvprintw
        movq    $6, %rdx            #col number for mvprintw
        movq    $initials1, %rcx
        movq    $0, %rax
        call    mvwprintw

        #print "represent your name on the scoreboard"
        movq    %r15, %rdi          #bin window
        movq    $3, %rsi            #row number for mvprintw
        movq    $2, %rdx            #col number for mvprintw
        movq    $initials2, %rcx
        movq    $0, %rax
        call    mvwprintw

        movq    %r15, %rdi          #refresh window
        call    wrefresh            
        movq    stdscr, %rdi        #refresh screen to show changes
        call    wrefresh

        movq    $0, %r12
        movq    $initsave, %rbx

        getinitialsloop:

            #wait for key press (pause)
            movq    stdscr, %rdi
            call    wgetch

            movq    %rbx, %r9           #the address of the initialsstring is stored in r9 so we don't overwrite it
            addq    %r12, %r9           #the offset is added to r9          
            movb    %al, (%r9)          #the input is added to the address in r9
            movq    %rax, %r8           #load the input into r8

            #print the character the user has just inputted
            movq    %r14, %rdi          #the window
            movq    $3, %rsi            #row number
            movq    $1, %rax            #the calculation for the column number
            mulq    %r12
            movq    $20, %rdx
            addq    %rax, %rdx
            movq    $initialform, %rcx  #the formatstring for the print, the char for %c will be stored in r8
            movq    $0, %rax
            call    mvwprintw

            movq    %r14, %rdi          #refresh window
            call    wrefresh            
            movq    stdscr, %rdi        #refresh screen to show changes
            call    wrefresh

            #check if all the initials have been retreived
            cmpq    $2, %r12
            je      continueendgame

            incq    %r12                #increment the counter
            jmp     getinitialsloop

        continueendgame:

        #add the user score to the scoreboard
        movq    $initsave, %rdi
        movq    -48(%rbp), %rsi
        call    appendscore

        #clear user window
        movq    %r14, %rdi
        call    wclear
        #clear bin window
        movq    %r15, %rdi
        call    wclear
        #clear screen
        movq    stdscr, %rdi
        call    wclear

    ##################################################################################################################

        #print the scoreboard
        call    printSB

        #wait for key press (pause)
        movq    stdscr, %rdi
        call    wgetch

        #clear screen
        movq    stdscr, %rdi
        call    wclear

        #destroy screen
        call    endwin

        #epilogue
        movq    %rbp, %rsp
        popq    %rbp

        movq    $0, %rdi
        call    exit
 