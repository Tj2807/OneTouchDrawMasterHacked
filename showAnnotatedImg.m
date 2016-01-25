function showAnnotatedImg( img_crop,noNode,Ccentroid )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
text_str = cell(noNode,1);

for k=1:noNode
   text_str{k} = num2str(k);
end

position = floor(Ccentroid);
box_color = {'red'};
%RGB = insertText(I,position,text_str,'FontSize',18,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
annotatedImg = insertText(img_crop,position,text_str,'FontSize',50,'BoxColor',box_color,'TextColor','white');

% figure(2)
% imshow(annotatedImg)

end

