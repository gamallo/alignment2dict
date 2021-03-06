# Extractor of Probability Dictionaries from Aligned Parallel Corpora


## Requirements:
* Perl and Bash interperters
* The input must be an aligned parallel text in either tmx or csv format

## Description
This system takes as entry a tmx or csv file with aligned sentences in two languages and extract a probabilistic bilingual dictionary. You can use [Web Align Tookit](http://phraseotext.univ-grenoble-alpes.fr/webAlignToolkit/) to create your aligned sentences in either tmx or csv format.

## How to use

```
Syntax: align2dict <format> <lang1> <lang2>  <file> 
      
      languages = gl, es, en, en_GB, pt,...
      format = tmx, csv
      file = path of the file input 
```

Example of tmx input:
```
sh align2dict.sh tmx en_GB gl tests/en_GB-gl.tmx
```
## How to configure parameters
By default, the system gives 5 similar words per word and only consider those word pairs with appearing in more than 5 segments. You can change the values by editing file `align2dict` and setting variables TOP (number of top similar words) and TH (minimum frequency of word pairs). 

## Output
The output is a plain text file saved in the `./dictioraries` folder

## Authors
ProLNat@GE Group, CiTIUS

University of Santiago de Compostela
