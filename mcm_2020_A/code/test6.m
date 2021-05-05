function test6
% ��һ��ģ��2004�����˷�Χ��Ⱥ�ֲ�����ͼ�λ�չʾ
clear,clc
load('A_pre_2.mat');
A(:) = A(:)*100;
%% 2004�������¶ȷֲ�ͼ
Q = A(:,:,1); % ��ȡ2004���¶�
temp1 = [9.7 12.2];% ����
temp2 = [3.7 6.2];% ����
% posS = [28 44];% �ո���λ��
posS = [29.5 44.5];% �ո���λ��
mapD = 102.6923;% ��ͼ��һ�����ӵĳ���
% �ܿ�����
r = 889/mapD;
[idxx1,idxy1] = find(Q>=temp1(1)*100 & Q<=temp1(2)*100);
[idxx2,idxy2] = find(Q>=temp2(1)*100 & Q<=temp2(2)*100);
D1 = [idxx1,idxy1];
D2 = [idxx2,idxy2];
temp = [];
for i = 1 : length(D1)
    if norm(D1(i,:)-posS)>r
        temp = [temp i];
    end
end
D1(temp,:) = [];
D1 = D1';
%% ����������ѡ��2
temp = [];
for i = 1 : length(D2)
    if norm(D2(i,:)-posS)>r
        temp = [temp i];
    end
end
D2(temp,:) = [];
D2 = D2';
% ������
Answer1 = [];
Answer2 = [];
N = 1000;
for n = 1 : N
    % ���ѡȡ��ʼλ��
    m1 = unidrnd(length(D1));
    m2 = unidrnd(length(D2));
    tempS1 = D1(:,m1);
    tempS2 = D2(:,m2);
    fishX1 = tempS1(1);
    fishY1 = tempS1(2);
    fishX2 = tempS2(1);
    fishY2 = tempS2(2);
    for i = 1 : 67
        % ѡ����ݶ�Ӧ�¶ȵ�ͼ
        E = A(:,:,i);
        % ½��
        M = min(E);
        %% Ԫ����������
        % ����
        F1 = E((fishX1-1:fishX1+1),(fishY1-1:fishY1+1));% ѡ���ʱ���㸽����3*3λ��
        [tempX,tempY] = getBestChoice(F1,temp1(1),temp1(2));
        fishX1 = fishX1 + tempX - 2;
        fishY1 = fishY1 + tempY - 2;
        tempS1(:,i+1) = [fishX1 fishY1];
        % ����
        F2 = E((fishX2-1:fishX2+1),(fishY2-1:fishY2+1));% ѡ���ʱ���㸽����3*3λ��
        [tempX,tempY] = getBestChoice(F2,temp2(1),temp2(2));
        fishX2 = fishX2 + tempX - 2;
        fishY2 = fishY2 + tempY - 2;
        tempS2(:,i+1) = [fishX2 fishY2];
        if i == 17
            Answer1 = [Answer1;tempS1(:,end)'];
            Answer2 = [Answer2;tempS2(:,end)'];
        end
    end
end
c = getMap(Q,Answer1',Answer2');
hold on
imshow(c,'InitialMagnification','fit')
x = 0.5 : 222-133+2-0.5;
y = 0.5 : 69-5+2-0.5;
[M,N] = meshgrid(x,y);
hold on
plot(x,N,'k');
plot(M,y,'k');
realX = posS(2)-r;
realY = posS(1)-r;
rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
[xx1,yy1] = k_means(Answer1);
[xx2,yy2] = k_means(Answer2);
scatter(yy1,xx1,[100],'filled','b')
scatter(yy2,xx2,[100],'filled','b')
scatter(44.5,29.5,[100],'filled','g')

scatter(42,28.84,[100],'filled','g')
% scatter(43.5,28.5,[100],'filled','m')
% realX = 43.5-r;
% realY = 28.5-r;
% rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
% scatter(42.5,31.5,[100],'filled','g')
function [bestX,bestY] = getBestChoice(P,a,b)
%% ѡȡԪ�����λ��
% P : Ԫ������3*3����
% a : ����¶�����
% b : ����¶�����
% M : ���λ��
a = a*100;
b = b*100;
N = length(find(P >= a & P <= b));
if N > 0
   % �����ѡ��
   [r,c] = find(P >= a & P <= b);
   m = unidrnd(N);
   bestX = r(m);
   bestY = c(m);
else
    % �����ѡ��
    A = zeros(3,3);
    for i = 1 : 3
        for j = 1 : 3
            if P(i,j) < a
               A(i,j) = abs(P(i,j)-a);
            elseif P(i,j) > b
                A(i,j) = abs(P(i,j)-b);
            end
        end
    end
    N = length(find(A==min(A(:))));
    if N == 1
        [bestX,bestY] = find(A==min(A(:)));
    else
        m = unidrnd(N);
        [bestX,bestY] = find(A==min(A(:)));
        bestX = bestX(m);
        bestY = bestY(m);
    end
end

function C = getMap(E,D1,D2)
%% ����RGB
% �������½��ΪG������ΪR������ΪB
[a,b] = size(E);
Ea = zeros(a,b);
Eb = zeros(a,b);
R = zeros(a,b);
G = zeros(a,b);
B = ones(a,b);
C = zeros(a,b,3);
for i = 1 : a
    for j = 1 : b
        if E(i,j) > 0
            Ea(i,j) = E(i,j);
        else
            Eb(i,j) = E(i,j);
        end
    end
end
R = Ea./max(Ea); % ��һ��
for i = 1 : a
    for j = 1 : b
        if E(i,j) == -32768
            G(i,j) = 255;
            R(i,j) = 255;
            B(i,j) = 255;
        end
    end
end
for i = 1 : length(D1)
   d = D1(:,i);
   if d(1)~=0 & d(2)~=0
       R(d(1),d(2)) = 1; % ��ɫ
       G(d(1),d(2)) = 192/255; % ��ɫ
       B(d(1),d(2)) = 203/255; % ��ɫ
   end
end

for i = 1 : length(D2)
   d = D2(:,i);
   if d(1)~=0 & d(2)~=0
       R(d(1),d(2)) = 100; % ��ɫ
       G(d(1),d(2)) = 12/255; % ��ɫ
       B(d(1),d(2)) = 103/255; % ��ɫ
   end
end

B = B./3;
C(:,:,1) = R;
C(:,:,2) = G;
C(:,:,3) = B;

function [dataX,dataY] = k_means(data)
% my_kmeans
% By Chris, zchrissirhcz@gmail.com
% 2016��9��30�� 19:13:43

% ������Ŀk
K = 4;

% ׼�����ݣ�������2ά��,80�����ݣ���data.txt�ж�ȡ
%data = zeros(100, 2);
% load 'Answer1.mat'; % ֱ�Ӵ洢��data������
% data = Answer1;
x = data(:,1);
y = data(:,2);

% �������ݣ�2άɢ��ͼ
% x,y: Ҫ���Ƶ����ݵ�  20:ɢ���С��ͬ����Ϊ20  'blue':ɢ����ɫΪ��ɫ
% s = scatter(x, y, 20, 'blue');
% title('ԭʼ���ݣ���Ȧ����ʼ���ģ����');

% ��ʼ������
sample_num = size(data, 1);       % ��������
sample_dimension = size(data, 2); % ÿ����������ά��

% �����ֶ�ָ�����ĳ�ʼλ��
clusters = zeros(K, sample_dimension);
clusters(1,:) = [-3,1];
clusters(2,:) = [2,4];
clusters(3,:) = [-1,-0.5];
clusters(4,:) = [2,-3];

% hold on; % ���ϴλ�ͼ��ɢ��ͼ�������ϣ�׼���´λ�ͼ
% ���Ƴ�ʼ����
% scatter(clusters(:,1), clusters(:,2), 'red', 'filled'); % ʵ��Բ�㣬��ʾ���ĳ�ʼλ��

c = zeros(sample_num, 1); % ÿ�����������صı��

PRECISION = 0.0001;


iter = 100; % �ٶ�������100��
for i=1:iter
    % ���������������ݣ�ȷ�������ء���ʽ1
    for j=1:sample_num
        %t = arrayfun(@(item) item
        %[min_val, idx] = min(t);
        gg = repmat(data(j,:), K, 1);
        gg = gg - clusters;   % norm:��������ģ��
        tt = arrayfun(@(n) norm(gg(n,:)), (1:K)');
        [~, minIdx] = min(tt);
        % data(j,:)���������ģ����ΪminIdx
        c(j) = minIdx;
    end
    
    % ���������������ݣ����´��ġ���ʽ2
    convergence = 1;
    for j=1:K
        up = 0;
        down = 0;
        for k=1:sample_num
            up = up + (c(k)==j) * data(k,:);
            down = down + (c(k)==j);
        end
        new_cluster = up/down;
        delta = clusters(j,:) - new_cluster;
        if (norm(delta) > PRECISION)
            convergence = 0;
        end
        clusters(j,:) = new_cluster;
    end
%     figure;
%     f = scatter(x, y, 20, 'blue');
%     hold on;
%     scatter(clusters(:,1), clusters(:,2), 'filled'); % ʵ��Բ�㣬��ʾ���ĳ�ʼλ��
%     title(['��', num2str(i), '�ε���']);
    
    if (convergence)
        
        dataX = clusters(i,1);
        dataY = clusters(i,2);
%         disp(['�����ڵ�', num2str(i), '�ε���']);
        break;
    end
end