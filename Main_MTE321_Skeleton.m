% MTE 321 Project 2:
% Kinematic Analysis of Rotational Mechanism
% By: Ryan Chen, Jeremy Phy, Jackie Zhu
% Submitted April 5, 2022


% Independant variables in appropriate units
dtheta2 = 40;
ddtheta2 = 0;

% Initialize arrays to collect desired values
M12 = [];
Cx_list = zeros(1, 360);
Cy_list = zeros(1, 360);
dCx_list = zeros(1, 360);
dCy_list = zeros(1, 360);
ddCx_list = zeros(1, 360);
ddCy_list = zeros(1, 360);

theta3_list = zeros(1, 360);
dtheta3_list = zeros(1, 360);
ddtheta3_list = zeros(1, 360);

a2x_list = zeros(1, 360);
a2y_list = zeros(1, 360);
a3x_list = zeros(1, 360);
a3y_list = zeros(1, 360);

shaking_force = zeros(1, 360);
shaking_moment = zeros(1, 360);

M = cell(360, 1);

F12x_list = zeros(1, 360);
F12y_list = zeros(1, 360);
F23x_list = zeros(1, 360);
F23y_list = zeros(1, 360);
F13_list = zeros(1, 360);
M12_list = zeros(1, 360);



% Iterate through the values of theta to find the required for all angles:
for theta2 = 0:1:360
    
    % Part A and B) Eqns of angles and C's displacement
    theta3 = atan2d((0.12-0.05*sind(theta2)), (0.04-0.05*cosd(theta2)));

    ro3x = 0.05*cosd(theta2) + 0.10*cosd(theta3);
    ro3y = 0.05*sind(theta2) + 0.10*sind(theta3);
    r3 = sqrt(ro3x^2 + ro3y^2);

    dtheta3 = ((0.05*dtheta2)/r3)*cosd(theta2 - theta3);
    ddtheta3 = -(0.05/r3)*(dtheta2^2)*sind(theta2 - theta3);

    theta3_list(theta2 + 1) = theta3;
    dtheta3_list(theta2 + 1) = dtheta3;
    ddtheta3_list(theta2 + 1) = ddtheta3;

    Cx_list(theta2 + 1) = 0.05*cosd(theta2) + 0.20*cosd(theta3);
    Cy_list(theta2 + 1) = 0.05*sind(theta2) + 0.20*sind(theta3);

    dCx_list(theta2 +1) = -0.05*dtheta2*sind(theta2) - 0.20*dtheta3*sind(theta3);
    dCy_list(theta2 +1) = 0.05*dtheta2*cosd(theta2) + 0.20*dtheta3*cosd(theta3);

    ddCx_list(theta2 +1) = -0.05*(dtheta2^2)*cosd(theta2) - 0.20*(dtheta3^2)*cosd(theta3) - 0.20*ddtheta3*sind(theta3);
    ddCy_list(theta2 +1) = -0.05*(dtheta2^2)*sind(theta2) - 0.20*(dtheta3^2)*sind(theta3) + 0.20*ddtheta3*cosd(theta3);

    dR3 = 0.05*dtheta2*sind(theta2 - theta3);
    
    % Part C:
    vo3x = -0.05*dtheta2*sind(theta2) - 0.10*dtheta3*sind(theta3);
    vo3y = 0.05*dtheta2*cosd(theta2) + 0.10*dtheta3*cosd(theta3);
    
    ag2x = -0.025*(dtheta2^2)*cosd(theta2);
    ag2y = -0.025*(dtheta2^2)*sind(theta2);
    ag3x = -0.05*(dtheta2^2)*cosd(theta2) - 0.1*(dtheta3^2)*cosd(theta3) - 0.1*ddtheta3*sind(dtheta3);
    ag3y = -0.05*(dtheta2^2)*sind(theta2) - 0.1*(dtheta3^2)*sind(theta3) + 0.1*ddtheta3*cosd(dtheta3);
    
    Io = 5.33 * 10^-5;
    m2 = 0.00265;
    m3 = 0.016;

    % Solving Force matrix using Eqns from above
    B = [m2*ag2x; m2*ag2y; 0; m3*ag3x; m3*ag3y; Io*ddtheta3];
    A = [-1 0 1 0 0 0;
         0 -1 0 1 0 0;
         0 0 -0.05*sind(theta2) 0.05*cosd(theta2) 0 1;
         0 0 -1 0 cosd(theta3 - 90) 0;
         0 0 0 -1 sind(theta3 - 90) 0;
         0 0 -0.10*sind(theta3) 0.10*cosd(theta3) (r3-0.1)*cosd(theta3)*sind(theta3-90)-(r3-0.1)*sind(theta3)*cosd(theta3-90) 0
        ];

    F = A\B;
    
    M{theta2 + 1} = F;

    F12x_list(theta2 + 1) = F(1, 1);
    F12y_list(theta2 + 1) = F(2, 1);
    F23x_list(theta2 + 1) = F(3, 1);
    F23y_list(theta2 + 1) = F(4, 1);
    F13_list(theta2 + 1) = F(5, 1);
    M12_list(theta2 + 1) = F(6, 1);
    
    % Shaking force/moment Eqns for part D
    shaking_x = F(5, 1)*cosd(theta3-90) - F(1,1);
    shaking_y = F(5, 1)*sind(theta3-90) - F(2,1);
    shaking_force(theta2 + 1) = sqrt(shaking_x^2 + shaking_y^2);
    shaking_angle = atan2d(shaking_y, shaking_x);

    shaking_moment(theta2 + 1) = F(6, 1) - F(5, 1)*cosd(theta3-90)*0.12 - F(5, 1)*sind(theta3-90)*0.04;
    
end

% Plot all deliverables:
x = 0 : 1 : 360;
axis auto;
grid on;
figure_num = 1;

% Part A, Displacement, Linear Velocity and Linear Accelerations of C
figure(figure_num);
plot3(x, Cx_list, Cy_list);
grid on;
title("Displacement of C -vs- \theta_2");
xlabel('\theta_2  [degree]')
ylabel('X Position')
zlabel('Y Position')
view(90, 0);

figure_num = figure_num + 1;
figure(figure_num);
plot(x, dCx_list, x, dCy_list);
grid on;
legend('C_x', 'C_y'); 
title("Linear Velocity of C -vs- \theta_2");
xlabel('\theta_2  [degree]')
ylabel('Linear Velocity [m/s]')

figure_num = figure_num + 1;
figure(figure_num);
plot(x, ddCx_list, x, ddCy_list);
legend('C_x', 'C_y'); 
title("Linear Acceleration of C -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('Linear Accelerattion [m/s^2]')


% Part B, Angular Velocity and Angular Acceleration of link 3,
figure_num = figure_num + 1;
figure(figure_num);
plot(x, dtheta3_list);
title("Angular Velocity of Link 3 -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('d\theta_3  [rad/s]')


figure_num = figure_num + 1;
figure(figure_num);
plot(x, ddtheta3_list);
title("Angular Acceleration of Link 3 -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('dd\theta_3  [rad/s^2]')


% Part C =====
figure_num = figure_num + 1;
figure(figure_num);
plot(x, F12x_list);
title("F12x -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('F12x  [N]')

figure_num = figure_num + 1;
figure(figure_num);
plot(x, F12y_list);
title("F12y -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('F12y  [N]')

figure_num = figure_num + 1;
figure(figure_num);
plot(x, F23x_list);
title("F23x -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('F23x  [N]')

figure_num = figure_num + 1;
figure(figure_num);
plot(x, F23y_list);
title("F23y -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('F23y  [N]')

figure_num = figure_num + 1;
figure(figure_num);
plot(x, F13_list);
title("F13 -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('F13  [N]')

figure_num = figure_num + 1;
figure(figure_num);
plot(x, M12_list);
title("M12 -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('M12  [N]')


% Part D =====
figure_num = figure_num + 1;
figure(figure_num);
plot(x, shaking_force);
title("Shaking Force -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('Shaking Force  [N]')

figure_num = figure_num + 1;
figure(figure_num);
plot(x, shaking_moment);
title("Shaking Moment -vs- \theta_2");
grid on;
xlabel('\theta_2  [degree]')
ylabel('Shaking Moment  [N*m]')
