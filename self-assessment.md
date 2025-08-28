# Final Project Self Assessment

## Automate

**[O] Running the entire analysis requires rendering one Quarto document**

*Entire paper.qmd can be run in one render*

[O] The analysis runs without errors

*No errors in paper.qmd*

**[X] The analysis produces the expected output**

*The NH4 graph still appears weird, a lot of data is missing*

**[O] Data import/cleaning is handled in its own script(s)**

*Data import and cleaning are handled in other scripts*

## Organize

[X] Raw data is contained in its own folder

*All data is still in data folder. Could definitely create raw_data folder.*

[X] Intermediate outputs are created and saved to a separate folder from raw data

*Have yet to create seperate folder.*

**[O] At least one piece of functionality has been refactored into a function in its own file**

*Refactored a function written in spaghetti file, into `moving_average.R` by itself.*

## Document

[O] The repo has a README that explains where to find (1) data, (2) analysis script, (3) supporting code, and (4) outputs

*Meets criteria but could update a little*

**[X] The README includes a flowchart and text explaining how the analysis works**

*Have yet to create a flowchart and include into readme*

**[O] The code is appropriately commented**

*Commented a lot I feel*

**[O] Variable and function names are descriptive and follow a consistent naming convention**

*Variables and functions fit criteria. Could actually change `zapply()` but I kinda like it.*

## Scale

After cloning the repo on Workbench:

[O] Running the environment initialization script installs all required packages

*Don't have a environ_init script but I do install packages in paper.qmd?*

[O] The analysis script runs without errors

*No errors in paper.qmd*
