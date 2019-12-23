# utl_Pull-last-non-missing-variable-from-a-series-of-variables
    Pull last non missing variable from a series of variables
    Edge cases not tested.

    github
    https://tinyurl.com/szs52fm
    https://github.com/rogerjdeangelis/utl_Pull-last-non-missing-variable-from-a-series-of-variables

    Note: I run using a Win 7 on a power workstation so mileage may vary in the other 5 enhanced editors.

    SAS Forum
    https://tinyurl.com/sbbvpa2
    https://communities.sas.com/t5/SAS-Data-Management/How-to-pull-last-non-missing-variable-from-a-series-of-variables/m-p/613261

    Paul pointed out problems with my original solution

            a. Pauls solution with a minor enhancement
               Paul Dorfman
               sashole@bellsouth.net
               Also more robust solution by Mark Keintz in g.
               Keintz, Mark
               mkeintz@wharton.upenn.edu

            b. Fix original (not solution but related?)

            c. Dosubl

            d. Mark Keintz suggestion    (I programed it, so don't blame Mark)
               Keintz, Mark
               mkeintz@wharton.upenn.edu

            e. Peekclong

            f. Transpose (bonuus with name of last non missing variable

            g. More robust solution by Mark, Handles more types of missings.
               Keintz, Mark
               mkeintz@wharton.upenn.edu

            h. Salient comments by Paul Dorfam
               Paul Dorfman
               sashole@bellsouth.net

            i. Transtrn instead og tranwrd to eliminate embeded blanks


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

    %symdel names / nowarn;
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

    *                     _
    __      ___ __  ___  | | ___   __ _
    \ \ /\ / / '_ \/ __| | |/ _ \ / _` |
     \ V  V /| |_) \__ \ | | (_) | (_| |
      \_/\_/ | .__/|___/ |_|\___/ \__, |
             |_|                  |___/
    ;


    NOTE: Data set "WORK.have" has 3 observation(s) and 7 variable(s)
    NOTE: The data step took :
          real time : 0.012
          cpu time  : 0.015


    73        1  10   8  .  3   .
    74        2   3   2  .  .   .
    75        3  15   .  .  .  10
    76        ;
    77        run ;
    78
    79        data want;
    80
    81          set have;
    82          array bac stress:;
    83          addr=addrlong(bac[1]);
    84          vars=peekclong(addrlong(bac[1]),8*dim(bac));
    85          vrs=tranwrd(vars,put(.,rb8.),'');
    86          l=length(vrs);
    87          lst=substr(vrs,l-7);
    88          stres=input(lst,rb8.);
    89          put stres=;
    90          keep id str:;
    91        run;

    stres=3
    stres=.
    stres=10
    NOTE: 3 observations were read from "WORK.have"
    NOTE: Data set "WORK.want" has 3 observation(s) and 8 variable(s)
    NOTE: The data step took :
          real time : 0.013
          cpu time  : 0.015


    91      !     quit;
    92        quit; run;
    93        ODS _ALL_ CLOSE;

    *          __  __            _                _               _
      __ _    |  \/  | __ _ _ __| | __  _ __ ___ | |__  _   _ ___| |_
     / _` |   | |\/| |/ _` | '__| |/ / | '__/ _ \| '_ \| | | / __| __|
    | (_| |_  | |  | | (_| | |  |   <  | | | (_) | |_) | |_| \__ \ |_
     \__, (_) |_|  |_|\__,_|_|  |_|\_\ |_|  \___/|_.__/ \__,_|___/\__|
     |___/
    ;

    data have;
      x1=1;
      x2=2;
      do x3=2,1.5,.,.A; output; end;
    run;

    Up to 40 obs WORK.HAVE total obs=4

    Obs    X1    X2     X3

     1      1     2    2.0
     2      1     2    1.5
     3      1     2     .
     4      1     2     A


    * handles multiple types of missings;
    data want(keep=x1 x2 x3 last_non_missing);
      set have;
      last_non_missing=coalesce(x3,x2,x1);
      scn=input (scan (catx (".", of x:), -1),?? f.) ;
      put (x:) (=)  @19 last_non_missing=  @29 scn=;
    run;

    Up to 40 obs WORK.WANT total obs=4

                              LAST_NON_
    Obs    X1    X2     X3     MISSING

     1      1     2    2.0       2.0
     2      1     2    1.5       1.5
     3      1     2     .        2.0
     4      1     2     A        2.0

    *_         ____             _                                            _
    | |__     |  _ \ __ _ _   _| |   ___ ___  _ __ ___  _ __ ___   ___ _ __ | |_
    | '_ \    | |_) / _` | | | | |  / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \ '_ \| __|
    | | | |_  |  __/ (_| | |_| | | | (_| (_) | | | | | | | | | | |  __/ | | | |_
    |_| |_(_) |_|   \__,_|\__,_|_|  \___\___/|_| |_| |_|_| |_| |_|\___|_| |_|\__|

    ;
    Mark,

    'Tis true. One thing I think the feline functions lack is a sensor that would listed
    to which format to use for automatic num-2-char conversion. Suppose, for instance,
     that there were a SAS option - let's call it provisionally CATFMT -
    that could be set to a desired format. Then one could set it to CATFMT=HEX16 and code:

      laststress = input (scan (catx (".", of stress:), -1), hex16.) ;

    since the HEX16. format renders the standard missing value as a period. As I've said, I
    prefer your solution, especially since it handles special missing
    values to boot (the one above wouldn't).

    Back to the issue of feline auto-format choice, having it would be good in a
    number of aspects. For example, when a CAT is done for the sole purpose of
    MD5-ing a composite mixed-type key, using RB8 would be better than W.
    since it's much faster and always exactly precise. A couple of year ago at the SGF I
    asked Rick Langston (Don H. can testify as a witness) if the functionality could be added,
    and the answer was "sure". Too bad Rick retired soon thereafter.


    *_     _                       _
    (_)   | |_ _ __ __ _ _ __  ___| |_ _ __
    | |   | __| '__/ _` | '_ \/ __| __| '_ \
    | |_  | |_| | | (_| | | | \__ \ |_| | | |
    |_(_)  \__|_|  \__,_|_| |_|___/\__|_| |_|

    ;
    data have ;
      input id stress1 stress5 stress10 stress15 stress20 ;
      cards ;
    1  10   8  .  3   .
    2   3   02  .  .   .
    3  15   .  .  .  10
    ;
    run ;

    data want;
     set have;
     array nums[*] str:;
     lastNonMissing=.;
     chrBin=peekclong(addrlong(nums[1]),dim(nums)*8);
     chrBin=transtrn(chrBin,put(.,rb8.),trimn(''));        /* improvement */
     call pokelong(substr(chrBin,lengthn(chrBin)-7,8),addrlong(lastNonMissing));
     drop chrBin;
    run;quit;







