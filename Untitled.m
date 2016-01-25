text_str = cell(noNode,1);
nodes = 1:noNode;
for k=1:noNode
   text_str{k} = num2str(k);
end

position = floor(Ccentroid);
%box_color = {'red','green','yellow'};

annotatedImg = insertText(img_crop,position,text_str,'FontSize',50,'TextColor','red');
figure(4)
imshow(annotatedImg)