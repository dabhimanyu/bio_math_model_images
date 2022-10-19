function [xyuvt_data , T , p_dist] = calculate_dx_and_dy_from_tracking_output_002(tracking_output , ...
    num_of_frames_2_skip)
% Function To Calculate Dx and Dy of the Pixel Movement In the images: 
%
% Write documentation of this function whenever you are in good mood
idx1         =   0     ;
xyuvt_data   =   zeros( size(tracking_output , 1) - tracking_output(end , end) , 6 )  ;
u_tracks     = length(unique(tracking_output(: , 4))) ; 

% The 6 columns in the xyuvt_data matrix correspond to:
% C1 -> X-Coordinate Of The Particle 
% C2 -> Y-Coordinate Of the Particle 
% C3 -> dx-Component of the velocity (dx/dt) 
% C4 -> dy-Component of the Velocity (dy/dt) 
% C5 -> Frame Number To Which The Particle Belongs
% C6 -> Particle Id For which dx-dy was calculated
% C7 -> Distance Travelled = sqrt(dx^2 + dy^2)

% Average Distance Covered By Each Unique Particle ID
p_dist = table ;
p_dist.mean_dist        =   zeros(u_tracks , 1) ; 
p_dist.total_dist       =   zeros(u_tracks , 1) ; 
p_dist.track_length     =   zeros(u_tracks , 1) ; 

particle_i  = 1    ; 

    for particle_i  = 1 : u_tracks % %% tracking_output(end , end)
        temp_xy     =   tracking_output( tracking_output(: , 4) == particle_i , : )  ;  
        temp_uv     =   diff(temp_xy(: , 1:2)) / num_of_frames_2_skip ;
        idx2        =   size(temp_uv , 1) ; 
    
        % Construct XYUV Data Matrix:
        xyuvt_data(idx1+1 : idx1 + idx2 , 1:2 )     =       temp_xy(1:end-1 , 1:2)      ; 
        xyuvt_data(idx1+1 : idx1 + idx2 , 3:4 )     =       temp_uv                     ;
        xyuvt_data(idx1+1 : idx1 + idx2 , 5   )     =       temp_xy(1:end-1 , 3  )      ; 
        xyuvt_data(idx1+1 : idx1 + idx2 , 6   )     =       temp_xy(1:end-1 , 4  )      ; 
        xyuvt_data(idx1+1 : idx1 + idx2 , 7   )     =       sqrt(sum(temp_uv.^2, 2))    ;

        % Average Distance Covered By Each Unique Particle ID :
        p_dist.total_dist(particle_i)               =       sum(  sqrt(sum(temp_uv.^2, 2)) ) ; 
        p_dist.mean_dist( particle_i)               =       mean( sqrt(sum(temp_uv.^2, 2)) ) ; 
        p_dist.track_length(particle_i)             =       size(temp_uv , 1) ; 
    
        idx1 = idx1 + idx2 ; 
    end
T = table ; 
T.X_Coordinate          =   xyuvt_data(: , 1) ; 
T.Y_Coordinate          =   xyuvt_data(: , 2) ; 
T.Delta_X_Pixel         =   xyuvt_data(: , 3) ; 
T.Delta_Y_Pixel         =   xyuvt_data(: , 4) ;
T.Frame_Number          =   xyuvt_data(: , 5) ; 
T.Particle_ID           =   xyuvt_data(: , 6) ; 
T.Distance_Pixel        =   xyuvt_data(: , 7) ; 

end