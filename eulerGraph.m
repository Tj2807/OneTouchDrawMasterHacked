%Written by Tejas S. Niphadkar.
%The Code is opensource and can be modified,distributed or may directly be
%used in any project.
%API Instructions:
%Create an object to the class by giving the Graph Matrix as an Argument.
%Call startEuler function without any argument.
%To do: A diagraph with no. of edges more than 1 between two vertices.
classdef eulerGraph < handle
    properties
        graphInp, graphInpTransp, nVertices, oddVertex , eulerIncludedEdges, eulerAnsArray , visited ;
    end
    methods
        function obj = eulerGraph(edges)
            obj.graphInp=edges.graph;
            obj.graphInpTransp = obj.graphInp' ;
            obj.nVertices = size(obj.graphInp,1);
        end
        function isIt = isEuler(obj)
            oddVertexCount=0;
            %returns 1 if Euler's Path , 2 if Euler's Circuit , 0 if NONE.
            %Function Assumes that graph is connected.If not, a simple dfs will do.
            for i=1:1:obj.nVertices
                sumRow = sum(obj.graphInp(i,:));
                if mod(sumRow,2)~=0
                    oddVertexCount = oddVertexCount+ 1;
                    obj.oddVertex = i ;
                end 
            end 
            if oddVertexCount==0
                obj.oddVertex = 1;
            end
            if oddVertexCount==0 || oddVertexCount == 2
                isIt=1;
            else
                isIt=0;
            end
        end
        function ansCellArray = startEuler(obj,circleCoors)
            if ~obj.isEuler()
                fprintf('The Graph Matrix Input Does not have a valid Euler Path/Circuit');
            end
            obj.eulerIncludedEdges = 0;
            obj.eulerAnsArray= {};
            u=obj.oddVertex;
            obj.storeEuler(u);
            ansCellArray = obj.eulerAnsArray;
            actionOutputAutomate(ansCellArray,circleCoors);
        end
        function storeEuler(obj,vertex)
            %fprintf('here at %d\n',vertex);
            for i=1:1:obj.nVertices
                adj = obj.graphInp(vertex,i);
                %fprintf('at edge %d-%d\n',vertex,i);
                if adj~=0 && obj.isValidNextEdge(vertex,i)
                    obj.eulerIncludedEdges = obj.eulerIncludedEdges +1;
                    obj.eulerAnsArray{obj.eulerIncludedEdges,1} = vertex;
                    obj.eulerAnsArray{obj.eulerIncludedEdges,2} = i;
                    if obj.isEdgeDirected(vertex,i) %Check if edge is directed before removal/addition
                        obj.rmvDiaEdge(vertex,i);
                    else
                        obj.rmvNormalEdge(vertex,i);
                    end
                    obj.storeEuler(i);
                end
            end
        end
        function rmvNormalEdge(obj,u,v)
            obj.graphInp(v,u) = obj.graphInp(v,u) -1;
            obj.graphInp(u,v) = obj.graphInp(u,v) -1; 
        end
        function addNormalEdge(obj,u,v)
            obj.graphInp(u,v) = obj.graphInp(u,v)+ 1;
            obj.graphInp(v,u) = obj.graphInp(v,u)+ 1;
        end
        function rmvDiaEdge(obj,u,v)
            obj.graphInp(u,v) = obj.graphInp(u,v)- 1;
        end
        function addDiaEdge(obj,u,v)
            obj.graphInp(u,v) = obj.graphInp(u,v)+ 1;
        end
        function isIt = isEdgeDirected(obj,u,v)
            if obj.graphInpTransp(u,v) == obj.graphInpTransp(v,u)
                isIt = false;
            else
                isIt = true;
            end
        end     
        function isValid= isValidNextEdge(obj,u,v)
            %fprintf('at edge checking if valid %d-%d\n',u,v);
            remVertices=0;
            for i= 1:1:obj.nVertices
                if obj.graphInp(u,i)~=0
                    remVertices = remVertices+ 1;
                end
            end
            obj.visited = zeros(1,obj.nVertices);
            countWithEdge = obj.dfsCount(u);
            %Account for Directed edge
            if obj.isEdgeDirected(u,v)
                obj.rmvDiaEdge(u,v);
            else
                obj.rmvNormalEdge(u,v);
            end
            obj.visited = zeros(1,obj.nVertices);
            countWithoutEdge = obj.dfsCount(u);
            %Account for Directed edge
            if obj.isEdgeDirected(u,v)
                obj.addDiaEdge(u,v);
            else
                obj.addNormalEdge(u,v);
            end
            isValid = (remVertices==1 || countWithEdge==countWithoutEdge);
        end
        function countVisited = dfsCount(obj,u)
            obj.visited(u)=1;
            countVisited=1;
            %fprintf('Visited %d\n',u);
            for i= 1:1:obj.nVertices
                if obj.graphInp(u,i)~=0 && ~obj.visited(i)
                    countVisited = countVisited + obj.dfsCount(i);
                    %fprintf('Increased count for %d->%d',u,i);
                end
            end
        end
    end
end


%% The outputActionAutomate Block.

function actionOutputAutomate(outputCellArray,circleCoors)
    nextButtonX = 945;
    nextButtonY = 1050;
    %swipeDuration = 70;
    nEdges = size(outputCellArray,1);
    
    for i=1:1:nEdges
        %Get edge from and to vertex from Cell Array.
        fromVertex = outputCellArray{i,1};
        toVertex = outputCellArray{i,2};
        %Get coordinated of the edge Circles
        fromVertexCoorX = circleCoors(fromVertex,1);
        fromVertexCoorY = circleCoors(fromVertex,2);
        toVertexCoorX = circleCoors(toVertex,1);
        toVertexCoorY = circleCoors(toVertex,2);
        %Do the Swipe
        %SwipeCommandArray=['adb shell input swipe' ' ' num2str(fromVertexCoorX) ' ' num2str(fromVertexCoorY) ' ' num2str(toVertexCoorX) ' ' num2str(toVertexCoorY) ' ' num2str(swipeDuration)];
        %Or Do the tap
        %Tap Code Begin
        SwipeCommandArray=['adb shell input tap' ' ' num2str(fromVertexCoorX) ' ' num2str(fromVertexCoorY)];
        system(SwipeCommandArray);
        pause(0.1);
        if i==nEdges
        SwipeCommandArray=['adb shell input tap' ' ' num2str(toVertexCoorX) ' ' num2str(toVertexCoorY)];
        %Tap Code End.
        system(SwipeCommandArray);
        end
    end
        % Level completed.Wait for Next button to appear and tap it.
        pause(3);
        nextTapArray = ['adb shell input tap' ' ' num2str(nextButtonX) ' ' num2str(nextButtonY)];
        system(nextTapArray);
end
    