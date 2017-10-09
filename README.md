# Predicting Garbage Collector Invocation 

## Team fiboNazis


### Methodology followed:
Understanding data, Feature Engineering, Analyzing trends and applying to cleaned dataset


### Data at a glance:
There are 91 types of queries that are run on the search engine, each 30 times in the training dataset. The different fields in the dataset are explained on the contests webpage. The data pertaining to the series of queries run on the search engine and Garbage Collector Invocation is given in the Training file.


### Data pre-processing:
The data provided was clean, without any missing values. Data preprocessing was not required here.


### Feature Engineering and Trend analysis:

MemoryUsed – Difference between the finalUsedMemory and initialUsedMemory when Garbage Collector was not called and difference between finalUsedMemory and gcFinalMemory when Garbage Collector was called.

MemoryUsed_Mean – Average value of all the memory used corresponding to each query

MemoryInvoked – The memory invoked by the garbage collector

gcRun_TrueCount – Number of times garbage collector for each query

### Modeling:
Rule based hypothesis was used for modeling.Observing the data revealed a peculiar nature of the data. For each token the MemoryUsed is almost constant with value equal to their mean. So mapping between the tokens and the MemoryUsed_Mean is used on the test data to find the approximate memory used for each query. Also it was observed in the begining of the running queries on the search engine, the garbage collector was called than it was in the later stages(wrt the gcInitialMemory). So a linear function was made to use this trend and the values of the parameters of the linear function were optimised. Whenever the value of InitialMemoryUsed Exceeded this value Garabage Collector was called and memory was invoked, which was again a function of the stage at which the query is being run on the search engine
