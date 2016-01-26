%Written and Conceptualized by Arpan Majumdar.
%This code is OpenSource and can be directly used in any project without
%the need of taking any permission.

%Import the screenshot and rename it as img in the workspace and run program
clearvars -except img
clc

close all
warning off
%%
imshow(img)
img_gray=rgb2gray(img);
img_crop=img(1:end-340,:,:);    %For Level Mode
%img_crop=img(251:end-340,:,:);  % For Master Mode

%img_gray=img_gray(251:end-340,:); % For Master Mode
img_gray=img_gray(1:end-340,:);   %For Level Mode

[level,bwimg]=thresh_tool(img_gray);
imshow(bwimg)

% level1=110/255;
% bwimg=im2bw(img_gray,level1);
figure(1)
imshow(bwimg)
%%
img_r=img(:,:,1);
%img_r=img_r(251:end-340,:);  % For Master Mode 
img_r=img_r(1:end-340,:);  % For Level Mode
[level,bwredline]=thresh_tool(img_r);
figure(2)
imshow(bwredline)
% level2=200/255;
% bwredline=im2bw(img_r,level2);
% figure(2)
% imshow(bwredline)

%%
cc=bwconncomp(bwimg);
stats=regionprops(bwimg,'Centroid','MajorAxisLength','MinorAxisLength','Area');
%% Node detection
noNode=0; noArrow=0;
epsilon=10;

Cindex=[];Aindex=[];

nodes=zeros(size(bwimg));
arrows=zeros(size(bwimg));
label=bwlabel(bwimg);

for k=1:cc.NumObjects
    %Circle detection
    if abs(stats(k).MinorAxisLength-stats(k).MinorAxisLength)<epsilon && ...
       stats(k).MinorAxisLength>55 && stats(k).MinorAxisLength<65 &&...
       stats(k).MajorAxisLength>65 && stats(k).MajorAxisLength<75 && ...
       stats(k).Area>3300 && stats(k).Area<3450
        
            Cindex=[Cindex;k];
            noNode=noNode+1;
               
            map=label==k;
            nodes=nodes | map;
    end
    
    %Arrow detection
    if stats(k).Area>1750 && stats(k).Area<1850 && ...
       stats(k).MajorAxisLength>45 && stats(k).MajorAxisLength<60 && ...
       stats(k).MinorAxisLength>40 && stats(k).MinorAxisLength<55
            Aindex=[Aindex;k];
            noArrow=noArrow+1;
            
            map=label==k;
            arrows=arrows | map;
    end
   
end
%% All lines

bwallline=bwimg&~nodes;
arrows=bwmorph(arrows,'thicken',10);
bwallline= bwallline | arrows;
%noLines=cc.NumObjects-noNode;
%%
centroid=zeros(cc.NumObjects,2);

for k=1:cc.NumObjects
    centroid(k,:)=stats(k).Centroid;
end

Ccentroid=centroid(Cindex,:);
Acentroid=centroid(Aindex,:);

%%


graph=zeros(noNode);


for m=1:noNode
    for n=1:noNode
        if m==n
            continue;
        end
        
%         coordinate2=floor(mean(Ccentroid([m n],:)));
%         coordinate1=floor(mean([Ccentroid(m,:);coordinate2]));
%         coordinate3=floor(mean([Ccentroid(n,:);coordinate2]));
%         
%         
%         
%         if bwimg(coordinate1(2),coordinate1(1))&&bwimg(coordinate2(2),coordinate2(1))&&bwimg(coordinate3(2),coordinate3(1))
%               graph(m,n)=1;
%         end
         m=1;n=3;
        x1=Ccentroid(m,1);
        x2=Ccentroid(n,1);
        y1=Ccentroid(m,2);
        y2=Ccentroid(n,2);
        
        c1=x1+1i*y1;
        c2=x2+1i*y2;
        dis=abs(c1-c2);
        
        minSpacing=ceil(dis/10);
        points=conj(linspace(c1,c2,minSpacing))';
        margin1=abs(points-c1);
        index1=find(margin1<70);
        
        margin2=abs(points-c2);
        index2=find(margin2<70);
        
        index=[index1;index2];
        points(index)=[];
        
        x=floor(real(points));y=floor(imag(points));
        
        if diag(bwallline(y,x))
            graph(m,n)=1;
            if bwredline(y(1),x(1)) && bwredline(y(end),x(end))
            graph(m,n)=2;
            end
        end    
    end
end

showAnnotatedImg(img_crop,noNode,Ccentroid);
%%
inputGraph(graph)
