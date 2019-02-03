function [joints_kalman] = kf_test(joints, QQ, RR)
joints_kalman = zeros(size(joints,1),size(joints,2),size(joints,3));

%% Joints
for k = 1:size(joints,2)
    
    %% Define Main Variables
    % sampling rate
    dt = 1;
    
    % acceleration magnitude
    u = .005;
    
    % initialize state
    x = [joints(1,k,1); joints(2,k,1); 0; 0];

    % initialize estimate covariance matrix
    Q = QQ(:,:,k);
    P = Q;
    
    % measurement noise covariance
    R = RR(:,:,k);
    
    %% Define Coefficient Matrices (Physics-Based Model)
    % state update matrices
    A = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
    B = [(dt^2/2); (dt^2/2); dt; dt];
    
    % measurement update matrix
    C = [1 0 0 0; 0 1 0 0];
    
    %% Kalman Filter
    for t = 1:length(joints)
        disp(['Applying Kalman filter to frame ' num2str(t) ' of ' num2str(length(joints)) ' for joint ' num2str(k)]);
        
        %%%%%%%%%%%%%%%%%%%
        % Prediction Step %
        %%%%%%%%%%%%%%%%%%%
        % predict next state
        x = A*x;% + B*u;
        
        % predict next covariance
        P = A*P*A' + Q;
        
        %%%%%%%%%%%%%%%
        % Update Step %
        %%%%%%%%%%%%%%%
        % calculate Kalman gain
        K = P*C'*inv(C*P*C' + R);
        
        % update state estimate
        if ~isnan(joints(:,k,t))
            x = x + K * (joints(:,k,t) - C*x);
        end
        
        % update covariance estimate
        P = (eye(4) - K*C)*P;
        
        %%%%%%%%%%%%%%%%%%
        % Save Variables %
        %%%%%%%%%%%%%%%%%%
        joints_kalman(:,k,t) = [x(1); x(2)];
        
    end
    
end

end

