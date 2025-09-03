function [mean_intensity_at_centroid] = mean_intensity_calculator_2(...
    img , centroid)
    
    % Declaring new variables for quick easy use
    c = centroid ; 
    I = img ; 
    I_mean = zeros(size(c , 1) , 1 ) ; 
    
    for i = 1 : size(c , 1)
        y = c(i , 1) ; 
        x = c(i , 2) ; 
        I_mean(i , 1) = mean( [ I(x-1 , y) , I(x , y) , I(x+1 , y) , ...
                            I(x , y-1) , I(x , y+1) ] ) ; 
    end

    mean_intensity_at_centroid = I_mean ; 
end % end of mean_intensity_calculator