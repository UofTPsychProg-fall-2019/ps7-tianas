# NOTE ON READING THE DATA:
# We excluded all data under 200 ms in order to minimize outliers/null data as saccadic movements do not happen prior to 200 ms.
# Bins are 50 ms each starting from the sentential description onset point (i.e., "Move the [DESC_ONSET] other house...")
# "PMO" stands for "previously-mentioned object", which is synonymous with the "same" condition level. This is also
# what we expect people to look at in all but the NP-new condition (in which they're told to "move the OTHER object")

# Data & Libraries --------------------------------------------------------

df <- read.csv("~/Downloads/emdata.csv")

library(ggplot2)
library(car)
library(rpivotTable)
library(dplyr)
library(emmeans)


# 1. Probability of Fixation ----------------------------------------------

# Note that these pivot tables are included to emulate how I will pivot the data in Excel before I import the pivoted data into R for analysis.
# I like using the rpivotTable package, but it doesn't include a function to export the data into a data frame, rendering the outcome a bit pointless
# beyond a quick look at the data. When I'm actually visualizing my data, I will stick with the Excel --> import to R method.

## pivot table to look at probability of fixation over time:

df %>%
  tbl_df %>%
  filter( ANTIC == 0) %>%
  rpivotTable(rows="BIN_INDEX", 
              cols=c("nptype","givennew"), 
              aggregatorName="Average", 
              vals ="AVERAGE_IA_7_SAMPLE_COUNT_.", 
              rendererName="Table"
              )

## make a quick chart to look at the data!

df %>%
  tbl_df %>%
  filter( ANTIC == 0) %>%
  rpivotTable(rows=c("nptype","givennew"), 
              cols="BIN_INDEX", 
              aggregatorName="Average", 
              vals ="AVERAGE_IA_7_SAMPLE_COUNT_.", 
              rendererName="Line Chart"
  )


# 2. Mean Measurements ----------------------------------------------------

## pivot table to look at mean fixation to the PMO probability per condition

df %>%
  tbl_df %>%
  filter( ANTIC == 0, BIN_INDEX < 10) %>%
  rpivotTable(cols=c("nptype","givennew"), 
              aggregatorName="Average", 
              vals ="AVERAGE_IA_7_SAMPLE_COUNT_.", 
              rendererName="Table"
  )

## plotting the averages to look at probability of fixating on the previously-mentioned object
## note: this is just a quick look. When I actually visualize my data, I'll include error bars!

df %>%
  tbl_df %>%
  filter( ANTIC == 0, BIN_INDEX < 10) %>%
  rpivotTable(cols=c("nptype","givennew"), 
              aggregatorName="Average", 
              vals ="AVERAGE_IA_7_SAMPLE_COUNT_.", 
              rendererName="Bar Chart"
  )


# 3. Main Analyses: ANOVAs ------------------------------------------------

# the main analyses will operate on a condensed data file.
# this file contains information for eleven participants and their averages along
# different measurements per each condition (4), yielding 44 observations.
# this data contains the following information:
# - condition
# - part of speech (i.e., whether it's NP or pronoun)
# - object (i.e., whether they're expeceted to select the new object or PMO)
# - rt (i.e., reaction time)
# - selobj_same (whether PMO was chosen; a value of 1 indicates that they did)
# - fixation_same (proportion of fixations on PMO)

data <- read.csv("~/Downloads/exp1data.csv")

# and now, the ANOVAs!

## reaction time
anova(lm(rt ~ partofspeech*object, data))

## note: type III Anova function used on all of these as well to find intercept
Anova(lm(rt ~ partofspeech * object, data=data, contrasts=list(partofspeech=contr.sum, object=contr.sum)), type=3)


# choosing previously-mentioned object
anova(lm(selobj_same ~ partofspeech*object, data))

Anova(lm(selobj_same ~ partofspeech * object, data=data, contrasts=list(partofspeech=contr.sum, object=contr.sum)), type=3)


# probability of fixation on previously-mentioned object
anova(lm(fixation_same ~ partofspeech*object, data))

Anova(lm(fixation_same ~ partofspeech * object, data=data, contrasts=list(partofspeech=contr.sum, object=contr.sum)), type=3)


# 4. Main Analyses: Contrast Coding ---------------------------------------

# I will do some orthogonal contrast coding with my data.
# For now, here is how I'd go about cross-checking some of the data.

data$pronoun[0:23] <- -1
data$pronoun[23:44] <- 1

data$newObj[0:44] <- 1
data$newObj[12:44] <- -1
data$newObj[23:44] <- 1
data$newObj[34:44] <- -1

# add to table and reorganize

data$interaction <- (data$pronoun)*(data$newObj)

anova(lm(fixation_same ~ pronoun*newObj, data))


# 5. Main Analyses: Reaction Time, Plotted --------------------------------

## I'll follow up my analyses with some plots to portray the data.

ggplot(data, aes(x = partofspeech, y = rt, colour = object, fill=object)) +
  stat_summary(fun.y = mean, geom = "bar", position = "dodge", alpha=.2) +
  geom_point(position = position_jitterdodge(), alpha=.4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", 
               width = .1, position = position_dodge(width = .9))+
  theme_bw() +
  labs(x="Part-of-speech", y=expression(paste("Reaction time")), title="RT vs. part-of-speech, by object condition") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.title = element_text(face="bold"))


# 6. Main Analyses: PMO Selection, Plotted --------------------------------

ggplot(data, aes(x = partofspeech, y = selobj_same, colour = object, fill=object)) +
  stat_summary(fun.y = mean, geom = "bar", position = "dodge", alpha=.2) +
  geom_point(position = position_jitterdodge(), alpha=.4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", 
               width = .1, position = position_dodge(width = .9))+
  theme_bw() +
  labs(x="Part-of-Speech", y=expression(paste("Choosing PMO (1=yes)")), title="Choosing PMO vs. part-of-speech, by object condition") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.title = element_text(face="bold"))


# 7. Main Analyses: Probability of Fixation on PMO, Plotted ---------------

# note: I consider this to be my main DV.

ggplot(data, aes(x = partofspeech, y = fixation_same, colour = object, fill=object)) +
  stat_summary(fun.y = mean, geom = "bar", position = "dodge", alpha=.2) +
  geom_point(position = position_jitterdodge(), alpha=.4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", 
               width = .1, position = position_dodge(width = .9))+
  theme_bw() +
  labs(x="Part-of-Speech", y=expression(paste("Probability of fixation on PMO")), title="Fixation on PMO vs. part-of-speech, by object condition") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.title = element_text(face="bold"))


# 8. Pairwise Comparisons -------------------------------------------------

data.lm <- lm(fixation_same ~ partofspeech * object, data = data)
anova(data.lm)

## visualize to see if there are interactions

emmip(data.lm, partofspeech ~ object)

## and finally, pairwise comparisons
emmeans(data.lm, pairwise ~ partofspeech)

emmeans(data.lm, pairwise ~ object)

# at this point, I will have exported this data in an Rmd file for initial analysis with my team!
