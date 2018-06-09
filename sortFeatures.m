%sorts all of the features in ascending order according to their correlation values
clc
clear
load featurePCC
load featureName18

featurePCCrank = cell(18,2);

for i = 1 : 18
    featurePCCrank{i,1} = featureName18{1,i};
    featurePCCrank{i,2} = featurePCC(i,1);
end
featurePCCrank = sortrows(featurePCCrank,2);   
% featurePCCrank = sortrows(featurePCCrank,-2);  
save('featurePCCrank','featurePCCrank');

Dissimilar = featurePCCrank(1:12,2);
Similar = featurePCCrank(13:18,2);
save('Dissimilar','Dissimilar');
save('Similar','Similar');