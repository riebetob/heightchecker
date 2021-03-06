# Script for simple function that checks the difference in height from the sex-
# specific mean for each of the students in the given dataframe
# Date: 24.10.2017
# Author: Jann Goschenhofer

library(dplyr)

#Initialize the data frame
age = c(19, 22, 21, 23, 22, 20, 28, 25)
weight = c(50, 75, 80, 56, 75, 58, 65, 82)
height = c(1.66, 1.78, 1.90, 1.72, 1.83, 1.68, 1.70, 1.85)
sex = c("F", "M", "M", "F", "M", "F", "F", "M")

students = data.frame(cbind(age, weight, height, sex))
students = transform(students, age = as.numeric(as.character(age)))
students = transform(students, height = as.numeric(as.character(height)))
students = transform(students, weight = as.numeric(as.character(weight)))

students$name = c("Maria", "Franz", "Peter", "Lisa", "Hans", "Eva", "Mia", "Karl")
#Use a dataframe containing the information about the students as input
checkHeight3 <- function(students.input = students){
  #Calculate the gender specific means
  women_mean_height = as.numeric(students %>%
                             group_by(sex) %>%
                             summarise(mean(height)) %>%
                             filter(sex == "F") %>%
                             select("mean(height)"))
  men_mean_height = as.numeric(students %>%
                                   group_by(sex) %>%
                                   summarise(mean(height)) %>%
                                   filter(sex == "M") %>%
                                   select("mean(height)"))
  #initialize an empty vector to save the genderspecific height differnces
  height_vector = c() 
  #apply a function to the rows of the input dataframe 
  height_vector = apply(students, MARGIN = 1, 
    FUN = function(student){
    #substract the gender specific means from the individuals to get height differnces
    (if (student["sex"] == "M") men_mean_height - as.numeric(student["height"]) 
    else women_mean_height - as.numeric(student["height"]) ) 
    } ) 
  #create the final dataframe containing name od the students and the height differnces 
  #multiple height differences by 100 to get values in cm
  result.frame = data.frame("name" = students$name, "sexspec_height_diff" = height_vector*100)
  #return the dataframe
  return(result.frame)
}

checkHeight3(students.input = students)
