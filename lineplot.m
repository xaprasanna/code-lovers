% This lineplot script accepts any data file, preprocesses it to remove
% comments, plots and saves the data as an .svg file. It assumes the first
% column as x-axis and the remaining columns as y-axis. Depending upon the
% number of columns (and user input), it plots the data as xy, xny or xydy
% or xnydy plot. The script assumes x-axis to be time and sets the x-axis
% label and appropriate time units (\mus or ns). However, if that's not the
% case, user has the option to set the x-axis label. User has to set the
% y-axis label (there's no default for it). User can also provide
% ticklabels as input. If not inputs are provided, the script will plot
% with default settings.

function lineplot(fname, output)

% check if file exists

if nargin~=2
    error('Format: lineplot(filename, output).')
end

% File processing - Removing comment lines

fid = fopen(fname, "r");
content = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
D = content;
head1 = strfind(content{1}, '#');
head1 = find(~cellfun('isempty', head1));
head2 = strfind(content{1}, '@');
head2 = find(~cellfun('isempty', head2));
D{1,1}([head1; head2]) = [];
D = regexp(D{1,1}, '\s+', 'split');
D = vertcat(D{:});
data = cellfun(@str2double, D);

nrows = size(data, 1);
ncolumns = size(data, 2);
fprintf('The file has %d rows and %d columns\n', nrows, ncolumns)
for n = 1:ncolumns
    fprintf('Column %d  Min: %.3f \t Max: %.3f\n', n, min(data(:,n)), max(data(:,n)))
end

% Set axes limits, axes labels and tick labels

fprintf('You can set input values for the axes limits. Please input values as a list. Eg: [xmin xmax interval]\n')
xlimits = input('Enter limits for x-axis:\n');
ylimits = input('Enter limits for y-axis:\n');
xname = input('Time (units) is set as default label for x-axis. If not, please set label for x-axis:\n', 's');
if ~isempty(xname)
    xtickname = input('Enter tick labels for x-axis. Please input values as a list. Eg [a b c d e]\n');
end
yname = input('Enter label for y-axis:\n', 's');
ytickname = input('Enter tick labels for y-axis. Please input values as a list. Eg: [a b c d e]\n');

% Plotting xy data
if ncolumns == 2
    plot(data(:,1), data(:,2), 'b', 'LineWidth', 2)
elseif ncolumns == 3
    yopt = input('There are 3 columns in the file. Is it a xydy plot?\n(1) yes\t(2) no\n');
    if yopt == 1
        errorbar(data(:,1), data(:,2), data(:,3), 'LineWidth', 2, 'MarkerSize', 0.01)
    else
        plot(data(:,1), data(:,2:end))
    end
elseif ncolumns > 3
    yopt = input('There are more than 3 columns in the file. Is it a:\n(1) xnydy plot  (2) xny plot?\n');
    if yopt == 1
        j = 2;
        hold on
        for i = 1:(ncolumns -1)/2
            errorbar(data(:,1), data(:,j*i), data(:,(j*i)+1), 'LineWidth', 2, 'MarkerSize', 0.01)
        end
        hold off
    else
        plot(data(:,1), data(:,2:end), 'LineWidth', 2)
    end
end
a = gca;
set(a,'box','off','color','none')
b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[], 'LineWidth', 3);
axes(a)
set(gcf,'position',[150,150,1000,700])
set(gca, 'FontSize', 20, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'LineWidth', 3, 'TickLength', [0.02, 0.02])
a.XAxis.MajorTickChild.LineWidth = 3;
a.XAxis.MajorTickChild.LineWidth = 3;

if ~isempty(xlimits) && ~isempty(ylimits)
    xlim([xlimits(1) xlimits(2)])
    xticks(xlimits(1):xlimits(3):xlimits(2))
    ylim([ylimits(1) ylimits(2)])
    yticks(ylimits(1):ylimits(3):ylimits(2))
    
    xntick = {};
    if isempty(xname)
        if max(data(:,1))/1000 >= 100
            xlabel('Time (in \fontname{Helvetica}\mus)', 'FontSize',24, 'FontName','Helvetica', 'FontWeight','bold');
            xlst = [linspace(xlimits(1),xlimits(2),size(xlimits(1):xlimits(3):xlimits(2),2))];
            for i = 1:length(xlst)
                xntick = [xntick, sprintf('%.2f', xlst(i)/1000000)];
            end
        else
            xlabel('Time (in ns)', 'FontSize',18);
            xlst = [linspace(xlimits(1),xlimits(2),size(xlimits(1):xlimits(3):xlimits(2),2))];
            for i = 1:length(xlst)
                xntick = [xntick, sprintf('%.2f', xlst(i)/10000)];
            end
        end

    else
        xlabel(xname, 'FontSize', 24, 'FontWeight','bold', 'FontName', 'Helvetica');
        for i = 1:length(xtickname)
            xntick = [xntick, sprintf('%s', string(xtickname(i)))];
        end
    end
    set(gca,'xticklabel',xntick);
    ylabel(yname, "FontSize", 24, "FontName", 'Helvetica', 'FontWeight','bold');
    if ~isempty(ytickname)
        yntick = {};
        for i = 1:length(ytickname)
            yntick = [yntick, sprintf('%s', string(ytickname(i)))];
        end
        set(gca, 'yticklabel',ytickname);
    end
    
end
saveas(gcf, strcat(output, '.svg'))