clear; clc;
load factor.mat;
TestSamNum = 11;             % 学习样本数量
ForcastSamNum = 1;           % 预测样本数量
HiddenUnitNum=8;             % 隐含层
InDim = 4;                   % 输入层
OutDim = 1;                  % 输出层
% 原始数据 
p=factor(:,2:5)'; %输入量
t=factor(:,1)'; %输出量
%[SamIn, minp, maxp, tn, mint, maxt] = premnmx(p, t);   % 原始样本对（输入和输出）初始化
[P,minp,maxp,T,mint,maxt]= premnmx(p,t);
SamIn=P;
SamOut = T;         % 输出样本
MaxEpochs = 50000;   % 最大训练次数
lr = 0.05;           % 学习率
E0 = 1e-3;           % 目标误差
rng('default');
W1 = rand(HiddenUnitNum, InDim);      % 初始化输入层与隐含层之间的权值
B1 = rand(HiddenUnitNum, 1);          % 初始化输入层与隐含层之间的阈值
W2 = rand(OutDim, HiddenUnitNum);     % 初始化输出层与隐含层之间的权值              
B2 = rand(OutDim, 1);                 % 初始化输出层与隐含层之间的阈值
ErrHistory = zeros(MaxEpochs, 1);     
for i = 1 : MaxEpochs   
    HiddenOut = logsig(W1*SamIn + repmat(B1, 1, TestSamNum));   % 隐含层网络输出
    NetworkOut = W2*HiddenOut + repmat(B2, 1, TestSamNum);      % 输出层网络输出
    Error = SamOut - NetworkOut;       % 实际输出与网络输出之差
    SSE = sumsqr(Error);               % 能量函数（误差平方和）
    ErrHistory(i) = SSE;
    if SSE < E0
        break;
    end
    % 以下六行是BP网络最核心的程序
    % 权值（阈值）依据能量函数负梯度下降原理所作的每一步动态调整量
    Delta2 = Error;
    Delta1 = W2' * Delta2.* HiddenOut.* (1 - HiddenOut);    
    dW2 = Delta2 * HiddenOut';
    dB2 = Delta2 * ones(TestSamNum, 1); 
    dW1 = Delta1 * SamIn';
    dB1 = Delta1 * ones(TestSamNum, 1);
    % 对输出层与隐含层之间的权值和阈值进行修正
    W2 = W2 + lr*dW2;
    B2 = B2 + lr*dB2;
    % 对输入层与隐含层之间的权值和阈值进行修正
    W1 = W1 + lr*dW1;
    B1 = B1 + lr*dB1;
end
HiddenOut = logsig(W1*SamIn + repmat(B1, 1, TestSamNum));   % 隐含层输出最终结果
NetworkOut = W2*HiddenOut + repmat(B2, 1, TestSamNum);      % 输出层输出最终结果
a = postmnmx(NetworkOut, mint, maxt);    % 还原网络输出层的结果
x = 2006 : 2016;      % 时间轴刻度
newk = a(1, :);       % 网络输出价格

plot(x, newk, 'r-o', x, t, 'b--+');
legend('网络输出价格', '实际价格');
xlabel('年份');
ylabel('价格');
% 利用训练好的网络进行预测
pnew=[27093.3 28189 
    385723.25 273760
    352356.2 365600
    13.8 14];  % 2010年和2011年的相关数据；
pnewn = tramnmx(pnew, minp, maxp); 
HiddenOut = logsig(W1*pnewn + repmat(B1, 1, ForcastSamNum));  % 隐含层输出预测结果
anewn = W2*HiddenOut + repmat(B2, 1, ForcastSamNum);          % 输出层输出预测结果
anew = postmnmx(anewn, mint, maxt);
disp('预测值d：');
disp(anew);