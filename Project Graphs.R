project <- read_csv("~/Documents/Stanford/SOC 381/Project/Project Dataset.csv")
library(ggplot2)
library(tidyverse)
library(dplyr)

##histogram 1: counselors per 100 students
ggplot(project) + 
  geom_histogram(fill = "darkcyan",
                 aes(x = counselors_per_student))+
  labs(x = "Full-Time School Counselors per 100 Students", 
       y = "School Count",
       title = "Figure 1. Number of Full-Time Counselors Employed\nper 100 Students Enrolled", 
       subtitle = "Source: Civil Rights Data Collection (2017)") +
  theme_classic()+ 
  theme(axis.text.x = element_text(color = "gray26", size = 9),
        plot.title = element_text(color = "gray26", size = 14),
        plot.subtitle = element_text(color = "gray26", size =12),
        axis.text.y = element_text(color = "gray26", size = 9),
        axis.title.x = element_text(color = "gray26", size = 12),
        axis.title.y = element_text(color = "gray26", size = 12))+
  scale_x_continuous(breaks=c(0, .5, 1, 1.5, 2, 2.5, 3),
                     labels=c("0","0.5","1","1.5","2","2.5", "3"))

##histogram 2: suspensions per 100 students
ggplot(project) + 
  geom_histogram(fill = 'darkolivegreen3',
                 aes(x = suspension_rate))+
  labs(x = "Out-of-School Suspensions per 100 Students", 
       y = "School Count",
       title = "Figure 2. Number of Out-of-School Suspensions\nper 100 Students Enrolled", 
       subtitle = "Source: Civil Rights Data Collection (2017)") +
  theme_classic()+ 
  theme(axis.text.x = element_text(color = "gray26", size = 9),
        plot.title = element_text(color = "gray26", size = 14),
        plot.subtitle = element_text(color = "gray26", size =12),
        axis.text.y = element_text(color = "gray26", size = 9),
        axis.title.x = element_text(color = "gray26", size = 12),
        axis.title.y = element_text(color = "gray26", size = 12))+
  scale_x_continuous(breaks=c(0, 25, 50, 75, 100, 125),
                     labels=c("0","25","50","75","100","125")) 