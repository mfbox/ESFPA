clc
clear

load featureMatrix

allfeaturePCC = zeros(18,18);    
featurePCC = zeros(18,1);

for i = 1 : 18
    for j = 1 :18
        xi = featureMatrix18(:,i);
        xj = featureMatrix18(:,j);
        m = length(xi);  
        xi_mean = mean(xi);
        xj_mean = mean(xj);
        
        tempi = 0;
        for k = 1 : m
           tempi = tempi + (xi(k)-xi_mean)^2; 
        end
        si = sqrt(tempi);

        tempj = 0;
        for k = 1 : m
           tempj = tempj + (xj(k)-xj_mean)^2; 
        end
        sj = sqrt(tempj);
        
        if si*sj==0   
            allfeaturePCC(i,j) = 0;    
        else
            temp = 0;
            for k = 1 : m
                temp = temp + ((xi(k)-xi_mean)*(xj(k)-xj_mean))/(si*sj);
            end
            allfeaturePCC(i,j) = temp;
        end
        %step2. 
        if (i~=j)
            featurePCC(i,1) = featurePCC(i,1) + allfeaturePCC(i,j);
%             featurePCC(i,1) = sum(allfeaturePCC(i,:),2);
        end
    end
    featurePCC(i,1) =  featurePCC(i,1)/(18-1);
end

save('allfeaturePCC','allfeaturePCC');
save('featurePCC','featurePCC');     