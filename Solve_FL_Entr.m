function E=Solve_FL_Entr(theta, d, rou_s, T, pFL)
%solve the pickup function of Fernandez Luque (1974)
%E is the volumetric entrainment flux
%pFL�ǹ�ʽ�в�����Van Rijn (1984)�����ʱ���ڲ�ͬ�������ò�ֵͬ��pFL�仯��Χ0.0121-0.138

theta_cri=Crit_Shields( d, rou_s, T );
delta=(rou_s-1000)/1000;
E=pFL*sqrt(delta*9.81*d)*(theta-theta_cri)^1.5;

