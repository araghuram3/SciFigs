% sig_graph helps plot bar graphs with the significance asterisk
% designations. The only required input to this function is yData, that
% holds a vector of bar graph values. The other listed keywords
% are described below. An example of a call to this function would be:
% sig_graph([.123,.245,.178,.111,.2,.145], 'ErrorBar',[.01,.01,.01,.02,.03,.005],...
% 'YLabel','Performance','Significance',{[1,3],[3,2], 5,[1,5]},'BarWidth',.5)
%
% varargin can takes in keywords and then assigns the next input to that value:
% 'ErrorBar': vector (same as yData) of error values for the yData
% 'XLabels': labels of the bars on the x axis
% 'YLabel': title of the yaxis
% 'Title': title of the graph
% 'BarWidth': width of each bar
% 'Significance': cell array of things that are significant;
% each element of the cell array either has a number, that is significant
% byitself, or two numbers where the two are signficantly different;
% example shown below:
% {1,[2,3],[1,3]}
%
% The next version will probably include compatibility with arrays,
% ability to specify font and fontsizes of text in the figure, and
% color/textures of the bars.
%
% @version 1.0
% @author Ankit Raghuram
%
function sig_graph(yData, varargin)

    %% extract data from varargin
    try 
        err = [varargin{find(strcmp(varargin, 'ErrorBar'))+1}];
        x_label = [varargin{find(strcmp(varargin, 'XLabels'))+1}];
        y_label = [varargin{find(strcmp(varargin, 'YLabel'))+1}];
        tname = [varargin{find(strcmp(varargin, 'Title'))+1}];
        barwidth = [varargin{find(strcmp(varargin, 'BarWidth'))+1}];
        significance = [varargin{find(strcmp(varargin, 'Significance'))+1}];
    catch
        error('There was something wrong with the inputs')
    end
    
    %% plot the values
    % plot the bar
    if ~isempty(barwidth)
        hBar = bar(yData, barwidth);
    else
        hBar = bar(yData);
    end
    
    % hold on
    hold on;
    
    % store y's to calculate the largest bar 
    vals = yData;
    
    % plot the error
    if ~isempty(err)
        eBar = errorbar(hBar.XData, yData, err,'k.','LineWidth',1);
        
        % if there is error we need to add the error bars to the yData
        vals = vals + err;
    end
    
    % apply colormap
    colormap(gray)
    
    %% apply the labels
    % first the xticklabels
    if ~isempty(x_label)
        set(gca, 'XTick', 1:length(x_label), 'XTickLabel', x_label);
    end
    
    % then the ylabel
    if ~isempty(y_label)
        ylabel(y_label);
    end
    
    % title
    if ~isempty(tname)
        title(tname);
    end
    
    %% display significance
    % compute the largest y location
    bigY = max(max(vals));
    dbigY = bigY;
    
    % compute xscale shift
    xscale = .01 * (size(yData,2)-1);
    
    % compute number of significance dots needeed
    if ~isempty(significance)
        num = length(significance);
        for x = 1:num
            % indicies of the signficance
            locs = significance{x};
            
            if length(locs) == 1
                xval = hBar.XData(locs) + hBar.XOffset;
                yval = eBar.YData(locs) + eBar.UData(locs);
                text(xval-xscale, yval+.1*bigY,'*','FontSize',14);
            elseif length(locs) == 2
                % for appearances, sort them
                locs = sort(locs);
                xvals = hBar.XData(locs) + hBar.XOffset;
                yval = dbigY;
                dbigY = dbigY + .1*bigY;    % increment for next one
                av_x = mean(xvals);
                text(av_x-xscale, yval+.1*bigY,'*','FontSize',14);
                % need to plot lines
                plot([xvals(1),av_x-xscale*2],1.01*[yval+.1*bigY,yval+.1*bigY],'k');
                plot([av_x+xscale*2,xvals(2)],1.01*[yval+.1*bigY,yval+.1*bigY],'k');
                plot([xvals(1),xvals(1)], [(yval+.13*bigY),(yval+.09*bigY)],'k');
                plot([xvals(2),xvals(2)], [(yval+.13*bigY),(yval+.09*bigY)],'k');
            else
                error('Too many things are significant');
            end
        end
    end
    
    % hold off
    hold off
end