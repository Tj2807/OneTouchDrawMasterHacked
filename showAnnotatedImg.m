function showAnnotatedImg( img_crop,noNode,Ccentroid )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
text_str = cell(noNode+1,1);

for k=1:noNode
   text_str{k} = num2str(k);
end

position = floor(Ccentroid);

box_color = {'black'};
%RGB = insertText(I,position,text_str,'FontSize',18,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
commentSwag =...
{
    'Umm... Too Easy!';
    'Lemme Think....';
    'Hahahah, Seriously?';
    'You UnderEstimating me? :( ';
    'I can do better, test me! :p ';
    'Huhhhh, That''s called Swag! ';
    'Yo Bitch!';
    'Nahhh... Not Tired yet :p ';
    'I''ll find you and I''ll SOLVE you!';
    'Beta Tumse Na Ho payega!';
};
swagIndex = ceil(10*rand);
    
position1=[position;[200 100]];
text_str{noNode+1}=commentSwag{swagIndex};
annotatedImg = insertText(img_crop,position1,text_str,'FontSize',50,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');

 figure(1)
 imshow(annotatedImg)

end

