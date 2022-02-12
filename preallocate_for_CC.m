function CC_stats = preallocate_for_CC(number_of_Image_Files)
i = 1 ;     
temp_1                          =   1000                ; 
temp_2                          =   50                  ;
CC_stats(i , 1).Connectivity    =   10                  ; 
CC_stats(i , 1).ImageSize       =   [512 512]           ;
CC_stats(i , 1).PixelIdxList    =   cell(1 , temp_1)    ;
CC_stats(i , 1).PixelIdxList    =   cellfun(@(x) zeros(temp_2 , 1) , ...
                                    CC_stats(i , 1).PixelIdxList , 'UniformOutput', 0 ) ; 
% CC_stats(i , 1)
end