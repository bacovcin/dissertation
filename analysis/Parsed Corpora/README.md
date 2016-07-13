# Description

This folder contains the source code to generate ditransitive and heady  data from 
the [Penn Parsed Corpora of Historical English](https://www.ling.upenn.edu/hist-corpora/),
 the [York-Helsinki Parsed Corpus of Early English Correspondence](http://www-users.york.ac.uk/~lang22/PCEEC-manual/index.htm), and
the [York-Toronto-Helsinki Parsed Corpus of Old English Prose](http://www-users.york.ac.uk/~lang22/YcoeHome1.htm).

The queries and the code were constructed by [Hezekiah Akiva Bacovcin](http://www.hakivabacovcin.com/) and 
[Christopher Ahern](http://christopherahern.github.io/).  


# Instructions

## Data

psuedopassives.csv in the data subfolder comes from Einar Siggursson's work on pseudopassives.

Three different types of constructions are investigated:

### Ditransitive Constructions

This set of queries (associated with make-dit.sh) study changes in the realisation of sentences with a recipient and
theme object in English (e.g. "John gave Mary the book").

### Heavy NP Shift

The other two constructions both investigate the rates of "Heavy NP Shift" in the history of English. This construction
occurs when a "heavy" object noun phrase is moved to the right edge of the sentence. The two cases seen here involve moving
the object over either a prepositional phrase (e.g., "I saw in the park the book that I lost last week.", associated with 
make-heavyPP.sh) or an adverb (e.g., "I saw yesterday the book that I lost last week", associated with make-heavyAdv.sh).

## Code

To run the code either download the files as a [ZIP](https://github.com/bacovcin/dissertation/archive/master.zip),
 or clone the repository:

    git clone --recursive https://github.com/bacovcin/dissertation.git

Change directories to the analysis/Parsed Corpora folder in the cloned repository. If all of the corpora required 
(YCOE, PPCME2, PPCEME, PPCMBE2, PCEEC) are all in the same directory, then create a symbolic link to that directory:

    ln -s <directory containing all of the corpora> corpus

If the corpora are located in various directory, then create a corpus directory, change to that directory and
create symbolic links to the root directories of each of the individual corpora:

    mkdir corpus
    cd corpus
    ln -s <location of corpus>
    ...

Then pull in [information](https://github.com/bacovcin/parsedenglish_database/tree/9a049bd27df1d89acd6ddba3eb58169d964c1f14)
 about the documents in the corpus:

    git submodule update --init

Once you've structured the repository, run the make-prep.sh script to do the prep work necessary before any of the three
data generating scripts are run.

    ./make-prep.sh

As a point of reference, `make-prep.sh` takes about 8 minutes to run on a desktop with other applications running:

    time ./make-prep.sh

Then run the script associated with the data you want, which outputs the data to `data/DATATYPE/DATATYPE.txt` 
(where DATATYPE is either dit, heavyPP, or heavyAdv):

    ./make-DATATYPE.sh

As a point of reference, here are the time results for the following scripts:

    time bash make-dit.sh (41min)



## Output

In addition to the information compiled in [this repository](https://github.com/bacovcin/parsedenglish_database/blob/9a049bd27df1d89acd6ddba3eb58169d964c1f14/English_database.txt).
The data will be output to `data/do-support.txt` with the following additional columns:
do.supp	clause	negation
* do.supp : whether or not the token exhibits do-support
* clause : the kind of clause (declarative, question, imperative)
* negation : whether the sentence contains sentential negation or not

Note that these are all defined by the queries in `coding.c`.


# Citation

If you use this repository to generate data, please cite it. More importantly, if you use data generated
from the parsed corpus please cite [the corpora](https://www.ling.upenn.edu/hist-corpora/citing-corpora.html):

> Kroch, Anthony, and Ann Taylor. 2000. The Penn-Helsinki Parsed Corpus of Middle English (PPCME2). Department of Linguistics, University of Pennsylvania. CD-ROM, second edition, release 4. 

> Kroch, Anthony, Beatrice Santorini, and Lauren Delfs. 2004. The Penn-Helsinki Parsed Corpus of Early Modern English (PPCEME). Department of Linguistics, University of Pennsylvania. CD-ROM, first edition, release 3. 

> Kroch, Anthony, Beatrice Santorini, and Ariel Diertani. 2016. The Penn Parsed Corpus of Modern British English (PPCMBE2). Department of Linguistics, University of Pennsylvania. CD-ROM, second edition, release 1.

> Taylor, Ann, Arja Nurmi, Anthony Warner, Susan Pintzuk, and Terttu Nevalainen. 2006. The York-Helsinki Parsed Corpus of Early English Correspondence (PCEEC). Department of Linguistics, University of York. Oxford Text Archive, first edition.

> Taylor, Ann, Anthony Warner, Susan Pintzuk, and Frank Beths. 2003. The York-Toronto-Helsinki Parsed Corpus of Old English Prose (YCOE). Department of Linguistics, University of York. Oxford Text Archive, first edition (http://www-users.york.ac.uk/~lang22/YcoeHome1.htm)

It takes a lot of time and effort to build and annotate historical corpora well, so it's important to acknowledge that hard work. 

# Comments

If you have comments or questions about anything, feel free to email hbacovci@gmail.com.
