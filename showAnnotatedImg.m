function showAnnotatedImg( img_crop,node )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nodeIndex=size(node,2);
text_str = cell(nodeIndex+1,1);

for k=1:nodeIndex
   text_str{k} = num2str(k);
end

position=zeros(nodeIndex+1,2);
for k=1:nodeIndex
position(k,:) = floor(node(k).centroid);
end

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
    
position(nodeIndex+1,:)=[200 100];
text_str{nodeIndex+1,1}=commentSwag{swagIndex};
annotatedImg = insertText(img_crop,position,text_str,'FontSize',50,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');

 figure(1)
 imshow(annotatedImg)

end

