% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                                                  
% Initialize - function to initialize concentrations               
%   Arguments :                                                    
%                                                                  
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                                                  
% Generated by KPP - symbolic chemistry Kinetics PreProcessor      
%     KPP is developed at CGRER labs University of Iowa by         
%     Valeriu Damian & Adrian Sandu                                
%                                                                  
% File                 : mech_Initialize.m                         
% Time                 : Thu Jan  1 01:00:00 1970                  
% Working directory    : /proju/wrf-chem/thomas/mechanism-noHalogens
% Equation file        : mech.kpp                                  
% Output root filename : mech                                      
%                                                                  
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function   mech_Initialize ( )

global CFACTOR VAR FIX NVAR NFIX
  
  

   CFACTOR = 1.000000e+00 ;

   x = (0.)*CFACTOR ;
   for i = 1:NVAR
     VAR(i) = x ;
   end

   x = (0.)*CFACTOR ;
   for i = 1:NFIX
     FIX(i) = x ;
   end

% constant rate coefficients                                       
   RCONST(42) = 2.14e-10 ;
   RCONST(58) = 2e-11 ;
   RCONST(59) = 4e-12 ;
   RCONST(65) = 2.5e-22 ;
   RCONST(83) = 2.31e-11 ;
   RCONST(84) = 1.43e-11 ;
   RCONST(85) = 1.36e-11 ;
   RCONST(95) = 3e-12 ;
   RCONST(99) = 1.1e-11 ;
   RCONST(103) = 1e-11 ;
   RCONST(106) = 4.65e-11 ;
   RCONST(108) = 2.05e-10 ;
   RCONST(112) = 1.47e-11 ;
   RCONST(115) = 1e-10 ;
   RCONST(116) = 3e-11 ;
   RCONST(117) = 4.5e-13 ;
   RCONST(120) = 4e-14 ;
   RCONST(121) = 4e-14 ;
   RCONST(122) = 3.2e-11 ;
   RCONST(135) = 1.66e-18 ;
   RCONST(136) = 2e-16 ;
   RCONST(137) = 2e-16 ;
   RCONST(138) = 9e-17 ;
   RCONST(139) = 1e-16 ;
   RCONST(140) = 2.86e-13 ;
   RCONST(144) = 1e-13 ;
   RCONST(147) = 1.22e-11 ;
   RCONST(151) = 3.4e-15 ;
   RCONST(155) = 3.78e-12 ;
   RCONST(156) = 1.06e-12 ;
   RCONST(158) = 2.01e-10 ;
   RCONST(160) = 1000 ;
   RCONST(161) = 1000 ;
   RCONST(162) = 1000 ;
   RCONST(163) = 1000 ;
   RCONST(164) = 1000 ;
   RCONST(165) = 1000 ;
   RCONST(174) = 4e-12 ;
   RCONST(175) = 4e-12 ;
   RCONST(176) = 4e-12 ;
   RCONST(177) = 9e-12 ;
   RCONST(178) = 4e-12 ;
   RCONST(179) = 4e-12 ;
   RCONST(181) = 4e-12 ;
   RCONST(184) = 4e-12 ;
   RCONST(189) = 4e-12 ;
   RCONST(190) = 4e-12 ;
   RCONST(194) = 4e-12 ;
   RCONST(195) = 4e-12 ;
   RCONST(200) = 4e-12 ;
   RCONST(204) = 4e-12 ;
   RCONST(205) = 4e-12 ;
   RCONST(206) = 4e-12 ;
   RCONST(208) = 4e-12 ;
   RCONST(209) = 2e-11 ;
   RCONST(210) = 2e-11 ;
   RCONST(211) = 2.08e-12 ;
   RCONST(229) = 1.5e-11 ;
   RCONST(230) = 1.5e-11 ;
   RCONST(241) = 1e-11 ;
   RCONST(283) = 3.56e-14 ;
   RCONST(321) = 1.2e-12 ;
   RCONST(322) = 1.2e-12 ;
   RCONST(323) = 1.2e-12 ;
   RCONST(324) = 1.2e-12 ;
   RCONST(325) = 1.2e-12 ;
   RCONST(326) = 1.2e-12 ;
   RCONST(327) = 1.2e-12 ;
   RCONST(328) = 1.2e-12 ;
   RCONST(329) = 1.2e-12 ;
   RCONST(330) = 1.2e-12 ;
   RCONST(331) = 1.2e-12 ;
   RCONST(332) = 1.2e-12 ;
   RCONST(333) = 1.2e-12 ;
   RCONST(334) = 1.2e-12 ;
   RCONST(335) = 1.2e-12 ;
   RCONST(336) = 1.2e-12 ;
   RCONST(337) = 1.2e-12 ;
   RCONST(338) = 1.2e-12 ;
   RCONST(339) = 1.2e-12 ;
   RCONST(340) = 4e-12 ;
   RCONST(341) = 4e-12 ;
   RCONST(342) = 1.2e-12 ;
   RCONST(343) = 1.2e-12 ;
   RCONST(344) = 1.2e-12 ;
   RCONST(345) = 1.2e-12 ;
   RCONST(346) = 1.2e-12 ;
   RCONST(347) = 1.2e-12 ;
   RCONST(348) = 1.2e-12 ;
   RCONST(349) = 1.2e-12 ;
   RCONST(350) = 1.2e-12 ;
   RCONST(351) = 1.2e-12 ;
   RCONST(352) = 1.2e-12 ;
   RCONST(353) = 1.2e-12 ;
   RCONST(354) = 1.2e-12 ;
   RCONST(355) = 1.2e-12 ;
   RCONST(356) = 1.2e-12 ;
   RCONST(357) = 1.2e-12 ;
   RCONST(416) = 6.74e-06 ;
   RCONST(417) = 2.2e-05 ;
   RCONST(418) = 2.11e-05 ;
   RCONST(419) = 1.23e-05 ;
   RCONST(420) = 2.5e-12 ;
% END constant rate coefficients                                   

% INLINED initializations                                          

% End INLINED initializations                                      

   VAR = VAR(:);
   FIX = FIX(:);

      
return

% End of Initialize function                                       
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


