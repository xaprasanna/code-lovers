function avg = average(filename)
% average(filename) returns the average of rows or columns specified by the
% user.
% If file is in the same folder, then avg = average('file.xvg').
% If file is in a different location, then avg =
% average('/filepath/file.xvg')

fname = fopen(filename, 'r');
content = textscan(fname, '%s', 'Delimiter', '\n');
fclose(fname);
D = content
head1 = strfind(content{1}, '#');
head1 = find(~cellfun('isempty', head1));
head2 = strfind(content{1}, '@');
head2 = find(~cellfun('isempty', head2));
head3 = strfind(content{1}, '!');
head3 = find(~cellfun('isempty', head3));
head4 = strfind(content{1}, '~');
head4 = find(~cellfun('isempty', head4));
head5 = strfind(content{1}, '$');
head5 = find(~cellfun('isempty', head5));
head6 = strfind(content{1}, '%');
head6 = find(~cellfun('isempty', head6));
head7 = strfind(content{1}, '*');
head7 = find(~cellfun('isempty', head7));
head8 = strfind(content{1}, ';');
head8 = find(~cellfun('isempty', head8));

D{1,1}([head1; head2; head3; head4; head5; head6; head7; head8]) = [];

D = regexp(D{1,1}, '\s+', 'split');
D = vertcat(D{:});
data = cellfun(@str2double, D);

nrows = size(data, 1);
ncolumns = size(data, 2);
fprintf('The file has %d rows and %d columns\n', nrows, ncolumns)
choice = input('Do you want to average across: (1) Rows (2) Columns ?\n');
switch choice
    case 1
        ndata = data;
        selrows = input('Is the first column time: (1) Yes (2) No\n');
        switch selrows
            case 1
                ndata(:,1) = [];
            case 2
                ndata = data;
        end
        rowerror = input('Do you want to calculate error: (1) No (2) Std. Dev. (3) Std. Error ?\n');
        mtrx = zeros(nrows,2);
        switch rowerror
            case 1
                for i = 1:nrows
                    mtrx(i,1) = mean(ndata(i,:));
                end
            case 2
                for i = 1:nrows
                    mtrx(i,1) = mean(ndata(i,:));
                    mtrx(i,2) = std(ndata(i,:));
                end
            case 3
                for i = 1:nrows
                    mtrx(i,1) = mean(ndata(i,:));
                    mtrx(i,2) = std(ndata(i,:))/sqrt(length(ndata(i,:)));
                end
        end
    
        save_opt = input('Do you want the results to be (1) Printed (2) Saved ?\n');
        switch save_opt
            case 1
                fprintf('%6s %12s\n', 'Average', 'Error')
                for i = 1:nrows
                    fprintf('%6.4f %12.4f\n', mtrx(i,1), mtrx(i,2))
                end
            case 2
                [inp_filename, path] = uiputfile(''); 
                out_filename = fopen(inp_filename, 'wt');
                fprintf(out_filename, '%6s %12s\r\n', 'Average', 'Error');
                for i = 1:length(mtrx)
                    fprintf(out_filename, '%6.4f %12.4f\n', mtrx(i,1), mtrx(i,2));
                end
                fclose(out_filename);
        end
    case 2
        ndata = data;
        selcol = input('Is the first column time: (1) Yes (2) No\n');
        switch selcol
            case 1
                ndata(:,1) = [];
                disp('Time column has been ignored for further calculations. The first data column is now the new first column\n');
                csel = input('Do you want average value for (1) All columns (2) Selected columns\n');
                switch csel
                    case 1
                        ncolumns = ncolumns - 1;
                        mtrx = zeros(ncolumns, 2);
                        err_choice = input('Do you want to calculate error: (1) No (2) Std. Dev. (3) Std. Error\n');
                        switch err_choice
                            case 1
                                for i = 1:ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                end
                            case 2
                                for i = 1:ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i));
                                end
                            case 3
                                for i = 1:ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i))/sqrt(length(ndata(:,i)));
                                end
                        end
                    case 2
                        ncolumns = input('Please enter the list of columns in the following format [1 2 3 4]\n');
                        mtrx = zeros(length(ncolumns), 2);
                        err_choice = input('Do you want to calculate error: (1) No (2) Std. Dev. (3) Std. Error\n');
                        switch err_choice
                            case 1
                                for i = ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                end
                            case 2
                                for i = ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i));
                                end
                            case 3
                                for i = ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i))/sqrt(length(ndata(:,i)));
                                end
                        end
                            
                end             
            case 2
                ndata = data;
                csel = input('Do you want to average value for (1) All columns (2) Selected columns\n');
                switch csel
                    case 1
                        mtrx = zeros(ncolumns, 2);
                        err_choice = input('Do you want to calculate error: (1) No (2) Std. Dev. (3) Std. Error\n');
                        switch err_choice
                            case 1
                                for i = 1:ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                end
                            case 2
                                for i = 1:ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i));
                                end
                            case 3
                                for i = 1:ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i))/sqrt(length(ndata(:,i)))
                                end
                        end
                    case 2
                        ncolumns = input('Please enter the list of columns in the following format [1 2 3 4]\n');
                        mtrx = zeros(length(ncolumns), 2);
                        err_choice = input('Do you want to calculate error: (1) No (2) Std. Dev. (3) Std. Error\n');
                        switch err_choice
                            case 1 
                                for i = ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                end
                            case 2
                                for i = ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i));
                                end
                            case 3
                                for i = ncolumns
                                    mtrx(i,1) = mean(ndata(:,i));
                                    mtrx(i,2) = std(ndata(:,i))/sqrt(length(ndata(:,i)));
                                end
                        end
                end    
                                    
                
        end
        save_opt = input('Do you want the results to be: (1) Printed (2) Saved ?\n');
        switch save_opt
            case 1
                fprintf('%6s %12s\n', 'Average', 'Error')
                for i = 1:length(mtrx)
                    fprintf('%6.4f %12.4f\n', mtrx(i,1), mtrx(i,2))
                end
            case 2
                [inp_filename, path] = uiputfile('');
                out_filename = fopen(inp_filename, 'wt');
                fprintf(out_filename, '%6s %12s\r\n', 'Average', 'Error');
                for i = 1:length(mtrx)
                    fprintf(out_filename, '%6.4f %12.4f\n', mtrx(i,1), mtrx(i,2));
                end
                fclose(out_filename);
        end
        
end