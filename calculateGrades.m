close all; clear all;

load('classGrades.mat');
namesAndGrades(1:5, 1:size(namesAndGrades,2))
grades = namesAndGrades(1:15, 2:size(namesAndGrades,2));
meanGrades = mean(grades)
meanGrades = nanmean(grades)


meanMatrix = ones(15, 1)*meanGrades
curvedGrades = 3.5*(grades ./ meanMatrix);
nanmean(curvedGrades)

indices = find(curvedGrades > 5);
curvedGrades(indices) = 5;


totalGrade = ceil(nanmean(curvedGrades, 2));

letters = ['F' 'D' 'C' 'B' 'A'];
letterGrades = blanks(15);
disp(['Grades: ', letters(totalGrade)]);