function test11
%��3�ʡ�������
clear,clc 
global dt Tc;
Tc = 1; 
dt = 0.1; % ʱ����ɢ���� 
T1s = 50;
%% ������� 
[t1, error] = funRes(T1s); % t0����ʼ������ʱ
t1 = 50;
%% ���¼������Ų��� ����¼״ֵ̬ 
countt = 1;
N = 1000*Tc/dt;density = 0.850; % �ܶȳ�ֵ 
for n = 1:N % ��ɢ���� 
    time = n * dt; % ����ʵ��ʱ�� % ���������� 
    count0 = ceil(time/t1);%��һ�����ڣ�����0.5
    if count0 == countt
        quatyG = (8.2576-2.413)*pi*2.5^2*0.804541084;%��������
        count0 = countt;
        countt = countt + 1;
        T1Rand = t1*(1-rand*0);
    end
    Tra(n) = T1Rand;
    %����
    inQual = inFuel(time, density, quatyG, T1Rand); 
    inQ(n) = inQual; % ��¼ֵ 
    quatyG = quatyG - inQual;
    %����
    outQual = outFuel(time, density); 
    outQ(n) = outQual;% ��¼ֵ
    %�����ܶ�
    allM = density*pi*5^2*500; % ���������� 
    density = (allM - outQual + inQual)/(pi*5^2*500); % ����ƽ���ܶ�
    Denp(n) = funP2(density); % �����ʱ��ѹ�� 
    redu = 0;
    if Denp(n) > 100
        dP = Denp(n) - 0.1;
        C = 0.85;
        A = pi*0.7^2;
        redu = dt*C*A*sqrt(2*dP/density)*density;
        allM = density*pi*5^2*500; % ���������� 
        density = (allM - redu)/(pi*5^2*500); % ����ƽ���ܶ�
        Denp(n) = funP2(density); % �����ʱ��ѹ�� 
    end
    reduQ(n) = redu;
    Err1(n) = Denp(n) - 100; % ������� 
end
Err2 = sum(Err1)/N; % ��ʱ����������������� 
Err3 = sum(abs(Err1))/N;
figure 
plot((1:N)*dt,Denp,'-','Linewidth',1) 
legend('ѹǿ����') 
xlabel('ʱ�� t(ms)') 
ylabel('ѹǿ P(Mpa)') 
set(gcf,'units','centimeters') % ��׼��λ������ 
set(gcf,'InnerPosition',[0 5 16 8]) % ����Ļ��λ�ã�ͼ���ĳ��� % ����ѹǿ�� 
figure 
plot((1:N)*dt,Err1,'-','Linewidth',1) 
legend('ѹǿ��') 
xlabel('ʱ�� t(ms)') 
ylabel('ѹǿ�� P(Mpa)') 
set(gcf,'units','centimeters') % ��׼��λ������ 
set(gcf,'InnerPosition',[16 5 16 8]) % ����Ļ��λ�ã�ͼ���ĳ��� 
% ����ʱ�������ٺ�ʱ���뷧���ٹ�ϵͼ 
figure 
yyaxis left 
plot((1:N)*dt,reduQ/dt,'r-','Linewidth',0.6) % 
axis([1,Tc*1000,0,4]) 
xlabel('ʱ�� t(ms)') 
ylabel('������ v(mg/ms)') 
yyaxis right 
plot((1:N)*dt,Err1,'b-','Linewidth',1) % 
axis([0 1000 0 10])
legend('ѹ�����')
xlabel('ʱ�� t(ms)') 
ylabel('ѹǿ�� P(Mpa)') 
legend('ѹǿ��','������') 
set(gcf,'units','centimeters') % ��׼��λ������ 
set(gcf,'InnerPosition',[0 8 16 8]) % ����Ļ��λ�ã�ͼ���ĳ��� 
fprintf('�������Ϊ��%.3f Mpa\n',Err3) 
fprintf('���ͽ��ٶ�Ϊ%.3frad/ms\n',2*pi/t1) 
fprintf('��������Ϊ%.3fms\n',t1)
end
%% ������͹�������
    function [T1, error] = funRes(T1s) 
    global dt Tc
    N = 1000*Tc/dt;%һ�����ڵ���ɢʱ���ĸ���
    s = 0; 
    for Tt1 = T1s % �����������͹������� 
        countt = 1;
        density = 0.850; % �ܶȳ�ֵ 
        for n = 1:N % ��ɢ���� 
            time = n * dt; % ����ʵ��ʱ�� % ���� 
            count0 = ceil(time/Tt1);%��һ�����ڣ�����0.5
            if count0 == countt
                quatyG = (8.2576-2.413)*pi*2.5^2*0.804541084;%��������
                count0 = countt;
                countt = countt + 1;
            end
            %����
            inQual = inFuel(time, density, quatyG, Tt1); 
            quatyG = quatyG - inQual;
            %����
            outQual = outFuel(time, density); 
            %�����ܶ�
            allM = density*pi*5^2*500; % ���������� 
            density = (allM - outQual*2 + inQual)/(pi*5^2*500); % ����ƽ���ܶ�
            thisDen = funP2(density);
             if thisDen > 100
                dP = thisDen - 0.1;
                C = 0.85;
                A = pi*0.7^2;
                redu = dt*C*A*sqrt(2*dP/density)*density;
                allM = density*pi*5^2*500; % ���������� 
                density = (allM - redu)/(pi*5^2*500); % ����ƽ���ܶ�
                thisDen = funP2(density); % �����ʱ��ѹ�� 
             end
            Err1(n) = thisDen - 100; % ������� 
        end
        s = s+1; 
        Tt(s) = Tt1; 
        Err2(s) = sum(Err1)/N; % ��ʱ����������������� 
        Err3(s) = sum(abs(Err1))/N; % ������� 
    end
    [~,post] = min(abs(Err2));% ��С��� 
    T1 = Tt(post); 
    error = Err3(post); % ������� 
    end
    %% ���ͼ���
    function inQual = inFuel(time, density, quatyG, Tt1) 
    global dt;% ����ȫ�ֱ��� dt��Ϊʱ����ɢ���� 
    C = 0.85; % ����ϵ�� 
    A = pi*0.7^2;% A �ڵ���� 
    time = mod(time,Tt1);
    densityThis = quatyG/(pi*2.5^2*(8.2576-funP1(time,Tt1)));
    P1 = funP2(densityThis);
    dP = P1 - funP2(density);
    if dP >0
        inQual = dt*C*A*sqrt(2*dP/densityThis)*densityThis;
    else
        inQual = 0;
    end
        function y = funP1(time,Tt1)
            %���㼫������
            x = time/Tt1*2*pi;
            if x > pi
               x = 2*pi - x;
            end
               p = [ 0.002396583071159  -0.045169447134520   0.259343667669763  -0.287191167671020  -0.949901781277620  -0.094085519017568   7.247157138979486];
               y = p(1)*x.^6 + p(2)*x.^5 + p(3)*x.^4 + p(4)*x.^3 + p(5)*x.^2 + p(6)*x + p(7);
        end
    end
    %% �ܶ�ѹǿת������
    function y = funP2(density)
    a0 = 0.0006492; 
    a2 = 1.181e-09; 
    a1 = -2.005e-06; 
    C1 = -0.217807596; 
    x1 = 0; 
    x2 = 200; 
    for i = 1:15 
        x3 = (x1+x2)/2; 
        diff = C1 + a0*x3 + a1*x3^2/2+a2*x3^3/3 - log(density);%�ɸ���������϶��� 
        if diff >0 
            x2 = x3; 
        else
            x1 = x3; 
        end
    end
    y = x1; 
    end
    %% ����������
function outQual = outFuel(time, density) 
global dt;% ����ȫ�ֱ��� dt��Ϊʱ����ɢ���� 
C = 0.85;
time = mod(time,100); % �������ڵĴ��ڣ�ʱ��ȡ���ڵ�ģ 
outQual = dt*C*fA(time)*sqrt(2*(funP2(density) - 0.1)/density)*density;
    %������������̹�ϵ
end
function y = fA(t) 
    if t <= 0.3 
        p = 1e2*[  -7.990867642426816   5.971928252693086  -1.060265726099315   0.102083238968809 -0.003637386453599   0.000024184456616 ];
        y =  p(1)*t.^5 + p(2)*t.^4+ p(3)*t.^3 + p(4)*t.^2 + p(5)*t.^1 + p(6);
    elseif t <= 2.11 
        y = 1.53938040025900; 
    elseif t<= 2.46 
          p = 1e5*[0.007994714617843  -0.091940724563929   0.422208758333050  -0.967598402398776 1.106430728853096  -0.504897309130628 ];
          y =  p(1)*t.^5 + p(2)*t.^4+ p(3)*t.^3 + p(4)*t.^2 + p(5)*t.^1 + p(6);
    else
        y = 0; 
    end
end
