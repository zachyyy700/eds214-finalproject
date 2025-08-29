# Exceeds spec

## [] Running the entire analysis requires rendering one Quarto document

I believe my Quarto doc does run by itself but I also made it super concise and referenced to other folders like `R` folder if the reader would like to learn about the details more.

**NOTE:** The two exceeds specs have to be in different learning objectives

## [] Data import/cleaning is handled in its own script(s)

In relation to the first one, I have one R script called `dataimport_cleaning.R`, in the `R` folder. I felt that keeping it very concise would be best, keeping it separate from all the other R scripts used. This also made it really easy to follow I think.

# Collaboration
1. The feedback went well. I received good feedback telling me my qmd was great but would've liked more constructive stuff. For reviewing a peer, I was able to help them make their qmd more concise and less code-y.
2. 
- https://github.com/zachyyy700/eds214-finalproject/issues/3
- https://github.com/zachyyy700/eds214-finalproject/issues/5
- https://github.com/zachyyy700/eds214-finalproject/issues/4


[Merge conflict:](https://github.com/zachyyy700/eds214-finalproject/commit/ba63f241c851f873028e98b0d370beb054ac9bf1)

# Instructor feedback

## Automate

[E] **Running the entire analysis requires rendering one Quarto document**

- Fantastic work! Very clean and concise. Well done!

[M] The analysis runs without errors

[M] **The analysis produces the expected output**

[M] **Data import/cleaning is handled in its own script(s)**

## Organize

[M] Raw data is contained in its own folder

[NY] Intermediate outputs are created and saved to a separate folder from raw data

- data/ should contain raw data. Outputs should go in a separate (not nested) folder called outputs/.

[NY] **At least one piece of functionality has been refactored into a function in its own file**

- The R/ directory should *only* contain function definitions. Move other types of scripts elsewhere.

## Document

[M] The repo has a README that explains where to find (1) data, (2) analysis script, (3) supporting code, and (4) outputs

[M] **The README includes a flowchart and text explaining how the analysis works**

[M] **The code is appropriately commented**

[M] **Variable and function names are descriptive and follow a consistent naming convention**

## Scale

After cloning the repo on Workbench:

[M] Running the environment initialization script installs all required packages

[M] The analysis script runs without errors

## Collaborate

**NOTE:** Talk to me about these three - let's come up with a solution since you were out sick for a day.

[NY] **The student has provided attentive, constructive feedback in a peer review**

[NY] **The student has contributed to a peer's repo by opening an issue and creating a pull request**

[NY] The repo has at least three closed GitHub issues

[M] The commit history includes at least one merged branch and a resolved merge conflict

[M] The rendered analysis is accessible via GitHub Pages
