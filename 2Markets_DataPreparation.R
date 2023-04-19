# Data Preparation Script - 2 Markets #########################################
### Please cite #####
# Insider trading regulation and trader migration.

## Preparing workspace and necessary packages #################################

#install.packages("zTree")
pacman::p_load("zTree")
library("zTree")
#source("http://www.kirchkamp.de/lab/zTree.R") # Loads R import script by Oliver Kirchkamp (https://www.kirchkamp.de//lab/zTree.html#zTreeR)
library("stringr")
library("mgcv")
setwd(getwd())

QSourceFiles<-list.files("./DataExcel.",pattern="^19(10|11)(01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31)(_)(07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24)(0|1|2|3|4|5)(0|1|2|3|4|5|6|7|8|9).sbj",full.names=T,recursive=F)

RawData<-zTreeTables(SourceFiles,tables=NULL, sep="\t", ignore.errors = T)
RawQuestionnaires<-zTreeSbj(QSourceFiles, zTree.encoding = "WINDOWS-1252")
## changed Euro-Sign to Euro in text answers
## Treatment 1 == control questions
## Treatment 2 == Trial periods
## Treatment 3 == Market

Data <- RawData
QData <- RawQuestionnaires

save.image("RawDataI.RData")
#load("RawDataI.RData")

globals <-Data$globals
contracts <- Data$contracts
subjects <- Data$subjects
infodata <- Data$infodata
session <- Data$session
summary <- Data$summary
timelog <- Data$timelog
tagnums <- Data$tagnums
history <- Data$history
logfile  <- Data$logfile
auctionoffers <- Data$auctionoffers
auctionpractice <- Data$auctionpractice
dividends <- Data$dividends
endowments <- Data$endowments
import <- Data$import
indicativepricedetermination <- Data$indicativepricedetermination
## Market volume calculated from transactions table
marketsummary1 <- Data$marketsummary
marketsummary <- subset(marketsummary1, select = -c(Volume))
## periodsummary summerizes a period's observations over both markets
periodsummary <- subset(marketsummary, Market==1, select = -c(Market, Price))
offers <- Data$offers
practicetasks <- Data$practicetasks
pricedetermination <- Data$pricedetermination
results <- Data$results
resultsinsider <- Data$resultsinsider
resultsnoinsider <- Data$resultsnoinsider
settlement <- Data$settlement
signals <- Data$signals
tbsa <- Data$tbsa
tbsb <- Data$tbsb
transactions <- Data$transactions
dividends_preset <- Data$dividends_preset
historyreal <- Data$historyreal
infodatahistory <- Data$infodatahistory
layout <- Data$layout
profit <- Data$profit
settings_globals <- Data$settings_globals
signals_preset <- Data$signals_preset

## on participant specified sociodemographics wrong - see GeneralComments
QData$Female[QData$Date=="191113_0944" & QData$Subject==	13] <- "Weiblich"

save.image("RawDataII.RData")
#load("RawDataII.RData")

## Collect and distribute information about treatment and participants ########
## Specify treatment characteristics in each Table - assign sessionID
matchingTreatment1 <- subset(globals, Treatment==3 & (Period==1 | Period==4 | Period==10), select = c(Date , Period, `IsPun[1]`, `IsPun[2]`))
matchingTreatment1$`IsPun[1]`[matchingTreatment1$`IsPun[1]`==1]<-"R"
matchingTreatment1$`IsPun[1]`[matchingTreatment1$`IsPun[1]`==0]<-"N"
matchingTreatment1$`IsPun[2]`[matchingTreatment1$`IsPun[2]`==1]<-"R"
matchingTreatment1$`IsPun[2]`[matchingTreatment1$`IsPun[2]`==0]<-"N"
matchingTreatment1$REG <- interaction(matchingTreatment1$`IsPun[1]`,matchingTreatment1$`IsPun[2]`, sep="")
matchingTreatment <- subset(globals, Treatment==3 & (Period==1), select = c(Date))
matchingTreatment$Beginning <- paste(subset(matchingTreatment1, Period==1)$REG, sep=".")
matchingTreatment$End <- paste(subset(matchingTreatment1, Period==10)$REG, sep=".")
matchingTreatment$Treatment <- paste(subset(matchingTreatment1, Period==1)$REG,subset(matchingTreatment1, Period==4)$REG,subset(matchingTreatment1, Period==10)$REG, sep=".")
matchingTreatment$SessionID <- row(matchingTreatment)[,1]
matchingTreatment$ChgRegime <- "changeBottom"
matchingTreatment$ChgRegime[substr(matchingTreatment$Treatment, 1,1)!=substr(matchingTreatment$Treatment, 4,4)] <- "changeTop"
matchingTreatment$regOrder <- "RTop"
matchingTreatment$regOrder[substr(matchingTreatment$Treatment, 4,5)=="NR"] <- "NTop"
matchingTreatment$embTreatment <- paste(subset(matchingTreatment1, Period==1)$REG,subset(matchingTreatment1, Period==10)$REG, sep=".")
matchingTreatment$endTreatment <- paste(subset(matchingTreatment1, Period==1)$REG,subset(matchingTreatment1, Period==4)$REG, sep=".")
matchingTreatment$Location <- "Graz"
matchingTreatment$Location[matchingTreatment$SessionID>=16] <- "Vienna"
rm(matchingTreatment1)

## Distribute treatment characteristics
clist <- c("globals","timelog","subjects","summary","contracts","session","logfile","auctionoffers","auctionpractice","dividends","endowments",
           "history","import","indicativepricedetermination","infodata","marketsummary", "periodsummary","offers","practicetasks","pricedetermination","results",
           "resultsinsider","resultsnoinsider","settlement","signals","tbsa","tbsb","transactions","dividends_preset","historyreal","infodatahistory",
           "layout","profit","settings_globals","signals_preset","tagnums")
for(i in clist) {
  Object <- get(paste0(i))
  colnames(Object)[2] <- "Programme"
  Object <- merge(Object, matchingTreatment, by = c("Date"))
  Object <- subset(Object, Programme==3)
  assign(paste0(i), Object)
}
QData <- merge(QData, matchingTreatment, by = c("Date"))

## assign subjectID
subjectID <- subset(session, Subject!=17 & Programme==3, select = c(Date, Subject))
subjectID$subjectID <- row(subjectID)[,1]

## distribute subjectID
clist <- c("infodata", "subjects" , "session", "timelog", "history", "historyreal", "auctionpractice", "practicetasks", "results", "resultsinsider", "resultsnoinsider", "profit", "QData")
for(i in clist) {
  Object <- get(paste0(i))
  Object <- merge(Object, subjectID, by = c("Date", "Subject"), all.x = T)
  assign(paste0(i), Object)
}

## distribute Role
clist <- c("subjects" , "history")
for(i in clist) {
  Object <- get(paste0(i))
  Object$Role[as.numeric(Object$Subject)!=17 & Object$Role==1] <- "Uninformed trader"
  Object$Role[as.numeric(Object$Subject)!=17 & Object$Role==2] <- "Informed trader"
  Object$Role[as.numeric(Object$Subject)!=17 & Object$Role==3] <- "Observer"
  Object$Role[as.numeric(Object$Subject)==17] <- "Experimenter"
  assign(paste0(i), Object)
}

## Generate contracts/transactions/offers tables ##############################
## variable name correspondence
offers$status[offers$Status==2] <- "cancelled"
offers$status[offers$Status==1] <- "sold out"
offers$status[offers$Status==0] <- "on market"
offers$status[offers$Status==3] <- " fully invalidated"
offers$Phase <- "Phase 2"
offers$Phase[(offers$Period>=10)] <- "Phase 3"
offers$Phase[(offers$Period<4)] <- "Phase 1"

## assign offerID
offerID <- subset(offers, Programme==3, select = c(SessionID, Period, Market, ID))
offerID$offerID <- row(offerID)[,1]
offerID$OfferID <- offerID$ID

## assign transactionID
transactionID <- subset(transactions, Programme==3, select = c(SessionID, Period, Market, AcceptanceID))
transactionID$transactionID <- row(transactionID)[,1]
transactionID$TransactionID <- transactionID$AcceptanceID
transactionID <- transactionID[with(transactionID, order(SessionID, Period, Market, AcceptanceID)),]
transactionID$transactionIDm <- row(transactionID)[,1]
contracts$contractID <- row(contracts)[,1]

## distribute offerID
offers <- merge(offers, subset(offerID, select = c("SessionID", "Period", "Market", "ID", "offerID")), by = c("SessionID", "Period", "Market", "ID"), all.x = T)
transactions <- merge(transactions, subset(offerID, select = c("SessionID", "Period", "Market", "OfferID", "offerID")), by = c("SessionID", "Period", "Market", "OfferID"), all.x = T)
offers$market <- "Top"
offers$market[offers$Market==2] <- "Bottom"

## distribute transactionID
transactions <- merge(transactions, subset(transactionID, select = c("SessionID", "Period", "Market", "AcceptanceID", "transactionID", "transactionIDm")), by = c("SessionID", "Period", "Market", "AcceptanceID"), all.x = T)
contracts <- merge(contracts, subset(transactionID, select = c("SessionID", "Period", "Market", "TransactionID", "transactionID", "transactionIDm")), by = c("SessionID", "Period", "Market", "TransactionID"), all.x = T)

contracts$LimitVolume <- contracts$Volume
contracts$transactionVol <- contracts$VolumeTraded
contracts$remainingVolExPost <- contracts$LimitVolume - contracts$Transacted
contracts$remainingVolExAnte <- contracts$remainingVolExPost + contracts$transactionVol

transactions$transactionVol <- transactions$Volume

offers$LimitVolume <- offers$Volume
offers$totTransacted <- offers$Transacted
offers$CancelledVolume <- 0
offers$CancelledVolume[offers$Status==2] <- offers$Volume[offers$Status==2] - offers$totTransacted[offers$Status==2]

## specifying starting time of auction
AuctionTimes <- subset(timelog, select = c(Date, Programme, Period, Time), Event==2 & Programme==3)
colnames(AuctionTimes) <- c("Date", "Programme", "Period", "AuctionStartTime")
AuctionTimes <- merge(AuctionTimes, subset(timelog, select = c(Date, Programme, Period, Time), Event==188 & Programme==3), by = c("Date", "Programme", "Period"))
colnames(AuctionTimes) <- c("Date", "Programme", "Period", "AuctionStartTime", "AuctionEndTime")

## distribute offer start time to transactions
transactions <- merge(transactions, subset(offers, select = c("SessionID", "Period", "Market", "offerID", "OfferTime")), by=c("SessionID", "Period", "Market", "offerID"), all = F)

clist <- c("contracts", "transactions", "offers")
for(i in clist) {
  Object <- get(paste0(i))
  Object <- merge(Object, AuctionTimes, by = c("Date", "Programme", "Period"))
  Object$offertime <- round(Object$OfferTime - Object$AuctionStartTime, digits = 0)
  assign(paste0(i), Object)
}

transactions$offertimeP <- transactions$OfferTime - transactions$AuctionStartTime
transactions$transactiontimeP <- transactions$Time - transactions$AuctionStartTime
transactions$transactiontime <- round(transactions$Time - transactions$AuctionStartTime, digits = 0)
contracts$time <- round(contracts$Time - contracts$AuctionStartTime, digits = 0)

## specify offer end time
offers$offertimeEnd[offers$Status == 1 ] <- round(offers$StatusTime[offers$Volume==offers$Transacted] - offers$AuctionStartTime[offers$Volume==offers$Transacted], digit = 0)
offers$offertimeEnd[offers$Status == 2 | offers$Status ==3] <- round(offers$StatusTime[offers$Status == 2 | offers$Status ==3] - offers$AuctionStartTime[offers$Status == 2 | offers$Status ==3], digit = 0)
offers$offertimeEnd[offers$Status == 0 ] <- round(offers$AuctionEndTime[offers$Status == 0] - offers$AuctionStartTime[offers$Status == 0], digit = 0)
offers$remainingVol <- offers$Volume - offers$Transacted

## Generate order table - all contracts + unexecuted offers ###################
orders <- merge(contracts, subset(offers, select = c("SessionID", "Period", "Market", "OfferTime", "offertimeEnd", "offerID")), by=c("SessionID", "Period", "Market", "OfferTime"), all.y = F)
orders <- merge(orders, subset(offers, select = c("offerID", "totTransacted")), by = c("offerID"))
orders <- merge(orders, subset(offers, select=c("Date", "Programme", "Period", "Market", "Price", "Offerer", "totTransacted", "Status","status", "Type", "offertime", "offertimeEnd", "offerID",
                                                   "Beginning", "End", "Treatment", "SessionID", "ChgRegime", "regOrder", "AuctionStartTime", "AuctionEndTime", "LimitVolume")), 
                                  by=c("Date", "Programme", "Period", "Market", "Price", "Offerer", "totTransacted", "Status", "Type", "offertime", "offertimeEnd", "offerID",
                                       "Beginning", "End", "Treatment", "SessionID", "ChgRegime", "regOrder","AuctionStartTime", "AuctionEndTime", "LimitVolume"), all=T)

orders$time[orders$Status == 0 ] <- round(orders$AuctionEndTime[orders$Status == 0] - orders$AuctionStartTime[orders$Status == 0], digit = 0)
index <- with(orders, order(offerID, time))
orders <- orders[index,]
orders$orderStarttime <- orders$offertime
orders$orderStarttime2 <- 0
orders$offerID2 <- 0
for(i in 2:length(orders$time)){
orders$orderStarttime2[i] <- orders$time[i-1]
orders$offerID2[i] <- orders$offerID[i-1]
}
orders$orderStarttime[orders$offerID==orders$offerID2] <- orders$orderStarttime2[orders$offerID==orders$offerID2]

## time on market (between orders)
orders$ordertime <- orders$time - orders$orderStarttime
orders$transactionVol[is.na(orders$transactionVol) | orders$transactionVol<0] <- 0
orders$remainingVol <- orders$LimitVolume - orders$totTransacted + orders$transactionVol

## assign orderID
orderID <- subset(orders, Programme==3, select = c(SessionID, Period, Market, contractID, offerID, transactionID, Status))
orderID$contractID[is.na(orderID$contractID)] <- 0
orderID$id <- paste0(orderID$contractID,".", orderID$offerID)
orderID$orderID <- row(orderID)[,1]

orders$Phase <- "Phase 2"
orders$Phase[(orders$Period>=10)] <- "Phase 3"
orders$Phase[(orders$Period<4)] <- "Phase 1"
orders$market <- "Top"
orders$market[orders$Market==2] <- "Bottom"

## distribute contractID and orderID
orders$contractID[is.na(orders$ID)] <- 0
orders <- merge(orders, subset(orderID, select = c("SessionID", "Period", "Market", "contractID", "offerID", "orderID")), by = c("SessionID", "Period", "Market", "offerID", "contractID"), all.x = T, all.y = F)
orders$contractID[is.na(orders$ID)] <- NA
transactions <- merge(transactions, subset(orderID, is.na(transactionID)==F, select = c("SessionID", "Period", "Market", "transactionID", "orderID")), by = c("SessionID", "Period", "Market", "transactionID"),all.x = T, all.y = F)
contracts <- merge(contracts, subset(orderID, is.na(contractID)==F, select = c("SessionID", "Period", "Market", "contractID", "Status", "orderID")), by = c("SessionID", "Period", "Market", "Status", "contractID"), all.y = F)

## subjectID as makerID and takerID
subjectID1 <- subjectID
subjectID1$makerID <- subjectID$subjectID
subjectID1$takerID <- subjectID$subjectID

## assign subjectID to active trader in offers and transactions tables
offers <- merge(offers, subset(subjectID1, select = c(Subject, Date, makerID)), by.x = c("Offerer", "Date"), by.y = c("Subject", "Date"), all.x=T, all.y=F)
offers$type[offers$Type==(1)] <- "BuyingOffer"
offers$type[offers$Type==(-1)] <- "SellingOffer"

transactions <- merge(transactions, subset(subjectID1, select = c(Subject, Date, takerID)), by.x = c("AccepterID", "Date"), by.y = c("Subject", "Date"), all.x=T, all.y=F)
transactions <- merge(transactions, subset(offers, select = c(ID, makerID, Type, type, SessionID, Period, Market, Programme)), by.x = c("OfferID", "SessionID", "Period", "Market", "Programme"), by.y = c("ID" , "SessionID", "Period", "Market", "Programme"), all.x=T, all.y=F)
transactions$BuyerID <- NA
transactions$SellerID <- NA
transactions$BuyerID[transactions$Type==1] <- transactions$makerID[transactions$Type==1]
transactions$BuyerID[transactions$Type==(-1)] <- transactions$takerID[transactions$Type==(-1)]
transactions$SellerID[transactions$Type==(-1)] <- transactions$makerID[transactions$Type==(-1)]
transactions$SellerID[transactions$Type==(1)] <- transactions$takerID[transactions$Type==(1)]
transactions$Phase <- "Phase 2"
transactions$Phase[(transactions$Period>=10)] <- "Phase 3"
transactions$Phase[(transactions$Period<4)] <- "Phase 1"

## distribute offer volume to transactions
transactions <- merge(transactions, subset(contracts, !is.na(transactionID), select = c(transactionID, remainingVolExAnte, remainingVolExPost), by = transactionID))

## assign subjectID to active trader in orders
orders <- merge(orders, subset(subjectID1, select = c(Subject, Date, takerID)), by.x = c("Accepter", "Date"), by.y = c("Subject", "Date"), all.x=T, all.y=F)
orders <- merge(orders, subset(subjectID1, select = c(Subject, Date, makerID)), by.x = c("Offerer", "Date"), by.y = c("Subject", "Date"), all.x=T, all.y=F)
orders$BuyerID <- NA
orders$SellerID <- NA
orders$BuyerID[orders$Type==1] <- orders$makerID[orders$Type==1]
orders$BuyerID[orders$Type==(-1)] <- orders$takerID[orders$Type==(-1)]
orders$SellerID[orders$Type==(-1)] <- orders$makerID[orders$Type==(-1)]
orders$SellerID[orders$Type==(1)] <- orders$takerID[orders$Type==(1)]
orders$type[orders$Type==(1)] <- "BuyingOffer"
orders$type[orders$Type==(-1)] <- "SellingOffer"
orders$Period <- as.numeric(orders$Period)

## Occurences per second ######################################################
sl <- c(1:24)
pl <- c(1:12)
tl <- c(0:180)
ml <- c(1:2)
seconds <- expand.grid(sl, pl, tl, ml)
names(seconds) <- c("SessionID", "Period", "time", "Market")
seconds$Programme <- 3
seconds <- merge(seconds, matchingTreatment, by = c("SessionID"))

contsum <- aggregate(Volume ~ SessionID + Period + transactiontime + Market, data = subset(transactions, Programme==3), function(x) sum(x))
names(contsum) <- c("SessionID", "Period", "time", "Market", "sumq")
seconds <- merge(seconds, contsum, by = c("SessionID", "Period", "time", "Market"), all.x = T)
seconds$sumq[is.na(seconds$sumq)] <- 0

## MA process
for(s in 1:24){
  for(P in 1:12){
    for(m in 1:2){
    seconds$MA[seconds$SessionID==s & seconds$Period==P & seconds$Market==m] <- stats::filter(x = subset(seconds, SessionID==s & Period==P & Market==m, select = c(time, sumq))$sumq  , filter =  c(1/2^c(1:9),1/2^9), method = "convolution", sides =1)  
  }}
}

for(s in 1:24){
  for(P in 1:12){
    for(m in 1:2){
    tg <- gam(sumq ~ s(time, k=180/10), data=subset(seconds, SessionID==s & Period==P & Market==m))
    seconds$volfit[seconds$SessionID==s & seconds$Period==P & seconds$Market==m] <- fitted.values(tg)
  }}}

## Market characteristics #####################################################
## assign market characteristics
clist <- c("seconds", "marketsummary", "periodsummary", "contracts", "transactions", "offers", "orders")
for(i in clist) {
      Object <- get(paste0(i)) 
      Object$BBV <- NA
      Object$IsREG <- NA
   for (s in 1:32){
    for (P in (-1):12){
      Object$BBV[Object$SessionID==s & Object$Period==P & Object$Programme==3] <- globals$`BBV[1]`[globals$SessionID==s & globals$Period==P & globals$Programme==3]
      Object$BBVCent <- Object$BBV - 57.5
      Object$IsREG[Object$SessionID==s & Object$Period==P & Object$Market==1 & Object$Programme==3] <- globals$`IsPun[1]`[globals$SessionID==s & globals$Period==P & globals$Programme==3]
      Object$IsREG[Object$SessionID==s & Object$Period==P & Object$Market==2 & Object$Programme==3] <- globals$`IsPun[2]`[globals$SessionID==s & globals$Period==P & globals$Programme==3]
      Object$IsREG[Object$IsREG==0] <-"NOREG"
      Object$IsREG[Object$IsREG==1] <- "REG"
      Object$othermarket <- "REG"
      Object$othermarket[Object$Period>=10 & Object$End=="NN"] <- "NOREG"
      Object$othermarket[Object$Period<=3 & Object$Beginning=="NN"] <- "NOREG"
      Object$othermarket[Object$Market==1 & Object$regOrder=="RTop" & Object$Period>3 & Object$Period<10] <- "NOREG"
      Object$othermarket[Object$Market==2 & Object$regOrder=="NTop" & Object$Period>3 & Object$Period<10] <- "NOREG"
      Object$REGBoth <- 0
      Object$REGBoth[Object$IsREG=="REG" & Object$othermarket=="REG"] <- 1
      Object$REGonly <- 0
      Object$REGonly[Object$IsREG=="REG" & Object$othermarket=="NOREG"] <- 1
      Object$REGSH <- 0
      Object$REGSH[Object$IsREG=="REG" & Object$othermarket=="NOREG"] <- 1
      assign(paste0(i), Object)
    }
  }
}


marketsummary$market <- "Top"
marketsummary$market[marketsummary$Market==2] <- "Bottom"
marketsummary$center <- substr(marketsummary$Treatment, 4,5)
marketsummary$middle <- "No"
marketsummary$middle[marketsummary$Period>3 & marketsummary$Period<=9] <- "yes"
marketsummary$Part <- "middle"
marketsummary$Part[(marketsummary$Period>=10)] <- "end"
marketsummary$Part[(marketsummary$Period<4)] <- "start"
marketsummary$Part <- factor(marketsummary$Part, levels = c("start", "middle", "end"))
marketsummary$Phase <- factor(marketsummary$Part, levels = c("start", "middle", "end"), labels = c("Phase 1", "Phase 2", "Phase 3"))
marketsummary$myMarketTreatment <- paste0(substr(marketsummary$Treatment, 1,1), ".", substr(marketsummary$Treatment, 4,4))
marketsummary$myMarketTreatment[marketsummary$market == "Bottom"] <- paste0(substr(marketsummary$Treatment[marketsummary$market == "Bottom"], 2,2), ".", substr(marketsummary$Treatment[marketsummary$market == "Bottom"], 5,5))
marketsummary$history <- marketsummary$myMarketTreatment
marketsummary$history[marketsummary$Period<4] <- 1
marketsummary$history[marketsummary$Period>3 & marketsummary$Period<10] <- paste0(substr(marketsummary$Treatment[marketsummary$Period>3 & marketsummary$Period<10], 1,1))
periodsummary$center <- substr(periodsummary$Treatment, 4,5)
periodsummary$middle <- "No"
periodsummary$middle[periodsummary$Period>3 & periodsummary$Period<=9] <- "yes"
periodsummary$Part <- "middle"
periodsummary$Part[(periodsummary$Period>=10)] <- "end"
periodsummary$Part[(periodsummary$Period<4)] <- "start"
periodsummary$IsREG[periodsummary$Period<=3 & periodsummary$Beginning=="RR"] <- "REG"
periodsummary$IsREG[periodsummary$Period<=3 & periodsummary$Beginning=="NN"] <- "NOREG"
periodsummary$IsREG[periodsummary$Period>=10 & periodsummary$End=="RR"] <- "REG"
periodsummary$IsREG[periodsummary$Period>=10 & periodsummary$End=="NN"] <- "NOREG"
periodsummary$IsREG[periodsummary$Period<10 & periodsummary$Period>3 & periodsummary$center=="RN"] <- "REG"
periodsummary$IsREG[periodsummary$Period<10 & periodsummary$Period>3 & periodsummary$center=="NR"] <- "NOREG"

## calculate profits per action of traders
transactions$SellersProfit <- (transactions$Price - transactions$BBV) * transactions$transactionVol
transactions$MakersProfit <- (transactions$Price - transactions$BBV) * transactions$transactionVol
transactions$MakersProfit[transactions$type == "BuyingOffer"] <- -(transactions$Price[transactions$type == "BuyingOffer"] - transactions$BBV[transactions$type == "BuyingOffer"])*transactions$transactionVol[transactions$type == "BuyingOffer"]

## RD,RAD,GD,GAD ##############################################################
transactions$RDi <- transactions$Price - transactions$BBV
transactions$GDi <- log(transactions$Price / transactions$BBV)

## Bid/ask - best Prices per second ###########################################
for(s in 1:24){
  for(P in 1:12){
    for(m in 1:2){
      for(t in 0:180){
        # Type specifies Bids(=1) and Ask(=-1)
        seconds$BestBid[seconds$SessionID==s & seconds$Period==P & seconds$time==t & seconds$Market==m] <- max(subset(offers, Type==1 & Programme==3 & Period==P & SessionID==s & Market==m &
                                                                                                offertime<=t & (offertimeEnd>=t | offertimeEnd<(-7777)))$Price)
        seconds$BestAsk[seconds$SessionID==s & seconds$Period==P & seconds$time==t & seconds$Market==m] <- min(subset(offers, Type==(-1) & Programme==3 & Period==P & SessionID==s & Market==m &
                                                                                                offertime<=t & (offertimeEnd>=t | offertimeEnd<(-7777)))$Price)
        seconds$lastPrice[seconds$SessionID==s & seconds$Period==P & seconds$time==t & seconds$Market==m] <- min(subset(transactions, Programme==3 & Period==P & SessionID==s & Market==m & transactiontime ==max(subset(transactions, Programme==3 & Period==P & SessionID==s & Market==m & transactiontime<=t)$transactiontime))$Price)
      }}}}

seconds$BestBid[seconds$BestBid==(-Inf)] <- NA
seconds$BestAsk[seconds$BestAsk==(Inf)] <- NA
seconds$BestBid[seconds$BestBid==(-1)] <- NA
seconds$BestAsk[seconds$BestAsk==(1001)] <- NA
seconds$BAspread <- seconds$BestAsk - seconds$BestBid
seconds$midpointBA <- (seconds$BestAsk + seconds$BestBid)/2
seconds$lastPrice[seconds$lastPrice==(Inf) | seconds$lastPrice==(-Inf)] <- NA
seconds$lnlastPrice <- log(seconds$lastPrice)
secy <- seconds
secy$time <- secy$time+1
seconds <- merge(seconds, subset(secy, select = c("time", "Period", "SessionID", "Market", "lnlastPrice")), by = c("time", "Period", "SessionID", "Market"), all.x = T)
names(seconds)[names(seconds)=="lnlastPrice.x"] <- "lnlastPrice"
names(seconds)[names(seconds)=="lnlastPrice.y"] <- "L.lnlastPrice"
## calculate return per second
seconds$return <- seconds$lnlastPrice - seconds$L.lnlastPrice

seconds <- merge(seconds, subset(marketsummary, select = c(Period, SessionID, Market, history, market)), by = c("Period", "SessionID", "Market"))
seconds$BestBidmod <- 20
seconds$BestAskmod <- 95
seconds$BestBidmod[seconds$BestBid>=25 & is.na(seconds$BestBid)==F] <- seconds$BestBid[seconds$BestBid>=25 & is.na(seconds$BestBid)==F] 
seconds$BestAskmod[seconds$BestAsk<=90 & is.na(seconds$BestAsk)==F] <- seconds$BestAsk[seconds$BestAsk<=90 & is.na(seconds$BestAsk)==F]
seconds$BAspreadmod <- seconds$BestAskmod-seconds$BestBidmod
seconds$midpointBAmod <- (seconds$BestAskmod+seconds$BestBidmod)/2
seconds$BestBidmod2 <- seconds$BestBid
seconds$BestAskmod2 <- seconds$BestAsk
seconds$BestBidmod2[seconds$BestBid<10 & is.na(seconds$BestBid)==F] <- NA
seconds$BestAskmod2[seconds$BestAsk>105 & is.na(seconds$BestAsk)==F] <- NA
seconds$BAspreadmod2 <- seconds$BestAskmod2 - seconds$BestBidmod2
seconds$midpointBAmod2 <- (seconds$BestAskmod2 + seconds$BestBidmod2)/2

## calculate winsorized bid and ask
winsa <- quantile(seconds$BestAsk, .995, na.rm = T)
winsa1 <- quantile(seconds$BestAsk, .005, na.rm = T)
winsb <- quantile(seconds$BestBid, .995, na.rm = T)
winsb1 <- quantile(seconds$BestBid, .005, na.rm = T)
seconds$BestAskwins <- seconds$BestAsk
seconds$BestAskwins[seconds$BestAsk>winsa & is.na(seconds$BestAsk)==F] <- winsa
seconds$BestAskwins[seconds$BestAsk<winsa1 & is.na(seconds$BestAsk)==F] <- winsa1
seconds$BestBidwins <- seconds$BestBid
seconds$BestBidwins[seconds$BestBid>winsb & is.na(seconds$BestBid)==F] <- winsb
seconds$BestBidwins[seconds$BestBid<winsb1 & is.na(seconds$BestBid)==F] <- winsb1
seconds$BAspreadwins <- seconds$BestAskwins-seconds$BestBidwins
winsc <- quantile(seconds$BAspread, .995, na.rm = T)
winsc1 <- quantile(seconds$BAspread, .005, na.rm = T)
## calculate winsorized bid/ask spreads
seconds$BAspreadwins2 <- seconds$BAspread
seconds$BAspreadwins2[seconds$BAspread>winsc & is.na(seconds$BAspread)==F] <- winsc
seconds$BAspreadwins2[seconds$BAspread<winsc1 & is.na(seconds$BAspread)==F] <- winsc1

save.image("RawDataIII.RData")
#load("RawDataIII.RData")

## Collect Bid/Ask for marketsummary/periodsummary tables ######################
## distribute data about prices at the last second
a <- aggregate(cbind(BestBid, BestAsk, BAspread, midpointBA) ~ Period + SessionID + Market, subset(seconds,  time==180), function(x) mean(x, na.rm = T), na.action = NULL)
colnames(a) <- c( "Period","SessionID", "Market", "BestBid180", "BestAsk180", "BAspread180", "midpointBA180")
## distribute data about prices in the last 30 second
b <- aggregate(cbind(BestBid, BestAsk, BAspread, midpointBA) ~ Period + SessionID + Market, subset(seconds,  time>=150), function(x) mean(x, na.rm=T), na.action = NULL)
colnames(b) <- c("Period","SessionID", "Market",  "BestBid150", "BestAsk150", "BAspread150", "midpointBA150")
## distribute data about prices over the whole period
c <- aggregate(cbind(BestBid, BestAsk, BAspread, midpointBA, return, lnlastPrice) ~ Period + SessionID + Market, seconds, function(x) mean(x, na.rm=T), na.action = NULL)
colnames(c) <- c("Period","SessionID", "Market",  "meanBestBid", "meanBestAsk", "meanBAspread", "meanmidpointBA", "meanreturnsec", "meanPrice")
marketsummary <- merge(marketsummary, a, by = c("Market","SessionID", "Period"))
marketsummary <- merge(marketsummary, b, by = c("Market","SessionID", "Period"))
marketsummary <- merge(marketsummary, c, by = c("Market","SessionID", "Period"))
## distribute data about prices' variance
d <- aggregate(cbind( return, lnlastPrice) ~ Period + SessionID + Market, seconds, function(x) sd(x, na.rm=T), na.action = NULL)
colnames(d) <- c("Period","SessionID", "Market", "sdreturnsec", "sdPrice")
marketsummary <- merge(marketsummary, d, by = c("Market","SessionID", "Period"))

## interval-wise calculation of bid and ask
seconds$bin <- cut(seconds$time, 18)
f <- aggregate(cbind(-BestBid, BestAsk) ~ Period + SessionID + Market + bin, seconds, function(x) min(x, na.rm=T), na.action = NULL)
colnames(f) <- c("Period","SessionID", "Market", "bin",  "BestBid", "BestAsk")
f$BAspread <- f$BestAsk+f$BestBid

## distribute winsorized bid/ask spreads within 99.5% quantile
h <- aggregate(cbind(BAspreadwins, BAspreadwins2) ~ Period + SessionID + Market, seconds, function(x) mean(x))
colnames(h) <- c("Period","SessionID", "Market", "meanBAspreadwins", "meanBAspreadwins2")
marketsummary <- merge(marketsummary, h, by = c("Market","SessionID", "Period"))

## distribute data about prices at the last second
a <- aggregate(cbind(BestBid, BestAsk, BAspread, midpointBA) ~ Period + SessionID, subset(seconds,  time==180), function(x) mean(x, na.rm=T), na.action = NULL)
colnames(a) <- c( "Period","SessionID", "BestBid180", "BestAsk180", "BAspread180", "midpointBA180")
## distribute data about prices in the last 30 second
b <- aggregate(cbind(BestBid, BestAsk, BAspread, midpointBA) ~ Period + SessionID, subset(seconds,  time>=150), function(x) mean(x, na.rm=T), na.action = NULL)
colnames(b) <- c("Period","SessionID",  "BestBid150", "BestAsk150", "BAspread150", "midpointBA150")
## distribute data about prices in the whole period
c <- aggregate(cbind(BestBid, BestAsk, BAspread, midpointBA) ~ Period + SessionID, seconds, function(x) mean(x, na.rm=T), na.action = NULL)
colnames(c) <- c("Period","SessionID",  "meanBestBid", "meanBestAsk", "meanBAspread", "meanmidpointBA")
periodsummary <- merge(periodsummary, a, by = c("SessionID", "Period"))
periodsummary <- merge(periodsummary, b, by = c("SessionID", "Period"))
periodsummary <- merge(periodsummary, c, by = c("SessionID", "Period"))

periodsummary$midpointBAavg180 <- (periodsummary$BestAsk180 + periodsummary$BestBid180) /2
periodsummary$midpointBAavg150 <- (periodsummary$BestAsk150 + periodsummary$BestBid150) /2
periodsummary$meanmidpointBA <- (periodsummary$meanBestAsk + periodsummary$meanBestBid) /2
periodsummary$BAspread180 <- periodsummary$BestAsk180-periodsummary$BestBid180

marketsummary$midpointBAavg150 <- (marketsummary$BestAsk150 + marketsummary$BestBid150) /2
marketsummary$meanmidpointBA <- (marketsummary$meanBestAsk + marketsummary$meanBestBid) /2
marketsummary$BAspread180 <- marketsummary$BestAsk180 - marketsummary$BestBid180
## calc differences to actual BBV
marketsummary$BA_BBV <- marketsummary$meanmidpointBA - marketsummary$BBV
marketsummary$BA_BBV150 <- marketsummary$midpointBA150 - marketsummary$BBV
marketsummary$BA_BBV180 <- marketsummary$midpointBA180 - marketsummary$BBV
marketsummary$lnBA_BBV <- log(marketsummary$meanmidpointBA / marketsummary$BBV)
marketsummary$lnBA_BBV150 <- log(marketsummary$midpointBA150 / marketsummary$BBV)
marketsummary$lnBA_BBV180 <- log(marketsummary$midpointBA180 / marketsummary$BBV)

periodsummary$BA_BBVavg <- periodsummary$meanmidpointBA - periodsummary$BBV
periodsummary$BA_BBVavg150 <- periodsummary$midpointBAavg150 - periodsummary$BBV
periodsummary$BA_BBVavg180 <- periodsummary$midpointBAavg180 - periodsummary$BBV
periodsummary$lnBA_BBVavg <- log(periodsummary$meanmidpointBA / periodsummary$BBV)
periodsummary$lnBA_BBVavg150 <- log(periodsummary$midpointBAavg150 / periodsummary$BBV)
periodsummary$lnBA_BBVavg180 <- log(periodsummary$midpointBAavg180 / periodsummary$BBV)

## Calculate volume by trader type for marketsummary #########################
## distribute role characteristics to transactions
transactions <- merge( transactions, subset(subjects, select = c("Role", "Period", "subjectID")), by.y= c("Period", "subjectID"), by.x = c("Period", "makerID"))
colnames(transactions)[colnames(transactions)=="Role"] <- "makerRole"
transactions <- merge( transactions, subset(subjects, select = c("Role", "Period", "subjectID")), by.y= c("Period", "subjectID"), by.x = c("Period", "takerID"))
colnames(transactions)[colnames(transactions)=="Role"] <- "takerRole"
## summerize by trader types
oo <- aggregate(cbind(Volume) ~ SessionID + Period + Market + takerRole + makerRole, data = transactions, function(x) sum(x))
oo1 <- reshape2::dcast(subset(oo), SessionID + Market + Period ~ paste0("Volume") + takerRole + makerRole, value.var = "Volume", drop = FALSE)
colnames(oo1) <- c("SessionID", "Market", "Period", "Volume_Informed_Informed","Volume_Uninformed_Informed", "Volume_Informed_Uninformed","Volume_Uninformed_Uninformed")
oo1[is.na(oo1)] <- 0
marketsummary <- merge(marketsummary, oo1, by = c("SessionID", "Period", "Market"))

marketsummary$VolumeUni <- marketsummary$Volume_Informed_Uninformed + marketsummary$Volume_Uninformed_Informed + marketsummary$Volume_Uninformed_Uninformed
marketsummary$VolumeInf <- marketsummary$Volume_Informed_Informed + marketsummary$Volume_Informed_Uninformed + marketsummary$Volume_Uninformed_Informed
marketsummary$VolumeUni2 <- marketsummary$Volume_Informed_Uninformed + marketsummary$Volume_Uninformed_Informed + 2*marketsummary$Volume_Uninformed_Uninformed
marketsummary$VolumeInf2 <- 2*marketsummary$Volume_Informed_Informed + marketsummary$Volume_Informed_Uninformed + marketsummary$Volume_Uninformed_Informed

## Calculate (winsorized) returns and volatility ##############################
## winsorized prices
Pwinsa <- quantile(transactions$Price, .995, na.rm = T)
Pwinsa1 <- quantile(transactions$Price, .005, na.rm = T)
transactions$Pricewins <- transactions$Price
transactions$Pricewins[transactions$Price>Pwinsa & is.na(transactions$Price)==F] <- Pwinsa
transactions$Pricewins[transactions$Price<Pwinsa1 & is.na(transactions$Price)==F] <- Pwinsa1
# match data with previous prices
transactionssd <- subset(transactions, select = c(Period, SessionID, Market, transactionIDm, Pricewins, Price))
transactionssd$transactionIDm <- transactionssd$transactionIDm+1
names(transactionssd)[names(transactionssd)=="Pricewins"] <- "L.Pricewins"
names(transactionssd)[names(transactionssd)=="Price"] <- "L.Price"
transactions <- merge(transactions, transactionssd, by = c("Period", "SessionID", "Market", "transactionIDm"), all.x = T)
## calc returns with winsorized prices
transactions$returnwins <- log(transactions$Pricewins) - log(transactions$L.Pricewins)
## calc returns
transactions$return <- log(transactions$Price) - log(transactions$L.Price)
## calc winsorised returns
Rwind <- quantile(transactions$return, .995, na.rm = T)
Rwind1 <- quantile(transactions$return, .005, na.rm = T)
transactions$returnwins2 <- transactions$return
transactions$returnwins2[transactions$return>Rwind & is.na(transactions$return)==F] <- Rwind
transactions$returnwins2[transactions$return<Rwind1 & is.na(transactions$return)==F] <- Rwind1
## calc mean and volatility
mean <- aggregate(cbind(return, returnwins,returnwins2, 1) ~ SessionID + Market + Period, data = transactions, function(x) sum(x))
colnames(mean) <- c("SessionID", "Market", "Period", "meanreturn", "meanreturnwins", "meanreturnwins2", "obsreturn")
sd <- aggregate(cbind(return, returnwins, returnwins2) ~ SessionID + Market + Period, data = transactions, function(x) sd(x))
colnames(sd) <- c("SessionID", "Market", "Period", "volatility", "volatilitywins", "volatilitywins2")
marketsummary <- merge(marketsummary, mean, by = c("SessionID", "Period", "Market"), all = T)
marketsummary <- merge(marketsummary, sd, by = c("SessionID", "Period", "Market"), all = T)

## Calculate limit volume for marketsummary ###################################
## summerize by market
offermarket <- aggregate(cbind(1, LimitVolume, CancelledVolume, remainingVol) ~ Market + SessionID + Programme + Period, data=offers, function(x) sum(x, na.rm=T), na.action = NULL)
colnames(offermarket) <- c("Market", "SessionID", "Programme", "Period", "Countoffers", "LimitVolume", "CancelledVolume", "remainingVol")
marketsummary <- merge(marketsummary, offermarket, by = c("Market","SessionID", "Programme", "Period"))
## summerize offers to sell
offermarketsell <- aggregate(cbind(1, LimitVolume) ~ Market + SessionID + Programme + Period, data=subset(offers, type = "SellingOffer"), function(x) sum(x, na.rm=T), na.action = NULL)
colnames(offermarketsell) <- c("Market", "SessionID", "Programme", "Period", "CountSelloffers", "SellLimitVolume")
marketsummary <- merge(marketsummary, offermarketsell, by = c("Market","SessionID", "Programme", "Period"))
## summerize offers to buy
offermarketbuy <- aggregate(cbind(1, LimitVolume) ~ Market + SessionID + Programme + Period, data=subset(offers, type = "BuyingOffer"), function(x) sum(x, na.rm=T), na.action = NULL)
colnames(offermarketbuy) <- c("Market", "SessionID", "Programme", "Period", "CountBuyoffers", "BuyLimitVolume")
marketsummary <- merge(marketsummary, offermarketbuy, by = c("Market","SessionID", "Programme", "Period"))

## distribute role characteristics to offers
offers <- merge(offers, subset(subjects, select = c("Role", "Period", "subjectID")), by.y= c("Period", "subjectID"), by.x = c("Period", "makerID"))
colnames(offers)[colnames(offers)=="Role"] <- "makerRole"
## summerize by trader types
ol <- aggregate(cbind(LimitVolume) ~ SessionID + Period + Market + makerRole + Programme, data = offers, function(x) sum(x))
ol1 <- reshape2::dcast(subset(ol), SessionID + Market + Period + Programme ~ paste0("LimitVolume") + makerRole, value.var = "LimitVolume", drop = FALSE)
colnames(ol1) <- c("SessionID", "Market", "Period", "Programme", "LimitVolumeInf","LimitVolumeUni")
ol1[is.na(ol1)] <- 0
marketsummary <- merge(marketsummary, ol1, by = c("SessionID", "Period", "Market", "Programme"))
marketsummary$lnLimitVolume <- log(marketsummary$LimitVolume)

## RD,RAD,GD,GAD ##############################################################
marketprofitAbility <- aggregate(cbind(Volume, (Volume*abs(Price-BBV)), Volume*RDi, Volume*abs(RDi), Volume*GDi, Volume*abs(GDi), abs(log(57.5/BBV))*Volume, Volume*BBV ,  1) ~ Market + SessionID + Programme + Period, data=transactions, function(x) sum(x, na.rm=T), na.action = NULL)
colnames(marketprofitAbility) <- c("Market","SessionID", "Programme", "Period", "Volume", "ProfitPotential", "SRDi", "SRADi", "SGDi", "SGADi", "SGADihyp", "VBBV" , "NumTransactions")
marketprofitAbility$GD <- exp(1/marketprofitAbility$Volume * marketprofitAbility$SGDi) - 1
marketprofitAbility$GAD <- exp(1/marketprofitAbility$Volume * marketprofitAbility$SGADi) - 1
marketprofitAbility$GADhyp <- exp(1/marketprofitAbility$Volume * marketprofitAbility$SGADihyp) - 1
marketprofitAbility$RD <- marketprofitAbility$SRDi / marketprofitAbility$VBBV
marketprofitAbility$RAD <- marketprofitAbility$SRADi / marketprofitAbility$VBBV
marketsummary <- merge(marketsummary, marketprofitAbility, by = c("Market","SessionID", "Programme", "Period"))
marketsummary$rGAD <- 1-marketsummary$GAD/marketsummary$GADhyp

## calculate RD,RAD,GD,GAD  for the last 60 seconds
marketprofitAbility120 <- aggregate(cbind(Volume, (Volume*abs(Price-BBV)), Volume*RDi, Volume*abs(RDi), Volume*GDi, Volume*abs(GDi), abs(log(57.5/BBV))*Volume, Volume*BBV ,  1) ~ Market + SessionID + Programme + Period, data=subset(transactions, Time >= 120), function(x) sum(x, na.rm=T), na.action = NULL)
colnames(marketprofitAbility120) <- c("Market","SessionID", "Programme", "Period", "Volume", "ProfitPotential", "SRDi", "SRADi", "SGDi", "SGADi", "SGADihyp", "VBBV" , "NumTransactions")
marketprofitAbility120$GD120 <- exp(1/marketprofitAbility120$Volume * marketprofitAbility120$SGDi) - 1
marketprofitAbility120$GAD120 <- exp(1/marketprofitAbility120$Volume * marketprofitAbility120$SGADi) - 1
marketprofitAbility120$GADhyp120 <- exp(1/marketprofitAbility120$Volume * marketprofitAbility120$SGADihyp) - 1
marketprofitAbility120$RD120 <- marketprofitAbility120$SRDi / marketprofitAbility120$VBBV
marketprofitAbility120$RAD120 <- marketprofitAbility120$SRADi / marketprofitAbility120$VBBV
marketsummary <- merge(marketsummary, subset(marketprofitAbility120, select = c(GD120, GAD120,GADhyp120, RD120, RAD120, Market, SessionID, Programme, Period)), by = c("Market","SessionID", "Programme", "Period"), all = T)
marketsummary$rGAD120 <- 1-marketsummary$GAD120/marketsummary$GADhyp120

## Sum over both markets in a period / odds ###################################
summarkets <- aggregate(cbind(Volume, LimitVolume, VolumeInf, VolumeUni, LimitVolumeInf, LimitVolumeUni) ~ SessionID + Programme + Period, data=marketsummary, function(x) sum(x, na.rm=T), na.action = NULL)
colnames(summarkets) <- c("SessionID", "Programme", "Period", "TotVolume", "TotLimitVolume", "TotVolumeInf", "TotVolumeUni", "TotLimitVolumeInf", "TotLimitVolumeUni")
marketsummary <- merge(marketsummary, summarkets, by = c("SessionID", "Programme", "Period"))
marketsummary$marketshare <- marketsummary$Volume / marketsummary$TotVolume
marketsummary$marketshareLimit <- marketsummary$LimitVolume/marketsummary$TotLimitVolume
marketsummary$AssetTurnover <- marketsummary$Volume / marketsummary$remainingVol
marketsummary$TransactionSize <- marketsummary$Volume / marketsummary$NumTransactions
marketsummary$LimitOrderTurnover <- marketsummary$LimitVolume / marketsummary$remainingVol
marketsummary$LimitOrderSize <- marketsummary$LimitVolume / marketsummary$Countoffers
marketsummary$relCancelledVolume <- marketsummary$CancelledVolume / marketsummary$LimitVolume
marketsummary$odds <- marketsummary$Volume/(marketsummary$TotVolume - marketsummary$Volume)
marketsummary$oddsLimit <- marketsummary$LimitVolume / (marketsummary$TotLimitVolume - marketsummary$LimitVolume)
## odds by trader type
marketsummary$oddsUninf <- marketsummary$VolumeUni / (marketsummary$TotVolumeUni - marketsummary$VolumeUni)
marketsummary$oddsInf <- marketsummary$VolumeInf / (marketsummary$TotVolumeInf - marketsummary$VolumeInf)
marketsummary$oddsLimitUninf <- marketsummary$LimitVolumeUni / (marketsummary$TotLimitVolumeUni - marketsummary$LimitVolumeUni)
marketsummary$oddsLimitInf <- marketsummary$LimitVolumeInf / (marketsummary$TotLimitVolumeInf - marketsummary$LimitVolumeInf)
## replace missing odds because of no-trade
marketsummary$oddsInfmax <- marketsummary$oddsInf
marketsummary$oddsInfmax[marketsummary$oddsInf==Inf] <- max(marketsummary$oddsInf[marketsummary$oddsInf!=Inf])
marketsummary$oddsInfmax2 <- marketsummary$oddsInf
marketsummary$oddsInfmax2[marketsummary$oddsInf==Inf] <- marketsummary$VolumeInf[marketsummary$oddsInf==Inf]/1
marketsummary$oddsInfmax3 <- marketsummary$oddsInf
marketsummary$oddsInfmax3[marketsummary$oddsInf==Inf & marketsummary$Part == "end"] <- max(marketsummary$oddsInf[marketsummary$oddsInf!=Inf & marketsummary$Part == "end"])
marketsummary$oddsInfmax3[marketsummary$oddsInf==Inf & marketsummary$Part == "middle"] <- max(marketsummary$oddsInf[marketsummary$oddsInf!=Inf & marketsummary$Part == "middle"])
Owind <- quantile(marketsummary$odds, .995, na.rm = T)
Owind1 <- quantile(marketsummary$odds, .005, na.rm = T)
marketsummary$oddswins <- marketsummary$odds
marketsummary$oddswins[marketsummary$odds>Owind] <- Owind
marketsummary$oddswins[marketsummary$odds<Owind1] <- Owind1
OLwind <- quantile(marketsummary$oddsLimit, .995, na.rm = T)
OLwind1 <- quantile(marketsummary$oddsLimit, .005, na.rm = T)
marketsummary$oddsLimitwins <- marketsummary$oddsLimit
marketsummary$oddsLimitwins[marketsummary$oddsLimit>OLwind | marketsummary$oddsLimit == Inf] <- OLwind
marketsummary$oddsLimitwins[marketsummary$oddsLimit<OLwind1 | marketsummary$oddsLimit == -Inf] <- OLwind1
OIwind <- quantile(marketsummary$oddsInf, .995, na.rm = T)
OIwind1 <- quantile(marketsummary$oddsInf, .005, na.rm = T)
marketsummary$oddsInfwins <- marketsummary$oddsInf
marketsummary$oddsInfwins[marketsummary$oddsInf>OIwind | marketsummary$oddsInf == Inf] <- OIwind
marketsummary$oddsInfwins[marketsummary$oddsInf<OIwind1 | marketsummary$oddsInf == -Inf] <- OIwind1
OUwind <- quantile(marketsummary$oddsUninf, .995, na.rm = T)
OUwind1 <- quantile(marketsummary$oddsUninf, .005, na.rm = T)
marketsummary$oddsUninfwins <- marketsummary$oddsUninf
marketsummary$oddsUninfwins[marketsummary$oddsUninf>OUwind | marketsummary$oddsUninf == Inf] <- OUwind
marketsummary$oddsUninfwins[marketsummary$oddsUninf<OUwind1 | marketsummary$oddsUninf == -Inf] <- OUwind1
## periodsummary
sumperiods <- subset(marketsummary, Market==1, select = c("SessionID", "Programme", "Period", "marketshare"))
periodsummary <- merge(periodsummary, sumperiods, by = c("SessionID", "Programme", "Period"))

## Calculate odds by Phase ####################################################
ms <- aggregate(cbind(log(odds), log(oddswins), log(oddsLimit), log(oddsUninf), log(oddsUninfwins), log(oddsInf), log(oddsInfwins), log(oddsLimitUninf), log(oddsLimitInf), abs(log(odds)),abs(log(oddsLimit)), log(marketshare), log(marketshareLimit), (marketshare), (marketshareLimit), abs(log(marketshare+.5)), abs(log(marketshareLimit+.5))) ~ Part + SessionID + market, data = subset(marketsummary), function(x) mean(x))
colnames(ms) <- c("Part", "SessionID", "market", "geomodds", "geomoddswins", "geomoddsLimit", "geomoddsUni", "geomoddsUniwins", "geomoddsInf", "geomoddsInfwins", "geomoddsLimitUni", "geomoddsLimitInf", "absgeomodds", "absgeomoddsLimit", "lnmarketshare", "lnmarketshareLimit", "marketshare", "marketshareLimit","abslnmarketshare", "abslnmarketshareLimit" )
ms$Avgmarketshare <- exp(ms$lnmarketshare)
ms$AvgmarketshareLimit <- exp(ms$lnmarketshareLimit)
a1 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("lnmarketshare") + Part, value.var = "lnmarketshare", drop = FALSE)
a2 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("lnmarketshareLimit") + Part, value.var = "lnmarketshareLimit", drop = FALSE)
a3 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("abslnmarketshare") + Part, value.var = "abslnmarketshare", drop = FALSE)
a4 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("abslnmarketshareLimit") + Part, value.var = "abslnmarketshareLimit", drop = FALSE)
a5 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomodds") + Part, value.var = "geomodds", drop = FALSE)
a6 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddsLimit") + Part, value.var = "geomoddsLimit", drop = FALSE)
a7 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("absgeomodds") + Part, value.var = "absgeomodds", drop = FALSE)
a8 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("absgeomoddsLimit") + Part, value.var = "absgeomoddsLimit", drop = FALSE)
a9 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddswins") + Part, value.var = "geomoddswins", drop = FALSE)
a10 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddsUni") + Part, value.var = "geomoddsUni", drop = FALSE)
a11 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddsUniwins") + Part, value.var = "geomoddsUniwins", drop = FALSE)
a12 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddsInf") + Part, value.var = "geomoddsInf", drop = FALSE)
a13 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddsInfwins") + Part, value.var = "geomoddsInfwins", drop = FALSE)
a14 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddsLimitUni") + Part, value.var = "geomoddsLimitUni", drop = FALSE)
a15 <- reshape2::dcast(subset(ms), SessionID + market ~ paste0("geomoddsLimitInf") + Part, value.var = "geomoddsLimitInf", drop = FALSE)
marketsummary <- merge(marketsummary, a1, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a2, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a3, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a4, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a5, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a6, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a7, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a8, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a9, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a10, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a11, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a12, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a13, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a14, by = c("SessionID", "market"))
marketsummary <- merge(marketsummary, a15, by = c("SessionID", "market"))
## one period lag
lag <- subset(marketsummary, select = c(SessionID, market, Period, Volume, LimitVolume, marketshare, marketshareLimit, odds, oddsLimit))
colnames(lag) <- c("SessionID", "market", "Period", "lagVolume", "lagLimitVolume", "lagmarketshare", "lagmarketshareLimit", "lagodds", "lagoddsLimit")
lag$Period <- lag$Period + 1
marketsummary <- merge(marketsummary, subset(lag, Period<=12), by = c("SessionID", "market", "Period"), all = T)
## Period 3
lag1 <- subset(lag, Period==4)
colnames(lag1) <- c("SessionID", "market", "Period", "P3Volume", "P3LimitVolume", "P3marketshare", "P3marketshareLimit", "P3odds", "P3oddsLimit")
marketsummary <- merge(marketsummary, subset(lag1, select =-c(Period)), by = c("SessionID", "market"), all = T)

## Calculate time of unexecuted profitable order ##############################
## calculates relative money on the table. weighted by time and volume relative to the overall time and volume offered overall
orders$unprofittime <- orders$Type*(orders$Price-orders$BBV) * orders$remainingVol * orders$ordertime
orders$unprofittime[orders$unprofittime<=0] <- NA
unprofittime <- aggregate(cbind(unprofittime, remainingVol*ordertime) ~ Market + SessionID + Programme + Period, data=subset(orders, unprofittime>0), function(x) sum(x, na.rm=T), na.action = NULL)
colnames(unprofittime) <- c("Market","SessionID", "Programme", "Period", "unprofittime", "voltime")
marketsummary <- merge(marketsummary, unprofittime, by = c("Market","SessionID", "Programme", "Period"), all = T)
marketsummary$unprofittime[is.na(marketsummary$unprofittime)] <- 0
marketsummary$RUPT <- marketsummary$unprofittime / marketsummary$BBV / marketsummary$voltime

## periodsummary
marketsummary2 <- marketsummary
marketsummary2$Volume2 <- marketsummary2$Volume
marketsummary2$Volume2[marketsummary2$Market==2] <- -marketsummary2$Volume[marketsummary2$Market==2]
periodsummary2 <- aggregate(cbind(Volume, Volume2, ProfitPotential, unprofittime, LimitVolume, SRDi, SRADi, SGDi, SGADi, VBBV, NumTransactions) ~ SessionID + Period + Programme, data = subset(marketsummary2), function(x) sum(x), na.action = NULL)
periodsummary2$GD <- exp(1/periodsummary2$Volume*periodsummary2$SGDi)-1
periodsummary2$GAD <- exp(1/periodsummary2$Volume*periodsummary2$SGADi)-1
periodsummary2$RD <- periodsummary2$SRDi/periodsummary2$VBBV
periodsummary2$RAD <- periodsummary2$SRADi/periodsummary2$VBBV
periodsummary <- merge(periodsummary, periodsummary2, by = c("SessionID", "Period", "Programme"))

periodsummary$lnVolume <- log(periodsummary$Volume)

## Subjectmarket table ########################################################
## collect initialendowment for each market
for(s in 1:24){
  for(P in 1:12){
subjects$InitialEndowment[subjects$SessionID==s & subjects$Period==P & subjects$Programme==3] <- subjects$`InitialAssets[1]`[subjects$SessionID==s & subjects$Period==P & subjects$Programme==3]*globals$`BBV[1]`[globals$SessionID==s & globals$Period==P & globals$Programme==3] + subjects$InitialCash[subjects$SessionID==s & subjects$Period==P & subjects$Programme==3]
  }}

## create one row for each period(pl), participant(subl), and market(ml)
pl <- c(1:12)
subl <- c(1:max(subset(subjects$subjectID, is.na(subjects$subjectID)==F)))
ml <- c(1:2)
subjectsummary <- expand.grid(subl, pl,  ml)
names(subjectsummary) <- c("subjectID", "Period", "Market")
subjectsummary <- merge(subjectsummary, subset(subjects, Programme==3 & Period==1, select = c("subjectID", "SessionID")), by = c("subjectID"))
subjectsummary <- merge(subjectsummary, matchingTreatment, by = c("SessionID"))
subjectsummary$myMarketTreatment <- paste0(substr(subjectsummary$Treatment, 1,1), ".", substr(subjectsummary$Treatment, 4,4))
subjectsummary$myMarketTreatment[subjectsummary$Market == 2] <- paste0(substr(subjectsummary$Treatment[subjectsummary$Market == 2], 2,2), ".", substr(subjectsummary$Treatment[subjectsummary$Market == 2], 5,5))
subjectsummary$history <- subjectsummary$myMarketTreatment
subjectsummary$history[subjectsummary$Period<4] <- 1
subjectsummary$history[subjectsummary$Period>3 & subjectsummary$Period<10] <- paste0(substr(subjectsummary$Treatment[subjectsummary$Period>3 & subjectsummary$Period<10], 1,1))
subjectsummary$Programme <- 3

## collect data for each market
for(P in 1:12){
  for(sub in 1:max(subset(subjects$subjectID, is.na(subjects$subjectID)==F))){ 
    subjectsummary$InitialAssets[ subjectsummary$Period==P & subjectsummary$subjectID==sub] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`InitialAssets[1]`
    subjectsummary$Assets[ subjectsummary$Period==P & subjectsummary$subjectID==sub] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`Assets[1]`
    subjectsummary$LimitVolume[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`LimitVol[1]`
    subjectsummary$LimitVolume[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`LimitVol[2]`
    subjectsummary$Volume[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`VolumeTransactions[1]`
    subjectsummary$Volume[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`VolumeTransactions[2]`
    subjectsummary$CancelledVolume[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`CancelledVol[1]`
    subjectsummary$CancelledVolume[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`CancelledVol[2]`
    subjectsummary$VolumeMarketOrder[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`VolMarketTran[1]`
    subjectsummary$VolumeMarketOrder[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`VolMarketTran[2]`
    subjectsummary$VolumeLimitOrder[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`VolLimitTran[1]`
    subjectsummary$VolumeLimitOrder[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`VolLimitTran[2]`
    subjectsummary$TradingProfit[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`TradingProfit[1]`
    subjectsummary$TradingProfit[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`TradingProfit[2]`
    subjectsummary$Punished[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`Punished[1]`
    subjectsummary$Punished[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`Punished[2]`
    subjectsummary$PunishmentReceived[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==1] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`CompensationReceived[1]`
    subjectsummary$PunishmentReceived[ subjectsummary$Period==P & subjectsummary$subjectID==sub & subjectsummary$Market==2] <- subset(subjects, Period==P & subjectID==sub & Programme==3)$`CompensationReceived[2]`
    }}

save.image("RawDataIV.RData")

subjects$EndEndowmentPun <- subjects$InitialEndowment + subjects$`TradingProfit[1]` + subjects$`TradingProfit[2]` + subjects$`CompensationReceived[1]` + subjects$`CompensationReceived[2]`
subjectsummary <- merge(subjectsummary, subset(subjects, select = c(subjectID, Period, ProfitPeriod, Role, Cash,InitialCash, InitialEndowment, EndVermoegen, EndEndowmentPun, TotalShort)), by=c("subjectID", "Period"))
subjectsummary <- subset(subjectsummary, Role!="Observer")
## calculate profits
subjectsummary <- merge(subjectsummary, subset(subjects, Period==12, select = c("TotalProfit", "subjectID")), by = c("subjectID"))
subjectsummary$TPPun <- subjectsummary$TradingProfit + subjectsummary$PunishmentReceived
subjectsummary$TPRedist <- subjectsummary$TradingProfit + subjectsummary$PunishmentReceived
subjectsummary$TPRedist[subjectsummary$Role == "Informed trader"] <- subjectsummary$TradingProfit[subjectsummary$Role == "Informed trader"] + subjectsummary$PunishmentReceived[subjectsummary$Role == "Informed trader"]/2
subjectsummary$PD <- subjectsummary$TPPun / subjectsummary$InitialEndowment
subjectsummary$logPD <- log(1+subjectsummary$TPPun / subjectsummary$InitialEndowment)

## Determine active traders ###################################################
subjectsummary$activeTrader <- "inactive"
subjectsummary$activeTrader[subjectsummary$Volume>0 | subjectsummary$LimitVolume>0] <- "active"
subjectsummary$transacted <- "Has not transacted"
subjectsummary$transacted[subjectsummary$Volume>0] <- "Transacted"
subjectsummary$offered <- "Has not offered"
subjectsummary$offered[subjectsummary$LimitVolume>0] <- "Offered"

sellsTable <- aggregate(Volume ~ Market + Period + SellerID, data = transactions, function(x) sum(x))
colnames(sellsTable)[colnames(sellsTable)=="SellerID"] <- "subjectID"
colnames(sellsTable)[colnames(sellsTable)=="Volume"] <- "VolumeSold"
subjectsummary <- merge(subjectsummary, sellsTable, by = c("subjectID", "Market", "Period"), all = T)
subjectsummary$VolumeSold[is.na(subjectsummary$VolumeSold)] <- 0

buysTable <- aggregate(Volume ~ Market + Period + BuyerID, data = transactions, function(x) sum(x))
colnames(buysTable)[colnames(buysTable)=="BuyerID"] <- "subjectID"
colnames(buysTable)[colnames(buysTable)=="Volume"] <- "VolumePurchased"
subjectsummary <- merge(subjectsummary, buysTable, by = c("subjectID", "Market", "Period"), all = T)
subjectsummary$VolumePurchased[is.na(subjectsummary$VolumePurchased)] <- 0

## Short sells ################################################################
## distribute sellers stock endowment
transactions <- merge(transactions, subset(subjectsummary, select = c(subjectID, Period, Market, InitialAssets, Assets)),by.x=c("SellerID", "Period", "Market"), by.y=c("subjectID", "Period", "Market"))
colnames(transactions)[colnames(transactions)=="InitialAssets"] <- "SellersInitialAssets"         
colnames(transactions)[colnames(transactions)=="Assets"] <- "SellersFinalAssets" 
## determine sold assets at the time of transaction
library(dplyr)
transactions <- transactions %>%
  group_by(SessionID, Period, SellerID) %>%
  arrange(transactiontime) %>%
  mutate(SellerSales = cumsum(transactionVol))
## determine bought assets at the time of transaction
transactions$SellerBuyes <- 0
for(i in 1:max(transactions$transactionID)){
  k <- transactions$SellerID[transactions$transactionID == i]
  t <- transactions$transactiontime[transactions$transactionID == i]
  p <- transactions$Period[transactions$transactionID == i]
  transactions$SellerBuyes[transactions$transactionID == i] <- sum(transactions$transactionVol[transactions$BuyerID == k & transactions$transactiontime<t & transactions$Period == p])
}
## determine sellers stock endomment at the time of transaction
transactions$SellerAssetsBefore <- with(SellersInitialAssets + SellerBuyes - SellerSales + transactionVol, data = transactions)
transactions$SellerAssetsAfter <- with(SellersInitialAssets + SellerBuyes - SellerSales, data = transactions)
## calculate short sells
transactions$shortsells <- 0
transactions$shortsells[transactions$SellerAssetsAfter < 0] <- transactions$transactionVol[transactions$SellerAssetsAfter < 0]
transactions$shortsells[transactions$SellerAssetsAfter < 0 & transactions$SellerAssetsBefore > 0] <- -transactions$SellerAssetsAfter[transactions$SellerAssetsAfter < 0 & transactions$SellerAssetsBefore > 0]
shortTable1 <- aggregate(shortsells ~ Market + Period + SellerID, data = transactions, function(x) sum(x))
colnames(shortTable1)[colnames(shortTable1)=="SellerID"] <- "subjectID"
subjectsummary <- merge(subjectsummary, shortTable1, by = c("subjectID", "Market", "Period"), all = T)
subjectsummary$shortsells[is.na(subjectsummary$shortsells)] <- 0
## sum short sells by markets
shortTable <- aggregate(cbind(TotalShort, shortsells) ~ Market + SessionID + Programme + Period, function(x) sum(x), data=subset(subjectsummary))
marketsummary <- merge(marketsummary, shortTable, by = c("Market", "SessionID", "Programme", "Period"), all = T)

## Margin buys ###############################################################
## distribute buyers monetary endowment
transactions <- merge(transactions, subset(subjectsummary, select = c(subjectID, Period, Market, InitialCash, Cash)),by.x=c("BuyerID", "Period", "Market"), by.y=c("subjectID", "Period", "Market"))
colnames(transactions)[colnames(transactions)=="InitialCash"] <- "BuyerInitialCash"         
colnames(transactions)[colnames(transactions)=="Cash"] <- "BuyerFinalCash" 
## determine revenues at the time of transaction
transactions <- transactions %>%
  group_by(SessionID, Period, BuyerID) %>%
  arrange(transactiontime) %>%
  mutate(BuyerbuysTaler = cumsum(transactionVol*Price))
## determine spend money at the time of transaction
transactions$BuyerSellsTaler <- 0
for(i in 1:max(transactions$transactionID)){
  k <- transactions$BuyerID[transactions$transactionID == i]
  t <- transactions$transactiontime[transactions$transactionID == i]
  p <- transactions$Period[transactions$transactionID == i]
  transactions$BuyerSellsTaler[transactions$transactionID == i] <- sum(transactions$Price[transactions$SellerID == k & transactions$transactiontime<t & transactions$Period == p]*transactions$transactionVol[transactions$SellerID == k & transactions$transactiontime<t & transactions$Period == p])
}
## determine buyers monetary endomment at the time of transaction
transactions$BuyerCashBefore <- with(BuyerInitialCash - BuyerbuysTaler + BuyerSellsTaler + transactionVol*Price, data = transactions)
transactions$BuyerCashAfter <- with(BuyerInitialCash - BuyerbuysTaler + BuyerSellsTaler, data = transactions)
## calculate margin buys at BBV
transactions$marginbuysTaler <- 0
transactions$marginbuysTaler[transactions$BuyerCashAfter < 0] <- transactions$transactionVol[transactions$BuyerCashAfter < 0] * transactions$Price[transactions$BuyerCashAfter < 0]
transactions$marginbuysTaler[transactions$BuyerCashAfter < 0 & transactions$BuyerCashBefore > 0] <- -transactions$BuyerCashAfter[transactions$BuyerCashAfter < 0 & transactions$BuyerCashBefore > 0]
## calculate margin buys at the current Price (as volume)
transactions$marginbuysAsset <- 0
transactions$marginbuysAsset[transactions$BuyerCashAfter < 0] <- transactions$transactionVol[transactions$BuyerCashAfter < 0]
transactions$marginbuysAsset[transactions$BuyerCashAfter < 0 & transactions$BuyerCashBefore > 0] <- -transactions$BuyerCashAfter[transactions$BuyerCashAfter < 0 & transactions$BuyerCashBefore > 0] / transactions$Price[transactions$BuyerCashAfter < 0 & transactions$BuyerCashBefore > 0]
marginTable1 <- aggregate(cbind(marginbuysTaler, marginbuysAsset) ~ Market + Period + BuyerID, data = transactions, function(x) sum(x))
colnames(marginTable1)[colnames(marginTable1)=="BuyerID"] <- "subjectID"
subjectsummary <- merge(subjectsummary, marginTable1, by = c("subjectID", "Market", "Period"), all = T)
subjectsummary$marginbuysTaler[is.na(subjectsummary$marginbuysTaler)] <- 0
subjectsummary$marginbuysAsset[is.na(subjectsummary$marginbuysAsset)] <- 0

marginTable <- aggregate(cbind(marginbuysTaler, marginbuysAsset) ~ Market + SessionID + Programme + Period, function(x) sum(x), data=subset(subjectsummary))
marketsummary <- merge(marketsummary, marginTable, by = c("Market", "SessionID", "Programme", "Period"), all = T)
marketsummary$marginbuys <- marketsummary$marginbuysTaler / marketsummary$BBV

## merge some data between subjectsummery from marketsummary
subjectsummary <- merge(subjectsummary, subset(marketsummary, Programme==3, select = c("SessionID", "Market", "Period", "IsREG", "othermarket", "REGBoth", "REGonly", "REGSH", "BBV", "BBVCent", "market", "middle", "Part")), by = c("SessionID", "Market", "Period"), all.x = T)

subjectsummary$marginbuys <- subjectsummary$marginbuysTaler / subjectsummary$BBV
subjectsummary$Phase <- factor(subjectsummary$Part, levels = c("start", "middle", "end"), labels = c("Phase 1", "Phase 2", "Phase 3"))

## summerize by trader types
shortTableR <- aggregate(cbind(shortsells, marginbuysTaler, marginbuysAsset, marginbuys) ~ SessionID + Period + Market + Role, data = subjectsummary, function(x) sum(x))
shortTableR1 <- reshape2::dcast(subset(shortTableR), SessionID + Period + Market ~ paste0("shortsells") + Role, value.var = "shortsells", drop = FALSE)
shortTableR2 <- reshape2::dcast(subset(shortTableR), SessionID + Period + Market ~ paste0("marginbuys") + Role, value.var = "marginbuys", drop = FALSE)
shortTableR3 <- reshape2::dcast(subset(shortTableR), SessionID + Period + Market ~ paste0("marginbuysAsset") + Role, value.var = "marginbuysAsset", drop = FALSE)
shortTableR4 <- reshape2::dcast(subset(shortTableR), SessionID + Period + Market ~ paste0("marginbuysTaler") + Role, value.var = "marginbuysTaler", drop = FALSE)
shortTableR1 <- merge(shortTableR1, shortTableR2, by = c("SessionID", "Period", "Market"))
shortTableR1 <- merge(shortTableR1, shortTableR3, by = c("SessionID", "Period", "Market"))
shortTableR1 <- merge(shortTableR1, shortTableR4, by = c("SessionID", "Period", "Market"))
shortTableR1 <- subset(shortTableR1, select = c("SessionID", "Period", "Market", "shortsells_Informed trader","shortsells_Uninformed trader", "marginbuys_Informed trader","marginbuys_Uninformed trader", "marginbuysAsset_Informed trader","marginbuysAsset_Uninformed trader", "marginbuysTaler_Informed trader","marginbuysTaler_Uninformed trader"))
colnames(shortTableR1) <- c("SessionID", "Period", "Market", "shortsells_Informed","shortsells_Uninformed", "marginbuys_Informed","marginbuys_Uninformed", "marginbuysAsset_Informed","marginbuysAsset_Uninformed", "marginbuysAsset_Informed","marginbuysAsset_Uninformed")
shortTableR1[is.na(shortTableR1)] <- 0
marketsummary <- merge(marketsummary, shortTableR1, by = c("SessionID", "Period", "Market"), all = T)


## avg prices in the last 60 sec ##############################################
Prices120 <- aggregate(cbind(transactionVol*Price, transactionVol) ~ Market + SessionID + Programme + Period, function(x) sum(x), data=subset(transactions, Time >= 120))
Prices120$Price120 <- Prices120$V1 / Prices120$transactionVol
marketsummary <- merge(marketsummary, subset(Prices120, select = c("Market", "SessionID", "Programme", "Period", "Price120")), by = c("Market", "SessionID", "Programme", "Period"), all = T)

## not profitable transactions by trader ######################################
transactions2 <- transactions
transactions2$unprofit <- abs(transactions2$SellersProfit)
transactions2$subjectID <- transactions2$SellerID
transactions2$subjectID[transactions2$SellersProfit>0] <- transactions2$BuyerID[transactions2$SellersProfit>0]
unprofit2 <- aggregate(cbind(unprofit, Volume, 1) ~ Market + subjectID + Programme + Period, data=transactions2, function(x) sum(x, na.rm=T), na.action = NULL)
colnames(unprofit2) <- c("Market","subjectID", "Programme", "Period", "TPUnProfitTransaction", "VolUnprofitTransaction", "NumUnprofitTransactions")
subjectsummary <- merge(subjectsummary, unprofit2, by = c("Market","subjectID", "Programme", "Period"), all = T)
subjectsummary$TPUnProfitTransaction[is.na(subjectsummary$TPUnProfitTransaction)==T] <- 0
subjectsummary$VolUnprofitTransaction[is.na(subjectsummary$VolUnprofitTransaction)==T] <- 0
subjectsummary$NumUnprofitTransactions[is.na(subjectsummary$NumUnprofitTransactions)==T] <- 0

## subjects' marketshare, odds, and overall volume of each trader #############
summarketssubj <- aggregate(cbind(Volume, LimitVolume) ~ SessionID + Programme + Period + subjectID, data=subjectsummary, function(x) sum(x))
colnames(summarketssubj) <- c("SessionID", "Programme", "Period", "subjectID", "TotVolumeTrader", "TotLimitVolumeTrader")
subjectsummary <- merge(subjectsummary, summarketssubj, by = c("SessionID", "Programme", "Period", "subjectID"))
subjectsummary$marketshare <- subjectsummary$Volume/subjectsummary$TotVolumeTrader
subjectsummary$lnVolume <- log(subjectsummary$Volume)
subjectsummary$odds <- subjectsummary$Volume/(subjectsummary$TotVolumeTrader-subjectsummary$Volume)
subjectsummary$oddsLimit <- subjectsummary$LimitVolume/(subjectsummary$TotLimitVolumeTrader-subjectsummary$LimitVolume)

## active Traders per market ##################################################
activeTrader <- aggregate(cbind(subjectID) ~ Market + SessionID + Programme + Period, function(x) length(x), data=subset(subjectsummary, Volume>0 | LimitVolume>0))
colnames(activeTrader) <- c("Market","SessionID", "Programme", "Period", "NumActiveTrader")
marketsummary <- merge(marketsummary, activeTrader, by = c("Market","SessionID", "Programme", "Period"))
activeTrader <- aggregate(cbind(subjectID) ~ Market + SessionID + Programme + Period, function(x) length(x), data=subset(subjectsummary, Volume>0))
colnames(activeTrader) <- c("Market","SessionID", "Programme", "Period", "NumTransactingTraders")
marketsummary <- merge(marketsummary, activeTrader, by = c("Market","SessionID", "Programme", "Period"))
activeTrader <- aggregate(cbind(subjectID) ~ Market + SessionID + Programme + Period, function(x) length(x), data=subset(subjectsummary, LimitVolume>0))
colnames(activeTrader) <- c("Market","SessionID", "Programme", "Period", "NumOfferingTraders")
marketsummary <- merge(marketsummary, activeTrader, by = c("Market","SessionID", "Programme", "Period"))

activeTraderRole1 <- aggregate(cbind(subjectID) ~ Role + Market + SessionID + Period + Programme, function(x) length(x), data=subset(subjectsummary, Volume>0 | LimitVolume>0))
activeTraderRole <- reshape2::dcast(subset(activeTraderRole1), Period + Market + SessionID + Programme ~ paste0("NumActiveTrader") + Role, value.var = "subjectID", drop = T)
activeTraderRole$ParticipationRate_Inf <- activeTraderRole$`NumActiveTrader_Informed trader` / 4
activeTraderRole$ParticipationRate_Uninf <- activeTraderRole$`NA_Uninformed trader` / 10
marketsummary <- merge(marketsummary, subset(activeTraderRole, select = c("Market","SessionID", "Programme", "Period", "ParticipationRate_Uninf", "ParticipationRate_Inf")), by = c("Market","SessionID", "Period", "Programme"))

## merge more data subjectsummary & marketsummary
subjectsummary <- merge(subjectsummary, subset(marketsummary, Programme==3, select = c("SessionID", "Market", "Period", "Price", "Price120", "NumActiveTrader", "NumTransactingTraders", "TotVolume", "TotLimitVolume", "ParticipationRate_Uninf", "ParticipationRate_Inf")), by = c("SessionID", "Market", "Period"), all.x = T)

## subjects' summery over both markets ########################################
subjectsummaryP <- aggregate(cbind(Volume, TradingProfit, TPPun, TPRedist) ~ subjectID + Role + Treatment + embTreatment + endTreatment + Location + Beginning + End + ChgRegime + regOrder + SessionID + Programme + Period + BBV + BBVCent + TotVolume + TotLimitVolume + middle + Part + TotalProfit + ProfitPeriod + InitialEndowment + EndVermoegen, function(x) sum(x), data = subjectsummary)
activeTraderP <- aggregate(cbind(subjectID) ~  SessionID + Programme + Period, function(x) length(x), data=subset(subjectsummaryP, Volume>0))
colnames(activeTraderP) <- c("SessionID", "Programme", "Period", "NumActiveTrader")
periodsummary <- merge(periodsummary, activeTraderP, by = c("SessionID", "Programme", "Period"))

subjectsummaryP$IsREG <- NA
subjectsummaryP$REGBoth <- 0
subjectsummaryP$REGSH <- 0
subjectsummaryP$REGonly <- 0
subjectsummaryP$IsREG[subjectsummaryP$Period<=3 & subjectsummaryP$Beginning=="RR"] <- "REG"
subjectsummaryP$REGBoth[subjectsummaryP$Period<=3 & subjectsummaryP$Beginning=="RR"] <- 1
subjectsummaryP$IsREG[subjectsummaryP$Period<=3 & subjectsummaryP$Beginning=="NN"] <- "NOREG"
subjectsummaryP$IsREG[subjectsummaryP$Period>=10 & subjectsummaryP$End=="RR"] <- "REG"
subjectsummaryP$REGBoth[subjectsummaryP$Period>=10 & subjectsummaryP$End=="RR"] <-  1
subjectsummaryP$IsREG[subjectsummaryP$Period>=10 & subjectsummaryP$End=="NN"] <- "NOREG"
subjectsummaryP$IsREG[subjectsummaryP$Period<10 & subjectsummaryP$Period>3 & substr(subjectsummaryP$Treatment, 4,5)=="RN"] <- "REG"
subjectsummaryP$REGonly[subjectsummaryP$Period<10 & subjectsummaryP$Period>3 & substr(subjectsummaryP$Treatment, 4,5)=="RN"] <- 1
subjectsummaryP$IsREG[subjectsummaryP$Period<10 & subjectsummaryP$Period>3 & substr(subjectsummaryP$Treatment, 4,5)=="NR"] <- "NOREG"
subjectsummaryP$REGSH[subjectsummaryP$Period<10 & subjectsummaryP$Period>3 & substr(subjectsummaryP$Treatment, 4,5)=="RN"] <- 1
subjectsummaryP$PD <- subjectsummaryP$TPPun / subjectsummaryP$InitialEndowment
subjectsummaryP$logPD <- log(1+subjectsummaryP$TPPun / subjectsummaryP$InitialEndowment)

subperiods <- subset(subjectsummary, Market==1, select = c("subjectID","SessionID", "Programme", "Period", "marketshare"))
subjectsummaryP <- merge(subjectsummaryP, subperiods, by = c("subjectID", "SessionID", "Programme", "Period"))

## Observer proficiency #######################################################
infodata <- merge(infodata, subset(marketsummary, Programme == 3, select = c(SessionID, Period, Market, IsREG), by = c("SessionID", "Period", "Market")), all = T)
correctobs <- aggregate(cbind(Selected, (IsInsider*Selected), (IsInsider*Selected*(IsREG=="REG")), ((1-IsInsider)*Selected)) ~ Market + SessionID + Period, data= subset(infodata, Market!=0), function(x) sum(x))
colnames(correctobs) <- c( "MarketRole", "SessionID", "Period", "NumSelected", "NumDetections", "NumPunished", "NumMissuspected")
## MarketRole describes the market in which an observer is responsible
observers <- merge(subjects, correctobs, by = c("MarketRole", "SessionID", "Period"))
observers <- merge(observers, subset(globals, select = c(`IsPun[1]`, `IsPun[2]`, SessionID, Period)), by= c("SessionID", "Period"))
observers$IsREG[observers$Role=="Observer"] <- "NOREG"
observers$IsREG[observers$MarketRole==1 & observers$`IsPun[1]`==1] <- "REG"
observers$IsREG[observers$MarketRole==2 & observers$`IsPun[2]`==1] <- "REG"
obsprof <- aggregate(cbind(Punished, Punished*(IsREG=="REG")) ~ SessionID + Market, data = subjectsummary, function(x) sum(x))
## checksum
observers$NumSelected2 <- (observers$Selected1+observers$Selected2+observers$Selected3+observers$Selected4+observers$Selected5+
                             observers$Selected6+observers$Selected7+observers$Selected8+observers$Selected9+observers$Selected10+
                             observers$Selected11+observers$Selected12+observers$Selected13+observers$Selected14)
inactiveObsPeriod <- aggregate(cbind(NumSelected, (NumSelected>0), NumPunished, (NumPunished>0), NumMissuspected) ~ SessionID + MarketRole, data = subset(observers), function(x) sum(x))
observers$market <- factor(observers$Market, levels = c(1,2), labels = c("Top", "Bottom"))
observers$Part <- "middle"
observers$Part[(observers$Period>=10)] <- "end"
observers$Part[(observers$Period<4)] <- "start"
observers$Part <- factor(observers$Part, levels = c("start", "middle", "end"))
observers$Phase <- factor(observers$Part, levels = c("start", "middle", "end"), labels = c("Phase 1", "Phase 2", "Phase 3"))

## Organize questionnaire ####################################################
QData <- subset(QData, Subject!=17)

QData$gender[QData$Female=="Weiblich" & is.na(QData$Female)==F] <-"female"
QData$gender[QData$Female==as.factor(QData$Female)[1] & is.na(QData$Female)==F] <-"male"
QData$gender[QData$Female=="Divers" & is.na(QData$Female)==F] <-"xdivers"

QData$Age <- as.numeric(levels(as.factor(QData$Age)))[as.factor(QData$Age)]
QData$RiskGeneral <- as.numeric(levels(as.factor(QData$RiskGeneral)))[as.factor(QData$RiskGeneral)]
QData$RiskFinancial <- as.numeric(levels(as.factor(QData$RiskFinancial)))[as.factor(QData$RiskFinancial)]
QData$LossAversion <- as.numeric(levels(as.factor(QData$LossAversion)))[as.factor(QData$LossAversion)]
QData$OpinionPenalty <- as.numeric(levels(as.factor(QData$OpinionPenalty)))[as.factor(QData$OpinionPenalty)]
QData$ProbabilityDetected<- as.numeric(levels(as.factor(QData$ProbabilityDetected)))[as.factor(QData$ProbabilityDetected)]

## distribute information from questionnaire
subjectsummary <- merge(subjectsummary, QData, by = c("Date", "subjectID", "SessionID", "Treatment", "ChgRegime", "regOrder", "Beginning", "End", "embTreatment", "endTreatment", "Location"))
subjects <- merge(subjects, QData, by = c("Date","Subject", "subjectID", "SessionID", "Treatment", "ChgRegime", "regOrder", "Beginning", "End", "embTreatment", "endTreatment", "Location"), all = T)
observers <- merge(observers, QData, by = c("Date", "subjectID", "SessionID", "Treatment", "ChgRegime", "regOrder", "Beginning", "End", "embTreatment", "endTreatment", "Location"))

## demean #####################################################################
marketsummary$lnVolume <- log(marketsummary$Volume)
sessionmean <- aggregate(cbind(Volume, lnVolume, LimitVolume, lnLimitVolume, RD, RAD, GD, GAD) ~ SessionID, data = marketsummary, function(x) mean(x))
colnames(sessionmean) <- c("SessionID", "meanVolume", "meanlnVolume", "meanLimitVolume", "meanlnLimitVolume", "meanRD", "meanRAD", "meanGD", "meanGAD")
marketsummary <- merge(marketsummary, sessionmean, by = c("SessionID"))
subjectsummary$lnLimitVolume <- log(subjectsummary$LimitVolume)
subjectmean <- aggregate(cbind(Volume, lnVolume, LimitVolume, lnLimitVolume) ~ subjectID, data = subjectsummary, function(x) mean(x))
colnames(subjectmean) <- c("subjectID", "meanVolume", "meanlnVolume", "meanLimitVolume", "meanlnLimitVolume")
subjectsummary <- merge(subjectsummary, subjectmean, by = c("subjectID"))

## Profits normation ##########################################################
subjectsummary$InitialEndowmentUnits <- subjectsummary$InitialEndowment / subjectsummary$BBV
subjectsummary$EndEndowmentUnits <- subjectsummary$EndVermoegen / subjectsummary$BBV
subjectsummary$EndEndowmentUnitsPun <- subjectsummary$EndEndowmentPun / subjectsummary$BBV
subjectsummary$relInitialEndowment  <- subjectsummary$InitialEndowment / 60 / subjectsummary$BBV
subjectsummary$relEndVermoegenPun  <- subjectsummary$EndVermoegen / 60 / subjectsummary$BBV
subjectsummary$relEndEndowmentPun  <- subjectsummary$EndEndowmentPun / 60 / subjectsummary$BBV

subjectsummary$TPUnits <- subjectsummary$TradingProfit / subjectsummary$BBV
subjectsummary$TPUnitsPun <- subjectsummary$TPPun / subjectsummary$BBV
subjectsummary$TPUnitsRedist <- subjectsummary$TPRedist / subjectsummary$BBV
subjectsummary$PDbefore <- subjectsummary$TradingProfit / subjectsummary$InitialEndowment
subjectsummary$PDPun <- subjectsummary$TPPun / subjectsummary$InitialEndowment
subjectsummary$PDRedist <- subjectsummary$TPRedist / subjectsummary$InitialEndowment
subjectsummary$PDbeforeVol <- 1000 * subjectsummary$TradingProfit / subjectsummary$InitialEndowment / subjectsummary$Volume
subjectsummary$PDbeforeVol[is.na(subjectsummary$PDbeforeVol)] <- 0
subjectsummary$PDPunVol <- 1000 * subjectsummary$TPPun / subjectsummary$InitialEndowment / subjectsummary$Volume
subjectsummary$PDPunVol[is.na(subjectsummary$PDPunVol)] <- 0
subjectsummary$PDRedistVol <- 1000 * subjectsummary$TPRedist / subjectsummary$InitialEndowment / subjectsummary$Volume
subjectsummary$PDRedistVol[is.na(subjectsummary$PDRedistVol)] <- 0

subjectsummary$logTPPun <- log(subjectsummary$TPUnitsPun + 2 * subjectsummary$InitialEndowmentUnits) - log(2 * subjectsummary$InitialEndowmentUnits)
k <- subjectsummary$EndEndowmentUnitsPun - subjectsummary$InitialEndowmentUnits - subjectsummary$TPUnitsPun
j <- subjectsummary$TPUnitsPun
h <- subjectsummary$InitialEndowmentUnits
c <- h + sqrt(h^2-k*j)
c2 <- h - sqrt(h^2-k*j)
d <- sqrt(2*c*h)
d1 <- sqrt(2*c2*h)
subjectsummary$logdecTP <- log((c+j)/d)

subjectsummary$capBeginning <- 2*subjectsummary$InitialEndowmentUnits
subjectsummary$capEnd <- (subjectsummary$EndEndowmentUnitsPun+subjectsummary$InitialEndowmentUnits)
subjectsummary$logcap <- log(subjectsummary$capEnd)-log(subjectsummary$capBeginning)

## Distributional indices #####################################################
## Gini coefficient
subjectsummary <- subjectsummary %>%
  dplyr::group_by(SessionID, Period, market) %>%
  dplyr::mutate(rankPDbefore = rank(PDbefore, ties.method = "first")) %>%
  dplyr::mutate(rankPDPun = rank(PDPun, ties.method = "first")) %>%
  dplyr::mutate(rankProfit = rank(ProfitPeriod, ties.method = "first")) %>%
  # ProfitPeriod provides the accumulated profit over both markets
  dplyr::mutate(relPDbefore = ((1+PDbefore)/sum(1+PDbefore))) %>%
  dplyr::mutate(cumPDbefore = order_by(rankPDbefore, cumsum(relPDbefore))) %>%
  dplyr::mutate(sumPDbefore = sum(1+PDbefore)) %>%
  dplyr::mutate(relPDPun = ((1+PDPun)/sum(1+PDPun))) %>%
  dplyr::mutate(cumPDPun = order_by(rankPDPun, cumsum(relPDPun))) %>%
  dplyr::mutate(sumPDPun = sum(1+PDPun)) %>%
  dplyr::mutate(relProfit = (ProfitPeriod/sum(ProfitPeriod))) %>%
  dplyr::mutate(cumProfit = order_by(rankProfit, cumsum(relProfit))) %>%
  dplyr::mutate(rankinitialAssets = rank(InitialAssets, ties.method = "first")) %>%
  dplyr::mutate(cumAssets = order_by(rankinitialAssets, cumsum(InitialAssets/30/14))) %>%
  dplyr::mutate(rankinitialEndowment = rank(InitialEndowment, ties.method = "first")) %>%
  dplyr::mutate(cumEndowment = order_by(rankinitialEndowment, cumsum(InitialEndowment/BBV/60/14)))

subjectsummary <- subjectsummary %>%
  dplyr::group_by(SessionID, Period, market, Role) %>%
  dplyr::mutate(rankPDbeforeRole = rank(PDbefore, ties.method = "first"))

avgtraderprofit2 <- aggregate(cbind(Volume, LimitVolume, TradingProfit, TPUnits, TPUnitsPun, ProfitPeriod, (Volume > 0 | LimitVolume > 0), PDbefore, PDPun, PDRedist, PDbeforeVol, PDPunVol, PDRedistVol, PDbefore*as.numeric(PDbefore>0), PDPun*as.numeric(PDPun>0), PDRedist*as.numeric(PDRedist>0), PDbefore*as.numeric(PDbefore<0), PDPun*as.numeric(PDPun<0), PDRedist*as.numeric(PDRedist<0), shortsells, marginbuys, marginbuysAsset) ~ Role + subjectID + SessionID, data=subjectsummary, function(x) mean(x))
avgtraderprofit <- reshape2::dcast(subset(avgtraderprofit2), subjectID + SessionID ~ paste0("PDbefore") + Role, value.var = "PDbefore", drop = T)
colnames(avgtraderprofit) <- c("subjectID", "SessionID", "AvgPDbeforeInf", "AvgPDbeforeUni")
avgtraderprofit <- avgtraderprofit %>%
  dplyr::group_by(SessionID) %>%
  dplyr::mutate(rankavgPDbeforeUni = rank(AvgPDbeforeUni, ties.method = "first")) %>%
  dplyr::mutate(rankavgPDbeforeInf = rank(AvgPDbeforeInf, ties.method = "first"))

subjectsummary <- merge(subjectsummary, avgtraderprofit, by = c("subjectID", "SessionID"))
subjectsummary$rankavgPDbeforeRole <- subjectsummary$rankavgPDbeforeInf
subjectsummary$rankavgPDbeforeRole[subjectsummary$Role == "Uninformed trader"] <- subjectsummary$rankavgPDbeforeUni[subjectsummary$Role == "Uninformed trader"]
subjectsummary$AvgPDbeforeRole <- subjectsummary$AvgPDbeforeInf
subjectsummary$AvgPDbeforeRole[subjectsummary$Role == "Uninformed trader"] <- subjectsummary$AvgPDbeforeUni[subjectsummary$Role == "Uninformed trader"]

## one row per market
## HHI
HHalpha <- 2
marketsummary <- merge(marketsummary, aggregate(cbind(cumPDbefore, cumPDPun, cumProfit, cumAssets, cumEndowment, (InitialAssets/(14*30))^HHalpha, (Assets/(14*30))^HHalpha, (InitialEndowment/BBV/(14*60))^HHalpha, (EndVermoegen/BBV/(14*60))^HHalpha, (EndEndowmentPun/BBV/(14*60))^HHalpha, (Volume)^HHalpha, ((1+PDbefore)/sumPDbefore)^HHalpha, ((1+PDPun)/sumPDPun)^HHalpha) ~ SessionID + Period + market, data=subset(subjectsummary), FUN = sum, na.action = NULL, na.rm=T), by = c("SessionID", "Period", "market"))
colnames(marketsummary)[colnames(marketsummary) %in% c(paste0("V", 6:13))] <- c("HHInitialAssets", "HHEndAssets", "HHInitialEndowment", "HHEndEndowment", "HHEndEndowmentPun", "HHVolume", "HHPDbefore", "HHPDPun")
marketsummary <- merge(marketsummary, aggregate(cbind(InitialAssets^HHalpha, Assets^HHalpha, (InitialEndowment/BBV)^HHalpha, (EndVermoegen/BBV)^HHalpha, (EndEndowmentPun/BBV)^HHalpha, Volume^HHalpha, (1+PDbefore)^HHalpha, (1+PDPun)^HHalpha,  1 + PDbefore, 1 + PDPun, InitialAssets, Assets, InitialEndowment/BBV, EndVermoegen/BBV, EndEndowmentPun/BBV) ~ SessionID + Period + market, data=subset(subjectsummary, Volume > 0 | LimitVolume > 0), FUN = sum, na.action = NULL, na.rm=T), by = c("SessionID", "Period", "market"))
colnames(marketsummary)[colnames(marketsummary) %in% c(paste0("V",1:10), "InitialAssets", "Assets", "V13", "V14", "V15")] <- c("HHI_InitialAssets", "HHI_EndAssets", "HHI_InitialEndowment", "HHI_EndEndowment", "HHI_EndEndowmentPun", "HHI_Volume", "HHI_PDbefore", "HHI_PDPun", "sumPDbeforeActive", "sumPDPunActive", "InitialAssetsActive", "EndAssetsActive", "InitialEndowmentActive", "EndEndowmentActive", "EndEndowmentPunActive")
marketsummary$HHI_InitialAssets <-  (marketsummary$HHI_InitialAssets / (marketsummary$InitialAssetsActive)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader - 1)
marketsummary$HHI_EndAssets <- (marketsummary$HHI_EndAssets / (marketsummary$EndAssetsActive)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader - 1)
marketsummary$HHI_InitialEndowment <- (marketsummary$HHI_InitialEndowment / (marketsummary$InitialEndowmentActive)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader - 1)
marketsummary$HHI_EndEndowment <- (marketsummary$HHI_EndEndowment / (marketsummary$EndEndowmentActive)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader - 1)
marketsummary$HHI_EndEndowmentPun <- (marketsummary$HHI_EndEndowmentPun / (marketsummary$EndEndowmentPunActive)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader - 1)
marketsummary$HHI_Volume <- (marketsummary$HHI_Volume / (marketsummary$Volume*2)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader/2 - 1)
marketsummary$HHVolume <- (marketsummary$HHVolume / (marketsummary$Volume*2)^HHalpha) 
marketsummary$HHI_PDbefore <- (marketsummary$HHI_PDbefore / (marketsummary$sumPDbefore)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader - 1)
marketsummary$HHI_PDPun <- (marketsummary$HHI_PDPun / (marketsummary$sumPDPun)^HHalpha * marketsummary$NumActiveTrader - 1) / (marketsummary$NumActiveTrader - 1)
## Gini
marketsummary$GiniPDbefore <- (1-marketsummary$cumPDbefore/7.5) # 2 / (14 + 1) = 1 / 7.5
marketsummary$GiniPDPun <- (1-marketsummary$cumPDPun/7.5)
marketsummary$GiniProfit <- (1-marketsummary$cumProfit/7.5)
marketsummary$GiniAssets <- (1-marketsummary$cumAssets/7.5) 
marketsummary$GiniEndowment <- (1-marketsummary$cumEndowment/7.5) 

marketsummary$lnVolume <- log(marketsummary$Volume)

## Rolesummary ################################################################
Rolesummary0 <- reshape2::melt(subset(marketsummary, select = c(VolumeInf, VolumeUni, SessionID, Period, market, TotVolumeInf, TotVolumeUni, TotVolume)), id.vars = c("SessionID", "Period", "market", "TotVolumeUni", "TotVolumeInf", "TotVolume"))
colnames(Rolesummary0)[colnames(Rolesummary0) == "variable"]<- "Role"
colnames(Rolesummary0)[colnames(Rolesummary0) == "value"]<- "Volume" 
Rolesummary0$Role <- factor(Rolesummary0$Role, labels = c("Informed trader", "Uninformed trader"))
Rolesummary0$TotVolumeRole <- Rolesummary0$TotVolumeInf
Rolesummary0$TotVolumeRole[Rolesummary0$Role == "Uninformed trader"] <- Rolesummary0$TotVolumeUni[Rolesummary0$Role == "Uninformed trader"]
Rolesummary <- aggregate(cbind(1, (Volume > 0 | LimitVolume > 0), InitialAssets, Assets, Volume, LimitVolume, CancelledVolume, VolumeMarketOrder, VolumeLimitOrder, logdecTP, InitialEndowmentUnits,EndEndowmentUnits,EndEndowmentUnitsPun, ProfitPeriod, TradingProfit, TPPun, TPRedist, TPUnits, TPUnitsPun, TPUnitsRedist, logcap, PD, Cash, InitialCash, InitialEndowment, EndVermoegen, TotVolumeTrader,
                               TotLimitVolumeTrader, shortsells, TotalShort, marginbuys, marginbuysAsset, marginbuysTaler) ~ SessionID + Treatment + Period +
                           history + ChgRegime + regOrder + Beginning + End + embTreatment + endTreatment + Location + Market + Programme + myMarketTreatment + IsREG + BBV + Location + Role + 
                           market + IsREG + othermarket + REGBoth + REGonly + REGSH + BBV + BBVCent + Price + TotLimitVolume + market + middle + Part, data = subset(subjectsummary, Programme==3), function(x) sum(x))
colnames(Rolesummary)[colnames(Rolesummary) %in% c("V1", "V2")]<- c("TraderCount", "NumActiveTrader")
Rolesummary$PR <- Rolesummary$NumActiveTrader/Rolesummary$TraderCount
colnames(Rolesummary)[colnames(Rolesummary) == "Volume"] <- "TraderVolume"
Rolesummary$TraderVolume <- Rolesummary$TraderVolume/Rolesummary$TraderCount
Rolesummary$TraderLimitVolume <- Rolesummary$LimitVolume/Rolesummary$TraderCount
Rolesummary <- merge(Rolesummary,  subset(marketsummary, Programme==3, select = c("SessionID", "Period", "market", "Price120")), by = c("SessionID", "Period", "market"), all = T)
Rolesummary1 <- aggregate(cbind(log(odds), log(oddsLimit)) ~ SessionID + Treatment + Period + market + IsREG + Role, data = subset(subjectsummary, Programme==3), function(x) mean(x[x < Inf & x > -Inf], na.rm = TRUE))
colnames(Rolesummary1)[colnames(Rolesummary1) == "V1"]<- "geomodds"
colnames(Rolesummary1)[colnames(Rolesummary1) == "V2"]<- "geomoddsLimit"
Rolesummary <- merge(Rolesummary, Rolesummary1, by = c("SessionID", "Treatment","Period", "market", "IsREG", "Role"))
Rolesummary <- merge(Rolesummary, subset(Rolesummary0, select = -c(TotVolumeInf, TotVolumeUni)), by = c("SessionID", "Period", "market", "Role"))

## not used logPD because of NaN
Rolesummary$lnVolume <- log(Rolesummary$Volume)
Rolesummary$lnLimitVol <- log(Rolesummary$LimitVolume)
Rolesummary2 <- aggregate(cbind(InitialAssets, Assets, LimitVolume, Volume, CancelledVolume, VolumeMarketOrder, VolumeLimitOrder, TradingProfit, Cash, InitialCash, InitialEndowment, EndVermoegen) ~ SessionID + Treatment+ Period +
                            history + ChgRegime + regOrder + Beginning + End + embTreatment + endTreatment + Location + Market  + Programme + myMarketTreatment  + IsREG + BBV + Location + Role + 
                            market + IsREG + othermarket + REGBoth + REGonly + REGSH + BBV + BBVCent + Price + Price120 + NumActiveTrader + NumTransactingTraders + TotVolume + TotLimitVolume + market + middle + Part, data = subset(subjectsummary, Programme==3), function(x) sum(x))
#colnames(Rolesummary2)[colnames(Rolesummary2) == "V13"]<- "Department"
#colnames(Rolesummary2)[colnames(Rolesummary2) == "V14"]<- "gender"
Rolesummary$marketshare <- Rolesummary$Volume / Rolesummary$TotVolumeRole
Rolesummary$marketshareLimit <- Rolesummary$LimitVolume / Rolesummary$TotLimitVolumeTrader
##### TotVolumeTrader counts transactions between same-role participants twice - thus TotVolumeRole is used from marketsummary
Rolesummary$odds <- Rolesummary$Volume/(Rolesummary$TotVolumeRole-Rolesummary$Volume)
Rolesummary$oddsLimit <- Rolesummary$LimitVolume/(Rolesummary$TotLimitVolumeTrader-Rolesummary$LimitVolume)
Rolesummary$odds1 <- Rolesummary$odds
Rolesummary$odds1[Rolesummary$odds == Inf] <- Rolesummary$Volume[Rolesummary$odds == Inf] / 1
Rolesummary$odds1[Rolesummary$odds == -Inf] <- 1 / Rolesummary$Volume[Rolesummary$odds == -Inf]
Rolesummary$oddsLimit1 <- Rolesummary$oddsLimit
Rolesummary$oddsLimit1[Rolesummary$oddsLimit == Inf] <- Rolesummary$Volume[Rolesummary$oddsLimit == Inf] / 1
Rolesummary$oddsLimit1[Rolesummary$oddsLimit == -Inf] <- 1 / Rolesummary$Volume[Rolesummary$oddsLimit == -Inf]
Rolesummary <- Rolesummary %>%
  dplyr::group_by(Role) %>%
  dplyr::mutate(winsRodds = quantile(odds, .995, na.rm = T)) %>%
  dplyr::mutate(winsRodds1 = quantile(odds, .005, na.rm = T))
Rolesummary$oddswins <- Rolesummary$odds
Rolesummary$oddswins[Rolesummary$oddswins>Rolesummary$winsRodds] <- Rolesummary$winsRodds[Rolesummary$oddswins>Rolesummary$winsRodds]
Rolesummary$oddswins[Rolesummary$oddswins<Rolesummary$winsRodds1] <- Rolesummary$winsRodds1[Rolesummary$oddswins<Rolesummary$winsRodds1]
  
msT <- aggregate(cbind(log(odds), log(oddswins), log(oddsLimit), abs(log(odds)),abs(log(oddsLimit)), log(marketshare), log(marketshareLimit), (marketshare), (marketshareLimit), abs(log(marketshare+.5)), abs(log(marketshareLimit+.5))) ~ Part + SessionID + Role + market, data = subset(Rolesummary), function(x) mean(x))
colnames(msT) <- c("Part", "SessionID", "Role", "market","geomodds", "geomoddswins", "geomoddsLimit","absgeomodds", "absgeomoddsLimit", "lnmarketshare", "lnmarketshareLimit", "marketshare", "marketshareLimit","abslnmarketshare", "abslnmarketshareLimit" )
a1T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("lnmarketshare") + Part, value.var = "lnmarketshare", drop = FALSE)
a2T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("lnmarketshareLimit") + Part, value.var = "lnmarketshareLimit", drop = FALSE)
a3T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("abslnmarketshare") + Part, value.var = "abslnmarketshare", drop = FALSE)
a4T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("abslnmarketshareLimit") + Part, value.var = "abslnmarketshareLimit", drop = FALSE)
a5T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("geomodds") + Part, value.var = "geomodds", drop = FALSE)
a6T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("geomoddsLimit") + Part, value.var = "geomoddsLimit", drop = FALSE)
a7T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("absgeomodds") + Part, value.var = "absgeomodds", drop = FALSE)
a8T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("absgeomoddsLimit") + Part, value.var = "absgeomoddsLimit", drop = FALSE)
a9T <- reshape2::dcast(subset(msT), SessionID + Role + market ~ paste0("geomoddswins") + Part, value.var = "geomoddswins", drop = FALSE)
Rolesummary <- merge(Rolesummary, a1T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a2T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a3T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a4T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a5T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a6T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a7T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a8T, by = c("SessionID", "Role", "market"))
Rolesummary <- merge(Rolesummary, a9T, by = c("SessionID", "Role", "market"))
lagR <- subset(Rolesummary, select = c(SessionID, market, Period, Role, Volume, LimitVolume, marketshare, marketshareLimit, odds, oddsLimit))
colnames(lagR) <- c("SessionID", "market", "Period", "Role", "lagVolume", "lagLimitVolume", "lagmarketshare", "lagmarketshareLimit", "lagodds", "lagoddsLimit")
lagR$Period <- lagR$Period + 1
Rolesummary <- merge(Rolesummary, subset(lagR, Period<=12), by = c("SessionID", "market", "Period", "Role"), all.x = T)
lagR1 <- subset(lagR, Period==4)
colnames(lagR1) <- c("SessionID", "market", "Period", "Role", "P3Volume", "P3LimitVolume", "P3marketshare", "P3marketshareLimit", "P3odds", "P3oddsLimit")
Rolesummary <- merge(Rolesummary, subset(lagR1, select =-c(Period)), by = c("SessionID", "market", "Role"), all.x = T)

## phasesummary ###############################################################
phasesummary0 <- aggregate(cbind(VolumeUni, VolumeInf, TotVolumeInf, TotVolumeUni) ~ SessionID + market + Part, data = subset(marketsummary, Programme==3), function(x) sum(x[x < Inf & x > -Inf], na.rm = TRUE))
phasesummary0a <- reshape2::melt(subset(phasesummary0), id.vars = c("SessionID", "market", "Part", "TotVolumeInf", "TotVolumeUni")) 
colnames(phasesummary0a)[colnames(phasesummary0a) == "variable"]<- "Role"
colnames(phasesummary0a)[colnames(phasesummary0a) == "value"]<- "Volume"
phasesummary0a$Role <- factor(phasesummary0a$Role, labels = c("Uninformed trader", "Informed trader"))
phasesummary0a$TotVolumeRole <- phasesummary0a$TotVolumeInf
phasesummary0a$TotVolumeRole[phasesummary0a$Role == "Uninformed trader"] <- phasesummary0a$TotVolumeUni[phasesummary0a$Role == "Uninformed trader"]
phasesummary <- aggregate(cbind(LimitVolume, PR, CancelledVolume, TotLimitVolumeTrader, TraderCount, 1, TraderVolume, TraderLimitVolume, shortsells, TotalShort, marginbuys, marginbuysAsset, marginbuysTaler) ~ SessionID + Treatment +
                            history + ChgRegime + regOrder + Beginning + End + embTreatment + endTreatment + Location + Market + Programme + myMarketTreatment + IsREG + Location + Role + 
                            market + othermarket + REGBoth + REGonly + REGSH + middle + Part, data = subset(Rolesummary, Programme==3), function(x) sum(x))
colnames(phasesummary)[colnames(phasesummary) == "V6"]<- "obs"
phasesummary$PR <- phasesummary$PR / phasesummary$obs
phasesummary$TraderVolume <- phasesummary$TraderVolume / phasesummary$obs
phasesummary$TraderLimitVolume <- phasesummary$TraderLimitVolume / phasesummary$obs
phasesummary$NumActiveTrader <- phasesummary$PR * phasesummary$TraderCount
phasesummary1 <- aggregate(cbind(log(odds1), log(oddsLimit1), abs(log(odds1)),abs(log(oddsLimit1)), log(Volume), log(LimitVolume), log(TotVolumeRole)) ~ SessionID + market + Role + Part, data = subset(Rolesummary, Programme==3), function(x) mean(x[x < Inf & x > -Inf], na.rm = TRUE))
colnames(phasesummary1)[colnames(phasesummary1) %in% c(paste0("V", 1:7))] <- c("geomodds","geomoddsLimit","absgeomodds","absgeomoddsLimit", "lnVolume", "lnLimitVolume", "lnTotalVolRole")
phasesummary <- merge(phasesummary, subset(phasesummary1), by = c("SessionID","Part", "market", "Role"))
phasesummary <- merge(phasesummary, subset(phasesummary0a, select = -c(TotVolumeInf,TotVolumeUni)), by = c("SessionID","Part", "market", "Role"))
colnames(phasesummary)[colnames(phasesummary) == "TotVolumeRole"]<- "TotVolume"
colnames(phasesummary)[colnames(phasesummary) == "TotLimitVolumeTrader"]<- "TotLimitVolume"
phasesummarymarket <- aggregate(cbind(Volume, LimitVolume, NumActiveTrader, CancelledVolume, TotVolume, TotLimitVolume, 1, shortsells, TotalShort, marginbuys, marginbuysAsset, marginbuysTaler) ~ SessionID + Treatment +
                                  history + ChgRegime + regOrder + Beginning + End + embTreatment + endTreatment + Location + Market + Programme + myMarketTreatment + IsREG + Location + 
                                  market + othermarket + REGBoth + REGonly + REGSH + middle + Part, data = subset(marketsummary), function(x) sum(x))
colnames(phasesummarymarket)[colnames(phasesummarymarket) == "V7"]<- "obs"
phasesummarymarket$TraderCount <- 14 * phasesummarymarket$obs
phasesummarymarket$PR <- phasesummarymarket$NumActiveTrader / phasesummarymarket$TraderCount
phasesummarymarket$TraderVolume <- phasesummarymarket$Volume / phasesummarymarket$TraderCount
phasesummarymarket$TraderLimitVolume <- phasesummarymarket$LimitVolume / phasesummarymarket$TraderCount
phasesummarymarket1 <- aggregate(cbind(log(odds), log(oddsLimit), abs(log(odds)),abs(log(oddsLimit)), log(Volume), log(LimitVolume), log(TotVolume)) ~ SessionID + market + Part, data = subset(marketsummary), function(x) mean(x[x < Inf & x > -Inf], na.rm = TRUE))
colnames(phasesummarymarket1)[colnames(phasesummarymarket1) %in% c(paste0("V", 1:7))] <- c("geomodds","geomoddsLimit","absgeomodds","absgeomoddsLimit", "lnVolume", "lnLimitVolume", "lnTotalVolRole")
phasesummarymarket <- merge(phasesummarymarket, subset(phasesummarymarket1), by = c("SessionID","Part", "market"))
phasesummarymarket$Role <- "market"
phasesummary <- rbind(phasesummary, phasesummarymarket)

phasesummary$marketshare <- phasesummary$Volume / phasesummary$TotVolume
phasesummary$marketshareLimit <- phasesummary$LimitVolume / phasesummary$TotLimitVolume
phasesummary$odds <- phasesummary$Volume / (phasesummary$TotVolume - phasesummary$Volume)
phasesummary$oddsLimit <- phasesummary$LimitVolume / (phasesummary$TotLimitVolume - phasesummary$LimitVolume)
ph1 <- reshape2::dcast(subset(phasesummary), SessionID + Role + market ~ paste0("odds") + Part, value.var = "odds", drop = FALSE)
ph2 <- reshape2::dcast(subset(phasesummary), SessionID + Role + market ~ paste0("geomodds") + Part, value.var = "geomodds", drop = FALSE)
ph3 <- reshape2::dcast(subset(phasesummary), SessionID + Role + market ~ paste0("oddsLimit") + Part, value.var = "oddsLimit", drop = FALSE)
ph4 <- reshape2::dcast(subset(phasesummary), SessionID + Role + market ~ paste0("geomoddsLimit") + Part, value.var = "geomoddsLimit", drop = FALSE)
phasesummary <- merge(phasesummary, ph1, by = c("SessionID", "Role", "market"))
phasesummary <- merge(phasesummary, ph2, by = c("SessionID", "Role", "market"))
phasesummary <- merge(phasesummary, ph3, by = c("SessionID", "Role", "market"))
phasesummary <- merge(phasesummary, ph4, by = c("SessionID", "Role", "market"))
#phasesummary$TraderVolume <- phasesummary$Volume / phasesummary$TraderCount
#phasesummary$TraderLimitVolume <- phasesummary$LimitVolume / phasesummary$TraderCount
phasesummary$TraderlnVolume <- phasesummary$lnVolume - log(phasesummary$TraderCount / phasesummary$obs)
phasesummary$TraderlnLimitVolume <- phasesummary$lnLimitVolume - log(phasesummary$TraderCount / phasesummary$obs)
phasesummary$Phase <- factor(phasesummary$Part, levels = c("start", "middle", "end"), labels = c("Phase 1", "Phase 2", "Phase 3"))
phasesummary$d1 <- log(phasesummary$odds) - log(phasesummary$odds_start)
phasesummary$d2 <- log(phasesummary$odds) - log(phasesummary$odds_middle)
phasesummary$d3 <- log(phasesummary$odds) - log(phasesummary$odds_end)
phasesummary$d1r <- log(phasesummary$odds) / 6 - log(phasesummary$odds_start) / 3
phasesummary$d2r <- log(phasesummary$odds) / 6 - log(phasesummary$odds_middle) / 6
phasesummary$d3r <- log(phasesummary$odds) / 6 - log(phasesummary$odds_end) / 3
phasesummary$d1P <- (phasesummary$geomodds) - (phasesummary$geomodds_start)
phasesummary$d2P <- (phasesummary$geomodds) - (phasesummary$geomodds_middle)
phasesummary$d3P <- (phasesummary$geomodds) - (phasesummary$geomodds_end)

## phaseREG: by Phase and regulation ##########################################
phaseREGsummary0 <- aggregate(cbind(VolumeUni, VolumeInf, TotVolumeInf, TotVolumeUni) ~ SessionID + IsREG + Part, data = subset(marketsummary, Programme==3), function(x) sum(x[x < Inf & x > -Inf], na.rm = TRUE))
phaseREGsummary0a <- reshape2::melt(subset(phaseREGsummary0), id.vars = c("SessionID", "IsREG", "Part", "TotVolumeInf", "TotVolumeUni")) 
colnames(phaseREGsummary0a)[colnames(phaseREGsummary0a) == "variable"]<- "Role"
colnames(phaseREGsummary0a)[colnames(phaseREGsummary0a) == "value"]<- "Volume"
phaseREGsummary0a$Role <- factor(phaseREGsummary0a$Role, labels = c("Uninformed trader", "Informed trader"))
phaseREGsummary0a$TotVolumeRole <- phaseREGsummary0a$TotVolumeInf
phaseREGsummary0a$TotVolumeRole[phaseREGsummary0a$Role == "Uninformed trader"] <- phaseREGsummary0a$TotVolumeUni[phaseREGsummary0a$Role == "Uninformed trader"]
phaseREGsummary <- aggregate(cbind(LimitVolume, PR, CancelledVolume, TotLimitVolumeTrader, TraderCount, 1, TraderVolume, TraderLimitVolume) ~ SessionID + Treatment +
                            ChgRegime + regOrder + Beginning + End + embTreatment + endTreatment + Location + Programme + IsREG + Location + Role + 
                            middle + Part, data = subset(Rolesummary, Programme==3), function(x) sum(x))
colnames(phaseREGsummary)[colnames(phaseREGsummary) == "V6"]<- "obs"
phaseREGsummary$PR <- phaseREGsummary$PR / phaseREGsummary$obs
phaseREGsummary$TraderVolume <- phaseREGsummary$TraderVolume / phaseREGsummary$obs
phaseREGsummary$TraderLimitVolume <- phaseREGsummary$TraderLimitVolume / phaseREGsummary$obs
phaseREGsummary$NumActiveTrader <- phaseREGsummary$PR * phaseREGsummary$TraderCount
phaseREGsummary1 <- aggregate(cbind(log(odds1), log(oddsLimit1), abs(log(odds1)),abs(log(oddsLimit1)), log(Volume), log(LimitVolume), log(TotVolumeRole)) ~ SessionID + IsREG + Role + Part, data = subset(Rolesummary, Programme==3), function(x) mean(x[x < Inf & x > -Inf], na.rm = TRUE))
colnames(phaseREGsummary1)[colnames(phaseREGsummary1) %in% c(paste0("V", 1:7))] <- c("geomodds","geomoddsLimit","absgeomodds","absgeomoddsLimit", "lnVolume", "lnLimitVolume", "lnTotalVolRole")
phaseREGsummary <- merge(phaseREGsummary, subset(phaseREGsummary1), by = c("SessionID","Part", "IsREG", "Role"))
phaseREGsummary <- merge(phaseREGsummary, subset(phaseREGsummary0a, select = -c(TotVolumeInf,TotVolumeUni)), by = c("SessionID","Part", "IsREG", "Role"))
colnames(phaseREGsummary)[colnames(phaseREGsummary) == "TotVolumeRole"]<- "TotVolume"
colnames(phaseREGsummary)[colnames(phaseREGsummary) == "TotLimitVolumeTrader"]<- "TotLimitVolume"
phaseREGsummarymarket <- aggregate(cbind(Volume, LimitVolume, NumActiveTrader, CancelledVolume, TotVolume, TotLimitVolume, 1) ~ SessionID + Treatment +
                                  ChgRegime + regOrder + Beginning + End + embTreatment + endTreatment + Location + Programme + IsREG + Location + 
                                  middle + Part, data = subset(marketsummary), function(x) sum(x))
colnames(phaseREGsummarymarket)[colnames(phaseREGsummarymarket) == "V7"]<- "obs"
phaseREGsummarymarket$TraderCount <- 14 * phaseREGsummarymarket$obs
phaseREGsummarymarket$PR <- phaseREGsummarymarket$NumActiveTrader / phaseREGsummarymarket$TraderCount
phaseREGsummarymarket$TraderVolume <- phaseREGsummarymarket$Volume / phaseREGsummarymarket$TraderCount
phaseREGsummarymarket$TraderLimitVolume <- phaseREGsummarymarket$LimitVolume / phaseREGsummarymarket$TraderCount
phaseREGsummarymarket1 <- aggregate(cbind(log(odds), log(oddsLimit), abs(log(odds)),abs(log(oddsLimit)), log(Volume), log(LimitVolume), log(TotVolume)) ~ SessionID + IsREG + Part, data = subset(marketsummary), function(x) mean(x[x < Inf & x > -Inf], na.rm = TRUE))
colnames(phaseREGsummarymarket1)[colnames(phaseREGsummarymarket1) %in% c(paste0("V", 1:7))] <- c("geomodds","geomoddsLimit","absgeomodds","absgeomoddsLimit", "lnVolume", "lnLimitVolume", "lnTotalVolRole")
phaseREGsummarymarket <- merge(phaseREGsummarymarket, subset(phaseREGsummarymarket1), by = c("SessionID","Part", "IsREG"))
phaseREGsummarymarket$Role <- "market"
phaseREGsummary <- rbind(phaseREGsummary, phaseREGsummarymarket)

phaseREGsummary$marketshare <- phaseREGsummary$Volume/phaseREGsummary$TotVolume
phaseREGsummary$marketshareLimit <- phaseREGsummary$LimitVolume/phaseREGsummary$TotLimitVolume
phaseREGsummary$odds <- phaseREGsummary$Volume/(phaseREGsummary$TotVolume-phaseREGsummary$Volume)
phaseREGsummary$oddsLimit <- phaseREGsummary$LimitVolume/(phaseREGsummary$TotLimitVolume-phaseREGsummary$LimitVolume)
#phaseREGsummary$TraderVolume <- phaseREGsummary$Volume / phaseREGsummary$TraderCount
#phaseREGsummary$TraderLimitVolume <- phaseREGsummary$LimitVolume / phaseREGsummary$TraderCount
phaseREGsummary$TraderlnVolume <- phaseREGsummary$lnVolume - log(phaseREGsummary$TraderCount / phaseREGsummary$obs)
phaseREGsummary$TraderlnLimitVolume <- phaseREGsummary$lnLimitVolume - log(phaseREGsummary$TraderCount / phaseREGsummary$obs)


Rolesummary$Period0 <- as.numeric(Rolesummary$Period) - 1
Rolesummary$Period0[Rolesummary$Part == "middle"] <- Rolesummary$Period0[Rolesummary$Part == "middle"] - 3
Rolesummary$Period0[Rolesummary$Part == "end"] <- Rolesummary$Period0[Rolesummary$Part == "end"] - 9
subjectsummary$Period0 <- as.numeric(subjectsummary$Period) - 1
subjectsummary$Period0[subjectsummary$Part == "end"] <- subjectsummary$Period0[subjectsummary$Part == "end"] - 9
marketsummary$Period0 <- as.numeric(marketsummary$Period) - 1
marketsummary$Period0[marketsummary$Part == "middle"] <- marketsummary$Period0[marketsummary$Part == "middle"] - 3
marketsummary$Period0[marketsummary$Part == "end"] <- marketsummary$Period0[marketsummary$Part == "end"] - 9
seconds$Period0 <- as.numeric(seconds$Period) - 1
seconds$Period0[seconds$Part == "middle"] <- seconds$Period0[seconds$Part == "middle"] - 3
seconds$Period0[seconds$Part == "end"] <- seconds$Period0[seconds$Part == "end"] - 9

seconds$market <- factor(seconds$market, levels = c("Top", "Bottom"))
transactions$market <- factor(transactions$Market, levels = c(1,2), labels = c("Top", "Bottom"))
transactions$BBVIsReservationSeller <- "Yes"
transactions$BBVIsReservationSeller[transactions$Price < transactions$BBV] <- "No"
transactions$UMIsReservationSeller <- "Yes"
transactions$UMIsReservationSeller[transactions$Price < 57.5] <- "No"

save.image("RawData.RData")

marketsummary <- subset(marketsummary, select = c("SessionID", "Date", "Period", "Period0", "Phase", "market", "Programme", "Treatment", "regOrder", "embTreatment", "history", "Location", 
                                                  "BBV", "BBVCent", "IsREG", "othermarket", "REGBoth", "REGSH",
                                                  "BestBid180", "BestAsk180", "BAspread180", "midpointBA180", "BestBid150", "BestAsk150", "BAspread150", "midpointBA150", "midpointBAavg150",
                                                  "BA_BBV", "BA_BBV150", "BA_BBV180", "lnBA_BBV",  "lnBA_BBV150", "lnBA_BBV180",  
                                                  "meanBestBid", "meanBestAsk", "meanBAspread", "meanmidpointBA", "meanBAspreadwins", "meanBAspreadwins2", 
                                                  "meanreturnsec", "meanreturn", "meanreturnwins", "meanreturnwins2", "obsreturn", "sdreturnsec", "volatility", "volatilitywins", "volatilitywins2", "meanPrice", "sdPrice",   
                                                  "Volume", "lagVolume", "VolumeUni", "VolumeInf", "Volume_Informed_Informed", "Volume_Uninformed_Informed", "Volume_Informed_Uninformed", "Volume_Uninformed_Uninformed",
                                                  "LimitVolume", "lagLimitVolume", "LimitVolumeInf", "LimitVolumeUni", "NumTransactions",
                                                  "Countoffers", "CountSelloffers", "CountBuyoffers", "CancelledVolume", "remainingVol", "SellLimitVolume","BuyLimitVolume",
                                                  "ProfitPotential", "GD", "GAD", "GADhyp", "rGAD", "RD", "RAD", "GD120", "GAD120", "RD120", "RAD120",  "Price", "Price120",
                                                  "marketshare", "lagmarketshare", "marketshareLimit", "lagmarketshareLimit", "AssetTurnover",  "TransactionSize", "LimitOrderTurnover",  "LimitOrderSize", "relCancelledVolume",
                                                  "odds", "lagodds", "oddsLimit", "lagoddsLimit", "oddsUninf", "oddsInf", "oddsInfmax", "oddsInfmax2", "oddsInfmax3","oddswins", "oddsLimitwins", "oddsInfwins", "oddsUninfwins", "oddsLimitUninf", "oddsLimitInf", 
                                                  "geomodds_start", "geomodds_middle", "geomodds_end", "absgeomodds_start", "absgeomodds_middle", "absgeomodds_end", "geomoddsInf_start", "geomoddsInf_middle", "geomoddsInf_end", "geomoddsUni_start", "geomoddsUni_middle", "geomoddsUni_end",
                                                  "geomoddswins_start", "geomoddswins_middle", "geomoddswins_end",  "geomoddsInfwins_start", "geomoddsInfwins_middle", "geomoddsInfwins_end", "geomoddsUniwins_start", "geomoddsUniwins_middle", "geomoddsUniwins_end",
                                                  "geomoddsLimitInf_start", "geomoddsLimitInf_middle", "geomoddsLimitInf_end", "geomoddsLimitUni_start", "geomoddsLimitUni_middle", "geomoddsLimitUni_end",
                                                  "geomoddsLimit_start", "geomoddsLimit_middle", "geomoddsLimit_end", "absgeomoddsLimit_start", "absgeomoddsLimit_middle", "absgeomoddsLimit_end", 
                                                  "unprofittime",  "RUPT", "shortsells", "marginbuysTaler", "marginbuysAsset", "marginbuys", "shortsells_Informed", "shortsells_Uninformed", "marginbuys_Informed", "marginbuys_Uninformed", "marginbuysAsset_Informed", "marginbuysAsset_Uninformed",
                                                  "NumActiveTrader", "NumTransactingTraders", "NumOfferingTraders", "ParticipationRate_Uninf", "ParticipationRate_Inf",
                                                  "HHInitialAssets", "HHEndAssets", "HHInitialEndowment", "HHEndEndowment", "HHEndEndowmentPun", "HHVolume", "HHPDbefore", "HHPDPun",
                                                  "HHI_InitialAssets","HHI_EndAssets","HHI_InitialEndowment", "HHI_EndEndowment", "HHI_EndEndowmentPun", "HHI_Volume", "HHI_PDbefore", "HHI_PDPun", 
                                                  "GiniPDbefore", "GiniPDPun", "GiniProfit", "GiniAssets", "GiniEndowment"))

subjectsummary <- subset(subjectsummary, select = c("subjectID", "SessionID", "Date", "Subject", "client", "Period", "Period0", "Phase", "market", "Programme", "Treatment", "regOrder", "embTreatment", "history", "Location",
                                                    "BBV", "BBVCent", "IsREG", "othermarket", "REGBoth", "REGSH", "Role", 
                                                    "InitialAssets", "Assets", "InitialCash", "Cash", "InitialEndowment", "EndVermoegen", "EndEndowmentPun", "InitialEndowmentUnits", "EndEndowmentUnits", "EndEndowmentUnitsPun",
                                                    "Punished", "PunishmentReceived","TradingProfit", "TPRedist", "TPPun", "TPUnits", "TPUnitsRedist", "TPUnitsPun", 
                                                    "ProfitPeriod", "PDbefore", "PDRedist", "PDPun", "PDbeforeVol", "PDRedistVol", "PDPunVol", "rankPDbefore", "rankPDbeforeRole", "rankavgPDbeforeRole", "AvgPDbeforeRole",
                                                    "Volume", "LimitVolume", "CancelledVolume", "VolumeMarketOrder", "VolumeLimitOrder", "VolumeSold", "VolumePurchased", "activeTrader", "transacted", "offered",
                                                    "TPUnProfitTransaction", "VolUnprofitTransaction", "NumUnprofitTransactions",
                                                    "marketshare", "odds", "oddsLimit",
                                                    "shortsells", "marginbuysTaler", "marginbuysAsset", "marginbuys", 
                                                    "ParticipationRate_Uninf", "ParticipationRate_Inf",
                                                    "ObserverStrategy", 'WhichMarket', "ProbabilityDetected", "StrategyTrader", "OpinionPenalty", "RiskGeneral", "RiskFinancial", "LossAversion", "Department", "MajorOther", "Age", "Female", "GeneralComments", "gender"))

phasesummary <- subset(phasesummary, select = c("SessionID", "Role", "Phase", "market", "Programme", "Treatment", "regOrder", "embTreatment", "history", "Location",
                                                "IsREG", "othermarket", "REGBoth", "REGSH", 
                                                "Volume", "LimitVolume", "NumActiveTrader", "PR", "CancelledVolume", "TraderCount", "obs", "TraderVolume", "TraderLimitVolume", 
                                                "shortsells", "marginbuys", "marginbuysAsset", "marginbuysTaler",  
                                                "odds", "odds_start", "odds_middle", "odds_end", "oddsLimit", "oddsLimit_start", "oddsLimit_middle", "oddsLimit_end",
                                                "geomodds", "geomoddsLimit", "absgeomodds", "absgeomoddsLimit", "geomodds_start", "geomodds_middle", "geomodds_end", "geomoddsLimit_start", "geomoddsLimit_middle", "geomoddsLimit_end", "marketshare", "marketshareLimit",
                                                "d1", "d2", "d3", "d1r", "d2r", "d3r", "d1P", "d2P", "d3P"))

observers <- subset(observers, select = c("subjectID", "SessionID", "Date", "client", "Period", "Phase", "market", "Programme", "Treatment", "regOrder", "embTreatment", "Location",
                                          "IsREG", "Role", "NumSelected", "NumDetections", "NumPunished", "NumMissuspected", "ProfitPeriod", 
                                          "ObserverStrategy", "OpinionPenalty", "RiskGeneral", "RiskFinancial", "LossAversion", "Department", "MajorOther", "Age", "Female", "GeneralComments", "gender"))

subjects <- subset(subjects, select = c("subjectID", "SessionID", "Date", "Subject", "Group", "client", "Period", "Programme", "Treatment", "regOrder", "embTreatment", "Location",
                                        "Role", "IsInsider", "IsExperimenter", "IsAuthority",
                                        "InitialAssets[1]", "Assets[1]", "InitialCash", "Cash", "InitialEndowment", "EndVermoegen", "EndEndowmentPun",
                                        "Punished[1]", "Punished[2]","TradingProfit[1]", "TradingProfit[2]", "CompensationReceived[1]", "CompensationReceived[2]",
                                        "ProfitPeriod", "PD",
                                        "VolumeTransactions[1]", "VolumeTransactions[2]", "LimitVol[1]", "LimitVol[1]", "CancelledVol[1]", "CancelledVol[2]", "VolMarketTran[1]", "VolMarketTran[2]", "VolLimitTran[1]", "VolLimitTran[1]", "Transactions[1]", "Transactions[2]", "VolPurch[1]", "VolPurch[2]", "VolSold[1]", "VolSold[2]",
                                        "TotalProfit", 
                                        "ObserverStrategy", "WhichMarket", "ProbabilityDetected", "StrategyTrader", "OpinionPenalty", "RiskGeneral", "RiskFinancial", "LossAversion", "Department", "MajorOther", "Age", "Female", "GeneralComments", "gender"))

transactions <- subset(transactions, select = c("transactionID", "SessionID", "Date", "Period", "Phase", "market", "Programme", "Treatment", "regOrder", "embTreatment", "Location", 
                                                "BBV", "BBVCent", "IsREG", "othermarket", "REGBoth", "REGSH",
                                                "offerID", "type", "takerID", "makerID", "makerRole", "takerRole", "BuyerID", "SellerID", "orderID",
                                                "Price", "Volume", "remainingVolExAnte", "remainingVolExPost", "SellersProfit", "MakersProfit", "shortsells", "marginbuysTaler", "marginbuysAsset",
                                                "Pricewins", "L.Pricewins", "L.Price", "return", "returnwins", "returnwins2",
                                                "Time", "transactionVol", "OfferTime", "AuctionStartTime", "AuctionEndTime", "offertime", "transactiontime"))

offers <- subset(offers, select = c("offerID", "SessionID", "Date", "Period", "Phase", "market", "Programme", "Treatment", "regOrder", "embTreatment", "Location", 
                                    "BBV", "BBVCent", "IsREG", "othermarket", "REGBoth", "REGSH",
                                    "type", "makerID", "makerRole", "status", "Price", "Volume", "LimitVolume", "totTransacted", "CancelledVolume", "remainingVol", "BuyVol", "SellVol", 
                                    "AuctionStartTime", "AuctionEndTime", "offertime", "offertimeEnd"))

orders <- subset(orders, select = c("orderID", "offerID", "transactionID", "SessionID", "Date", "Period", "Phase", "market", "Programme", "Treatment", "regOrder", "embTreatment", "Location", 
                                    "BBV", "BBVCent","IsREG", "othermarket", "REGBoth", "REGSH",
                                    "type", "makerID", "takerID", "status", "Price", "Volume", "LimitVolume", "transactionVol", "totTransacted", "remainingVolExPost", "remainingVolExAnte",  
                                    "AuctionStartTime", "AuctionEndTime", "ordertime", "orderStarttime", "offertime", "offertimeEnd"))

seconds <- subset(seconds, select = c("SessionID", "market", "time", "Period", "Period0", "Programme", "Date", "Treatment", "regOrder", "embTreatment", "history", "Location", 
                                      "MA", "BBV", "BBVCent", "IsREG", "othermarket", "REGBoth", "REGSH", 
                                      "BestBid", "BestAsk", "BAspread", "midpointBA", "lastPrice", "lnlastPrice", "L.lnlastPrice", "return", 
                                      "BestAskwins", "BestBidwins", "BAspreadwins", "BAspreadwins2"))

save(file = "Data.RData", list = c("marketsummary", "subjectsummary", "subjects", "phasesummary", "observers", "transactions", "offers", "orders", "seconds"))

