function [Q_mle_avg, R_mle_avg] = kf_train(kf_gt, kf_raw)

% constant velocity model
A = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];
H = [1 0 0 0; 0 1 0 0];

% number of movement segments
T = 10;
M = 50;

% split up state vector
X = zeros(4,7,T,M);
s = 2; f = T+1;

for m = 1:M
    X(1:2,:,:,m) = kf_gt(:,:,s-1:f-1);
    idx = 2;
    
    for i  = s:f-1
        X(3,:,idx,m) = kf_gt(1,:,i) - kf_gt(1,:,i-1);
        X(4,:,idx,m) = kf_gt(2,:,i) - kf_gt(2,:,i-1);
        idx = idx + 1;
    end
    
    s = f+1; f = f+T;

end

%% Train Q
% calculate Q_mle and mu_mle for each m^th movement segment of each j^th joint
QQ_mle = zeros(4,4,7,M);
mmu_mle = zeros(4,7,T-1,M);
meanX = zeros(4,7,M);

for m = 1:M
    
    for j = 1:7
        
        meanX(:,j,m) = mean(X(:,j,:,m),3);
        
        for t = 2:T
            QQ_mle(:,:,j,m) = QQ_mle(:,:,j,m) + (X(:,j,t,m) - meanX(:,j,m))*(X(:,j,t,m) - meanX(:,j,m))';
            mmu_mle(:,j,t-1,m) = A*X(:,j,t-1,m);
        end
        
        QQ_mle(:,:,j,m) = QQ_mle(:,:,j,m) / (T-1);
        
    end
    
end

% construct first layer of GMM's (10 components per movement period)
Q_mle = zeros(4,4,7,M);
mu_mle = zeros(4,7,M);
dotprod = zeros(4,4,7,M);

for m = 1:M
    for j = 1:7
        mu_mle(:,j,m) = mean(mmu_mle(:,j,:,m),3);
        
        for t = 1:9
            dotprod(:,:,j,m) = dotprod(:,:,j,m) + mmu_mle(:,j,t,m)*mmu_mle(:,j,t,m)';
        end
        
        Q_mle(:,:,j,m) = QQ_mle(:,:,j,m) + (1/(T-1))*dotprod(:,:,j,m) - meanX(:,j,m)*meanX(:,j,m)';
          
    end
end

% construct second layer of GMM's (50 components in total)
Q_star = zeros(4,4,7);
mu_star = mean(meanX,3);
dotprod_star = zeros(4,4,7);

for j = 1:7
    
    for m = 1:M
        dotprod_star(:,:,j) = dotprod_star(:,:,j) + meanX(:,j,m)*meanX(:,j,m)';
    end
    

    Q_star(:,:,j) = (1/M)*sum(Q_mle(:,:,j,:),4) + (1/M)*dotprod_star(:,:,j) - mu_star(:,j)*mu_star(:,j)';

end

%% Train R
Rmle = zeros(2,2,7);

for j = 1:7
    for t = 1:T*M
        Rmle(:,:,j) = Rmle(:,:,j) + (kf_raw(:,j,t) - kf_gt(:,j,t))*(kf_raw(:,j,t) - kf_gt(:,j,t))';
    end
    Rmle(:,:,j) = Rmle(:,:,j) / (T*M);
end


%% Test Qmle and Rstar
Qmle = zeros(4,4,7);
    
for j = 1:7

    for t = 2:T
        Qmle(:,:,j) = Qmle(:,:,j) + (X(:,j,t) - A*X(:,j,t-1))*(X(:,j,t) - A*X(:,j,t-1))';
    end

    Qmle(:,:,j) = Qmle(:,:,j) / (T-1);

end

% calculate Q_mle and mu_mle for each m^th movement segment of each j^th joint
RR_mle = zeros(2,2,7,M);
mmu_mle = zeros(2,7,T,M);
kf_raw_reshaped = reshape(kf_raw,[2,7,T,M]);

for m = 1:M
    
    for j = 1:7
        
        for t = 1:T
            RR_mle(:,:,j,m) = RR_mle(:,:,j,m) + (kf_raw_reshaped(:,j,t,m) - H*X(:,j,t,m))*(kf_raw_reshaped(:,j,t,m) - H*X(:,j,t,m))';
            mmu_mle(:,j,t,m) = H*X(:,j,t,m);
        end
        
        RR_mle(:,:,j,m) = RR_mle(:,:,j,m) ./ (T);
        
    end
    
end

% construct first layer of GMM's (10 components per movement period)
R_mle = zeros(2,2,7,M);
mu_mle = zeros(2,7,M);
dotprod = zeros(2,2,7,M);

for m = 1:M
    for j = 1:7
        mu_mle(:,j,m) = mean(mmu_mle(:,j,:,m),3);
        
        for t = 1:T
            dotprod(:,:,j,m) = dotprod(:,:,j,m) + mmu_mle(:,j,t,m)*mmu_mle(:,j,t,m)';
        end
        
        R_mle(:,:,j,m) = RR_mle(:,:,j,m) + (1/(T))*dotprod(:,:,j,m) - mu_mle(:,j,m)*mu_mle(:,j,m)';
          
    end
end

% construct second layer of GMM's (50 components in total)
R_star = zeros(2,2,7);
mu_star = mean(mu_mle,3);
dotprod_star = zeros(2,2,7);

for j = 1:7
    
    for m = 1:M
        dotprod_star(:,:,j) = dotprod_star(:,:,j) + mu_mle(:,j,m)*mu_mle(:,j,m)';
    end
    
    R_star(:,:,j) = (1/M)*sum(R_mle(:,:,j,:),4) + (1/M)*dotprod_star(:,:,j) - mu_star(:,j)*mu_star(:,j)';

end

Q_mle_avg = zeros(4,4,7);
R_mle_avg = zeros(2,2,7);

for j = 1:7
    Q_mle_avg(:,:,j) = mean(QQ_mle(:,:,j,:),4);
    R_mle_avg(:,:,j) = mean(RR_mle(:,:,j,:),4);
end

end

