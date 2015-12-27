This file contains instructions how to use and understand the run-analysis.R file.

Important note: in order to run the commands, please uncomment the setwd line at the beginning at the file, 
set the path to the "UCI HAR Dataset" directory according to your own settings and run the setwd command.
This stepis also mentioned in the run_analysis.R itself.

run-analysis.R is a file wich is intended for 2 purposes:
- extract and process data
- make this process and the underlying data understandable in terms of correctness and consistency

In order to achieve this, the file includes both processing commands and commands for verifying the result of the processing step: is the data we obtain from a step correct and consistent with the goal?

As I had no time to include automatic checking of the data, wich would yeld a fully automated processing of the data, I recommend you to open the file and execute instruction by instruction. I think that for the purpose of learning and understanding whats going on, this is a more useful way  than running a fully automated script.

The script also contains comments to explain the different steps, as required by good programming practices :-).




  
