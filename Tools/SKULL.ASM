//HELLONEO JOB (ASSY),'WOOLBRIGHT',CLASS=A,MSGCLASS=Y,                  00010000
//         NOTIFY=&SYSUID,MSGLEVEL=(1,1)                                00020000
//ASM      EXEC PROC=HLASMCL                                            00030000
//SYSIN    DD   *                                                       00040000
CLR70    TITLE 'C L E A R - TSO'                                        00050000
         PRINT ON,DATA,GEN                                              00060000
CLEAR    CSECT                                                          00080000
*         SETUP registers and save areas thanks @bigendiansmalls      * 00110000
MAIN     STM   14,12,12(13)    # Save caller reg                        00140000
         LR    8,15            # Base register                          00150000
         USING MAIN,8          # R8 for addressability                  00160000
         GETMAIN RU,LV=72      # for our savearea                       00170000
         ST    13,4(,1)        # Store Caller's SA address              00180000
         ST    1,8(,13)        # Put my SA addr in caller's SA          00190000
         LR    13,1            # R13 has addr of our SA                 00200000
         DS    0H              # halfword boundaries                    00210000
* Let the fun Begin!                                                  * 00230000
* YREGS sets R0 through R15, it is in SYS1.MACLIB                       00250000
         YREGS                                                          00260000
* GTSIZE checks your terminal and sets R0 to the screen width and R0 to 00270000
* the height, also in SYS1.MACLIB                                       00280000
         GTSIZE                                                         00290000
         CH    R0,=H'1'        # Compare R0 (total number of lines)     00300000
*                                to 0x01 and set condition              00310000
         BL    EXITP           # If R0 is less than 0x01 exit           00320000
* Now turn on Full Screen MODE. Initial means                           00330000
* this is the first time we're using this macro                         00340000
         STFSMODE ON,INITIAL=YES                                        00350000
* Set Terminal Display Manager Options                                  00360000
* Basically we can turn on display manager and display interupt         00370000
* keys. KEYS=NO is how we would do that                                 00380000
         STTMPMD ON                                                     00390000
* the rest comes from http://www.tommysprinkle.com/mvs/P3270/hello2.htm 00400000
* TPUT Macro puts a data stream to TSO                                  00410000
* to escape the buffer you must pass 0x27                               00420000
* FULLSCR here basically means we send 3270 stream                      00430000
         TPUT  STREAM,STREAMLN,FULLSCR                                  00440000
* But it dissapears super fast unless we add a TGET                     00450000
* Which GETs input from the user                                        00460000
         TGET  INBUF,INBUFLN,ASIS                                       00470000
* And now undo the Full Screen and Display Manager                      00480000
         STFSMODE OFF                                                   00490000
         STTMPMD OFF                                                    00500000
*********************************************************************** 00510000
* And we Exit                                                           00520000
*********************************************************************** 00530000
EXITP    LR    1,13            # Move my SA into R1                     00540000
         L     13,4(,13)       # RST Caller SA Addr                     00550000
         FREEMAIN RU,A=(1),LV=72                                        00560000
         LM    14,12,12(13)    # restore registers                      00570000
         XR    15,15           # zero return code                       00580000
         BCR   15,14           # Branch back to caller                  00590000
STREAM   DS    0C                                                       00600000
         DC    X'27'       ESCAPE TSO CHARACTER                         00610000
         DC    X'F5'       ERASE/WRITE                                  00620000
         DC    X'C3'       WCC                                          00630000
         DC    X'114040'   SBA                                          00640000
         DC    X'2902'     SFE (Three Attribute Pairs To Follow)        00650000
         DC    X'C0F8'     ATTR #1 (BASIC = PROTECTED)                  00660000
         DC    X'42F4'     ATTR #3 (COLOR = RED)                        00680000
         DC    31X'40'                                                  00690000
         DC    C'uu$$$$$$$$$$$uu'                                       00691000
         DC    62X'40'                                                  00692000
         DC    C'uu$$$$$$$$$$$$$$$$$uu'                                 00693000
         DC    58C' '                                                   00694000
         DC    C'u$$$$$$$$$$$$$$$$$$$$$u'                               00695000
         DC    56C' '                                                   00696000
         DC    C'u$$$$$$$$$$$$$$$$$$$$$$$u'                             00697000
         DC    54C' '                                                   00698000
         DC    C'u$$$$$$$$$$$$$$$$$$$$$$$$$u'                           00699000
         DC    53C' '                                                   00700000
         DC    C'u$$$$$$*   *$$$*   *$$$$$$u'                           00701000
         DC    53C' '                                                   00702000
         DC    C'*$$$$*      u$u       $$$$*'                           00703000
         DC    54C' '                                                   00704000
         DC    C'$$$u       u$u       u$$$'                             00705000
         DC    55C' '                                                   00706000
         DC    C'$$$u      u$$$u      u$$$'                             00707000
         DC    56C' '                                                   00708000
         DC    C'*$$$$uu$$$   $$$uu$$$$*'                               00709000
         DC    58C' '                                                   00709100
         DC    C'*$$$$$$$*   *$$$$$$$*'                                 00709200
         DC    61C' '                                                   00709300
         DC    C'u$$$$$$$u$$$$$$$u'                                     00709400
         DC    64C' '                                                   00709500
         DC    C'u$*$*$*$*$*$*$u'                                       00709600
         DC    54C' '                                                   00709700
         DC    C'uuu        $$u$ $ $ $ $u$$       uuu'                  00709800
         DC    44C' '                                                   00709900
         DC    C'u$$$$       $$$$$u$u$u$$$       u$$$$'                 00710000
         DC    43C' '                                                   00710100
         DC    C'$$$$$uu      *$$$$$$$$$*     uu$$$$$$'                 00710200
         DC    41C' '                                                   00710300
         DC    C'u$$$$$$$$$$$uu    *****    uuuu$$$$$$$$$'              00710400
         DC    40C' '                                                   00710500
         DC    C'$$$$***$$$$$$$$$$uuu   uu$$$$$$$$$***$$$*'             00710600
         DC    40C' '                                                   00710700
         DC    C'***      **$$$$$$$$$$$uu **$***'                       00710800
         DC    58C' '                                                   00710900
         DC    C'uuuu **$$$$$$$$$$uuu'                                  00711000
         DC    51C' '                                                   00711100
         DC    C'u$$$uuu$$$$$$$$$uu **$$$$$$$$$$$uuu$$$'                00711200
         DC    42C' '                                                   00711300
         DC    C'$$$$$$$$$$****           **$$$$$$$$$$$*'               00711400
         DC    43C' '                                                   00711500
         DC    C'*$$$$$*                      **$$$$**'                 00711600
STREAMLN EQU   *-STREAM                                                 00712000
*                                                                       00720000
INBUF    DS    XL128                                                    00730000
INBUFLN  EQU   *-INBUF                                                  00740000
         END   ,                                                        00750000
/*                                                                      00760000
//L.SYSLMOD DD DSN=PLAGUE.ASM.EXE(NEO),DISP=(SHR)                       00770000
//                                                                      00780000
