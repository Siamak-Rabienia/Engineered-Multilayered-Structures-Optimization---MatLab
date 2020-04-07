% Script to call a function that computes analytics for varying layer
% sizes. J.B, 7/22/16
clear all; close all; clc;

lays = 20:2:40;
nlays = size(lays,2);

for i = 1:nlays
   lay = lays(i);
   hold on;
   func_hw1_c(lay);
   hold off;
end