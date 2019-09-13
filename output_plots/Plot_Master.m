%--------------------------------------------------------------------------------------
 % Output Plotting Routines for
 % Platform for Atmospheric Chemistry and Transport in 1D 
 %
 % 
 % Developed by:
 % 
 % Katie Tuite: ktuite@ucla.edu
 % Jochen Stutz: jochen@atmos.ucla.edu
 % Jennie L. Thomas: jennie.thomas@univ-grenoble-alpes.fr
 %
 % Version 1.0
 % Last updated: September 13, 2019
 %
 % Comment out routines you don't want to use
 % Specific Routines and the output PDF's are in indivual folders
 % 
 % --------------------------------------------------------------------------------------

clear all
close all

 %----------------------------------------------------------------------

% Plotting reaction Rates
% PDF's are named after species name
% Name has to have leading and trailing spaces !!!!!
% Plots are sorted according to decending reacgtion rate maximum

cd('RxnRate_3D');
Plot3D_RXN(' HCHO ','*HCHO');
cd('../');


%---------------------------------------------------------------------
% Plot unsorted Species above a threshold of 100 molec per cc
% PDFs in directory SpecAll_3D 

cd('SpecAll_3D');
run('plot_SpecAll_3D_V2.m');
cd('../');


%---------------------------------------------------------------------
% Plot unsorted Species above a threshold of 100 molec per cc
% PDFs in directory SpecAll_3D 

plot_lev = [5 7 9 11 14];     % array with altitudes to be plotted
cd('SpecAll_alt');
PlotTraceAll(plot_lev);
cd('../');


% %---------------------------------------------------------------------
% Plot sorted Species above a threshold of 100 molec per cc
% The following structure defines the pages that will be plotted
%.Name is the filename of the PDF
% .Spec is the arry of a maximum of 8 species
% note that the x-axis is only labeled in plots 7 and 8 on the page

PlotStruct(1).Name={'Main'};
PlotStruct(1).Spec = {'O3','HO','HO2','H2O2','HCHO','CO','SO2'};
PlotStruct(2).Name={'NOx'};
PlotStruct(2).Spec = {'NO','NO2','NO3','N2O5','HONO','HNO3','HNO4','PAN'};
PlotStruct(3).Name={'HC'};
PlotStruct(3).Spec = {'ETH','HC3','HC5','HC8','ISO','LIM','TOL'};

% %-----------------------------------------------------------
% % Sorted 3D plot

 cd('SpecInd_3D');
 Plot3D_Ind(PlotStruct);
 cd('../');


%-----------------------------------------------------------
% Sorted trace plot at levels defined in plot_lev

plot_lev = [5 7 9 11 14];

cd('SpecInd_alt');
PlotTrace_Ind(PlotStruct,plot_lev);
cd('../');


% %------------------------------------------------------------
% 3D plot of all emissions above a certain threshold

cd('EmAll_3D');
run('plot_EmAll_3D_V2.m');
cd('../');


