      *declare this is a cobol code, named "HW2-FEE-REPORT"
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HW2-FEE-REPORT.

      *read three files, using "LINE SEQUENTIAL" for one data match to one column
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STUDENT-FILE  ASSIGN TO "HW2-Student-Main.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT FEES-FILE     ASSIGN TO "HW2-Fees.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PAYMENT-FILE  ASSIGN TO "HW2-Student-Payment.csv"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

      *set the input data as sting and process as X(n)
       FD STUDENT-FILE.
       01 STUDENT-LINE       PIC X(80).

       FD FEES-FILE.
       01 FEES-LINE          PIC X(40).

       FD PAYMENT-FILE.
       01 PAYMENT-LINE       PIC X(40).

       WORKING-STORAGE SECTION.
      
      *save student id, name, and payment type 
       01 WS-STU-ID          PIC X(10).
       01 WS-STU-NAME        PIC X(30).
       01 WS-STU-TYPE        PIC X(10).

       01 WS-FEE-TYPE        PIC X(10).
       01 WS-FEE-AMT-STR     PIC X(10).
       01 WS-FEE-AMT         PIC 9(7) VALUE 0.

       01 WS-PAY-ID          PIC X(10).
       01 WS-PAY-AMT-STR     PIC X(10).
       01 WS-PAY-AMT         PIC 9(7) VALUE 0.

      *for files EOF
       01 EOF-STU            PIC X VALUE "N".
       01 EOF-FEE            PIC X VALUE "N".
       01 EOF-PAY            PIC X VALUE "N".

       01 TOTAL-RECEIVED     PIC 9(9) VALUE 0.
       01 DUE-AMT            PIC S9(9) VALUE 0.

       PROCEDURE DIVISION.
       
      *open three files as input
       MAIN.
           OPEN INPUT STUDENT-FILE
                INPUT FEES-FILE
                INPUT PAYMENT-FILE
      
      *process all the column, match the payment type, search for how much that student had already paid
           PERFORM UNTIL EOF-STU = "Y"
               READ STUDENT-FILE
                   AT END
                       MOVE "Y" TO EOF-STU
                   NOT AT END
                       PERFORM PARSE-STUDENT
                       PERFORM FIND-FEE
                       PERFORM FIND-PAY
                       COMPUTE DUE-AMT = WS-FEE-AMT - WS-PAY-AMT
                       
      *add total students payment 
                       ADD WS-PAY-AMT TO TOTAL-RECEIVED
                       
      *if paid isn't enough, display
                       IF DUE-AMT > 0
                           PERFORM DISPLAY-RESULT
                       END-IF
               END-READ
           END-PERFORM

           DISPLAY "========================================"
           DISPLAY "TOTAL RECEIVED BEFORE DUE: " TOTAL-RECEIVED
           DISPLAY "========================================"
      
      *close files
           CLOSE STUDENT-FILE
                 FEES-FILE
                 PAYMENT-FILE
           STOP RUN.

      *subprocess
       PARSE-STUDENT.
           UNSTRING STUDENT-LINE
               DELIMITED BY ","
               INTO WS-STU-ID
                    WS-STU-NAME
                    WS-STU-TYPE
           END-UNSTRING.
      *repeatedly reading the payment type file until find the match payment type
       FIND-FEE.
           MOVE 0 TO WS-FEE-AMT
           MOVE "N" TO EOF-FEE
           PERFORM REWIND-FEES
           PERFORM UNTIL EOF-FEE = "Y"
               READ FEES-FILE
                   AT END
                       MOVE "Y" TO EOF-FEE
                   NOT AT END
                       UNSTRING FEES-LINE
                           DELIMITED BY ","
                           INTO WS-FEE-TYPE
                                WS-FEE-AMT-STR
                       END-UNSTRING
                       IF FUNCTION TRIM(WS-FEE-TYPE)
                             = FUNCTION TRIM(WS-STU-TYPE)
                           MOVE FUNCTION NUMVAL(
                               FUNCTION TRIM(WS-FEE-AMT-STR))
                             TO WS-FEE-AMT
                           MOVE "Y" TO EOF-FEE
                       END-IF
               END-READ
           END-PERFORM.

      *close the file and read again
       REWIND-FEES.
           CLOSE FEES-FILE
           OPEN INPUT FEES-FILE.
      
      *find how much the student has paid already, find the only one
       FIND-PAY.
           MOVE 0 TO WS-PAY-AMT
           MOVE "N" TO EOF-PAY
           PERFORM REWIND-PAYS
           PERFORM UNTIL EOF-PAY = "Y"
               READ PAYMENT-FILE
                   AT END
                       MOVE "Y" TO EOF-PAY
                   NOT AT END
                       UNSTRING PAYMENT-LINE
                           DELIMITED BY ","
                           INTO WS-PAY-ID
                                WS-PAY-AMT-STR
                       END-UNSTRING
                       IF WS-PAY-ID = WS-STU-ID
                           MOVE FUNCTION NUMVAL(
                               FUNCTION TRIM(WS-PAY-AMT-STR))
                             TO WS-PAY-AMT
                           MOVE "Y" TO EOF-PAY
                       END-IF
               END-READ
           END-PERFORM.

       REWIND-PAYS.
           CLOSE PAYMENT-FILE
           OPEN INPUT PAYMENT-FILE.

      *display
       DISPLAY-RESULT.
           DISPLAY "ID   : " WS-STU-ID
           DISPLAY "Name : " WS-STU-NAME
           DISPLAY "Type : " WS-STU-TYPE
           DISPLAY "Fee  : " WS-FEE-AMT
           DISPLAY "Paid : " WS-PAY-AMT
           DISPLAY "Due  : " DUE-AMT
           DISPLAY "------------------------------".
