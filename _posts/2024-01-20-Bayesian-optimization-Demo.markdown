---
title:  " Seeing Bayesian Optimization in Action: An Animated MATLAB Example"
date:   2024-01-14 3:20:00 +0900
permalink: /posts/Bayesian-optimizatin-Demo/
---
Bayesian optimization is an iterative process that starts with prior beliefs about the objective function to be estimated, including its smoothness and other characteristics. Over time, it collects more evidence through an acquisition function to refine its initial beliefs about the objective function.

To implement the Bayesian optimization algorithm, the first step is to choose an objective function that accurately represents the system to be modeled and optimized. Typically, the Gaussian process model is employed, and it has also been utilized for this demo.

## Gausian Process
Gausian process model described with mean $(\mu (x))$ and covariance $(k(x,x'))$ functions. Then, the objecetive function represented as:

$ f(x) \sim GP(\mu(x), k(x,x'))$

Initially, the mean value is assumed to be zero. When a new observation made, both the mean and the covariance will be updated using the equations of the posterior distribution function. 

The covarince function $k(x,x')$ also called a kernel funciton. The common kernel function to model Gaussian process is an exponential quadratic function represented as follows.

$ K(X_1,X_2)=\sigma^2 \left (-\frac{||X_1 - X_2||^2}{2l^2}  \right )$ \
Initially, the covariance fucntion computed from the hypper parameter values $\sigma$,representing the variance in the model,and $l$, which aslo represents the length scale. $X_1$ and $X_2$ are input variables for 2D search space. The covariance (kernel) fuction can be implemented in MATLAB code as given below.

{%highlight MATLAB %}
% For 1-D
function f = kernel_x(X,l,sig_var)
    distance = squareform(pdist(X));
    f = sig_var*exp(-distance.^2./(2*l^2));
end
{% endhighlight %}



{%highlight MATLAB %}
% For 2-D
function f = kernel_xy(x, y, l, sigma)
    distance = pdist2(x,y);
    f= sigma*exp(-distance.^2./(2*l^2));
end
{% endhighlight %}

The next step involves the implementaion of acquisition function. There are number of acquistion functions. For this demo, expected improvement is selected. 

## Acquisition Function
$$
	\text{EI}(x;\xi) = 
    \begin{cases} 
		\left(f(x^\star)  - \mu(x)  - \xi\right) \Phi\left(\frac{f(x^\star) -
		\mu(x)-\xi}{\sigma(x)}\right) + \sigma(x) \phi\left(\frac{f(x^\star) -
		\mu(x) -\xi}{\sigma(x)}\right) , & \quad \sigma(x) > 0 \\ 
        0, & \quad \sigma(x) \leq 0
	\end{cases}
$$
where, \
     EI $\rightarrow$ expected improvement  
     $\xi$ $\rightarrow$  exploration-exploitation tradeoff parameter  
     $\phi$ $\rightarrow$ normal probablity distribution function   
     $\Phi$ $\rightarrow$ normal cumulative distribution function  
     $\sigma$ $\rightarrow$ expected mean uncertainity  
     $f(x^*)$ $\rightarrow$ optimum value found so far  

The above equation can be written in compact form
$$
EI(z) = 
\begin{cases}
   \sigma(x) \left( z \Phi\left( z \right) +  \phi\left(z\right) \right) , & \quad \sigma(x) > 0 \\
 0, & \quad \sigma(x) \leq 0
\end{cases}
$$

where  
    $z = \frac{d}{\sigma(x)}$  
    $d=f(x^\star) - \mu(x)-\xi $ 

MATLAB implementation:
{%highlight MATLAB %}
function EI = aqufun(ytrain, mu, stdv,xi)
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
{% endhighlight %}

## Model  Update

The joint distribution of the training output, $f$, and test data output, $f_\star$,  with noisy observation is described as follows:

$$
\begin{bmatrix} y \\ f_\star\end{bmatrix}  = \mathcal{N} \begin{pmatrix}0,\begin{bmatrix}
K(X,X) + \sigma_n^2I & K(X,X_\star) \\ K(X_\star,X) & K(X_\star,X_\star) 
\end{bmatrix}\end{pmatrix}
$$

A conditional probability is applied to obtain the posterior distribution over a function that agrees with the observed data points.

$$
f_\star|X,y,X_\star  \sim \mathcal{N}(\bar{f_\star}, cov(f_\star)), 
$$

where  
$$
 \bar{f_\star}  \overset{\Delta}{=} \mathbb{E}[f_\star|X,y,X_\star] = K(X_\star,X)[K(X,X) + \sigma_n^2I]^{-1}y \\  
 cov(f_\star)   = K(X_\star,X_\star) - K(X_\star,X)[K(X,X)+\sigma_n^2I]^{-1}K(X,X_\star)
$$

The MATLAB Implementation :
{% highlight MATLAB %}
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
{% endhighlight %}


### Full MATLAB Code

For this demonstration, observation values are sampled from a sine function. Consequently, the objective function is expected to approximate a sine wave as the number of obsevations increases.

{% highlight MATLAB %}

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
    EI = aqufun(ytrain, mu, stdv,i);
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

{% endhighlight %}