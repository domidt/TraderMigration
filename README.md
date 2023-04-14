# TraderMigration
This repository provides all data and analyses code used in the JFM paper

The file ``Data.RData`` consists of six data tables:

## marketsummary
The table ``marketsummary`` summarizes data for each market, i.e. two observations per period and cohort.

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
|marginbuysAsset| Purchases with negative money endowments divided by the transaction price.|
|marginbuys| Purchases with negative money endowments divided by the buyback value.|
|shortsells_Informed| Number of assets sold with negative asset endowment using the short limit capacity involving informed traders.|
|shortsells_Uninformed| Number of assets sold with negative asset endowment using the short limit capacity involving uninformed traders.| 
|marginbuys_Informed| Purchases with negative money endowments divided by the buyback value involving informed traders.|
|marginbuys_Uninformed| Purchases with negative money endowments divided by the buyback value involving uninformed traders.|
|marginbuysAsset_Informed| Purchases with negative money endowments divided by the transaction price involving informed traders.|
|marginbuysAsset_Uninformed| Purchases with negative money endowments divided by the transaction price involving uninformed traders.|
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

## subjectsummary
The table ``subjectsummary`` summarizes data for each individual in each market, i.e. 14 observation for each market, period, and cohort. 

| Variable | Description |
---| ---|
|subjectID| ID variable, which uniquely identifies each participant from ``1`` to ``382``.|
|SessionID| ID variable, which uniquely identifies each session from ``1`` to ``24``.|
|Date| Date and Program Starting Time of the experimental session in format yymmdd_hhmm.|
|Subject| ID variable, which identifies participants within a experimental session from ``1`` to ``14``.|
|client| ID variable, which identifies participants within a experimental session.|
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
|REGSH| Regulatory index which is either ``1`` when a market in Phase 2 applies regulation or ``0`` otherwise.|
|Role| Trader type index which is either ``Informed trader`` or ``Uninformed trader``.|
|InitialAssets| Number of assets this participant is endowed at the beginning of this period.|
|Assets| Number of assets this participants holds at market closing of this period.|
|InitialCash| Monetary units this participant is endowed at the beginning of this period.|
|Cash| Monetary units this participants holds at market closing of this period.|
|InitialEndowment| Initial asset endowment time the buyback value plus the initial monetary units.|
|EndVermoegen| Asset endowment times the buyback value plus the monetary units at market closing before redistributions and punishment.|
|EndEndowmentPun| Asset endowment times the buyback value plus the monetary units at market closing after redistributions and punishment.|
|InitialEndowmentUnits| Initial asset endowment value plus initial monetary units divided by the buyback value.|
|EndEndowmentUnits| Asset endowment plus the monetary units divided by the buyback value at market closing before redistributions and punishment.|
|EndEndowmentUnitsPun| Asset endowment plus the monetary units divided by the buyback value at market closing after redistributions and punishment.|
|Punished| Binary variable which is either ``1`` when this trader is informed and correctly identified, or ``0`` otherwise.|
|PunishmentReceived| Sum of redistributions and punishement payments lost or received in this single market.|
|TradingProfit| Profits from market participation in experimental monetary units before redistribution and punishment.|
|TPRedist| Profits from market participation in experimental monetary units after redistribution.|
|TPPun| Profits from market participation in experimental monetary units after redistribution and punishment.|
|TPUnits| Profits from market participation in asset units (experimental monetary units divided by the buyback value) before redistribution and punishment.|
|TPUnitsRedist| Profits from market participation in asset units after redistribution.|
|TPUnitsPun| Profits from market participation in asset units after redistribution and punishment.|
|ProfitPeriod| Profit from market participation in Euro after redistribution and punishment.|
|PDbefore| Wealth change before redistribution and punishement.|
|PDRedist| Wealth change after redistribution.|
|PDPun| Wealth change after redistribution and punishment.|
|PDbeforeVol| Wealth change per transacted asset before redistribution and punishment.|
|PDRedistVol| Wealth change per transacted asset after redistribution.|
|PDPunVol| Wealth change per transacted asset after redistribution and punishment.|
|rankPDbefore| Ordered rank of wealth change before redistribution and punishment within a single market from ``1`` (lowest) to ``14`` (highest).|
|rankPDbeforeRole| Ordered rank of wealth change before redistribution and punishment within a single market by trader type from ``1`` (lowest) to ``10`` (highest, resp. ``4`` for informed traders).|
|rankavgPDbeforeRole| Ordered rank of average wealth change before redistribution and punishment throughout the experiment by role from ``1`` (lowest) to ``14`` (highest).|
|Volume| Number of assets transacted in a single market.|
|LimitVolume| Number of assets offered in limit orders in a single market.|
|CancelledVolume| Number of offered assets withdrawn before market closing.|
|VolumeMarketOrder| Number of accepted assets in market orders in a single market.|
|VolumeLimitOrder| Number of offered assets accepted by another trader in a single market.|
|activeTrader| Binary variable which identifies whether this trader placed any limit order or accepted any market order.|
|transacted| Binary variable which identifies whether this trader accepted any market order.|
|offered| Binary variable which identifies whether this trader placed any limit order.|
|marketshare| Ratio of transacted volume of this trader over the transacted volume in both simultaneously operating markets.|
|odds| Ratio of transacted volume of this trader over the transacted volume in the other, simultaneously operating market.|
|oddsLimit| Ratio of limit order volume of this trader over the limit order volume in the other, simultaneously operating market.|
|shortsells| Number of assets sold with negative asset endowment using the short limit capacity.|
|marginbuysTaler| Money spend to buy assets with negative money endowment using the credit limit.|
|marginbuysAsset| Purchases with negative money endowments divided by the transaction price.|
|marginbuys| Purchases with negative money endowments divided by the buyback value.|
|ParticipationRate_Uninf| Number of active uninformed traders in this market divided by the total number of uninformed traders.|
|ParticipationRate_Inf| Number of active informed traders in this market divided by the total number of informed traders.|
|ObserverStrategy| Self-description of observers at the end of the experiment how they use information: PostQ1: ``Please describe how you think the available information (1.\ volume limit; 2.\ volume limit deleted; 3.\ trading volume limit; 4.\ trading volume market; 5.\ volume purchased; 6.\ volume sold; 7.\ volume purchased - sold; 8.\ average price; 9.\ average volume) can be used to identify informed traders!``.|
|ProbabilityDetected| Self-description of traders at the end of the experiment how they estimate the probability of a detection of informed traders. PostQ3: `` How high do you estimate the probability that an observer correctly identifies a trader with information as such.``.|
|StrategyTrader| Self-description of traders at the end of the experiment of their trading strategy. PostQ4: ``What strategies did you use to avoid being recognized by observers as a trader with information?``.|
|OpinionPenalty| Self-description of participants at the end of the experiment about their opinion on the appropriateness of the penalty. PostQ5: ``If a trader with information is correctly selected by the observer, he loses his trading profit and must pay an additional penalty equal to the trading profit. Please indicate whether you consider this penalty to be appropriate, too low, or too high.``.|
|RiskGeneral| Self-description of participants' risk tolerance at the end of the experiment. PostQ6: ``How do you see yourself: are you generally a person who is fully prepared to take risks or do you try to avoid taking risks?``.|
|RiskFinancial| Self-description of participants' financial risk tolerance at the end of the experiment. PostQ7 ``People can behave differently in different situations. How would you rate your willingness to take risks in financial matters?``.|
|LossAversion| Self-description of participants loss tolerance at the end of the experiment. PostQ8 ``In financial decisions, both gains and losses are possible. To what extent do possible losses compared to possible gains influence you?``.|
|Department| Self-description of participants' department of studies. PostQ9: ``Which faculty are you studying at?``.|
|MajorOther| If they specified other at department, they are asked to specify here their faculty.|
|Age| Self-description of participants' age. PostQ10a: ``Age in years``.|
|Female| Self-description of participants' gender which can be either ``Weiblich`` for Female, ``Männlich`` for Male, or ``Divers``.
|GeneralComments| Room for further comments concerning the experiment.|
|gender| Self-description of participants' gender which can be either ``female``, ``male``, or ``xdivers``.

## phasesummary
The table ``phasesummary`` summarizes data for each phase, market, and trader type and for the overall market, i.e. three observations for each trader type times two markets times three phases constitute 18 observations for each cohort.

| Variable | Description |
---| ---|
|SessionID| ID variable, which uniquely identifies each session from ``1`` to ``24``.|
|Role| Trader type index which is either ``Informed trader``, ``Uninformed trader``, or ``market``.|
|Phase| Phase index, which is either ``Phase 1`` for periods 1 to 3, ``Phase 2`` for periods 4 to 9, or ``Phase 3``.|
|market| Market index, which is either ``Bottom`` or ``Top`` indicating the position on the screen.|
|Programme| Progress index, which is either ``1`` for the pre-experimental questionnaire, ``2`` for the training periods, and ``3`` for the actual experimental data.|
|Treatment| Treatment index, which is either ``NN.NR.RR``, ``NN.RN.RR``, ``RR.NR.NN``, ``RR.NR.RR``, ``RR.RN.NN``, or ``RR.RN.RR``.|
|regOrder| Treatment index specifying the order of market regulation in Phase 2, which is either ``NR``, or ``RN``.| 
|embTreatment| Treatment index specifying the regulation in Phase 1 and 3, which is either``NN.RR'', ``RR.NN'', or ``RR.RR``.|
|history| Treatment index specifying the regulation in previous Phases, which is either ``1`` for markets in Phase 1, ``N`` (resp. ``R``) for markets in Phase 2 which succeeded NOREG (REG) markets, ``N.N``, ``N.R``, ``R.N``, or ``R.R`` for markets in Phase 3.| 
|Location| City index, which is either ``Graz`` or ``Vienna``.|
|IsREG| Regulatory index, which is either ``REG`` for regulated markets or ``NOREG``.|
|othermarket| Regulatory index for the simultaneous opposite market, which is either ``REG`` for regulated markets or ``NOREG``.|
|REGBoth| Regulatory index which is either ``1`` when both markets in a phase apply regulation or ``0`` otherwise.|
|REGSH| Regulatory index which is eiterh ``1`` when markets in Phase 2 apply regulation or ``0`` otherwise.|
|Volume| Number of assets transacted in a phase.|
|LimitVolume| Number of assets offered in limit orders in a phase.|
|NumActiveTrader| Number of traders who either placed a limit order or accepted a market order.|
|PR| Participation Rate - Number of active traders divided by the total number of traders.|
|CancelledVolume| Number of offered assets withdrawn before market closing.|
|TraderCount| Number of traders times periods in a phase.|
|obs| Number of market observations, i.e. number of markets with activity.|
|TraderVolume| Number of assets transacted per trader in a phase.|
|TraderLimitVolume| Number of assets offered in limit orders per trader in a phase.|
|shortsells| Number of assets sold with negative asset endowment using the short limit capacity.|
|marginbuysTaler| Money spend to buy assets with negative money endowment using the credit limit.|
|marginbuysAsset| Purchases with negative money endowments divided by the transaction price.|
|marginbuys| Purchases with negative money endowments divided by the buyback value.|
|odds| Ratio of transacted volume over the transacted volume in the other, simultaneously operating markets (arithmetic averages).|
|odds_start| Ratio of transacted volume between simultaneously operating market of the same cohort in Phase 1.|
|odds_middle| Ratio of transacted volume between simultaneously operating market of the same cohort in Phase 2.|
|odds_end| Ratio of transacted volume between simultaneously operating market of the same cohort in Phase 3.|
|oddsLimit| Ratio of limit order volume over the limit order volume in the other, simultaneously operating markets.|
|oddsLimit_start| Ratio of limit order volume between simultaneously operating market of the same cohort in Phase 1.|
|oddsLimit_middle| Ratio of limit order volume between simultaneously operating market of the same cohort in Phase 2.|
|oddsLimit_end| Ratio of limit order volume between simultaneously operating market of the same cohort in Phase 3.|
|geomodds| Geometric ratio of transacted volume over the transacted volume in the other, simultaneously operating markets (geometric averages).|
|geomoddsLimit| Geometric ratio of limit order volume over the limit order volume in the other, simultaneously operating markets.|
|absgeomodds| Geometric absolute ratio of transacted volume over the transacted volume in the other, simultaneously operating markets.|
|absgeomoddsLimit| Geometric absolute ratio of limit order volume over the limit order volume in the other, simultaneously operating markets.|
|geomodds_start| Geometric ratio of transacted volume between simultaneously operating market of the same cohort in Phase 1.|
|geomodds_middle| Geometric ratio of transacted volume between simultaneously operating market of the same cohort in Phase 2.|
|geomodds_end| Geometric ratio of transacted volume between simultaneously operating market of the same cohort in Phase 3.|
|geomoddsLimit_start| Geometric ratio of limit order volume between simultaneously operating market of the same cohort in Phase 1.|
|geomoddsLimit_middle| Geometric ratio of limit order volume between simultaneously operating market of the same cohort in Phase 2.|
|geomoddsLimit_end| Geometric ratio of limit order volume between simultaneously operating market of the same cohort in Phase 3.|
|marketshare| Ratio of transacted volume over the transacted volume of simultaneously operating markets.|
|marketshareLimit| Ratio of limit order volume over the limit order volume of simultaneously operating markets.|
|d1| Difference in odds between this phase and Phase 1.|
|d2| Difference in odds between this phase and Phase 2.|
|d3| Difference in odds between this phase and Phase 3.|
|d1r| Difference in odds between this phase and Phase 1 dividing odds by the number of periods in the resp. phase.|
|d2r| Difference in odds between this phase and Phase 2 dividing odds by the number of periods in the resp. phase.|
|d3r| Difference in odds between this phase and Phase 3 dividing odds by the number of periods in the resp. phase.|
|d1P| Difference in geometric odds between this phase and Phase 1.|
|d2P| Difference in geometric odds between this phase and Phase 2.|
|d3P| Difference in geometric odds between this phase and Phase 3.|

## observers
The table ``observers`` summarizes data for each observer in each period, i.e. two observation for each period and cohort. 

| Variable | Description |
---| ---|
|subjectID| ID variable, which uniquely identifies each participant from ``1`` to ``382``.|
|SessionID| ID variable, which uniquely identifies each session from ``1`` to ``24``.|
|Date| Date and Program Starting Time of the experimental session in format yymmdd_hhmm.|
|Subject| ID variable, which identifies participants within a experimental session from ``1`` to ``14``.|
|client| ID variable, which identifies participants within a experimental session.|
|Period| Period index, ranging from ``1`` to ``12``.|
|Phase| Phase index, which is either ``Phase 1`` for periods 1 to 3, ``Phase 2`` for periods 4 to 9, or ``Phase 3``.|
|market| Market index, which is either ``Bottom`` or ``Top`` indicating the position on the screen.|
|Programme| Progress index, which is either ``1`` for the pre-experimental questionnaire, ``2`` for the training periods, and ``3`` for the actual experimental data.|
|Treatment| Treatment index, which is either ``NN.NR.RR``, ``NN.RN.RR``, ``RR.NR.NN``, ``RR.NR.RR``, ``RR.RN.NN``, or ``RR.RN.RR``.|
|regOrder| Treatment index specifying the order of market regulation in Phase 2, which is either ``NR``, or ``RN``.| 
|embTreatment| Treatment index specifying the regulation in Phase 1 and 3, which is either``NN.RR'', ``RR.NN'', or ``RR.RR``.|
|Location| City index, which is either ``Graz`` or ``Vienna``.|
|IsREG| Regulatory index, which is either ``REG`` for regulated markets or ``NOREG``.|
|Role| Participants' role index which is ``Observer``.|
|NumSelected| Number of traders suspected to be informed after market closing.|
|NumDetections| Number of traders correctly identified to be informed after market closing.|
|NumPunished| Number of traders correctly identified to be informed in the regulatory regime REG after market closing.|
|NumSelected| Number of traders incorrectly suspected to be informed after market closing.|
|ProfitPeriod| Profit from market observation in Euro.|
|ObserverStrategy| Self-description of observers at the end of the experiment how they use information: PostQ1: ``Please describe how you think the available information (1.\ volume limit; 2.\ volume limit deleted; 3.\ trading volume limit; 4.\ trading volume market; 5.\ volume purchased; 6.\ volume sold; 7.\ volume purchased - sold; 8.\ average price; 9.\ average volume) can be used to identify informed traders!``.|
|ProbabilityDetected| Self-description of traders at the end of the experiment how they estimate the probability of a detection of informed traders. PostQ3: `` How high do you estimate the probability that an observer correctly identifies a trader with information as such.``.|
|StrategyTrader| Self-description of traders at the end of the experiment of their trading strategy. PostQ4: ``What strategies did you use to avoid being recognized by observers as a trader with information?``.|
|OpinionPenalty| Self-description of participants at the end of the experiment about their opinion on the appropriateness of the penalty. PostQ5: ``If a trader with information is correctly selected by the observer, he loses his trading profit and must pay an additional penalty equal to the trading profit. Please indicate whether you consider this penalty to be appropriate, too low, or too high.``.|
|RiskGeneral| Self-description of participants' risk tolerance at the end of the experiment. PostQ6: ``How do you see yourself: are you generally a person who is fully prepared to take risks or do you try to avoid taking risks?``.|
|RiskFinancial| Self-description of participants' financial risk tolerance at the end of the experiment. PostQ7 ``People can behave differently in different situations. How would you rate your willingness to take risks in financial matters?``.|
|LossAversion| Self-description of participants loss tolerance at the end of the experiment. PostQ8 ``In financial decisions, both gains and losses are possible. To what extent do possible losses compared to possible gains influence you?``.|
|Department| Self-description of participants' department of studies. PostQ9: ``Which faculty are you studying at?``.|
|MajorOther| If they specified other at department, they are asked to specify here their faculty.|
|Age| Self-description of participants' age. PostQ10a: ``Age in years``.|
|Female| Self-description of participants' gender which can be either ``Weiblich`` for Female, ``Männlich`` for Male, or ``Divers``.
|GeneralComments| Room for further comments concerning the experiment.|
|gender| Self-description of participants' gender which can be either ``female``, ``male``, or ``xdivers``.

## transactions
The table ``transactions`` summarizes data for each acceptence of a limit order, i.e. one observations per market order.

| Variable | Description |
---| ---|
|transactionID| ID variable, which uniquely identifies each market order from ``1`` to ``23549``.|
|SessionID| ID variable, which uniquely identifies each session from ``1`` to ``24``.|
|Date| Date and Program Starting Time of the experimental session in format yymmdd_hhmm.|
|Period| Period index, ranging from ``1`` to ``12``.|
|Phase| Phase index, which is either ``Phase 1`` for periods 1 to 3, ``Phase 2`` for periods 4 to 9, or ``Phase 3``.|
|market| Market index, which is either ``Bottom`` or ``Top`` indicating the position on the screen.|
|Programme| Progress index, which is either ``1`` for the pre-experimental questionnaire, ``2`` for the training periods, and ``3`` for the actual experimental data.|
|Treatment| Treatment index, which is either ``NN.NR.RR``, ``NN.RN.RR``, ``RR.NR.NN``, ``RR.NR.RR``, ``RR.RN.NN``, or ``RR.RN.RR``.|
|regOrder| Treatment index specifying the order of market regulation in Phase 2, which is either ``NR``, or ``RN``.| 
|embTreatment| Treatment index specifying the regulation in Phase 1 and 3, which is either``NN.RR'', ``RR.NN'', or ``RR.RR``.|
|Location| City index, which is either ``Graz`` or ``Vienna``.|
|BBV| Buyback Value.|
|BBVCent| Buyback Value centralized by the unconditional expected value of 57.5.|
|IsREG| Regulatory index, which is either ``REG`` for regulated markets or ``NOREG``.|
|othermarket| Regulatory index for the simultaneous opposite market, which is either ``REG`` for regulated markets or ``NOREG``.|
|REGBoth| Regulatory index which is either ``1`` when both markets in a period apply regulation or ``0`` otherwise.|
|REGSH| Regulatory index which is eiterh ``1`` when a market in Phase 2 applies regulation or ``0`` otherwise.|
|offerID| ID variable, which uniquely identifies each limit order from ``1`` to ``19390``.|
|type| Limit order index specifying whether the liquidity provider offers to buy (``BuyingOffer``) or to sell (``SellingOffer``).|
|takerID| ID variable, which uniquely identifies the liquidity taker from ``1`` to ``382``.|
|makerID| ID variable, which uniquely identifies the liquidity provider from ``1`` to ``382``.|
|makerRole | Trader type index for the liquidity taker which is either ``Informed trader`` or ``Uninformed trader``.|
|takerRole| Trader type index for the liquidity provider which is either ``Informed trader`` or ``Uninformed trader``.|
|BuyerID| ID variable, which uniquely identifies the buying party from ``1`` to ``382``.|
|SellerID| ID variable, which uniquely identifies the selling party from ``1`` to ``382``.|
|orderID| ID variable, which uniquely identifies each withdrawal, limit, and market order from ``1`` to ``19390``.|
|Price| Price of the transactions at which the asset is bought and sold.|
|Volume| Number of assets transacted via this market order.|
|remainingVolExAnte| Number of assets offered via the respective limit order before this market order.|
|remainingVolExPost| Number of assets offered via the respective limit order after the execution of this market order.|
|SellersProfit| Trading profit in Taler of the selling party by this market order.|
|MakersProfit| Trading profit in Taler of the liquidity provider by this market order.|
|shortsells| Number of assets sold by the selling party with negative asset endowment using the short limit capacity.|
|marginbuysTaler| Money spend to buy assets by the buying party with negative money endowment using the credit limit.|
|marginbuysAsset| Purchases by the buying party with negative money endowments divided by the transaction price.|
|Pricewins| Price of the transactions at which the asset is bought and sold after a symmetric 90% winsorization of prices.|
L.Pricewins| Last price before this market order after a symmetric 90% winsorization of prices.|
|L.Price| Last price before this market order.|
|return| Log price change between transactions, i.e., ln(``Price``) - ln(``L.Price``).|
|returnwins| Log price change between transactions after a symmetric 90% winsorization of prices.|
|returnwins2| Log price change between transactions after a symmetric 90% winsorization of returns.|
|Time| Time in seconds that has been passed since z-Tree has been started until the market order was executed.|
|transactionVol| Number of assets transacted via this market order.|
|OfferTime| Time in seconds that has been passed since z-Tree has been started until the limit order was placed.|
|AuctionStartTime| Time in seconds that has been passed since z-Tree has been started until the start of the auction.|
|AuctionEndTime| Time in seconds that has been passed since z-Tree has been started until the end of the auction.|
|offertime| Time in seconds that has been passed since the start of the auction until the limit order was placed.|
|transactiontime| Time in seconds that has been passed since the start of the auction until the market order was executed.|

## offers
The table ``offers`` summarizes data for each placement of a limit order, i.e. one observations per limit order.

| Variable | Description |
---| ---|
|offerID| ID variable, which uniquely identifies each limit order from ``1`` to ``19390``.|
|SessionID| ID variable, which uniquely identifies each session from ``1`` to ``24``.|
|Date| Date and Program Starting Time of the experimental session in format yymmdd_hhmm.|
|Period| Period index, ranging from ``1`` to ``12``.|
|Phase| Phase index, which is either ``Phase 1`` for periods 1 to 3, ``Phase 2`` for periods 4 to 9, or ``Phase 3``.|
|market| Market index, which is either ``Bottom`` or ``Top`` indicating the position on the screen.|
|Programme| Progress index, which is either ``1`` for the pre-experimental questionnaire, ``2`` for the training periods, and ``3`` for the actual experimental data.|
|Treatment| Treatment index, which is either ``NN.NR.RR``, ``NN.RN.RR``, ``RR.NR.NN``, ``RR.NR.RR``, ``RR.RN.NN``, or ``RR.RN.RR``.|
|regOrder| Treatment index specifying the order of market regulation in Phase 2, which is either ``NR``, or ``RN``.| 
|embTreatment| Treatment index specifying the regulation in Phase 1 and 3, which is either``NN.RR'', ``RR.NN'', or ``RR.RR``.|
|Location| City index, which is either ``Graz`` or ``Vienna``.|
|BBV| Buyback Value.|
|BBVCent| Buyback Value centralized by the unconditional expected value of 57.5.|
|IsREG| Regulatory index, which is either ``REG`` for regulated markets or ``NOREG``.|
|othermarket| Regulatory index for the simultaneous opposite market, which is either ``REG`` for regulated markets or ``NOREG``.|
|REGBoth| Regulatory index which is either ``1`` when both markets in a period apply regulation or ``0`` otherwise.|
|REGSH| Regulatory index which is eiterh ``1`` when a market in Phase 2 applies regulation or ``0`` otherwise.|
|type| Limit order index specifying whether the liquidity provider offers to buy (``BuyingOffer``) or to sell (``SellingOffer``).|
|makerID| ID variable, which uniquely identifies the liquidity provider from ``1`` to ``382``.|
|makerRole | Trader type index for the liquidity taker which is either ``Informed trader`` or ``Uninformed trader``.|
|status| Limit order index, which is either ``cancelled`` if this limit order got cancelled somewhen throughout the auction, ``on market`` if this limit order remaind in the order book at market closing, ``sold out`` when all assets were accepted by another party, or ``fully invalidated`` when they are no longer feasible at market closing.|
|Price| Price of the limit order at which the asset is offered to buy or sell.|
|Volume| Number of assets offered via this limit order.|
|LimitVolume| Number of assets offered via this limit order.|
|totTransacted| Number of assets transacted via this limit order.|
|CancelledVolume| Number of assets cancelled of this limit order.|
|remainingVol| Number of assets offered via this limit order at market closing.|
|BuyVol| Number of assets offered via this limit order which the liquidity provided offered to buy.|
|SellVol| Number of assets offered via this limit order which the liquidity provided offered to sell.|
|AuctionStartTime| Time in seconds that has been passed since z-Tree has been started until the start of the auction.|
|AuctionEndTime| Time in seconds that has been passed since z-Tree has been started until the end of the auction.|
|offertime| Time in seconds that has been passed since the start of the auction until the limit order was placed.|
|offertimeEnd| Time in seconds that has been passed since the start of the auction until the end of the respective limit order, i.e., either at market closing, withdrawal, or when the limit order sold out.|

## orders
The table ``orders`` summarizes data for each order, i.e. one observations per withdrawal, limit, and market order.

| Variable | Description |
---| ---|
|orderID| ID variable, which uniquely identifies each withdrawal, limit, and market order from ``1`` to ``19390``.|
|offerID| ID variable, which uniquely identifies each limit order from ``1`` to ``19390``.|
|transactionID| ID variable, which uniquely identifies each market order from ``1`` to ``23549``.|
|SessionID| ID variable, which uniquely identifies each session from ``1`` to ``24``.|
|Date| Date and Program Starting Time of the experimental session in format yymmdd_hhmm.|
|Period| Period index, ranging from ``1`` to ``12``.|
|Phase| Phase index, which is either ``Phase 1`` for periods 1 to 3, ``Phase 2`` for periods 4 to 9, or ``Phase 3``.|
|market| Market index, which is either ``Bottom`` or ``Top`` indicating the position on the screen.|
|Programme| Progress index, which is either ``1`` for the pre-experimental questionnaire, ``2`` for the training periods, and ``3`` for the actual experimental data.|
|Treatment| Treatment index, which is either ``NN.NR.RR``, ``NN.RN.RR``, ``RR.NR.NN``, ``RR.NR.RR``, ``RR.RN.NN``, or ``RR.RN.RR``.|
|regOrder| Treatment index specifying the order of market regulation in Phase 2, which is either ``NR``, or ``RN``.| 
|embTreatment| Treatment index specifying the regulation in Phase 1 and 3, which is either``NN.RR'', ``RR.NN'', or ``RR.RR``.|
|Location| City index, which is either ``Graz`` or ``Vienna``.|
|BBV| Buyback Value.|
|BBVCent| Buyback Value centralized by the unconditional expected value of 57.5.|
|IsREG| Regulatory index, which is either ``REG`` for regulated markets or ``NOREG``.|
|othermarket| Regulatory index for the simultaneous opposite market, which is either ``REG`` for regulated markets or ``NOREG``.|
|REGBoth| Regulatory index which is either ``1`` when both markets in a period apply regulation or ``0`` otherwise.|
|REGSH| Regulatory index which is eiterh ``1`` when a market in Phase 2 applies regulation or ``0`` otherwise.|
|type| Limit order index specifying whether the liquidity provider offers to buy (``BuyingOffer``) or to sell (``SellingOffer``).|
|makerID| ID variable, which uniquely identifies the liquidity provider from ``1`` to ``382``.|
|takerID| ID variable, which uniquely identifies the liquidity taker from ``1`` to ``382``.|
|status| Limit order index, which is either ``cancelled`` if this limit order got cancelled via this order, ``on market`` if this limit order remaind in the order book after this order, ``sold out`` when all assets were accepted by another party, or ``fully invalidated`` when they are no longer feasible.|
|Price| Price of the limit order at which the asset is offered to buy or sell.|
|Volume| Number of assets offered via this limit order.|
|LimitVolume| Number of assets offered via the respective limit order.|
|transactionVol| Number of assets transacted via the respective market order.|
|totTransacted| Number of assets transacted via the respective limit order.|
|remainingVolExAnte| Number of assets offered via the respective limit order before this order.|
|remainingVolExPost| Number of assets offered via the respective limit order after the execution of this order.|
|AuctionStartTime| Time in seconds that has been passed since z-Tree has been started until the start of the auction.|
|AuctionEndTime| Time in seconds that has been passed since z-Tree has been started until the end of the auction.|
|ordertime| Time in seconds that has been passed since the start of the auction until the order was executed/placed/withdrawn.|
|orderStarttime| Time in seconds that has been passed since the start of the auction until the order was placed, i.e. since the limit order was placed or the last market order was executed.|
|offertime| Time in seconds that has been passed since the start of the auction until the limit order was placed.|
|offertimeEnd| Time in seconds that has been passed since the start of the auction until the end of the respective limit order, i.e., either at market closing, withdrawal, or when the limit order sold out.|
