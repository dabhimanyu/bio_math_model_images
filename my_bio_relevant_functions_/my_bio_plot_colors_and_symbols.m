function data = my_bio_plot_colors_and_symbols(U_profile_Avg  , Re)


data.color{01}          =       'b' ; 

data.color{02}          =       [1.0 , 0.47 , 1.00 ]   ; % Fushia Pink
data.color{03}          =       [0.0 , 0.50 , 1.00 ]   ; % A variant of Blue Color:
data.color{04}          =       [0.0 , 0.80 , 0.60 ]   ; % Caribbean green 
data.color{05}          =       [0.8500 0.3250 0.0980] ;  % Orange, Second Color Option in plot command  % 15 % 'r' ; %[0.8 , 0.50 , 0.20 ]   ; % Bronze
data.color{06}          =       [0.4940 0.1840 0.5560] ; % Violet    % [0.8500 0.3250 0.0980] ;  % Orange, Second Color Option in plot command 
                              % [0.9290 0.6940 0.1250] ;    %[0.53, 0.66 , 0.42 ]   ; % DARK RED
data.color{07}          =       [0.9290 0.6940 0.1250] ; % [0.4940 0.1840 0.5560] ;          % [0.0 , 0.29 , 0.29 ]   ; % Deep Jungle Green
data.color{08}          =       [0.3600 0.5400 0.6600] ;  % Electric Lavender  % [0.6 , 0.40 , 0.80 ]   ; % % Amethyst- A variant of Violet  
data.color{09}          =       [1.0  , 0.60 , 0.40 ]  ; % Atomic tangerine - A variant of face color
data.color{10}          =       [0.2300 0.2700 0.2900] ;  % Arsenic % 12 % [0.85  0.325  0.098] ; % [0.0 , 0.50 , 0.50 ]   ; % Teal   07


% data.color{11}          =       [1.0 , 0.77 , 0.05 ]   ; % Mikado yellow
data.color{11}          =       [0.4940 0.1840 0.5560] ; % Violet 
data.color{12}          =       [0.3010 0.7450 0.9330] ;  % Dark Sky blue
% data.color{12}          =       [0.2300 0.2700 0.2900] ;  % Arsenic % 12
data.color{13}          =       [1 , 0 , 0.5 ]         ;  % Bright Pink
% data.color{15}          =       [0.8500 0.3250 0.0980] ;  % Orange, Second Color Option in plot command  % 15 
%  




%% Arranging colors for particle laden plots:

% % data.color{02}          =       [0.0 , 0.50 , 1.00 ]     ; 
% % data.color{03}          =       [0.8500 0.3250 0.0980]   ; % Matlab's 2nd choice
% % data.color{04}          =       [0.8500 0.3250 0.0980]   ; 
% data.color{2}   =    [0.0 , 0.50 , 1.00 ]  ;      
% data.color{3}   =    [0.0 , 0.50 , 1.00 ]  ; 
% data.color{4}   =    [0.8500 0.3250 0.0980] ;  % Orange, Second Color Option in plot command
% data.color{5}   =    [0.8500 0.3250 0.0980] ;  % Orange, Second Color Option in plot command

data.symbol{01}         =       'o'                     ; 
data.symbol{02}         =       '^'                     ; 
data.symbol{03}         =       'v'                     ; 
data.symbol{04}         =       '*'                     ; 
data.symbol{05}         =       'h'                     ; 
data.symbol{06}         =       's'                     ;
data.symbol{07}         =       'p'                     ;
data.symbol{08}         =       'x'                     ;
data.symbol{09}         =       '<'                     ; 
data.symbol{10}         =       'd'                     ; 
data.symbol{11}         =       '+'                     ; 
data.symbol{12}         =       '>'                     ; 

%% Arrange Symbols For Plots:
data.symbol{01}         =       'o'                     ; 
data.symbol{02}         =       'o'                     ; 
data.symbol{03}         =       'v'                     ; 
data.symbol{04}         =       'v'                     ; 

% % % data.l{01}              =       "DNS Results"           ;
% % % data.l{02}              =       'TSI 32x32, 75%, FFT, '   ; 
% % % data.l{03}              =       'TSI 64x64, 75%, FFT, '     ; 
% % % data.l{04}              =       'TSI 48x48, 75%, FFT, '     ; 
% % % data.l{05}              =       'TSI 24x24, 75%, FFT, '; 
% % % data.l{06}              =       'TSI 24x24, 50%, FFT, '; 
% % % data.l{07}              =       'TSI 64x64, 50%, FFT, ';
% % % data.l{08}              =       'TSI 32x32, 50%, FFT, ';
% % % data.l{09}              =       'TSI 48x48, 50%, FFT, ';
% % % data.l{10}              =       strjoin({'TSI 32x8 , 75%, FFT, ' newline , 'Plotting Every 3rd Point,'}) ; 
% % % data.l{11}              =       ' TSI 32x32, 63%, FFT, ' ; 
% % % data.l{12}              =       ' TSI 64x64, 63%, FFT, ' ; 
tj = 2 ; 

% if nargin == 0


if nargin == 2
    lower_U_area =  U_profile_Avg ; 

%     data.l{02}      =       "Unladen, Profile Avg = " + num2str( (U_profile_Avg(1)) )  + ","  + " Re = " + num2str(Re(1))  ; 
%     data.l{03}      =       "2-Phase, Profile Avg = " + num2str( (U_profile_Avg(2)) )  + ","  + " Re = " + num2str(Re(2))  ;
%     data.l{04}      =       "2-Phase, Profile Avg = " + num2str( (U_profile_Avg(3)) )  + ","  + " Re = " + num2str(Re(3))  ;

    data.l{02}      =       sprintf(['\\bf{ 1. Q = 4.5' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 46.5 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(1) , Re(1) ) ;  
    data.l{03}      =       sprintf(['\\bf{ 2. Q = 4.5' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 93.0 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(2) , Re(2) ) ; 
    data.l{04}      =       sprintf(['\\bf{ 3. Q = 4.0' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 46.5 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(3) , Re(3) ) ;  
    data.l{05}      =       sprintf(['\\bf{ 4. Q = 4.0' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 93.0 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(4) , Re(4) ) ;  
    data.l{06}      =       sprintf(['\\bf{ 5. Q = 3.5' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 46.5 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(5) , Re(5) ) ;  
    data.l{07}      =       sprintf(['\\bf{ 6. Q = 3.5' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 93.0 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(6) , Re(6) ) ;  
    data.l{08}      =       sprintf(['\\bf{ 7. Q = 3.0' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 46.5 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(7) , Re(7) ) ;  
    data.l{09}      =       sprintf(['\\bf{ 8. Q = 3.0' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 93.0 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(8) , Re(8) ) ;
    data.l{10}      =       sprintf(['\\bf{ 9. Q = 2.5' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 46.5 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(9) , Re(9) ) ;  
    data.l{11}      =       sprintf(['\\bf{10. Q = 2.5' , ' $\\mathbf{ m^3/hr } $, \n' , '$\\mathbf{\\overline{U}}$ = %3.3f m/s, $\\mathbf{ \\delta Y }$ = 93.0 $\\mathbf{ \\mu m}$, Re = %5.0f }'] , U_profile_Avg(10) , Re(10) ) ; 
    
elseif nargin == 1
    
    lower_U_area =  U_profile_Avg ; 
    data.l{02}      =       "1. Infini Probe  , Unladen , 3000 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(1)) )   + " m/s "; % + ","  + " Re = " + num2str(Re(1))  ; 
    data.l{03}      =       "2. Navitar, 0.5x , 2-Phase , 2000 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(2)) )   + " m/s "; % + ","  + " Re = " + num2str(Re(2))  ; 
    data.l{04}      =       "3. Navitar, 1.0x , 2-Phase , 1000 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(3)) )   + " m/s "; % + ","  + " Re = " + num2str(Re(3))  ;

end








%%    


% %     data.l{02}      =       "1. Carrier Flow = 0        , 28.0A, 200 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(1)) )  + ","  + " Re = " + num2str(Re(1))  ; 
% %     data.l{03}      =       "2. Carrier Flow = 2 m^3/Hr , 28.0A, 500 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(2)) )  + ","  + " Re = " + num2str(Re(2))  ; 
% %     data.l{04}      =       "3. Carrier Flow = 3 m^3/Hr , 28.0A, 500 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(3)) )  + ","  + " Re = " + num2str(Re(3))  ;
% %     data.l{05}      =       "4. Carrier Flow = 4 m^3/Hr , 28.5A, 500 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(4)) )  + ","  + " Re = " + num2str(Re(4))  ;
% %     data.l{06}      =       "5. Carrier Flow = 3 m^3/Hr , 28.5A, 500 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(5)) )  + ","  + " Re = " + num2str(Re(5))  ;


% %     data.l{02}      =       "1. Infini Probe  , Unladen , 3000 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(1)) )  + " m/s ,"  + " Re = " + num2str(Re(1))  ; 
% %     data.l{03}      =       "2. Navitar, 0.5x , 2-Phase , 2000 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(2)) )  + " m/s ,"  + " Re = " + num2str(Re(2))  ; 
% %     data.l{04}      =       "3. Navitar, 1.0x , 2-Phase , 1000 Frames " + newline + "Profile Avg = " + num2str( (U_profile_Avg(3)) )  + " m/s ,"  + " Re = " + num2str(Re(3))  ;

%     % Legend 1:
% 
%     data.l{02}  =   "26 PSI Bypass, Results For Re =  760" ; 
%     data.l{03}  =   "26 PSI, Results For Re =  1200" ; 
%     data.l{04}  =   "30 PSI, Results For Re =  1300" ; 
%     data.l{05}  =   "40 PSI, Results For Re =  1900" ; 
%     data.l{06}  =   "40 PSI, Results For Re =  4994" ; 
%     data.l{07}  =   "40 PSI, Results For Re =  5793" ; 
%     data.l{08}  =   "40 PSI, Results For Re =  6523" ; 
%     data.l{09}  =   "40 PSI, Results For Re =  7370" ; 
%     data.l{10}  =   "40 PSI, Results For Re =  8165" ; 
%     data.l{11}  =   "40 PSI, Results For Re =  8720" ; 

% % % % Legend 2:
% % % data.l{02}      =       "26 PSI MidPlane, Profile Avg = " + num2str( (lower_U_area(1)) )+ "." ; 
% % % data.l{03}      =       "26 PSI Near Camera SidePlane, Profile Avg = " + num2str( (lower_U_area(2)) )+ "." ;
% % % data.l{04}      =       "26 PSI Far  Camera SidePlane, Profile Avg = " + num2str( (lower_U_area(3)) )+ "." ;
%

% % % % Legend 3:
% % % data.l{02}      =       "Background Sub.  , 16to08, Profile Avg = " + num2str( (lower_U_area(1)) )+ "." ; 
% % % data.l{03}      =       "Background Sub.  , 32to16, Profile Avg = " + num2str( (lower_U_area(2)) )+ "." ; 
% % % data.l{04}      =       "Background Sub,  , 48to24, Profile Avg = " + num2str( (lower_U_area(3)) )+ "." ; 
% % % data.l{05}      =       "Raw Image, 16to08, Profile Avg = " + num2str( (lower_U_area(4)) )+ "." ; 
% % % data.l{06}      =       "Raw Image, 32to16, Profile Avg = " + num2str( (lower_U_area(5)) )+ "." ; 
% % % data.l{07}      =       "Raw Image, 48to24, Profile Avg = " + num2str( (lower_U_area(6)) )+ "." ; 


%
% data.l{05}                =       "Re = 1900, Profile Avg = " + num2str( (lower_U_area(4)) )+ "." ;
%                            
% % data.l{02}              =       "26 PSI Results, TSI Deformable Grid, 128by16 to" + newline +  ...
% %                                 "128by8, Y-Overlap = 50%, "...
% %                                 + "Profile Avg = " + num2str( (lower_U_area(1)) )+ "." ;
%
% %                             
% % data.l{04}              =       "PIVlab 24by24, 75%, Profile Avg = " + num2str( (lower_U_area(3)) ) ;
% % data.l{05}              =       "PIVlab 32by32, 75%, Profile Avg = " + num2str( (lower_U_area(4)) ) ; 
%
% Legend For Samrat:
%
% % % % % data.l{02}              =       "TSI Recursive Deformable, " + newline + "Rectangular Grid, 192by48 to 192by12, " + newline + "X-Overlap = 50%, Y-Overlap = 50%, "  ; 
% % % % % data.l{03}              =       "TSI Recursive Deformable, l" + newline + "Rectangular Grid, 128by48 to 128by12, " + newline + "X-Overlap = 50%, Y-Overlap = 50%, "  ; 


% LEGEND 4:
% % data.l{02}      =       "Q = 4.50 m^3/hr, Profile Avg = " + num2str( (lower_U_area(1)) )+ ", Re = " + num2str(Re(1) ) +"."; 
% % data.l{03}      =       "Q = 5.00 m^3/hr, Profile Avg = " + num2str( (lower_U_area(2)) )+ ", Re = " + num2str(Re(2) ) +"."; 
% % data.l{04}      =       "Q = 5.50 m^3/hr, Profile Avg = " + num2str( (lower_U_area(3)) )+ ", Re = " + num2str(Re(3) ) +"."; 
% % data.l{05}      =       "Q = 6.00 m^3/hr, Profile Avg = " + num2str( (lower_U_area(4)) )+ ", Re = " + num2str(Re(4) ) +"."; 
% % data.l{06}      =       "Q = 6.50 m^3/hr, Profile Avg = " + num2str( (lower_U_area(5)) )+ ", Re = " + num2str(Re(5) ) +"."; 
% % data.l{07}      =       "Q = 6.75 m^3/hr, Profile Avg = " + num2str( (lower_U_area(6)) )+ ", Re = " + num2str(Re(6) ) +"."; 
% % % 

% LEGEND 5: 2-Phase
% % % data.l{02}      =       "2-Phase, Rot^{n}, 16to08, Profile Avg = " + num2str( (lower_U_area(1)) )  + "." ;   %  + " Re = " + num2str(Re(1))
% % % data.l{03}      =       "2-Phase, Rot^{n}, 32to16, Profile Avg = " + num2str( (lower_U_area(2)) )  + "." ;   %  + " Re = " + num2str(Re(2))

% % % % % % %LEGEND 6: 2-Phase
% % data.l{02}      =       "Unladen, Profile Avg = " + num2str( (lower_U_area(1)) )  + ","  + " Re = " + num2str(Re(1))  ; 
% % data.l{03}      =       "2-Phase, Profile Avg = " + num2str( (lower_U_area(2)) )  + ","  + " Re = " + num2str(Re(2))  ; 

% LEGEND 6: Different Re: 
% % %     data.l{02}  =   sprintf( '26 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f, Bypass' ,U_profile_Avg(01) , Re(01)  ) ;
% % %     data.l{03}  =   sprintf( '26 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(02) , Re(02)  ) ;
% % %     data.l{04}  =   sprintf( '30 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(03) , Re(03)  ) ;
% % %     data.l{05}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(04) , Re(04)  ) ;
% % %     data.l{06}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(05) , Re(05)  ) ;
% % %     data.l{07}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(06) , Re(06)  ) ;
% % %     data.l{08}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(07) , Re(07)  ) ;
% % %     data.l{09}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(08) , Re(08)  ) ;
% % %     data.l{10}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(09) , Re(09)  ) ;
% % %     data.l{11}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s,  Re  = %5.0f' ,U_profile_Avg(10) , Re(10)  ) ;
% 
%         data.l{02}  =   sprintf( '26 PSI Midplane, <U>  = %6.2f m/s,  Re  = %5.0f.' ,U_profile_Avg(01) , Re(01)  ) ;
%         data.l{03}  =   sprintf( '26 PSI NearCam ,<U>  = %6.2f m/s,  Re  = %5.0f.' ,U_profile_Avg(02) , Re(02)  ) ;
%         data.l{04}  =   sprintf( '26 PSI FarCam  , <U>  = %6.2f m/s,  Re  = %5.0f.' ,U_profile_Avg(03) , Re(03)  ) ;


% % % %     data.l{02}  =   sprintf( '26 PSI,  Profile Avg  = %7.7f m/s, \n Expt. With Bypass' ,U_profile_Avg(01) ) ;  % DEFAULT 5.2
% % % %     data.l{03}  =   sprintf( '26 PSI,  Profile Avg  = %7.7f m/s ' ,U_profile_Avg(02) ) ;
% % % %     data.l{04}  =   sprintf( '30 PSI,  Profile Avg  = %7.7f m/s ' ,U_profile_Avg(03) ) ;
% % % %     data.l{05}  =   sprintf( '40 PSI,  Profile Avg  = %7.7f m/s ' ,U_profile_Avg(04) ) ;
% % 
% % % %     data.l{06}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s ' ,U_profile_Avg(05) ) ;
% % % %     data.l{07}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s '  ,U_profile_Avg(06) ) ;
% % % %     data.l{08}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s ' ,U_profile_Avg(07) ) ;
% % % %     data.l{09}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s ' ,U_profile_Avg(08) ) ;
% % % %     data.l{10}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s ' ,U_profile_Avg(09) ) ;
% % % %     data.l{11}  =   sprintf( '40 PSI,  <U>  = %6.2f m/s ' ,U_profile_Avg(10) ) ;
% % 
% % % %     data.l{02}  =   sprintf( '26 PSI Midplane,  Profile Avg  = %7.7f m/s' ,U_profile_Avg(01) ) ;
% % % %     data.l{03}  =   sprintf( '26 PSI NearCam ,  Profile Avg  = %7.7f m/s' ,U_profile_Avg(02) ) ;
% % % %     data.l{04}  =   sprintf( '26 PSI FarCam  ,  Profile Avg  = %7.7f m/s' ,U_profile_Avg(03) ) ;
% %        
% %         data.l{02}  =   ['$\theta = -1.00^{\circ} , \langle V \rangle = $ ' , num2str(U_profile_Avg(01)) ,  ' m/s ']  ;
% %         data.l{03}  =   ['$\theta = +0.00^{\circ} , \langle V \rangle = $ ' , num2str(U_profile_Avg(02)) ,  ' m/s ']  ;
% %         data.l{04}  =   ['$\theta = -0.25^{\circ} , \langle V \rangle = $ '  , num2str(U_profile_Avg(03)) ,  ' m/s ']  ;
% %         data.l{05}  =   ['$\theta = -0.50^{\circ} , \langle V \rangle = $ ' , num2str(U_profile_Avg(04)) ,  ' m/s ']  ;
% %         data.l{06}  =   ['$\theta = -0.75^{\circ} , \langle V \rangle = $ ' , num2str(U_profile_Avg(05)) ,  ' m/s ']  ;
% %         data.l{07}  =   ['$\theta = -1.00^{\circ} , \langle V \rangle = $ ' , num2str(U_profile_Avg(06)) ,  ' m/s ']  ;
% %         data.l{08}  =   ['Optimal $\theta = +0.332^{\circ} , \langle V \rangle = $ ' , num2str(U_profile_Avg(01)) ,  ' m/s ']  ;
       
