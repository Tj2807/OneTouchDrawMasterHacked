%Written and Conceptualized by Arpan Majumdar.
%This code is OpenSource and can be directly used in any project without
%the need of taking any permission.

%Import the screenshot and rename it as img in the workspace and run program
%clearvars -except img
clc

close all
warning off
%% Image thresholding
% Output of this segment is binary image bwimg which consistes of nodes,
% edges and arrows

%imshow(img)
img=imread('img.png');
img_gray=rgb2gray(img);

img_crop=img(1:end-340,:,:);    %For Level Mode
%img_crop=img(251:end-340,:,:);  % For Master Mode

img_gray=img_gray(1:end-340,:);   %For Level Mode
%img_gray=img_gray(251:end-340,:); % For Master Mode

% [level,bwimg]=thresh_tool(img_gray);

level1=110/255;
bwimg=im2bw(img_gray,level1);
% figure(1)
% imshow(bwimg)

%% Detect nodes and arrows from bwimg

% Output of this segment is a stucture 'node' and 'arrow' whose fields are:
% node:
% centroid: Contains x,y coordinates of centroid of node in a 1x2 matrix
% color: 'b','y','g','r', depending on color of node

% arrow:
% centroid: Contains x,y coordinates of centroid of arrow in a 1x2 matrix

stats=regionprops(bwimg,'Centroid','MajorAxisLength','MinorAxisLength','Area');

nodeIndex=0; arrowIndex=0;
epsilon=10;

Cindex=[];Aindex=[];

nodes=zeros(size(bwimg));
arrows=zeros(size(bwimg));
label=bwlabel(bwimg);

for k=1:size(stats,1)
    %Node detection
    if abs(stats(k).MinorAxisLength-stats(k).MinorAxisLength)<epsilon && ...
       stats(k).MinorAxisLength>55 && stats(k).MinorAxisLength<65 &&...
       stats(k).MajorAxisLength>65 && stats(k).MajorAxisLength<75 && ...
       stats(k).Area>3300 && stats(k).Area<3450
        
            %Cindex=[Cindex;k];
            
            nodeIndex=nodeIndex+1;
            node.centroid(nodeIndex,:)=stats(k).Centroid;
            node.color(nodeIndex,1)=findColor(img_crop,stats(k).Centroid);
               
            map=label==k;
            nodes=nodes | map;
    end
    
    %Arrow detection
    if stats(k).Area>1750 && stats(k).Area<1850 && ...
       stats(k).MajorAxisLength>45 && stats(k).MajorAxisLength<60 && ...
       stats(k).MinorAxisLength>40 && stats(k).MinorAxisLength<55
%             Aindex=[Aindex;k];
            arrowIndex=arrowIndex+1;
            arrow.centroid(arrowIndex,:)=stats(k).Centroid;
                    
            map=label==k;
            arrows=arrows | map;
    end
   
end
%% Isolate lines from bwimg

bwallline=bwimg&~nodes;
arrows1=bwmorph(arrows,'thicken',10);
bwallline= bwallline | arrows1;

%% Check connectivity between every pair of nodes

% Output of this segment is a stucture 'edge' whose fields are:
% graph= 0,if there is no edge between m and n
%      = 1,if edge exists between m and n
%        = 2,if double edge(red edge) exists between m and n
% color='r','g','w', Depending on color of edge
% isDirectional= 0, if edge is not directional
%                = 1, if edge is directional
           
%Initialization of node structure
for m=1:nodeIndex
    for n=1:nodeIndex
        edge.graph(m,n)=0;
        edge.color(m,n)='w';
        edge.isDirectional(m,n)=0;
        
        if m==n
            edge.graph(m,n)=0;
            %edge.color(m,n)=[];
            edge.isDirectional(m,n)=0;
        end
    end
end

for m=1:nodeIndex
    for n=1:nodeIndex
        if m==n
            continue;
        end
        
%          m=3;n=1;

        x1=node.centroid(m,1);
        x2=node.centroid(n,1);
        y1=node.centroid(m,2);
        y2=node.centroid(n,2);
% Convert x,y coordinates of centres of nodes m,n to complex numbers for easy calculation of distance        
        c1=x1+1i*y1;
        c2=x2+1i*y2;
        dis=abs(c1-c2);
 
% Take equally spaced points between the nodes m and n and check whether all points
% lie in the white line(bwallline)
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
            
%Line exists between m and n
            edge.graph(m,n)=1;
            color(1)=findColor(img_crop,[x(1) y(1)]);
            color(2)=findColor(img_crop,[x(end) y(end)]);
            
            if color(1)==color(2)
                edge.color(m,n)=color(1);
            end
            
            
            if isequal(edge.color(m,n),'r')
                edge.graph(m,n)=2;
            end
            
%Now check if an arrow exists between nodes m and n
            arrow_check=zeros(length(x),1);
            for k=1:length(x)
                arrow_check(k)=arrows(y(k),x(k));
            end
            
            if any(arrow_check)
                findArrowIndex=floor(mean(find(arrow_check)));
                arrowCentroidCalc=[x(findArrowIndex) y(findArrowIndex)];
                
                error=[100 100];
                for k=1:size(arrow.centroid,1)
                     if abs(arrow.centroid(k,:)-arrowCentroidCalc)<error
                         error=abs(arrow.centroid(k,:)-arrowCentroidCalc);
                         arrowIndex=k;
                     end                  
                end
                
                a1=arrow.centroid(arrowIndex,1)+1i*arrow.centroid(arrowIndex,2);
                
                
                mDis=abs(c1-a1);
                nDis=abs(c2-a1);
                
                edge.isDirectional(m,n)=1;
                
                if mDis<nDis
                    edge.graph(m,n)=1;
                                        
                    if isequal(edge.color(m,n),'r')
                        edge.graph(m,n)=2;
                    end
                else
                    edge.graph(m,n)=0;
                end
               
            end           
        end    
    end
end

showAnnotatedImg(img_crop,node);
%%
 inputGraph(node,edge)
