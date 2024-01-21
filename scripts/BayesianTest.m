
close all
clc
l = 1;
sig_var = 1;
xtrain = [-4,-3, -2, -1, 1]';
noise = 0.2;
ytrain = sin(xtrain);

% "Test" data ( what we want to estimate/ interpolate)
n_s = 500;
xtest = transpose(linspace(-5,5,n_s));
% Create plot 
figure(1)
set(gcf, 'WindowState', 'maximized');
for i=1:10
    [mu,cov,stdv]=GP(xtrain,ytrain,xtest,l,sig_var,0);
    stdv = real(stdv);
    [EI,phi,PHI,z, idx] = aqufun(ytrain, mu, stdv,i);
    [eimax,posEI] = max(EI);
    xEI = xtest(posEI,:);
    xtrain(end+1,:) = xEI;               % Save xEI as next
    ytrain(end+1) = sin(xEI);

    f_above = mu+2*stdv;
    f_below = mu-2*stdv;
    xx = xtest;
    if(i==1)
        test_pos =205;
    else
        test_pos = posEI;%205;
    end
    ypdf = normpdf(xtest);
    ycdf = normcdf(xtest);
    ff = [f_below; flip(f_above,1)];
    subplot(211)
    fill([xx;flip(xx,1)],ff,[7 7 7]/8)
    ylim([-4 4]);
    xlim([-5 5]);
    hold on
    plot(xtest,sin(xtest),'-b','LineWidth',2)
    scatter(xtrain,ytrain,'blue','filled','diamond')
    plot(xtest,mu,'r--','LineWidth',2)
   
    plot(xtest,z+mu(test_pos,1),'--g')
    if (i==1)
        plot(ypdf+xtest(test_pos,1),xtest+mu(test_pos,1));
        plot(ycdf+xtest(test_pos,1),xtest+mu(test_pos,1));

        %
        fill([xtest(test_pos,1);xtest(test_pos,1);flip(ycdf(find(xtest<=z(test_pos,1)),:),1)+xtest(test_pos,1);xtest(test_pos,1)],...
            [xtest(1,1)+mu(test_pos,1);z(test_pos,1)+mu(test_pos,1);flip(xtest(find(xtest<=z(test_pos,1)),:),1)+mu(test_pos,1);...
            xtest(1,1)+mu(test_pos,1)],[0.8500 0.3250 0.0980],'FaceAlpha',0.3)
    else
        if(test_pos < 250)
            quiver(xtest(test_pos+10,1), -2, -0.15, -1.9, 0, 'r','MaxHeadSize', 0.8,'LineWidth', 4);
        else
            quiver(xtest(test_pos-10,1), -2, 0.15, -1.9, 0,'r','MaxHeadSize', 0.8, 'LineWidth', 4);
        end
    end
    px = [-5 5];
    py = [ytrain(idx) ytrain(idx)];
    px1 = [xtrain(idx) xtrain(idx)];
    px2 = [xtest(test_pos,1) xtest(test_pos,1)];
    py1 = [-5 ytrain(idx)];
    py2 = [-5 5];
    line(px,py,'LineStyle','--','LineWidth',2);
    line(px1,py1,'LineStyle','--','LineWidth',2);
    if (i==1)
        line(px2,py2,'Color','#D95319','LineStyle','-');
    end
    title("data fitting  process with Bayessian optimization")
    xlabel("x")
    ylabel("f(x)")
    legend("$\pm$ $\sigma(x)$ region","true function","observed points","$\mu$ (x)", ...
        "$z = (f(x^\star) - \mu (x)-\xi)/\sigma$",'Location', 'northeast','Interpreter','latex');

    if(i==1)

        % Create text
        text('FontWeight','bold','String','z(x_{test}) \rightarrow',...
            'Position',[-1.516111793479424,0.842299072270407,0]);
        % Create textarrow
        xshift = 0.15;
        yshift = -0.2;
        annotation(gcf,'textarrow',[0.498828125 0.518750000000004],...
            [0.828030303030303 0.795454545454545],'String',{'$\Phi(z)$'},...
            'HorizontalAlignment','center','Interpreter','latex');

        % Create textarrow
        annotation(gcf,'textarrow',[0.429296875 0.4515625],...
            [0.834090909090909 0.796969696969697],'String','$\phi(z)$',...
            'HorizontalAlignment','center','Interpreter','latex');

        % Create textbox
        annotation(gcf,'textbox',...
            [0.343080357142864,0.545937785766092,0.011997767857138,0.027858961826228],...
            'String','x^*',...
            'FontWeight','bold',...
            'FontSize',12,...
            'EdgeColor','none');


        % Create textbox
        annotation(gcf,'textbox',...
            [0.418229166666668,0.547169930312498,0.013281249999999,0.023999999999999],...
            'String','x_{test}',...
            'FontWeight','bold',...
            'FitBoxToText','off',...
            'EdgeColor','none');

        % Create textbox
        annotation(gcf,'textbox',...
            [0.088715841450217,0.694070297958506,0.023268399016965,0.035369775953006],...
            'String','f(x^*)',...
            'FontWeight','bold',...
            'FontSize',12,...
            'FitBoxToText','off',...
            'EdgeColor','none');
    else
        % Find all annotations in the current figure
        annotations = findall(gcf,'Type','annotation');
        delete(annotations);
    end

    hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(212)
    plot(xtest,phi,'LineWidth',2);
    hold on
    plot(xtest,PHI,'Color',"#D95319",'LineWidth',2);
    plot(xtest,stdv,'--','LineWidth',2);
    plot(xtest,EI,'LineWidth',2)
    fill([0;xtest],[EI;0],'b','FaceAlpha',0.3)
    ylim([-0.8*max(EI) 1.5*max(EI)]);
    xlim([-5 5]);
    title("EI equation components plot")
    xlabel("x")
    ylabel("outputs")
    legend("$\phi$ (z(x))","$\Phi$ (z(x))","$\sigma$ (x)","EI(z(x))",'Interpreter','latex','Location','southeast');
    hold off
    if(i==1)
        pause(5)
    else
        pause(3)
    end
end







function[mu,cov,stdv] = GP(xtrain, ytrain,xtest, l, sig_var, noise_var)
    n_t = length(xtrain);
    K_ss = kernel_xy(xtest,xtest,l,sig_var);
    K    = kernel_xy(xtrain,xtrain,l,sig_var);
    L    = chol(K + noise_var*eye(n_t),'lower');
    K_s  = kernel_xy(xtrain,xtest,l,sig_var);
    alpha = L'\(L\ytrain);
    mu = K_s'*alpha;
    v = L\K_s;
    cov = K_ss - v'*v;
    stdv = sqrt(diag(cov));

end

function [EI,phi,PHI, z, idx] = aqufun(ytrain, mu, stdv,i)
    % Exploration-exploitation parameter (greek letter, xi)
    % High xi = more exploration
    % Low xi = more exploitation (can be < 0)
    if(i==1)
        xi = -0.2;
    else
        xi=0.02;
    end
    [f_star,idx]=min(ytrain);
    d = f_star- mu - xi; % (f* - y) if minimiziation
    z = d./stdv;
    phi = normpdf(z);
    PHI = normcdf(z);

    EI = (stdv ~= 0).*(d.*PHI + stdv.*phi);
end 


% For 2-D
function f = kernel_xy(x, y, l, sigma)
    distance = pdist2(x,y);
    f= sigma*exp(-distance.^2./(2*l^2));
end

% For 1-D
function f = kernel_x(X,l,sig_var)
    distance = squareform(pdist(X));
    f = sig_var*exp(-distance.^2./(2*l^2));
end