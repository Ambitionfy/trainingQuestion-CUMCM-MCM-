function PSO
clear,clc,close all
%����Ⱥ�㷨
s1 = 1.49445;
s2 = 1.49445;%ѧϰ����
Maxg = 100;%��������
SizePop = 100;%��Ⱥ��ģ
x1max = 1;
x1min = 0.01;
x2max = 100;
x2min = 0.01;
x3max = 31.5;
x3min = 28.5;
Vmax = 1;
Vmin = -1;
par_num = 3;
%������ʼ���Ӻ��ٶ�
for i = 1 : SizePop
   Pop(i,1) = rand(1); 
   Pop(i,2) = 10*rand(1);
   Pop(i,3) = 30+1.5*rands(1); 
   V(i,:) = rands(1,par_num);
   %������Ӧ��
   
   Fitness(i) = test9(Pop(i,1),Pop(i,2),Pop(i,3));
end

%%����λ�ó�ʼ��
[BestFitness,BestIndex] = max(Fitness);
gBest = Pop(BestIndex,:);%ȫ������
pBest = Pop;
FitnesspBest = Fitness;%���������Ӧ��
FitnessgBest = BestFitness;%ȫ�������Ӧ��

%%����Ѱ��
for i  = 1 : Maxg
    for j = 1 : SizePop
        %��Ⱥ�и������ٶȸ���
        V(j,:) = V(j,:) + s1*rand*(pBest(j,:)-Pop(j,:)) + s2*rand*(gBest-Pop(j,:));
        %�����ٶȡ���������ֵ����Ϊ��ֵ
        V(j,find(V(j,:) > Vmax)) = Vmax;
        V(j,find(V(j,:) < Vmin)) = Vmin;
        %��Ⱥ����λ�ø���,0.5�ɻ���0-1������
        Pop(j,:) = Pop(j,:) + 0.5*V(j,:);
        Pop(find(Pop(:,1) > x1max),1) = x1max;
        Pop(find(Pop(:,1) < x1min),1) = x1min;
        Pop(find(Pop(:,2) > x2max),2) = x2max;
        Pop(find(Pop(:,2) < x2min),2) = x2min;
        Pop(find(Pop(:,3) > x3max),3) = x3max;
        Pop(find(Pop(:,3) < x3min),3) = x3min;
        Fitness(j) = test9(Pop(j,1),Pop(j,2),Pop(j,3));%������Ӧ��
        %�������Ÿ���
        if Fitness(j) > FitnesspBest(j)
           pBest(j,:) =  Pop(j,:);
           FitnesspBest(j) = Fitness(j);
        end
        %Ⱥ�����Ÿ���
        if Fitness(j) > FitnessgBest
           gBest = Pop(j,:);
           FitnessgBest = Fitness(j);
        end
    end
    yy(i) = FitnessgBest;
end
%%������
[FitnessgBest, gBest]

figure
plot(yy)
title('���Ÿ�����Ӧ��', 'fontsize', 12);
xlabel('��������', 'fontsize', 12);
ylabel('��Ӧ��', 'fontsize', 12);
