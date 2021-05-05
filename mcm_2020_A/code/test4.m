function test4
% ��һ��ģ��2004�����˷�Χ��Ⱥ�ֲ�
clear,clc,close all
load('A_pre.mat');
A(:) = A(:)*100;
control = [0,0];
% control(1) 0 : �����ܿط�Χ�� 1 : ����
% control(2) 0 : ��������Χ�����¶���Ⱥ�ֲ��� 1 : ֻ�����ܿط�Χ����Ⱥ
%% 2004�������¶ȷֲ�ͼ
Q = A(:,:,1); % ��ȡ2004���¶�
temp1 = [9.7 12.2]*100;% ����
temp2 = [3.7 6.2]*100;% ����
% posS = [28 44];% �ո���λ��
posS = [29.5 44.5];% �ո���λ��
mapD = 102.6923;% ��ͼ��һ�����ӵĳ���
% �ܿ�����
r = 889/mapD;
realX = posS(2)-r;
realY = posS(1)-r;
% [idxx1,idxy1] = find(Q>=temp1(1) & Q<=temp1(2));
% [idxx2,idxy2] = find(Q>=temp2(1) & Q<=temp2(2));
[idxx1,idxy1] = find(Q>=temp1(1) & Q<=temp1(2));
[idxx2,idxy2] = find(Q>=temp2(1) & Q<=temp2(2));
D1 = [idxx1,idxy1];

D2 = [idxx2,idxy2];
if control(2) == 1
%% ����������ѡ��1
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
elseif control(2) == 0
    D1 = D1';
    D2 = D2';
end
% D1 = D1(find(sqrt(D1-tempS1)<=r))';
% D2 = D2(find(sqrt(D2-tempS2)<=r))';
c = getMap(Q,D1,D2);
hold on
imshow(c,'InitialMagnification','fit')
% ������
x = 0.5 : 222-133+2-0.5;
y = 0.5 : 69-5+2-0.5;
[M,N] = meshgrid(x,y);
hold on
plot(x,N,'k');
plot(M,y,'k');
if control(1) == 0
    % ���ƹܿط�Χ
    hold on
    rectangle('Position',[realX,realY,2*r,2*r],'Curvature',[1,1],'linewidth',2,'EdgeColor','g'),axis equal
end
scatter(44.5,29.5,[70],'filled','g')


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
aaa = size(D1);
for i = 1 : aaa(2)
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