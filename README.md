My experiment looks at eye fixation patterns as a specific portion of a particular sentence unfolds in a given trial. The independent variables are the four conditions (yielded by which part-of-speech is used in the given sentence (NP vs pronoun) × whether the second sentence mentions a new object or a previously-mentioned object (new vs. same)), which are split into the following conditions:

1. Noun phrase - new 
2. Noun phrase - same 
3. Pronoun - new 
4. Pronoun - same 

Note that condition 3 is the ambiguous condition, and I'm ultimately looking to see whether participants looked at the new or previously-mentioned object in that condition. The dependent variable is eye fixation patterns. Before I jump into the main measures, I will compute some summary measures: probability of fixation over time per condition and mean probability per condition. Then, I will compute the following measures for my main analyses: reaction time, whether the previously-mentioned object was chosen, and probability of fixation to the previously-mentioned object over time.

I've already begun looking at some of my preliminary data, so this is largely executable code. A lot of my clean-up and pre-analysis is done in Excel. This is because my experiment is built in ExperimentBuilder, and data extraction is done via DataViewer. The output format of the data is in .txt format, and I save it as a .csv and pivot tables / export that data to R.

Please make sure to download the two .csv files!
