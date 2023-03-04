# rcvnavigator
Uses a command line interface (CLI) to navigate to desired verse in Recovery Version (https://text.recoveryversion.bible/) or its App counterpart: Holy Bible (Recovery Version) (https://www.recoveryversion.bible/app/)

In a CLI (e.g. Terminal), ```source``` the ```rl.sh``` file (e.g. ```source rl.sh```) OR include ```rl.sh``` in your ```~/.zshrc``` file (i.e. ```. ~/rl.sh```).

Then enter ```rl``` followed by a space and a desired Bible verse reference.

Possible commands for Romans 8:11 (for the app[^1]):
```
rl Romans 8:11
rl Rom. 8:11
rl rom 8:11
rl rom 8 11
```
```rl``` can be replaced with ```rw``` to look up the verse via a default browser instead:
```
rw Romans 8:11
rw rom 8 11
```
[^1]: As of 3/3/2023, when the app first opens, it opens to the last verse visited before closing the app instead of to your requested verse. You can simply enter the command again in the CLI once the app is open to navigate to the desired verse.
