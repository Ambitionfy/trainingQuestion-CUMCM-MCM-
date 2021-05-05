function test10
%ʵ����������ٶȱ������
clear,clc 
global dt Tc;
Tc = 5; 
dt = 0.1; % ʱ����ɢ���� 
%% ������� 
% for w = 1 : 1 : 40
funRes(); % t0����ʼ������ʱ
% end
end
%% ������͹�������
    function [T1, error] = funRes() 
    global dt Tc
    N = 1000*Tc/dt;%һ�����ڵ���ɢʱ���ĸ���
    s = 0; 
    wall = [];
    for w = 27 :0.5: 60 % �����������͹������� 
        wall = [wall w];
        Tt1 = 2*pi/w*1e3;
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
            Err1(n) = funP2(density) - 100; % �������
        end
        s = s+1; 
        Tt(s) = Tt1; 
        Err2(s) = sum(Err1)/N; % ��ʱ����������������� 
        Err3(s) = sum(abs(Err1))/N; % ������� 
    end
    figure
    plot(wall,Err3,'linewidth',1)
    xlabel('���ٶ�/rad/s');
    ylabel('���')
    title('���ٶȱ������')
    [~,post] = min(abs(Err3));% ��С��� 
    
    w = wall(post)
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
        inQual = dt*C*A*sqrt(2*dP/densityThis)*density;
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
