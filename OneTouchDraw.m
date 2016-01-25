%Import the screenshot and rename it as img in the workspace and run program
clearvars -except img
clc
close all
warning off

img_gray=rgb2gray(img);
%img_crop=img(1:end-350,:,:);    %For Level Mode
img_crop=img(251:end-350,:,:);  % For Master Mode

img_gray=img_gray(251:end-350,:); % For Master Mode
%img_gray=img_gray(1:end-350,:);   %For Level Mode

img_r=img(:,:,1);
img_r=img_r(251:end-350,:);  % For Master Mode 
%img_r=img_r(1:end-350,:);  % For Level Mode
 

% [level,bwimg]=thresh_tool(img_gray);
% imshow(bwimg)

level1=110/255;
bwimg=im2bw(img_gray,level1);
figure(1)
imshow(bwimg)

% [level,bwredline]=thresh_tool(img_r);
% figure(2)
% imshow(bwredline)
level2=200/255;
bwredline=im2bw(img_r,level2);
figure(2)
imshow(bwredline)

img1=bwareafilt(bwimg,[3300,3340]);
bwallline=bwimg&~img1;
figure(3)
imshow(bwallline)

%%
cc=bwconncomp(bwimg);
stats=regionprops(bwimg,'Centroid','MajorAxisLength','MinorAxisLength','Area');
%%
noNode=0;
epsilon=10;

Cindex=[];Lindex=[];

for k=1:cc.NumObjects
    flag=0;
    majorAxis=stats(k).MajorAxisLength;
    minorAxis=stats(k).MinorAxisLength;

    if abs(majorAxis-minorAxis)<epsilon
        Cindex=[Cindex;k];
        noNode=noNode+1;
        flag=1;
    end
   
end

%noLines=cc.NumObjects-noNode;
%%
centroid=zeros(cc.NumObjects,2);

for k=1:cc.NumObjects
    centroid(k,:)=stats(k).Centroid;
end

%%
Ccentroid=centroid(Cindex,:);
Lcentroid=centroid(Lindex,:);

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
%         m=1;n=5;
        x1=Ccentroid(m,1);
        x2=Ccentroid(n,1);
        y1=Ccentroid(m,2);
        y2=Ccentroid(n,2);
        
        c1=x1+1i*y1;
        c2=x2+1i*y2;
        dis=abs(c1-c2);
        
        minSpacing=ceil(dis/50);
        points=conj(linspace(c1,c2,minSpacing))';
        margin1=abs(points-c1);
        index1=find(margin1<100);
        
        margin2=abs(points-c2);
        index2=find(margin2<100);
        
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
