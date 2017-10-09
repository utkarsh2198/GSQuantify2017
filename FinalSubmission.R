#read data
df_train = read.csv("/home/utkarsh/Documents/gs_quantify/train.csv")
df_test = read.csv("/home/utkarsh/Documents/gs_quantify/test.csv")
sum(is.na(df_train))
#memory used by a token
df_train$MemoryUsed = df_train$initialFreeMemory - df_train$finalFreeMemory
df_train$MemoryUsed[df_train$gcRun == TRUE] = df_train$finalUsedMemory[df_train$gcRun == TRUE] - df_train$gcFinalMemory[df_train$gcRun == TRUE] 

##data analysis

#mean memory used for a query 
df = aggregate(MemoryUsed~query.token, data=df_train, mean)
names(df)[names(df) == "MemoryUsed"] <- "MemoryUsed_Mean"

#merging df with the training dataset
for(x in df$query.token)
  df_test$MemoryUsed_Mean[df_test$query.token == x] = df$MemoryUsed_Mean[df$query.token == x]

#Number of times GC was called for a particular token/query
df1 = aggregate(gcRun[df_train$gcRun==TRUE]~query.token[df_train$gcRun == TRUE], data=df_train, length)
df2 = tally(group_by(df_train,gcRun ,query.token ))
df2 = subset(df2,gcRun == FALSE & n == 30)
df2 = df2[,-1]
names(df2)[names(df2) == "n"] <- "gcRun_Truecount"
names(df1)[names(df1) == "query.token[df_train$gcRun == TRUE]"] <- "query.token"
names(df1)[names(df1) == "gcRun[df_train$gcRun == TRUE]"] <- "gcRun_Truecount"
df2$gcRun_Truecount = 0
df3 = rbind(df1,df2)
#merging dataframes df and df3
df3 = merge(df, df3, by.x = "query.token", by.y = "query.token")

#mean CPU time taken for a query/token implementation
df1 = aggregate(cpuTimeTaken~query.token, data=df_train, mean)
names(df)[names(df) == "cpuTimeTaken"] <- "cpuTimeTaken_Mean"
df3 = merge(df3, df1, by.x = "query.token", by.y = "query.token")


#Prediction using rule based hypothesis

df_test$gcRun = FALSE
df_test$initialUsedMemory[2:1625] = NA
df_test$initialFreeMemory[2:1625] = NA

for(x in c(2:250))
{
  df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x-1] + df_test$MemoryUsed_Mean[x-1]
  if(df_test$initialUsedMemory[x]>(5.1+0.0015*x))
  {
    df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x] -1
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] + 1 - df_test$MemoryUsed_Mean[x-1]
    df_test$gcRun[x-1] = TRUE
  }     
  else
  {
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] - df_test$MemoryUsed_Mean[x-1]  
    
  }
}

for(x in (250:540))
{
  df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x-1] + df_test$MemoryUsed_Mean[x-1]
  if(df_test$initialUsedMemory[x]>(5.1+0.0014*x))
  {
    df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x] - 1.4
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] + 1.4 - df_test$MemoryUsed_Mean[x-1]
    df_test$gcRun[x-1] = TRUE
  }     
  else
  {
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] - df_test$MemoryUsed_Mean[x-1]  
  }
}


for(x in c(540:800))
{
  df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x-1] + df_test$MemoryUsed_Mean[x-1]
  if(df_test$initialUsedMemory[x]>(5.1+0.0013*x))
  {
    df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x] - 1.8
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] + 1.8 - df_test$MemoryUsed_Mean[x-1]
    df_test$gcRun[x-1] = TRUE
  }     
  else
  {
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] - df_test$MemoryUsed_Mean[x-1]  
  }
}

for(x in c(800:1100))
{
  df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x-1] + df_test$MemoryUsed_Mean[x-1]
  if(df_test$initialUsedMemory[x]>(5.1+0.0012*x))
  {
    df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x] - 2.1
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] + 2.1 - df_test$MemoryUsed_Mean[x-1]
    df_test$gcRun[x-1] = TRUE
  }     
  else
  {
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] - df_test$MemoryUsed_Mean[x-1]  
  }
}
for(x in c(1100:1400))
{
  df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x-1] + df_test$MemoryUsed_Mean[x-1]
  if(df_test$initialUsedMemory[x]>(5.1+0.001*x))
  {
    df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x] - 2.3
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] + 2.3 - df_test$MemoryUsed_Mean[x-1]
    df_test$gcRun[x-1] = TRUE
  }     
  else
  {
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] - df_test$MemoryUsed_Mean[x-1]  
  }
}

for(x in c(1400:1625))
{
  df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x-1] + df_test$MemoryUsed_Mean[x-1]
  if(df_test$initialUsedMemory[x]>(5.1+0.0007*x))
  {
    df_test$initialUsedMemory[x] = df_test$initialUsedMemory[x] - 2.5
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] + 2.5 - df_test$MemoryUsed_Mean[x-1]
    df_test$gcRun[x-1] = TRUE
  }     
  else
  {
    df_test$initialFreeMemory[x] = df_test$initialFreeMemory[x-1] - df_test$MemoryUsed_Mean[x-1]  
  }
}

sub1 = df_test %>%
  select(initialFreeMemory,gcRun)

write.csv(sub1, "/home/utkarsh/Documents/gs_quantify/sub4.csv")
