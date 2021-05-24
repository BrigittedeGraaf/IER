clear all; 

% Code in words:
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
Matrix(:,1)=round(Matrix(:,1),-3); %round population amount to ten thousands
Matrix(:,1)=Matrix(:,1)./1000; %divide by million

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

%Countries in the complete dataset vs incomplete 
Country_complete=Country;
Country_complete(delete_rows,:)=[];

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

Subregion_complete=Subregion;
Subregion_complete(delete_rows,:)=[];



%% Correlation
%find correlation between the various variables 
r_xy=corrcoef(Matrix_w(:,1), Matrix_w(:,2));
r_yz=corrcoef(Matrix_w(:,2), Matrix_w(:,3));
r_xz=corrcoef(Matrix_w(:,3), Matrix_w(:,1));

%standard diviation 

%SE=SD/sqrt(N)

%95% interval =mean of the study sample  +- 1.96*SE



%perform p-test on the found correlation
















