function [MatchesIndex] = mvMismatches(cluster_1,cluster_2)
%remove mismatches
%
alpha = 0.1;
[n,~] = size(cluster_1);
ClusterNum_1 = int32(cluster_1(n,4)+1);
ClusterNum_2 = int32(cluster_2(n,4)+1);
C1 = cell(1,ClusterNum_1);
C2 = cell(1,ClusterNum_2);
C3 = cell(ClusterNum_1,ClusterNum_2);


%% 将聚类结果存入cell
for i = 1:n
    if(cluster_1(i,4) == -1)
        C1{1,ClusterNum_1} = [C1{1,ClusterNum_1};cluster_1(i,:)];
    else
        C1{1,int32(cluster_1(i,4))} = [C1{1,int32(cluster_1(i,4))};cluster_1(i,:)];  
    end

end

for i = 1:n
    if(cluster_2(i,4) == -1)
        C2{1,ClusterNum_2} = [C2{1,ClusterNum_2};cluster_2(i,:)];
    else
        C2{1,int32(cluster_2(i,4))} = [C2{1,int32(cluster_2(i,4))};cluster_2(i,:)];
    end
end

%% 对cell进行匹配，结果存入C3
MatchMat = zeros(ClusterNum_1,ClusterNum_2);
for i = 1:ClusterNum_1-1
    for j = 1:ClusterNum_2-1
        Cell_A = C1{1,i};
        Cell_B = C2{1,j};
        [Same, ia, ib]= intersect(Cell_A(:,1),Cell_B(:,1));
        MatchMat(i,j) = size(Same,1);
        C3{i,j} = [C3{i,j};[Cell_A(ia,:),Cell_B(ib,:)]];
    end
end

Noise_1 = C1{1,ClusterNum_1};
Noise_2 = C2{1,ClusterNum_2};
[Index_N, na, nb] = intersect(Noise_1(:,1),Noise_2(:,1));
MatchMat(ClusterNum_1,ClusterNum_2) = size(Index_N,1);
C3{ClusterNum_1,ClusterNum_2} = [C3{ClusterNum_1,ClusterNum_2};[Noise_1(na,:),Noise_2(nb,:)]];

MatchMask = zeros(ClusterNum_1,ClusterNum_2);
IndexMask = [];

for i = 1:ClusterNum_1-1
    [~,MaxIndex] = max(MatchMat(i,:));
    if(ismember(MaxIndex,IndexMask))
        continue;
    else
        IndexMask = [IndexMask, MaxIndex];
        MatchMask(i,MaxIndex) = 1;
    end
    
end

MatchMask(ClusterNum_1,ClusterNum_2) = 1;
for i = 1:ClusterNum_1
    for j = 1:ClusterNum_2
        if(MatchMask(i,j) == 0)
            C3{i,j} = [];
        end
    end
end

%% 根据motion flow 进行误匹配筛除
for i = 1:ClusterNum_1
    for j = 1:ClusterNum_2
        Cell_C = C3{i,j};
        if(isempty(Cell_C))
            continue;
        end
        AveMotion = [mean(Cell_C(:,2) - Cell_C(:,6)),mean(Cell_C(:,3) - Cell_C(:,7))];
        MatchCell = size(C3{i,j},1);
        m = 1;
        while m  <= MatchCell
            if(norm([Cell_C(m,2)-Cell_C(m,6), Cell_C(m,3)-Cell_C(m,7)] - AveMotion) > alpha)
                C3{i,j}(m,:) = [];
                m = m-1;
                MatchCell = MatchCell-1;
            end
            m = m+1;
        end
    end
end


%% 返回对应匹配索引
MatchesIndex = [];
for i = 1:ClusterNum_1
    for j = 1:ClusterNum_2
        if(~isempty(C3{i,j}))
            MatchesIndex = [MatchesIndex;C3{i,j}(:,1)];
        end
    end
end

MatchesIndex = sort(MatchesIndex);


end

