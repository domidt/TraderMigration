# TraderMigration
This repository provides all data and analyses code used in the JFM paper

The file ``Data.RData`` consists of six data tables:

## marketsummary
The table ``marketsummary`` summarizes data within a 

| Variable | Description |
---| ---|
|SessionID| ID variable, which uniquely identifies each session from ``1`` to ``24``.|
|Date| Date and Program Starting Time of the experimental session in format yymmdd_hhmm.|
|Period| Period index, ranging from ``1`` to ``12``.|
|Period0| Period index, ranging from ``0`` to ``5``, indicating the distance to the phase’s first period, starting with 0 to facilitate the interpretation of the intercept.|
|Phase| Phase index, which is either ``Phase 1`` for periods 1 to 3, ``Phase 2`` for periods 4 to 9, or ``Phase 3``.|
|market| Market index, which is either ``Bottom`` or ``Top`` indicating the position on the screen.|
|Programme| Progress index, which is either ``1`` for the pre-experimental questionnaire, ``2`` for the training periods, and ``3`` for the actual experimental data.|
|Treatment| Treatment index, which is either ``NN.NR.RR``, ``NN.RN.RR``, ``RR.NR.NN``, ``RR.NR.RR``, ``RR.RN.NN``, or ``RR.RN.RR``.|
|regOrder| Treatment index specifying the order of market regulation in Phase 2, which is either ``NR``, or ``RN``.| 
|embTreatment| Treatment index specifying the regulation in Phase 1 and 3, which is either``NN.RR'', ``RR.NN'', or ``RR.RR``.|
|history| Treatment index specifying the regulation in previous Phases, which is either ``1`` for markets in Phase 1, ``N`` (resp. ``R``) for markets in Phase 2 which succeeded NOREG (REG) markets, ``N.N``, ``N.R``, ``R.N``, or ``R.R`` for markets in Phase 3.| 
|Location| City index, which is either ``Graz`` or ``Vienna``.|
|BBV| Buyback Value.|
|BBVCent| Buyback Value centralized by the unconditional expected value of 57.5.|
|IsREG| Regulatory index, which is either ``REG`` for regulated markets or ``NOREG``.|
|othermarket| Regulatory index for the simultaneous opposite market, which is either ``REG`` for regulated markets or ``NOREG``.|
|REGBoth| Regulatory index which is either ``1`` when both markets in a period apply regulation or ``0`` otherwise.|
|REGSH| Regulatory index which is eiterh ``1`` when a market in Phase 2 applies regulation or ``0`` otherwise.|
|BestBid180| Active bid in the order book when market ended which offered the highest bid price.|
|BestAsk180| Active ask in the order book when market ended which offered assets for the lowest ask price.|
|BAspread180| Difference between best bid and best ask price when market ended.
|midpointBA180| Arithmetic average of the best bid and best ask price when market ended.|
|BestBid150| Mean best bids in the order book in the last 30 seconds weighted with the seconds providing the highest bid price.|
|BestAsk150| Mean best asks in the order book in the last 30 seconds weighted with the seconds providing the lowest ask price.|
|BAspread150| Mean difference between best bid and best ask price in the last 30 seconds each second.|
|midpointBA150| Mean midpoint between best bid and best ask price in the last 30 seconds each second.|
|midpointBAavg150| Midpoint between mean best bid and mean best ask price in the last 30 seconds each second.|
|BA_BBV| Difference between the mean midpoints between best bid and best ask prices of the whole timespan of one market, and the the buyback value.|
|BA_BBV150| Difference between the mean midpoints between best bid and best ask prices in the last 30 seconds, and the the buyback value.|
|BA_BBV180| Difference between the mean midpoints between best bid and best ask prices when market closes, and the the buyback value.|
|lnBA_BBV| Logarithmic ratio of the mean midpoints between best bid and best ask prices of the whole timespan of one market, and the the buyback value.|
|lnBA_BBV150| Logarithmic ratio between the mean midpoints between best bid and best ask prices in the last 30 seconds, and the the buyback value.|
|lnBA_BBV180| Logarithmic ratio between the mean midpoints between best bid and best ask prices when market closes, and the the buyback value.|
|meanBestBid| Mean best bids in the order book in the whole timespan of a market weighted with the seconds providing the highest bid price.|
|meanBestAsk| Mean best asks in the order book in the whole timespan of a market weighted with the seconds providing the lowerst ask price.|
|meanBAspread| Mean difference between best bid and best ask price each second.|
|meanmidpointBA| Mean midpoint between best bid and best ask price in the whole timespan of a market.|
|meanBAspreadwins| Mean difference between best bid and best ask price each second after a symmetric 90% winsorization of prices.|
|meanBAspreadwins2| Mean difference between best bid and best ask price each second after a symmetric 90% winsorization.|
|meanreturnsec| Mean price change between observations each second.|
|meanreturn| Mean price change between transactions.|
|meanreturnwins| Mean price change between transactions after a symmetric 90% winsorization of prices.|
|meanreturnwins2| Mean price change between transactions after a symmetric 90% winsorization.|
|obsreturn| Number of observations of returns, i.e., of two consecutive transactions.|
|sdreturnsec| Standard deviation of price changes observed each second within a market.|
|volatility| Standard deviation of transaction price returns within a market.|
|volatilitywins| Standard deviation of transaction price returns within a market after a symmetric 90% winsorization of prices.|
|volatilitywins2| Standard deviation of transaction price returns within a market after a symmetric 90% winsorization.|
|meanPrice| Mean transaction price within a market.|
|sdPrice| Standard deviation of transaction prices within a market.|
|Volume| Number of assets transacted in a single market.|
|lagVolume| Number of assets transacted in the previous market.|
|VolumeUni| Number of assets transacted involving uninformed traders in a single market.|
|VolumeInf| Number of assets transacted involving informed traders in a single market.|
|Volume_Informed_Informed| Number of assets offered and accepted by informed traders in a single market.|
|Volume_Uninformed_Informed| Number of assets offered by uninformed and accepted by informed traders in a single market.|
|Volume_Informed_Uninformed| Number of assets offered by informed and accepted by uninformed traders in a single market.|
|Volume_Uninformed_Uninformed| Number of assets offered and accepted by uninformed traders in a single market.|
|LimitVolume| Number of assets offered in limit orders in a single market.|
|lagLimitVolume| Number of assets offered in limit orders in the previous market.|
|LimitVolumeInf| Number of assets offered  in limit orders by informed traders in a single market.|
|LimitVolumeUni| Number of assets offered  in limit orders by uninformed traders in a single market.|
|NumTransactions| Number of transactions in a single market.|
|Countoffers| Number of limit orders placed in a single market.|
|CountSelloffers| Number of asks placed in a single market.|
|CountBuyoffers| Number of bids placed in a single market.|
|CancelledVolume| Number of offered assets withdrawn before market closing.|
|remainingVol| Number of offered assets in the order book at market closing.|
|SellLimitVolume| Number of assets offered in ask limit orders in a single market.|
|BuyLimitVolume| Number of assets offered in bid limit orders in a single market.|
|ProfitPotential|
|GD| Geometric Deviation - Geometric volume-weighted average relative mispricing within a market.|
|GAD| Geometric Absolute Deviation - Absolute geometric volume-weighted average relative mispricing within a market.|
|GADhyp| Hypothetical GAD when prices are set to be the unconditional expected value, 57.5.|
|rGAD| 1 minus the ratio between GAD and the hypothetical GAD.|
|RD| Relative Deviation - Arithmetic volume-weighted average relative mispricing within a market.|
|RAD| Relative Absolute Deviation - Absolute arithmetic volume-weighted average relative mispricing within a market.|
|GD120| Geometric volume-weighted average relative mispricing in the last minute of a market.|
|GAD120| Absolute geometric volume-weighted average relative mispricing in the last minute of a market.|
|RD120| Arithmetic volume-weighted average relative mispricing in the last minute of a market.|
|RAD120| Absolute arithmetic volume-weighted average relative mispricing in the last minute of a market.|
|Price| Last transaction price in a market.|
|Price120| Mean transaction price in the last minute of a market.|
|marketshare| Ratio of transacted volume over the transacted volume of both simultaneously operating markets.|
|lagmarketshare| marketshare in the previous period.|
|marketshareLimit| Ratio of limit order volume over the limit order volume of both simultaneously operating markets.|
|lagmarketshareLimit| marketshare of limits in the previous period.|
|AssetTurnover| Ratio of transacted volume over the remaining volume at market closing.|
|TransactionSize| Ratio of transacted volume over the number of transactions in a single market.|
|LimitOrderTurnover| Ratio of limit order volume over the remaining volume at market closing.|
|LimitOrderSize| Ratio of limit order volume over the number of transactions in a single market.|
|odds| Ratio of transacted volume over the transacted volume in the other, simultaneously operating market.|
|lagodds| odds in the previous period.|
|oddsLimit| Ratio of limit order volume over the limit order volume in the other, simultaneously operating market.|
|lagoddsLimit| limit order odds in the previous period.|
|oddsUninf| Ratio of transacted volume involving uninformed traders over the transacted volume involving uninformed traders in the other, simultaneously operating market.|
|oddsInf| Ratio of transacted volume involving informed traders over the transacted volume involving informed traders in the other, simultaneously operating market.|
|oddsInfmax| Ratio of transacted volume involving informed traders over the transacted volume involving informed traders in the other, simultaneously operating market such that markets with all market share are associated with the highest observed ratio.|
|oddsInfmax2| Ratio of transacted volume involving uninformed traders over the transacted volume involving uninformed traders in the other, simultaneously operating market such that markets with all market share are associated with the transacted volume over 1.|
|oddsInfmax3| Ratio of transacted volume involving uninformed traders over the transacted volume involving uninformed traders in the other, simultaneously operating market such that markets with all market share are associated with the highest observed ratio in the same phase.|
|oddswins| odds after 90% winsorization.|
|oddsLimitwins| limit order odds after 90% winsorization.|
|oddsInfwins| odds involving informed traders after 90% winsorization.|
|oddsUninfwins| odds involving uninformed traders after 90% winsorization.|
|unprofittime| Unexectued Profitable Orders per Time - Money on the table times the time on the market, i.e., profitable price difference between an offer and the fundamental value times the remaining volume times the timespan the order is on the market.|
|RUPT| Relative Unexecuted Profitable Orders per Time - relative money on the table, i.e., profitable price difference between an offer and the fundamental value times the remaining volume times the timespan the order is on the market divided by the fundamental value and divided by the sum of time times volume of all limit orders.|
|shortsells| Number of assets sold with negative asset endowment using the short limit capacity.|
|marginbuysTaler| Money spend to buy assets with negative money endowment using the credit limit.|
|marginbuysAsset| Purchases with negative money endowments devided by the transaction price.|
|marginbuys| Purchases with negative money endowments devided by the buyback value.|
|shortsells_Informed| Number of assets sold with negative asset endowment using the short limit capacity involving informed traders.|
|shortsells_Uninformed| Number of assets sold with negative asset endowment using the short limit capacity involving uninformed traders.| 
|marginbuys_Informed| Purchases with negative money endowments devided by the buyback value involving informed traders.|
|marginbuys_Uninformed| Purchases with negative money endowments devided by the buyback value involving uninformed traders.|
|marginbuysAsset_Informed| Purchases with negative money endowments devided by the transaction price involving informed traders.|
marginbuysAsset_Uninformed| Purchases with negative money endowments devided by the transaction price involving uninformed traders.|
|NumActiveTrader| Number of traders who either placed a limit order or accepted a market order.|
|NumTransactingTraders| Number of traders who either accepted a market order or whose limit order has been accepted by others.|
|NumOfferingTraders| Number of traders who placed a limit order.|
|ParticipationRate_Uninf| Number of active uninformed traders divided by the total number of uninformed traders.|
|ParticipationRate_Inf| Number of active informed traders divided by the total number of informed traders.|
|HHInitialAssets| Herfindahl–Hirschman index for the initial asset endowment with an alpha of 2.|
|HHEndAssets| Herfindahl–Hirschman index for the asset endowment at market closing with an alpha of 2.|
|HHInitialEndowment| Herfindahl–Hirschman index for the initial endowment with an alpha of 2.|
|HHEndEndowment| Herfindahl–Hirschman index for the endowment at market closing with an alpha of 2.|
|HHEndEndowmentPun| Herfindahl–Hirschman index for the endowment at market closing after punishment payments with an alpha of 2.|
|HHVolume| Herfindahl–Hirschman index for the transacted volume with an alpha of 2.|
|HHPDbefore| Herfindahl–Hirschman index for the wealth change before redistributions with an alpha of 2.|
|HHPDPun| Herfindahl–Hirschman index for the wealth change after punishement payments with an alpha of 2.|
|HHI_InitialAssets| Herfindahl–Hirschman index for the initial asset endowment with an alpha of 2 for active traders.|
|HHI_EndAssets| Herfindahl–Hirschman index for the asset endowment at market closing with an alpha of 2 for active traders.|
|HHI_InitialEndowment| Herfindahl–Hirschman index for the initial endowment with an alpha of 2 for active traders.|
|HHI_EndEndowment| Herfindahl–Hirschman index for the endowment at market closing with an alpha of 2 for active traders.|
|HHI_EndEndowmentPun| Herfindahl–Hirschman index for the endowment after punishment payment at market closing with an alpha of 2 for active traders.|
|HHI_Volume| Herfindahl–Hirschman index for the transacted volume with an alpha of 2 for active traders.|
|HHI_PDbefore| Herfindahl–Hirschman index for the wealth change before redistributions with an alpha of 2 for active traders.|
|HHI_PDPun| Herfindahl–Hirschman index for the wealth change after punisment payments with an alpha of 2 for active traders.|
|GiniPDbefore| Gini index for wealth change before redistributions.|
|GiniPDPun| Gini index for wealth change after punishment payment.|
|GiniProfit| Gini index for payoffs at market closing after punishemnt payment.|
|GiniAssets| Gini index for the initial asset endowment.|
|GiniEndowment| Gini index for the initial endowment.|
