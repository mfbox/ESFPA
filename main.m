clc
clear
time = cputime;
load featureName18
load featurePCCrank

n = 20; 
p = 0.8;

% d = 11; 
d = 18; 
Maxiter = 100;
x = zeros(n,d);

%Initialize pollen
for i = 1 : n
    x(i,:) = randi([0 1],1,d);
end

for i = 1 : n
    fitness1 = cell(n,d);
    fitness2 = cell(n,d);
    for j = 1 : d
        if x(i,j)==1
            fitness1(i,j) = featureName18(1,j);
            tem1=~cellfun(@isempty,fitness1(i,1:d));  
            sumdata1=sum(tem1');
            fitness11(1,1:sumdata1) = fitness1(~cellfun(@isempty, fitness1));
        else
            fitness2(i,j) = featureName18(1,j);
            tem2=~cellfun(@isempty,fitness2(i,1:d));  
            sumdata2=sum(tem2');
            fitness22(1,1:sumdata2) = fitness2(~cellfun(@isempty, fitness2));
        end
    end

%     tem2=~cellfun(@isempty,fitness2(i,1:d));  
%     sumdata2=sum(tem2');
    
    [match1 matchindex1] = ismember(fitness11,featurePCCrank(1:12,1));   
    TP = sum(match1==1);   
    [match2 matchindex2] = ismember(fitness11,featurePCCrank(13:18,1));
    FP = sum(match2==1);   
    [match3 matchindex3] = ismember(fitness22,featurePCCrank(1:12,1));
    FN = sum(match3==1);   
    [match4 matchindex4] = ismember(fitness22,featurePCCrank(13:18,1));
    TN = sum(match4==1);   
    accPerformance(i) = (TP+TN)/(TP+FP+TN+FN);
    
    featureNum(i) = sum(x(i,:)~=0,2);
    if featureNum(i)==0
        Fitness(i) = 0;
    else
        Fitness(i) = 0.8*accPerformance(i) + 0.2*(1/featureNum(i));  
    end
    
      fitness11(:) = [];   
      fitness22(:) = [];
end

% [accMax,I] = max(accPerformance);
[fitMax,I] = max(Fitness);
gbestpos = x(I,:);


%Update the pollen positions
% accNew = zeros(n,1);
FitnessNew = zeros(n,1);
for t = 1 : Maxiter
    for i = 1 : n
%         for j = 1 : d
        if rand < p
            L = Levy(d);
            s(i,:) = x(i,:) + L;      
        else
            epsilon = rand;
            JK = randperm(n);
            s(i,:) = x(i,:) + epsilon*(x(JK(1),:)-x(JK(2),:));
        end
        
        fitness3 = cell(n,d);
        fitness4 = cell(n,d);
        for j = 1 : d
            sigma = rand;
            if sigma<(1/(1+exp(s(i,j))))
                s(i,j) = 1;
            else
                s(i,j) = 0;
            end
            s(i,find((s(i,1:12)-gbestpos(1,1:12)) ~= 0)) = gbestpos(find((s(i,1:12)-gbestpos(1,1:12)) ~= 0));    
                                                                 
%         for j = 1 : d
            if s(i,j)==1
                fitness3(i,j) = featureName18(1,j);
                tem3=~cellfun(@isempty,fitness3(i,1:d));  
                sumdata3=sum(tem3');
                fitness33(1,1:sumdata3) = fitness3(~cellfun(@isempty, fitness3));
            else
                fitness4(i,j) = featureName18(1,j);
                tem4=~cellfun(@isempty,fitness4(i,1:d));  
                sumdata4=sum(tem4');
                fitness44(1,1:sumdata4) = fitness4(~cellfun(@isempty, fitness4));
            end
        end
            
        [match5 matchindex5] = ismember(fitness33,featurePCCrank(1:12,1));   
        TP2 = sum(match5==1);  
        [match6 matchindex6] = ismember(fitness33,featurePCCrank(13:18,1));
        FP2 = sum(match6==1);   
        [match7 matchindex7] = ismember(fitness44,featurePCCrank(1:12,1));
        FN2 = sum(match7==1);   
        [match8 matchindex8] = ismember(fitness44,featurePCCrank(13:18,1));
        TN2 = sum(match8==1);  
        accNew(i) = (TP2+TN2)/(TP2+FP2+TN2+FN2);
        
        featureNumNew(i) = sum(s(i,:)~=0,2);
        if featureNumNew(i)==0
            FitnessNew(i) = 0;
        else
            FitnessNew(i) = 0.8*accNew(i) + 0.2*(1/featureNumNew(i));
        end
        
        fitness33(:) = [];   
        fitness44(:) = [];
        
%         if (accNew(i)>=accPerformance(i))
         if (FitnessNew(i)>=Fitness(i))
            x(i,:) = s(i,:);
            Fitness(i) = FitnessNew(i);
        end
        
%         if accNew(i)>=accMax
        if FitnessNew(i)>=fitMax
            gbestpos = s(i,:);
            fitMax = FitnessNew(i);
        end
              
    end    
end


time=cputime-time;