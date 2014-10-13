## filestat ##

A simple script that reports the number and type of files in a specified directory.

Example usage:

```sh
$ ls
filestat.sh  LICENSE.txt  README.md
$ ./filestat.sh -h
Available command line switches are : -a -d <dir> -h -v
$ ./filestat.sh -d .
Total number of files in the target folder: 3
      2 ASCII text
      1 Bourne-Again shell script, ASCII text executable
$ ./filestat.sh -a -d .
Total number of files in the target folder: 3
./LICENSE.txt  ASCII text
./README.md    ASCII text
./filestat.sh  Bourne-Again shell script, ASCII text executable
```
