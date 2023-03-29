# General program characteristics
The program has the following features:

-	Universal timelog. The program logs every event in a single, unified timelog table, using the precise computer time instead of z-tree’s experiment time.
-	Experimenter interrupt. Experimenter can at all times move all subjects to the next stage or period or terminate the experiment.

## globals
|Variable |Content|
--- | --- |
|Period| Period number of the record.|
|NumPeriods| Total number of periods in z-Tree program.|
|NumExperimenterSubjects|	Number of experimenter subjects.|
|StartTime| Computer time at start of program.|
|TimeIN| Length in seconds of the RoleInfo stage.|
|TimeAuction|	Length in seconds of the Auction stage.|
|TimeCalculationTask|	Length in seconds of the CalculationTask stage.|
|TimeHistory|	Length in seconds of the History stage.|
|TimePunishment|	Length in seconds of the Punishment stage.|
|TimeFinalResults|	Length in seconds of the FinalResults stage.|
|TimePrediction|	Length in seconds of the Prediction stage.|
|Exchangerate|	Exchangerate, expressed as value of one ECU in CU. In the Profit variable, profit is always saved in actual CU, not ECU. This way, only this variable has to be modified, while the exchange rate in the Background is always 1.|
|Treatment|	Treatment ID. 0=Training, 1=BASE, 2=ID, 3=PUN, 4=MIX.|
|ForceTreatment|	If set to -1, Treatment is read from structure file, otherwise the setting here overwrites the setting in the structure file.|
|IsPun|	Punishment treatment (Treatments 3 and 4).|
|IsID|	ID treatment (Treatments 2 and 4).|
|Testmode|	Switch to activate testing mode.|
|MaxGroups|	Maximum number of groups within a market.|
|MaxObserverCols|	Maximum number of summary table data observers may see at a time.|
|NumTraders[\MaxGroups]|	Total number of traders in each of the groups. Array variable is GroupNum.|
|NumInsiders[\MaxGroups]|	Number of insiders in each of the groups. Array variable is GroupNum.
|NumGroups	Number of active groups.|
|NumTraderSubjects	Sum over all NumTraders[#].|
|GroupID[\MaxGroups]|	Group ID of each group. Corresponds to GroupID in the markets and groups tables and is in fact read from the markets table. Array variable is group number (1…\MaxGroups).|
|BBV[\MaxGroups]| Buy back value in each group. Array variable is GroupNum.|
|LastP[\MaxGroups]|	Last transaction price. Array variable is GroupNum.|
|BBVLowerBound|	Lower limit of possible buy back values.|
|BBVUpperBound| Upper limit of possible buy back values.|
|ForcedExitExperiment| Dummy variable equal to 1 if the experimenter forced an exit from the experiment.|
|ForcedExitPeriod| Dummy variable equal to 1 if the experimenter forced an exit from the period.|
|NumAuthorities| Number of authority subjects.|
|MoneyEndowment| Starting money inventory per subjects.|
|StockEndowment| Starting stock inventory per subjects.|
|ABMarktTransaktionen| Beginning number of market transactions.|
|ABMarktContracts| Beginning number of market contracts (offers).|
|ABMarktActions	Beginning number of market actions (every activity).|
|MarktTransaktionen| Number of market transactions in a market.|
|SumMarktTransaktionen| Cumulative (over all periods) number of market transactions.
|MarktContracts| Number of market contracts in a market.|
SumMarktContracts| Cumulative (over all periods) number of market contracts.
MarktActions| 
SummarktActions| Cumulative (over all periods) number of market actions.
RelativePayoff| Equal to 1 if payoff is relative to average earnings in the group, equal to 0 otherwise.
Payment| Traders’ base payoff.
Margin| Fixed amount (in ECU) which is deducted from total wealth at the end of the session.
PaymentAuthority| Authorities’ base payoff.
PaymentSelected| Payment to authority for each correctly selected insider. For uninformed traders who are selected, the payoff is 2*PaymentSelected.
PaymentSuspected| Payment to authority for each correctly suspected insider. For uninformed traders who are marked, the payoff is 2*PaymentSuspected.
PaymentInsidersGuess| Payment to authority for correctly guessing number of insiders.
PaymentTradersGuessTraders| Payment to traders for correctly guessing number of traders.
PaymentInsidersGuessTraders| Payment to traders for correctly guessing number of insiders.
BestBid[\MaxGroups]| Best currently outstanding bid (highest price). Array variable is GroupNum.
BestAsk[\MaxGroups]| Best currently outstanding ask (lowest price). Array variable is GroupNum.
numContracts[\MaxGroups]| Total number of contracts. Array variable is GroupNum.
numActions[\MaxGroups]| Total number of actions (every activity). Array variable is GroupNum.
numDelete[\MaxGroups]| Total number of deleted contracts. Array variable is GroupNum.
numTrades[\MaxGroups]| Total number of traded contracts. Array variable is GroupNum.
SumPunishment[\MaxGroups]| Total punishment assigned in the group.
Claimbase[\MaxGroups]| Total number of shares traded to the detriment of “claimants”, i.e. traders who were not identified as insiders.
NumPunishmentDone| Total number of subjecs who have finished the Punishment stage.
NumPredictionDone| Total number of subjecs who have finished the Prediction stage.
NumRoleInfoDone| Total number of subjecs who have finished the RoleInfo stage.
NumHistoryDone| Total number of subjecs who have finished the History stage.
NumHistoryDone| Total number of subjecs who have finished the History stage.
NumHistoryDone| Total number of subjecs who have finished the History stage.
FontSizeStandard| Standard font size.
FontSizeHeading| Font size used in headings.
FontSizeSubHeading| Font size used in subheadings.
I| Initialization variable, =-77777
i, j, k, m, Done| Temporary variables
PaymentAuthorityFixed| Fixed compensation for participation in experiment for authority
AssetEndowmentNonInsiderLowerBound| lower bound for stock, money (*BBV) and shorting endowment (=10)
AssetEndowmentNonInsiderUpperBound| Upper bound for stock, money (*BBV) and shorting endowment(=50)
ForceTreatment| Added: 5=ShortNOLeg, 6=ShortLeg
IsShort| | 0 for NOShort;1 for Short (Short selling possible)
MP| Multiplier to leverage PD (percentage difference) (=6.75)

subjects
Variable| Content
Period| Period number of the record
Subject| Subject number of the record
Group| Group the subject belongs to. Corresponds to GroupID in the markets and groups tables.
GroupNum| Group number the subject belongs to. Starts at 1 and bounded from above by \MaxGroups.
Profit| Period profit, calculated as (Money-StartMoney)*\exchangerate.
TotalProfit| Cumulative profit up to this period
IsExperimenter| 0 if normal participant, 1 if experimenter subject
Role| Subject’s role in the experiment: 0=calculation task, 1=uninformed, 2=insider, 3=authority.
IsInsider| 1 if insider (Role 2), 0 if not (Roles 0, 1 or 3)
Money| Subjects’ money balance.
Stock| Subjects’ stock balance.
FreeMoney| Money subjects have available after accounting for capital “bound” in outstanding buy offers.
FreeStock| Stock subjects have available after accounting for stock “bound” in outstanding sell offers.
Vermoegen| Current wealth at latest transaction price LastP.
VermoegenStock| Wealth in stocks at latest transaction price LastP.
OutgoingMoney| Total money “bound” in outstanding buy offers.
OutgoingStock| Total stock “bound” in outstanding sell offers.
LastP| Last transaction price.
LastPHelp| Starting price for graphs.
Contracts| Number of contracts created by this subject.
TaxRate| Tax rate applicable to trading volume (price times quantity).
SumTax| Total taxes paid by subject (continuously updated during trading).
Volume| Total number of shares traded by subject (continuously updated).
VolMarketOrders| Total number of shares traded by market orders by subject (continuously updated).
Transaktionen| Total number of transactions (irrespective of transacted quantity).
Purchases| Number of transactions where subject purchased.
PurchasedVol| Volume of transactions where subject purchased.
CancelledVol| Volume of cancelled orders.
Sales| Number of transactions where subject sold.
SoldVol| Volume of transactions where subject sold.
AvgPrice| Average price paid/received per share (volume-weighted).
MarketOrders| Total number of market orders (irrespective of transacted quantity).
SortOrder| Sort order for contract display. 1=Trader Tag, 2=Price, 3=Quantity.
num1| Number used in calculation task. Correct answer=num1*(num2*10+num3).
num2| Number used in calculation task. Correct answer=num1*(num2*10+num3).
num3| Number used in calculation task. Correct answer=num1*(num2*10+num3).
answer| Answer on latest calculation task question. Correct answer=num1*(num2*10+num3).
RightAnswers| Total number of correct answers given by subject.
WageBuchhalter| Per-answer payment to calculator subjects in EUR.
LastPUp| Upper bound derived from last price. Used for confirmation question in case subject submits bid or ask price far from last transaction price.
LastPDown| Lower bound derived from last price. Used for confirmation question in case subject submits bid or ask price far from last transaction price.
DoneRoleInfo| 0 if subject has not yet completed RoleInfo stage, 1 if it has.
DonePrediction| 0 if subject has not yet completed Prediction stage, 1 if it has.
DonePunishment| 0 if subject has not yet completed Punishment stage, 1 if it has.
DoneHistory| 0 if subject has not yet completed History stage, 1 if it has.
GuessTraders| Guess of the number of traders in the market.
GuessInsiders| Guess of the number of insiders in the market.
ScreenDisplay| Switch to determine which screen subjects see in stages. In Prediction stage and for authority subjects, 1=GeneralPrediction, 2=IndividualPrediction
RandNum| Random number for choice which authority’s punishment point assignment counts in case there are multiple authorities in same group.
Punished| 1 if subject was punished in this period, 0 if not.
Claimbase| Total number of shares traded to the detriment of the trader if the trader was a “claimant”, i.e. a trader who was not identified as an insider.
CompensationReceived| Compensation received through redistribution (in case of discovered insider, this is equal to insider’s positive profits, in case of uninformed or undiscovered insider, this is equal to sum of discovered insiders’ positive profits times the uninformed#s or undiscovered insider’s volume of unprofitable trades divided by the total volume of unprofitable trades of all unpunished traders).
ProfitPeriodCalculator| Period calculation profit in the calculator role.
ProfitPeriodTrader| Period trading profit in the trader role.
ProfitPeriodPredictor| Period prediction profit in the trader role.
ProfitPeriodAuthority| Period authority profit in the authority role.
ProfitPeriod| Subject’s total period profit.
EndVermoegen| Subject’s ending period wealth (Money+Stock*BBV[GroupNum]).
AvEndVermoegen| Average of EndVermoegen in the same group.
DiffAvEndVermoegen| If \RelativePayoff==1, difference between subject’s EndVermoegen and AvEndVermoegen, if ==0, difference between subjects’ EndVermoegen and their endowment value evaluated at the buyback value.
ShowColumn[9]| Switches to determine which of the columns in an observers’ summary table are being displayed.
Help| Determines which help screens are shown to observers:
1| No help screen active.
2| Offer volume screen active.
3| Offer-induced trading volume screen active.
4| Market trades screen active.
5| Volume bought screen active.
6| Volume sold screen active.
7| Volume bought minus volume sold screen active.
8| Average price screen active.
9| Average volume screen active.
10| Cancelled offers screen active.
MaxShort| Maximum of stocks subject shorted
MaxMargin| Maximum amount of taler subject used for buying on margin
TotalShort| Total amount of stock subject shorted
TotalMargin| Total amount of taler subject used for buying on margin
ShortStock| Shorting endowment stock
ShortMoney| Shorting endowment money
PersonalMoneyEndowment| | Personal money endowment for profit calculation
PersonalStockEndowment| Personal stock endowment for profit calculation
PaymentSubjectsTable| =if(Role==1|Role==2,\Payment,0);
basic compensation per period for traders for profit calculation (=2000 taler)
PaymentAuthoritySubjectsTable| =if(Role==3,\PaymentAuthority,0); basic compensation for per period for authorities for profit calculation (=2 €)
PD| Percentage difference
PDtimesMP| Percentage difference multiplicated with MP
DiffAvEndVermoegen| changed: now only difference between wealth in the beginning of the period and wealth in the end of the period (DiffAvEndVermoegen=Endvermögen-Anfangsvermögen)

timelog
|Variable| Content|
|ID| Unique identifier of this entry|
|Time| Time in seconds since start of treatment|
|Period| Period number of the record|
|Subject| Subject event was triggered by, (0) if not applicable|
|Event| Event being logged:|
||1. Program start.|
||2. Experimenter clicks OK to proceed from RoleInfo to next stage.|
||3. Experimenter forces exit to next stage from RoleInfo stage.|
||4. Experimenter forces exit to next period from RoleInfo stage.|
||5. Experimenter forces exit from the experiment from RoleInfo stage.|
||6. Subject clicks “OK” in RoleInfo stage.|
||7. Subject deletes buy order. Data[1] contains actionID_Del value of deleted contract.|
||8. Subject deletes sell order. Data[1] contains actionID_Del value of deleted contract.|
||9. Subject creates buy order. Data[1] contains actionID_C value of created contract.|
||10. Subject creates sell order. Data[1] contains actionID_C value of created contract.|
||11. Subject sells by market order. Data[1] contains contractID value of accepted offer.|
||12. Subject buys by market order. Data[1] contains contractID value of accepted offer.|
||13. Experimenter forces exit to next stage from Auction stage.|
||14. Experimenter forces exit to next period from Auction stage.|
||15. Experimenter forces exit from the experiment from Auction stage.|
||16. Observer subject clicks “Sort by trader code” button.|
||17. Observer subject clicks “Sort by price” button.|
||18. Observer subject clicks “Sort by quantity” button.|
||19. Calculator subject has solved question correctly. Data[1-3] contains num1-3 value, Data[4] contains answer. Correct answer=num1*(num2*10+num3).|
||20. Trader subject clicks OK in Prediction stage.|
||21. Experimenter forces exit to next stage from Prediction stage.|
||22. Experimenter forces exit to next period from Prediction stage.|
||23. Experimenter forces exit from the experiment from Prediction stage.|
||24. Observer clicks OK in Prediction->GeneralPrediction screen.|
||25. Observer clicks OK in Prediction->IndividualPrediction screen.|
||26. Subject clicks OK in History stage.|
||27. Experimenter forces exit to next stage from Punishment stage.|
||28. Experimenter forces exit to next period from Punishment stage.|
||29. Experimenter forces exit from the experiment from Punishment stage.|
||30. Experimenter forces exit to next stage from History stage.|
||31. Experimenter forces exit to next period from History stage.|
||32. Experimenter forces exit from the experiment from History stage.|
||33. Observer subject clicks “Sort by trader code” button.|
||34. Observer subject clicks “Sort by price” button.|
||35. Observer subject clicks “Sort by quantity” button.|
||36. Subject clicks “Market view” in history stage.|
||37. Subject clicks “Calculation and Prediction view” in history stage.|
||38. Subject clicks “Summary view” in history stage.|
||39. Observer clicks “Detailed results” in history stage.|
||40. Observer clicks “Summary view” in history stage.|
||41. Observer clicks to turn on Limit Order Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||42. Observer clicks to turn off Limit Order Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||43. Observer clicks to turn on Limit Trading Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||44. Observer clicks to turn off Limit Trading Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||45. Observer clicks to turn on Market Trading Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||46. Observer clicks to turn off Market Trading Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||47. Observer clicks to turn on Volume Bought in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||48. Observer clicks to turn off Volume Bought in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||49. Observer clicks to turn on Volume Sold in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||50. Observer clicks to turn off Volume Sold in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||51. Observer clicks to turn on Volume Difference in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||52. Observer clicks to turn off Volume Difference in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||53. Observer clicks to turn on Average Price in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||54. Observer clicks to turn off Average Price in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||55. Observer clicks to turn on Average Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||56. Observer clicks to turn off Average Volume in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||57. Observer clicks OK in Prediction->IndividualSelection screen.|
||58. Observer turns on offer volume help screen in auction stage.|
||59. Observer turns on offer induced trading volume help screen in auction stage.|
||60. Observer turns on market trade help screen in auction stage.|
||61. Observer turns on volume bought help screen in auction stage.|
||62. Observer turns on volume sold help screen in auction stage.|
||63. Observer turns on volume bought – volume sold help screen in auction stage.|
||64. Observer turns on average price help screen in auction stage.|
||65. Observer turns on average volume help screen in auction stage.|
||66. Observer turns off offer volume help screen in auction stage.|
||67. Observer turns off offer induced trading volume help screen in auction stage.|
||68. Observer turns off market trade help screen in auction stage.|
||69. Observer turns off volume bought help screen in auction stage.|
||70. Observer turns off volume sold help screen in auction stage.|
||71. Observer turns off volume bought – volume sold help screen in auction stage.|
||72. Observer turns off average price help screen in auction stage.|
||73. Observer turns off average volume help screen in auction stage.|
||74. Observer turns on cancelled order volume help screen in auction stage.|
||75. Observer turns off cancelled order volume help screen in auction stage.|
||76. Observer clicks to turn on Cancelled Orders in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||77. Observer clicks to turn off Cancelled Orders in auction stage. Data[1] contains cumulative time spent showing this item to date.|
||78. Observer turns on offer volume help screen in general prediction stage.|
||79. Observer turns on cancelled order volume help screen in general prediction stage.|
||80. Observer turns on offer induced trading volume help screen in general prediction stage.|
||81. Observer turns on market trade help screen in general prediction stage.|
||82. Observer turns on volume bought help screen in general prediction stage.|
||83. Observer turns on volume sold help screen in general prediction stage.|
||84. Observer turns on volume bought – volume sold help screen in general prediction stage.|
||85. Observer turns on average price help screen in general prediction stage.|
||86. Observer turns on average volume help screen in general prediction stage.|
||87. Observer turns off offer volume help screen in general prediction stage.|
||88. Observer turns off cancelled order volume help screen in general prediction.|
||89. Observer turns off offer induced trading volume help screen in general prediction stage.|
||90. Observer turns off market trade help screen in general prediction stage.|
||91. Observer turns off volume bought help screen in general prediction stage.|
||92. Observer turns off volume sold help screen in general prediction stage.|
||93. Observer turns off volume bought – volume sold help screen in general prediction stage.|
||94. Observer turns off average price help screen in general prediction stage.|
||95. Observer turns off average volume help screen in general prediction stage.|
||96. Observer turns on offer volume help screen in individual prediction stage.|
||97. Observer turns on cancelled order volume help screen in individual prediction stage.|
||98. Observer turns on offer induced trading volume help screen in individual prediction stage.|
||99. Observer turns on market trade help screen in individual prediction stage.|
||100. Observer turns on volume bought help screen in individual prediction stage.|
||101. Observer turns on volume sold help screen in individual prediction stage.|
||102. Observer turns on volume bought – volume sold help screen in individual prediction stage.|
||103. Observer turns on average price help screen in individual prediction stage.|
||104. Observer turns on average volume help screen in individual prediction stage.|
||105. Observer turns off offer volume help screen in individual prediction stage.|
||106. Observer turns off cancelled order volume help screen in individual prediction.|
||107. Observer turns off offer induced trading volume help screen in individual prediction stage.|
||108. Observer turns off market trade help screen in individual prediction stage.|
||109. Observer turns off volume bought help screen in individual prediction stage.|
||110. Observer turns off volume sold help screen in individual prediction stage.|
||111. Observer turns off volume bought – volume sold help screen in individual prediction stage.|
||112. Observer turns off average price help screen in individual prediction stage.|
||113. Observer turns off average volume help screen in individual prediction stage.|
||114. Observer turns on offer volume help screen in individual selection stage.|
||115. Observer turns on cancelled order volume help screen in individual selection stage.|
||116. Observer turns on offer induced trading volume help screen in individual selection stage.|
||117. Observer turns on market trade help screen in individual selection stage.|
||118. Observer turns on volume bought help screen in individual selection stage.|
||119. Observer turns on volume sold help screen in individual selection stage.|
||120. Observer turns on volume bought – volume sold help screen in individual selection stage.|
||121. Observer turns on average price help screen in individual selection stage.|
||122. Observer turns on average volume help screen in individual selection stage.|
||123. Observer turns off offer volume help screen in individual selection stage.|
||124. Observer turns off cancelled order volume help screen in individual selection.|
||125. Observer turns off offer induced trading volume help screen in individual selection stage.|
||126. Observer turns off market trade help screen in individual selection stage.|
||127. Observer turns off volume bought help screen in individual selection stage.|
||128. Observer turns off volume sold help screen in individual selection stage.|
||129. Observer turns off volume bought – volume sold help screen in individual selection stage.
||130. Observer turns off average price help screen in individual selection stage.|
||131. Observer turns off average volume help screen in individual selection stage.|
||132. Observer clicks to turn on Limit Order Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||133. Observer clicks to turn off Limit Order Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||134. Observer clicks to turn on Limit Trading Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||135. Observer clicks to turn off Limit Trading Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||136. Observer clicks to turn on Market Trading Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||137. Observer clicks to turn off Market Trading Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||138. Observer clicks to turn on Volume Bought in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||139. Observer clicks to turn off Volume Bought in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||140. Observer clicks to turn on Volume Sold in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||141. Observer clicks to turn off Volume Sold in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||142. Observer clicks to turn on Volume Difference in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||143. Observer clicks to turn off Volume Difference in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||144. Observer clicks to turn on Average Price in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||145. Observer clicks to turn off Average Price in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||146. Observer clicks to turn on Average Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||147. Observer clicks to turn off Average Volume in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||148. Observer clicks to turn on Cancelled Orders in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||149. Observer clicks to turn off Cancelled Orders in general prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||150. Observer clicks to turn on Limit Order Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||151. Observer clicks to turn off Limit Order Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||152. Observer clicks to turn on Limit Trading Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||153. Observer clicks to turn off Limit Trading Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||154. Observer clicks to turn on Market Trading Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||155. Observer clicks to turn off Market Trading Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||156. Observer clicks to turn on Volume Bought in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||157. Observer clicks to turn off Volume Bought in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||158. Observer clicks to turn on Volume Sold in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||159. Observer clicks to turn off Volume Sold in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||160. Observer clicks to turn on Volume Difference in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||161. Observer clicks to turn off Volume Difference in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||162. Observer clicks to turn on Average Price in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||163. Observer clicks to turn off Average Price in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||164. Observer clicks to turn on Average Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||165. Observer clicks to turn off Average Volume in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||166. Observer clicks to turn on Cancelled Orders in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||167. Observer clicks to turn off Cancelled Orders in individual prediction stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||168. Observer clicks to turn on Limit Order Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||169. Observer clicks to turn off Limit Order Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||170. Observer clicks to turn on Limit Trading Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||171. Observer clicks to turn off Limit Trading Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||172. Observer clicks to turn on Market Trading Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||173. Observer clicks to turn off Market Trading Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||174. Observer clicks to turn on Volume Bought in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||175. Observer clicks to turn off Volume Bought in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||176. Observer clicks to turn on Volume Sold in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||177. Observer clicks to turn off Volume Sold in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||178. Observer clicks to turn on Volume Difference in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||179. Observer clicks to turn off Volume Difference in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||180. Observer clicks to turn on Average Price in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||181. Observer clicks to turn off Average Price in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||182. Observer clicks to turn on Average Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||183. Observer clicks to turn off Average Volume in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||184. Observer clicks to turn on Cancelled Orders in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||185. Observer clicks to turn off Cancelled Orders in individual selection stage. Data[1] contains cumulative time spent showing this item in this stage to date.|
||186. RoleInfo stage begins.|
||187. Auction stage begins.|
||188. Prediction stage begins.|
||189. Punishment stage begins.|
||190. History stage begins.|
||191. FinalResults stage begins (final period only).|
|Data[…]| Array variable for saving additional data.|

## contracts
|Variable| Content|
---| ---|
|Period| Period number of the record.|
|Ask| Ask price. 1001=deleted or bid offer.|
|Bid| Bid price. -1=deleted or ask offer.
|qOfferB| Number of shares offered to be bought.|
|qOfferS| Number of shares offered to be sold.|
|qSell| Quantity to be sold by accepting an outstanding purchase offer from another subject.
|qBuy| Quantity to be bought by accepting an outstanding sales offer from another subject.
|contractID| ID of the contract.
|tradeID| ID of the transaction.|
|actionID_Del| Value of \numDelete when contract was deleted. Basically, the order in which contracts were deleted.|
|actionID_C| Value of \numActions when contract was created. Basically, the order in which contracts were created.|
|actionID_T| Value of \numActions when contract was transacted. Basically, the order in which contracts were transacted.|
|Tax| Tax to be paid on this contract (only filled when transacted).|
|Time1| Maximum of Time1 at the time of the contract’s creation. Used for graph.|
|p1| Used for graph.|
|LastPdown| |
|LastPup| |
|OutgoingMoneyCT| Money “bound” in outstanding buy offer.|
|OutgoingStockCT| Stock “bound” in outstanding sell offer.|
|q| Quantity of an offer which is transacted.|
|p| Price at which an offer is transacted.|
|Seller| Seller subject ID. -1=open, -2=deleted.|
|Buyer| Buyer subject ID. -1=open, -2=deleted.|
|Group| Group ID.|
|Maker| Maker Subject.|
|MakerTagNum| Maker TagNum.|
|BidDel| Bid price of deleted bid.|
|BASpreadDel| Bid-ask spread when contract was deleted. -1001=no spread.|
|BASpreladO| Bis-ask spread when contract was offered. -1001=no spread.|
|BestBid| Best bid (highest price) when contract was created.|
|BestAsk| Best ask (lowest price) when contract was created.|
|qOfferBHelp| Temporary variable containing qOfferB if offer acceptance is not for entire offer quantity.|
|pHelp| Temporary variable containing p if offer acceptance is not for entire offer quantity.|
|qSellHelp| Temporary variable containing qSell if offer acceptance is not for entire offer quantity.|
|BuyerHelp| Temporary variable containing Buyer if offer acceptance is not for entire offer quantity.|
|contractIDHelp| Temporary variable containing contractID if offer acceptance is not for entire offer quantity.|
|MakerTagNumHelp| Temporary variable containing MakerTagNum if offer acceptance is not for entire offer quantity.|

## infodata
(Life: Period)
|Variable| Content|
---| ---|
|Subject| Subject ID.|
|GroupNum| Subject GroupNum.|
|Contracts| Value of Contracts in subject’s record in the subjects table.|
|Volume| Value of Volume in subject’s record in the subjects table.|
|VolMarketOrders| Value of VolMarketOrders in subject’s record in the subjects table.|
|Transaktionen| Value of Transaktionen in subject’s record in the subjects table.|
|MarketOrders| Value of MarketOrders in subject’s record in the subjects table.|

## predictions
(Life: Period)
Help table containing, for every authority subject, one entry per subject in the same group. Used to let authority subject enter who they believe to be insiders and who they want to charge with being insiders.
|Variable| Content|
---| ---|
|Period| Period number.|
|GroupNum| Number of the group this prediction is for.|
|Subject| Subject number.|
|AuthoritySubject| Subject number of the authority subject this prediction is from.|
|IsInsider| 0 if subject is not informed, 1 if s/he is.|
|Suspected| 0 if authority believes that subject is not informed, 1 if s/he thinks it is.|
|Selected| 1 if authority charges that subject with being informed, 0 if authority does not.|
|TagNum| TagNum of Subject.|
|PayoffRelevant| If treatment PUN, 1=relevant for trader payoffs, 0=not relevant for trader payoffs (only 0 if multiple authorities in same group).|

## predictionhistory
(Life: Treatment)
Help table containing history of predictions, for display on history screen.
|Variable| Content|
---| ---|
|Period| Period number.|
|GroupNum| Number of the group this prediction is for.|
|Subject| Subject number.|
|AuthoritySubject| Subject number of the authority subject this prediction is from.|
|IsInsider| 0 if subject is not informed, 1 if s/he is.|
|Suspected| 0 if authority believes that subject is not informed, 1 if s/he thinks it is.|
|Selected| 1 if authority charges that subject with being informed, 0 if authority does not.|
|TagNum| TagNum of Subject.|
|PayoffRelevant| If treatment PUN, 1=relevant for trader payoffs, 0=not relevant for trader payoffs (only 0 if multiple authorities in same group).|
|GuessInsiders| Authority subject’s guess regarding the total number of insiders in the market. Copied from subjects table.|
|SumProfit| Authority subject’s period earnings. Copied from subjects table.|
|ProfitPeriod| Authority subject’s total payoff. Copied from subjects table.|

## history
(Life: Treatment)
Help table containing history of subjects’ results, for display on history screen.
|Variable| Content|
---| ---|
|Period| Period number.|
|Subject| Subject number.|
|GroupNum| Number of the group this subject was a member of.|
|Role| Subject’s role in the experiment: 0=calculation task, 1=uninformed, 2=insider, 3=authority.|
|Money| Subject’s money balance at the end of the period.|
|Stock| Subject’s stock balance at the end of the period.|
|BBV| Buyback value in the subject’s group.|
|CompensationReceived| Gain/loss from discovered insiders in the punishment treatments.|
|EndVermoegen| Subject’s wealth (money and stock) at the end of the period.|
|ProfitPeriodTrader| Period profit in the trader role.|
|GuessTraders| Trader’s guess of the total number of traders in the group.|
|NumTraders| Total number of traders in the subject’s group.|
|ProfitGuessNumTraders| Profit from trader’s guess of the total number of traders in the group.|
|NumInsiders| Number of insiders in the subject’s group.|
|GuessInsiders| Trader’s guess of the number of insiders in the group.|
|ProfitGuessNumInsiders| Profit from trader’s guess of the number of insiders in the group.|
|ProfitPeriodPredictor| Period profit from predictions.|
|RightAnswers| Correct answers in calculation task.|
|ProfitPeriodCalculator| Period profit in the calculator role.|
|SumProfit| Total profit for a period.|
|TradersSuspected| Total number of traders suspected as insiders by observer subject in this period.|
|TradersSelected| Total number of traders selected as insiders by observer subject in this period.|
|TradersCorrectlySuspected| Number of traders correctly suspectd as insiders by observer subject in this period.|
|TradersCorrectlySelected| Number of traders correctly selected as insiders by observer subject in this period.|
|ProfitPeriod| Observer subject’s period profit.|

## tagnums
(Life: Session)
|Variable| Content|
---| ---|
|TagID| ID number of the record.|
|TagNum| The tag number code. Tags consist of a letter and a number (e.g. R4). The code works as follows: The number is coded in the first digit, the letter in the second and third digits from the right. “R4” consists of the number 4 and the 18th letter in the alphabet and accordingly would be coded as 184.|

## markets
(Life: Treatment)
|Variable| Content|
---| ---|
|MarketID| ID number of the record. MarketID=0 is the training market.|
|GroupID[\MaxGroups]| Array containing the ID number of groups 1 and 2. This number corresponds to the GroupID variable in the groups table. It is -1 if the group is not active in this market.|

## structure
(Life: Treatment)
|Variable| Content|
---| ---|
|Period| Period number.|
|MarketID| ID number of the record. MarketID=0 is the training market.|
|IsTraining| 1 if training, 0 if not.|
|Treatment| Treatment ID. 0=Training, 1=BASE, 2=ID, 3=PUN, 4=MIX.|

## groups
(Life: Treatment)
|Variable| Content|
---| ---|
|GroupID| ID number of the record. This number corresponds to the GroupID array in the markets table. GroupID=0 is the training group.|
|NumInsiders| Number of insider subjects.|
|NumTraders| Total number of trader subjects.|

## summary
|Variable| Content|
---| ---|
|Period| Period number of the record.| 

## session
|Variable| Content|
---|---|
|Subject| Period number of the record.|
|FinalProfit| Profit to be paid (in EUR).|
|ShowUpFee| |
|ShowUpFeeInvested| |
|MoneyAdded| |
|MoneyToPay| |
|MoneyEarned| |
|Participate| Variable determining whether a subject sees a particular form of a questionnaire (1) or not (0). Reset to (1) for each new form i|n a questionnaire, but can be modified using a program in the form dialog.| 
