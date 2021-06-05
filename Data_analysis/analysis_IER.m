clear all; 

% First part of the code in words:
% To filter out these countries a matrix with all the data is made. 
% Then the NaN values in the matrix are located. 
% The rows with NaN values have to be deleted to determine the final matrix with solely complete data-sets. 
% Because for some countries more than one value is missing this results in the index of this row occurring multiple times in the array with to be deleted rows. 
% An array is made that contains the row numbers that should be deleted. 
% Finally these rows are deleted from the matrix.

%% read out the excel file cointaniing all collected data 
Country=readcell('IER_research_data.xlsx','Range','A2:A194');
Population=table2array(readtable('IER_research_data.xlsx', 'Range', 'B2:B194'));
Continent=readcell('IER_research_data.xlsx','Range','C2:C194');
Subregion=readcell('IER_research_data.xlsx','Range','D2:D194');
CDR=[NaN; table2array(readtable('IER_research_data.xlsx', 'Range', 'E2:E194'))];
CMR=[NaN; table2array(readtable('IER_research_data.xlsx', 'Range', 'F2:F194'))];
gender_w=[NaN; table2array(readtable('IER_research_data.xlsx', 'Range', 'G2:G194'))];
child_v=table2array(readtable('IER_research_data.xlsx', 'Range', 'I2:I194'));

Matrix=[];
Matrix=[Population, CDR, CMR, gender_w, child_v];   

%% filter out incomplete data-sets, determine the matrix with only complete datasets

%determine which rows need to be deleted because they do not contain a full data-set
[row_tobeD, col_tobeD] = find(isnan(Matrix));       
%to be deleter rows, 1 means delete, 0 means complete 
rows_incomplete=ismember(1:size(Matrix,1), row_tobeD);
delete_rows=find(rows_incomplete'==1);     %Used to delete incomplete data-sets
%Determine matrix with only complete data-sets
Matrix(delete_rows,:) = [];

%% Join CMR and CDR 
CDR_CMR=Matrix(:,2)./Matrix(:,3);
%replace the second and third column in the matrix by this new value
Matrix(:,2)=CDR_CMR;
Matrix(:,3)=[];

%% Weight the values
v=3;    %data is rounded off to per 10^v people
Matrix(:,1)=round(Matrix(:,1),-v); %round population amount to ten thousands
Matrix(:,1)=Matrix(:,1)./(10^v); %divide by million

Matrix_w=[]; 
pop_rep=[];
for i=1:size(Matrix,1)
    rep=repmat([Matrix(i,2), Matrix(i,3), Matrix(i,4)],Matrix(i,1),1);
    rep2=repmat(Matrix(i,1),Matrix(i,1),1);
    Matrix_w=[Matrix_w; rep];    %weighted matrix
    pop_rep=[pop_rep; rep2];
    i=i+1;
end 

%% Visualize the data
% figure;
% scatter3(Matrix_w(:,1),Matrix_w(:,2),Matrix_w(:,3),pop_rep/500)
% grid on
% xlabel('Divorce-rate [CMR/CDR]','Interpreter','Latex','Fontsize',8)
% ylabel('Gender wage gap [%]','Interpreter','Latex','Fontsize',8) %change name to 'Wave height [m]'
% zlabel('Children that experienced violence [%]','Interpreter','Latex','Fontsize',8)

%used in the report: A scatterplot containing the datapoints from all
%complete data-sets
% figure;
% scatter(Matrix_w(:,2),Matrix_w(:,3),pop_rep/350, Matrix_w(:,1), 'filled')
% grid on
% colorbar
% colormap
% xlabel('Gender wage gap [%]','Interpreter','Latex','Fontsize',12)
% ylabel('Children that experienced violence [%]','Interpreter','Latex','Fontsize',12)
% c=colorbar;
% c.Label.String = 'Divorce-rate [CMR/CDR]'

%% Determination of amoun of people analysed
%determine array with the population used for the analysis
Population_complete=Population;
Population_complete(delete_rows,:)=[];
disp('percentage of people analysed globally:')
analysed_p=sum(Population_complete);
%percentage of world population analysed
total_p=7674000000;
analysed_p/total_p

%% Contries, continents and subregions used in the for the analysis
%determine array with the countries used for the analysis 
Country_complete=Country;
Country_complete(delete_rows,:)=[];

%determine array with the continents used for the analysis
Continent_complete=Continent;
Continent_complete(delete_rows,:)=[];
%find out how frequent each continent is sampeled in the complete data-set
[D2,~,X2] = unique(Continent_complete(:));
Y2 = hist(X2,unique(X2));
Z2 = struct('name',D2,'freq',num2cell(Y2(:)));
%find out how frequent each continent is sampeled in the incomplete data-set
[D1,~,X1] = unique(Continent(:));
Y1 = hist(X1,unique(X1));
Z1 = struct('name',D1,'freq',num2cell(Y1(:)));

%determine array with the subregions used for the analysis
Subregion_complete=Subregion;
Subregion_complete(delete_rows,:)=[];

%% Correlation
%find correlation between the various variables 
%x:the ratio CDR/CMR
%y:the gender wage gap (%)
%z:children that experienced violence (%)

r_xy=corrcoef(Matrix_w(:,1), Matrix_w(:,2));    %Correlation between x and y
r_yz=corrcoef(Matrix_w(:,2), Matrix_w(:,3));    %Correlation between y and z   
r_xz=corrcoef(Matrix_w(:,3), Matrix_w(:,1));    %Correlation between x and z

%% Multiple correlation
%The multiple correlation between the variables is determined
r_xy=0.2077;        %value taken out of the matrix
r_yz=-0.5871;       %value taken out of the matrix
r_xz=-0.2912;       %value taken out of the matrix
R_zxy=sqrt((r_xz^2+r_yz^2-2*r_xz*r_yz*r_xy)/(1-r_xy^2));

%less biased multiple correlation
R_ub=1-(1-R_zxy^2)*(size(Matrix_w(:,3),1)-1)/(size(Matrix_w(:,3),1)-3-1)

%% Standard diviation 
%determine the standard deviation for the three variables 
Sx=std(Matrix_w(:,1));  %standard deviation x
Sy=std(Matrix_w(:,2));  %standard deviation y
Sz=std(Matrix_w(:,3));  %standard deviation z

%determine the maximum standard deviation to find the minimum sample size 
S=[Sx; Sy; Sz];
S_max=max(S);

z=1.96;     %z*-value for 95% interval
MOE_1=0.05;   %margin of error
MOE_2=0.01;
%determine samples required for the 
n_1=round((z*S_max/MOE_1)^2)*10^v;  %amount of samples needed with a margin of error of 5%
n_2=round((z*S_max/MOE_2)^2)*10^v;  %amount of samples needed with a margin of error of 1%
