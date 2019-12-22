Pull last non missing variable from a series of variables
Edge cases not tested.

Paul pointed out issues with my original solution, so here are
same fixes.
Thanks, Paul

Note I run using a Win 7 on a power workstation so mileage may vary in the other 6 enhanced SAS platforms.

SAS Forum
https://tinyurl.com/sbbvpa2
https://communities.sas.com/t5/SAS-Data-Management/How-to-pull-last-non-missing-variable-from-a-series-of-variables/m-p/613261

Paul pointed out problems with my original solution

        a. Pauls prefered solution with a minor enhancements
           Paul Dorfman
           sashole@bellsouth.net

        b. Fix original (not solution but related?)

        c. Dosubl

        d. Mark Keintz suggestion    (I programed it, so don't blame Mark)
           Keintz, Mark
           mkeintz@wharton.upenn.edu

        e. Peekclong

        f. Transpose (bonuus with name of last non missing variable

*
__      ___ __  ___
\ \ /\ / / '_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
;

Method e. Failed under wps (peekclong)

see log on end.

SOAPBOX ON

Had difficulty finding the output window, so I used a put
statement. I could find the log.
Would be nice to show a running log and output?

It takes me to much time with the eclipse IDE to test all the other methods.
I program like gamers play games?

SOAPBOX OFF

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;
* I added the '02';
data have ;
  input id stress1 stress5 stress10 stress15 stress20 ;
  put _infile_;
  strs=scan(compress(_infile_,'.'),-1,' ');
  cards ;
1  10   8  .  3   .
2   3   02  .  .   .
3  15   .  .  .  10
;
run ;

Up to 40 obs WORK.HAVE total obs=3

Obs    ID    STRESS1    STRESS5    STRESS10    STRESS15    STRESS20

 1      1       10         8           .           3           .
 2      2        3         2           .           .           .
 3      3       15         .           .           .          10

 *            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

WORK.HAVE total obs=3

  ID    STRESS1    STRESS5    STRESS10    STRESS15    STRESS20    STRS

   1       10         8           .           3           .        3
   2        3         2           .           .           .        2
   3       15         .           .           .          10        10

*          ____             _
  __ _    |  _ \ __ _ _   _| |
 / _` |   | |_) / _` | | | | |
| (_| |_  |  __/ (_| | |_| | |
 \__,_(_) |_|   \__,_|\__,_|_|

;
Paul, I made a very minor change to your solution. Changed f to f3.;

data want ;
  set have ;
  laststress = input (scan (catx (".", of stress:), -1), f3.) ;
run ;

*_         __ _                   _
| |__     / _(_)_  __  _ __  _ __(_) ___  _ __
| '_ \   | |_| \ \/ / | '_ \| '__| |/ _ \| '__|
| |_) |  |  _| |>  <  | |_) | |  | | (_) | |
|_.__(_) |_| |_/_/\_\ | .__/|_|  |_|\___/|_|
                      |_|
;


* even handles leading 0's

data have ;
  input id stress1 stress5 stress10 stress15 stress20 ;
  put _infile_;
  strs=scan(compress(_infile_,'.'),-1,' ');
  cards ;
1  10   8  .  3   .
2   3   02  .  .   .
3  15   .  .  .  10
;
run ;

Up to 40 obs WORK.HAVE total obs=3

Obs    ID    STRESS1    STRESS5    STRESS10    STRESS15    STRESS20    STRS

 1      1       10         8           .           3           .        3
 2      2        3         2           .           .           .        02  ***
 3      3       15         .           .           .          10        10


*             _                 _     _
  ___      __| | ___  ___ _   _| |__ | |
 / __|    / _` |/ _ \/ __| | | | '_ \| |
| (__ _  | (_| | (_) \__ \ |_| | |_) | |
 \___(_)  \__,_|\___/|___/\__,_|_.__/|_|

;

data have ;
  input id stress1 stress5 stress10 stress15 stress20 ;
  put _infile_;
  strs=scan(compress(_infile_,'.'),-1,' ');
  cards ;
1  10   8  .  3   .
2   3   2  .  .   .
3  15   .  .  .  10
;
run ;

* worth noting that this does not work with a temprary file:;
data want;

  if _n_=0 then do; %let rc=%sysfunc(dosubl('
      filename cat catalog "work.test.my.catams" ;
      data _null_; set have; file cat;  put (_all_) ($); run;quit;
      '));
  end;

  infile cat;
  input id stress1 stress5 stress10 stress15 stress20 ;
  strs=scan(compress(_infile_,'.'),-1,' ');

run;quit;


*    _     __  __            _
  __| |   |  \/  | __ _ _ __| | __
 / _` |   | |\/| |/ _` | '__| |/ /
| (_| |_  | |  | | (_| | |  |   <
 \__,_(_) |_|  |_|\__,_|_|  |_|\_\

;

data want;

  if _n_=0 then do; %let rc=%sysfunc(dosubl('
     /* should be fast */
     proc transpose data=have(obs=1) out=havXpo(where=(upcase(_name_)=:"STR"));run;quit;
     proc sort data=havXpo out=havSrt sortseq=linguistic(Numeric_Collation=ON);
        by descending _name_;
     run;quit;
     proc sql ; select _name_ into :names separated by "," from havSrt;quit;
     '));
  end;

  set have;
  last=coalesce(&names);

run;quit;

*                       _        _
  ___   _ __   ___  ___| | _____| | ___  _ __   __ _
 / _ \ | '_ \ / _ \/ _ \ |/ / __| |/ _ \| '_ \ / _` |
|  __/ | |_) |  __/  __/   < (__| | (_) | | | | (_| |
 \___| | .__/ \___|\___|_|\_\___|_|\___/|_| |_|\__, |
       |_|                                     |___/
;

data have ;
  input id stress1 stress5 stress10 stress15 stress20 ;
  put _infile_;
  strs=scan(compress(_infile_,'.'),-1,' ');
  cards ;
1  10   8  .  3   .
2   3   2  .  .   .
3  15   .  .  .  10
;
run ;

data want;

  set have;
  array bac stress:;
  addr=addrlong(bac[1]);
  vars=peekclong(addrlong(bac[1]),8*dim(bac));
  vrs=tranwrd(vars,put(.,rb8.),'');
  l=length(vrs);
  lst=substr(vrs,l-7);
  stres=input(lst,rb8.);
  put stres=;
  keep id str:;

run;quit;

* __    _
 / _|  | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___
| |_   | __| '__/ _` | '_ \/ __| '_ \ / _ \/ __|/ _ \
|  _|  | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/
|_|(_)  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|
                               |_|
;

/* I think the code can be simplified with a were clause instead of the 'data hav1st? */
data want;

  if _n_=0 then do; %let rc=%sysfunc(dosubl('
     /* should be fast */
     proc transpose data=have out=havXpo(where=(not missing(col1)));
       by id;
     run;quit;
     data havvue(rename=col1=stress) /view=havVue;
       set havXpo;
       by id;
       if last.id then output;
     run;quit;
     '));
  end;

  merge have havVue;  /* eliminate previous datastep and disubl it with a where clause */

run;quit;


Up to 40 obs WORK.WANT total obs=3

Obs    ID    STRESS1    STRESS5    STRESS10    STRESS15    STRESS20    STRS     _NAME_     STRESS

 1      1       10         8           .           3           .        3      STRESS15       3
 2      2        3         2           .           .           .        2      STRESS5        2
 3      3       15         .           .           .          10        10     STRESS20      10


