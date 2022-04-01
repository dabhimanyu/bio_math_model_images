function tracking_input = make_tracking_input_file_4BEADS(xy_data , max_displacement , percent_of_max_pixel_displacement )
% This Function shall create an Input File for the tracking Function: 
% It'll also remove nearby particles if the user supplies more than one
% Input to the function:
%
% NOTE: It Must be kept in mind that this function will call 
% remove_nearby_islands() to accomplih this.
% Just keep this in mind while making use of this function:

%% Check If any of the Input Cells is Empty:
% Eliminate that cell: 
temp_length     =   cellfun(@length , xy_data) ; 

if any(~temp_length)
    idx = find(temp_length == 0) ; 
    fprintf([' \n\n\t\t %i th Cell Of the Input Has Zero Elements' ...
        '\n\n\t\t Hence We''ll be deleting this cell Before ' ...
        '\n\n\t\t proceeding Further. ' ...
        ' . \n\n\n'] , idx  ) ; 
    xy_data = xy_data( ~cellfun('isempty' , xy_data) )  ; 
end
%% Prealocate For the Output: 
tracking_input  =   cell(length(xy_data) , 1)  ;  
temp            =   zeros(max(cellfun(@length , xy_data)) , 1) ;  
%% Default Inputs:

if nargin == 1
    
    fprintf([' \n\n\t\t You have provided only one Input.  ' ...
        '\n\n\t\t Hence NearBy Particles will NOT be removed. ' ...
        '\n\n\t\t Please provide Max Pixel Displacement (as 2nd Input to the Function)' ...
        ' \n\n\t\t in case you also want to remove nearby particles. \n\n\n'] ) ; 
    
    for framei = 1 : length(xy_data)
       temp = [xy_data{framei} , repmat(framei , [length(xy_data{framei}) , 1] ) ] ; 
       tracking_input{framei} = temp ; 
    end

elseif nargin == 2

    fprintf([' \n\n\t\t You have provided Two Inputs.  ' ...
    '\n\n\t\t Hence NearBy Particles will be removed, using ' ...
    '\n\n\t\t remove_nearBy_islands() macro, using the parameters' ...
    ' \n\n\t\t That you provided. \n\n\n'] ) ; 
    percent_of_max_pixel_displacement = 105 ; % 105% Of Max Particle Displacement

    % Loop For Removing Nearby Particles:
    % Calling Nearby Particle Removal Function: 
    
    for framei = 1 : length(xy_data)
       temp = remove_nearBy_islands_4BEADS(xy_data{framei} , max_displacement , percent_of_max_pixel_displacement) ; 
       temp = [ temp , repmat(framei , [length(temp) , 1] ) ] ; % NO NEED TO PREALLOCATE THIS
       tracking_input{framei} = temp ; 
    end

elseif nargin == 3
     fprintf([' \n\n\t\t You have provided Three Inputs.  ' ...
    '\n\n\t\t Hence NearBy Particles will be removed, using ' ...
    '\n\n\t\t remove_nearBy_islands() macro, using the parameters' ...
    ' \n\n\t\t That you provided. \n\n\n'] ) ;
    % Loop For Removing Nearby Particles:
    for framei = 1 : length(xy_data)
       temp = remove_nearBy_islands(xy_data{framei} , max_displacement , percent_of_max_pixel_displacement) ; 
       temp = [temp , repmat(framei , [length(temp) , 1] ) ] ; 
       tracking_input{framei} = temp ; 
    end

elseif nargin < 1 || nargin > 3
    
    fprintf([' \n\n\t\t At-least 1 and At MAX, 3 Inputs Allowed  ' ...
        '\n\n\t\t Dumbass ||-_-|| \n\n\t\t Check your Inputs First, ' ...
        'Before calling me. \n\n\n'] ) ; 
    return

end

%% Convert Cell-Array To A Matrix:
% After This Step, This Data could be directly fed to the tracking Macro:
tracking_input = cell2mat(tracking_input) ; 

% End of the Function
end