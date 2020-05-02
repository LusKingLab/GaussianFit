% Written by Emma Carley and Ivan Surovtsev 12/5/2019
%
% Purpose: Fit data to two Gausian curves then calculate the area under the
% curve of each - Based on Ivan's "oneFit" code
% 
% The input data is in a matrix (here LAC) where the first column of the
% matrix is the x-value for all plots and the other columns are the
% y-values for each plot
%
% --From Ivan's code--
% INPUT:
% x = x-data to fit
% y = y-data to fit (size(y) must be equal size(x))
% model = string specifing model from preset list.
% weights (optional) = array of wieghts for fitting (must the size of XX)
%
% OUTPUT:
% coeff = are best-fit parameters (values) of the model
% fit1  = is Matlab's fit object (useful for cofidence intevals, residuals etc)
% YYfit = returns values of the model with best-fit parameters values at points from XX
%  (useful for plotting) 
% ----
%
% coeff_all = matrix of the coefficients calculated for each curve
% coeff_all_new = ensures that the gaussian fits the left peak first then
% the right peak

coeff_all=[];
% Starts with an empty matrix for coeff_all

x=LAC(:,1);
% x is the first column of the data matrix


% Will plot the data in a new figure window

mat_size=size(LAC);
% Dimensions of the matrix of the input data

for ii=2:mat_size(2)
  % ii is a counter that will start at the second column of the matrix and
  % go through the end of the matrix - mat_size(2)
    
y=LAC(:,ii); 
%[coeff,fit1,YYfit]=oneFit_2(x,y,'Gauss+Gauss',sqrt(y));
[coeff,fit1,YYfit]=oneFit_2(x,y,'Gauss+Gauss');

% Use Ivan's oneFit code to fit the data to to gaussian curves
figure()
hold off
plot(x,y,'ok')
hold on
plot(x,YYfit,'-r')

pause
% Plot the data and the fit then the user must click to continue so that
% you have time to look at each graph and know how well the curve fits the
% data

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
    % another counter
    
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
