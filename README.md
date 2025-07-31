# autoripper
A bash script necessary to create an automated CD ripping machine.<br>
This made it much easier for me to backup my CD collection.<br>

Tested on Debian 12.<br>

This won't work at all on Windows.

# the janky broken stuff
- Currently if you kill the script while it is ripping by exiting with q, or CTRL+C,
any abcde processes still running in the background will remain running.
- If abcde fails for whatever reason, it won't automatically eject the drive, so
you may have to monitor the output to check for failed processes.

# how to use
1. Clone the repo.
2. Make sure you have all the dependencies installed.
3. Run ```install.sh```
4. Run ```autoripper.sh```
5. happy burning!
<br>
The abcde log files that are created while the script is running will always grow in size,
as the previous outputs are kept for debugging. Delete them once in a while if they get too large.

# dependencies (software)
- abcde
- flac
- gcc (for compiling drivestatus)

# dependencies (hardware)
- A computer with at least one CD-ROM drive. 
