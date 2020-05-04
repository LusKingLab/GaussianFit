% Written by Emma Carley and Ivan Surovtsev 12/5/2019 - Last Updated
% 5/4/2020
%
% Purpose: Fit data to two Gausian curves then calculate the area under the
% curve of each
% 
% The input data is in a matrix where the first column of the
% matrix is the x-value for all plots and the other columns are the
% y-values for each plot. Currently the variable 'Data' is a placeholder
% for the name of the matrix with your data
%
% 
% INPUT:
% XX = x-data to fit
% YY = y-data to fit (size(y) must be equal size(x))
% Replace the "Data" variable with the name of your data matrix
% model = string specifing model from preset list.
% weights (optional) = array of wieghts for fitting (must the size of XX)
%
% OUTPUT:
% coeff = are best-fit parameters (values) of the model
% fit1  = is Matlab's fit object (useful for cofidence intevals, residuals etc)
% YYfit = returns values of the model with best-fit parameters values at points from XX
%  (useful for plotting) 
% coeff_all = matrix of the coefficients calculated for each curve
% coeff_all_new = ensures that the gaussian fits the left peak first then
% the right peak
% Area1 = area under the first gaussian
% Area2 = area under the second gaussian
% AreaRatio = ratio of the second to the first peak

coeff_all=[];
% Starts with an empty matrix for coeff_all

XX=Data(:,1);
% x is the first column of the data matrix

mat_size=size(Data);
% Dimensions of the matrix of the input data

for ii=2:mat_size(2)
    
YY=Data(:,ii); 

weights=ones(size(XX));

model1 = fittype('C+a*2*exp(-(x-x01).^2/(2*sigma1^2))/sqrt(2*pi*sigma1^2)+b*2*exp(-(x-x02).^2/(2*sigma2^2))/sqrt(2*pi*sigma2^2)','dependent',{'y'},'independent',{'x'},'coefficients',{'C','a','b','x01','x02','sigma1','sigma2'});
         par0 = [min(YY),max(YY)/2,max(YY)/2,2.2,2.8,0.4,0.4];
         ffit=2;
         lb=[min(YY),0,0,0,2.5,0.35,0.35]; ub=[Inf,Inf,Inf,max(XX),max(XX),1,1];

switch ffit
    case 2
      fit1 = fit(XX,YY,model1,'Startpoint',par0,'Weights',weights,'Lower',lb,'Upper',ub);
    case 1
      fit1 = fit(XX,YY,model1,'Startpoint',par0,'Weights',weights);
    case 0
      fit1 = fit(XX,YY,model1,'Startpoint',par0);
end

coeff=coeffvalues(fit1);
        C=coeff(1);
        a=coeff(2);
        b=coeff(3);
        x01=coeff(4);
        x02=coeff(5);
        sigma1=coeff(6);
        sigma2=coeff(7);
        YYfit = C+ a*2*exp(-(XX-x01).^2/(2*sigma1^2))/sqrt(2*pi*sigma1^2)+ b*2*exp(-(XX-x02).^2/(2*sigma2^2))/sqrt(2*pi*sigma2^2);
      
figure()
hold off
plot(XX,YY,'ok')
hold on
plot(XX,YYfit,'-r')

pause
% Code will pause so you can ensure the plot fits the data well. Press any key to continue

coeff_all(ii-1,:)=coeff;
% Matrix of the coeff values calculated for each graph in the dataset

end

coeff_all_new=coeff_all;
% Set coeff_all_new to be the same as coeff_all so that in the next step
% you only change coeff_all_new and not the original fit

% This next part of the code is to ensure that the gaussians are fit such
% that the gaussians with the lower peak X-value is considered the first
% peak (x1) and the gaussian with the higher peak X-value is considered the
% second gaussian (x2)

for ii=1:mat_size(2)-1
    
    x1=coeff_all(ii,4);
    x2=coeff_all(ii,5);
    % Pulls out the x-value of the two peaks from the coeff data
    
    if x1>x2
        coeff_all_new(ii,4)=coeff_all(ii,5);
        coeff_all_new(ii,5)=coeff_all(ii,4);
        coeff_all_new(ii,2)=coeff_all(ii,3);
        coeff_all_new(ii,3)=coeff_all(ii,2);
        coeff_all_new(ii,6)=coeff_all(ii,7);
        coeff_all_new(ii,7)=coeff_all(ii,6);
        
        % If the first peak calculated in the gaussian is not the left most
        % peak on the graph, the data will be rearranged so that it is 
        
    end
    
end

Area1=coeff_all_new(:,2).*coeff_all_new(:,6);
Area2=coeff_all_new(:,3).*coeff_all_new(:,7);
% Calculating the area under the curve for each gaussian 

AreaRatio = Area2./Area1;
% Calculate the ratio of the areas under the curve
