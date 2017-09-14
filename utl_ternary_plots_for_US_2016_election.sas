Create Ternary Diagrams: An Example Using 2016 Presidential Polling Data

  SAS Jmp supports Ternary diagrams but not Classic SAS?

  Ternary diagrams and a nice way to plot 3D data in 2D..
  Especially useful when the x+y+z=constant? In political polling the sum is 100%.

  WORKING CODE
    IML/R WPS/Proc-R

       plot <- ggtern(data = have, aes(x = TRUMP, y = CLINTON, z = JOHNSON_STEIN)) +
       geom_point(aes(fill = DATE),size = 6,shape = 21,color = "black") +
       ggtitle("2016 U.S. Presidential Election Polls") +
       labs(fill = "DATE") +
       theme_custom(
         base_size = 12, base_family = "",
         tern.plot.background = NULL, tern.panel.background = NULL,
         col.T = "blue", col.L = "green", col.R = "red",col.grid.minor = "white") +
       theme(legend.position = c(0,1),legend.justification = c(1, 1));

  see
   https://goo.gl/eGqgs1
   https://www.r-bloggers.com/using-r-to-create-ternary-diagrams-an-example-using-2016-presidential-polling-data/


 HAVE
 =====

  Poll Results for Clinton, Trump and combined Johnson Stein.

   sd1.have total obs=7

   Obs      DATE      CLINTON    TRUMP    JOHNSONSTEIN

    1     9Aug2016       78         8          14
    2     8Aug2016       58        19          23
    3     7Aug2016       48         8          44
    4     6Aug2016       32        31          37
    5     5Aug2016       30        20          50
    6     4Aug2016        9        42          49
    7     3Aug2016       16        36          48


WANT
====

  Two points plotted

               CLINTON    TRUMP    JOHNSONSTEIN

     9Aug2016      78         8          14
     7Aug2016      48         8          44

   How to plot Clinton on on 7AUG2017

     1. Find the value of 48% on the Clinton axis
     2. Follow the diagonal lines to the other axes to
        get Trump and JohnsonStein vote percent estimates



                      0%
                   8%   100%                    Clinton   Trump  Johnstein
               Trump  /\
               ====  /\ \  78% ==>     9Aug2016    78%      8%     14%
                    /  @-\        =======
     =====     25% /------\ 75%   Clinton
     Trump        /\  / \ /\      =======
     =====       /  \/   /  \
                /   /\  / \  \ 50%
           50% /------\/---\--\         7Aug2016   48%      8%     14%
              /\  /   /\    @- \ 48%
             /  \/   /  \  /  / \
            /   /\  /    \/  /   \
           /   /  \/     /\ /     \
      75% / ------/\------ /-------\ 25%
         /\  /   /  \  /  / \      /\
        /  \/   /    \/  /   \    /  \      3AUG
       /   /   /     /\ /     \  /    \
   100%+__/_ _/_____/_ +_______\/______+ 0%
     0%    25%      50%     75%       100%

        14%        44%
                =============
                Johnson Stein
                =============

 *                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
informat date $10.;
input date$ clinton trump johnsonstein;
jit=int(8*uniform(5732));
if mod(_n_,2)=0 then do;
   clinton=clinton-3*jit;
   trump=trump+1*jit;
   johnsonstein=johnsonstein+2*jit;
end;
else do;
   clinton=clinton-2*jit;
   trump=trump-2*jit;
   johnsonstein=johnsonstein+4*jit;
end;
cards4;
9Aug2016 80 10 10
8Aug2016 70 15 15
7Aug2016 60 20 20
6Aug2016 50 25 25
5Aug2016 40 30 30
4Aug2016 30 35 35
3Aug2016 20 40 40
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;


%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
library(ggtern);
library(ggplot2);
have<-read_sas("d:/sd1/have.sas7bdat");
have$DATE<-as.factor(have$DATE);
have;
str(have);
pdf("d:/pdf/polls.pdf",12,8);
plot <- ggtern(data = have, aes(x = TRUMP, y = CLINTON, z = JOHNSONSTEIN)) +
geom_point(aes(fill = DATE),size = 6,shape = 21,color = "black") +
ggtitle("2016 U.S. Presidential Election Polls") +
labs(fill = "DATE") +theme_bvbw() + theme(legend.position = c(0,1),legend.justification = c(1, 1));
plot;
endsubmit;
');


/*
The WPS System

# A tibble: 7 × 5
      DATE CLINTON TRUMP JOHNSONSTEIN   JIT
    <fctr>   <dbl> <dbl>        <dbl> <dbl>
1 9Aug2016      78     8           14     1
2 8Aug2016      58    19           23     4
3 7Aug2016      48     8           44     6
4 6Aug2016      32    31           37     6
5 5Aug2016      30    20           50     5
6 4Aug2016       9    42           49     7
7 3Aug2016      16    36           48     2
Classes 'tbl_df', 'tbl' and 'data.frame':	7 obs. of  5 variables:
 $ DATE        : Factor w/ 7 levels "3Aug2016","4Aug2016",..: 7 6 5 4 3 2 1
 $ CLINTON     : num  78 58 48 32 30 9 16
 $ TRUMP       : num  8 19 8 31 20 42 36
 $ JOHNSONSTEIN: num  14 23 44 37 50 49 48
 $ JIT         : num  1 4 6 6 5 7 2
*/

