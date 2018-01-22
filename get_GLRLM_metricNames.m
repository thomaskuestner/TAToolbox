function metric_names = get_GLRLM_metricNames()

if nargin == 0
    metric_names = {'GLRLM - Short Run Emphasis' ; ...
                    'GLRLM - Long Run Emphasis' ; ...
                    'GLRLM - Gray-Level Nonuniformity' ; ...
                    'GLRLM - Run-Length Nonuniformity' ; ...
                    'GLRLM - Run Percentage' ; ... 
                    'GLRLM - Low Gray-Level Run Emphasis' ; ...
                    'GLRLM - High Gray-Level Run Emphasis' ; ...
                    'GLRLM - Short Run Low Gray-Level Emphasis' ; ...
                    'GLRLM - Short Run High Gray-Level Emphasis' ; ...
                    'GLRLM - Long Run Low Gray-Level Emphasis' ; ...
                    'GLRLM - Long Run High Gray-Level Emphasis' ; ...
                    'GLRLM - Gray-Level Variance' ; ...
                    'GLRLM - Run-Length Variance'};
    return
end