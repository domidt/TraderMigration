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
|embTreatment| Treatment index specifying the regulation in Phase 1 and 3, which is either``NN.RR'', ``RR.NN'', or ``RR.RR''.|
|history| Treatment index specifying the regulation in previous Phases, which is either ``1`` for markets in Phase 1, ``N`` (resp. ``R``) for markets in Phase 2 which succeeded NOREG (REG) markets, ``N.N``, ``N.R``, ``R.N``, or ``R.R`` for markets in Phase 3.| 
|Location| City index, which is either ``Graz`` or ``Vienna``.|
|BBV| Buyback Value.|
|BBVCent| Buyback Value centralized by the unconditional expected value of 57.5.|
|IsREG| Regulatory index, which is either ``REG`` for regulated markets or ``NOREG``.|
|othermarket| Regulatory index for the simultaneous opposite market, which is either ``REG`` for regulated markets or ``NOREG``.|
|REGBoth|
|REGSH|
                                                  "BestBid180", "BestAsk180", "BAspread180", "midpointBA180", "BestBid150", "BestAsk150", "BAspread150", "midpointBA150", "midpointBAavg150",
                                                  "BA_BBV", "BA_BBV150", "BA_BBV180", "lnBA_BBV",  "lnBA_BBV150", "lnBA_BBV180",  
                                                  "meanBestBid", "meanBestAsk", "meanBAspread", "meanmidpointBA", "meanBAspreadwins", "meanBAspreadwins2", 
                                                  "meanreturnsec", "meanreturn", "meanreturnwins", "meanreturnwins2", "obsreturn", "sdreturnsec", "volatility", "volatilitywins", "volatilitywins2", "meanPrice", "sdPrice",   
                                                  "Volume", "lagVolume", "VolumeUni", "VolumeInf", "Volume_Informed_Informed", "Volume_Uninformed_Informed", "Volume_Informed_Uninformed", "Volume_Uninformed_Uninformed",
                                                  "LimitVolume", "lagLimitVolume", "LimitVolumeInf", "LimitVolumeUni", "NumTransactions",
                                                  "Countoffers", "CountSelloffers", "CountBuyoffers", "CancelledVolume", "remainingVol", "SellLimitVolume","BuyLimitVolume",
                                                  "ProfitPotential", "GD", "GAD", "GADhyp", "rGAD", "RD", "RAD", "GD120", "GAD120", "RD120", "RAD120",  "Price", "Price120",
                                                  "marketshare", "lagmarketshare", "marketshareLimit", "lagmarketshareLimit", "AssetTurnover",  "TransactionSize", "LimitOrderTurnover",  "LimitOrderSize",
                                                  "odds", "lagodds", "oddsLimit", "lagoddsLimit", "oddsUninf", "oddsInf", "oddsInfmax", "oddsInfmax2", "oddsInfmax3","oddswins", "oddsLimitwins", "oddsInfwins", "oddsUninfwins",
                                                  #"geomodds_start", "geomodds_middle", "geomodds_end", "absgeomodds_start", "absgeomodds_middle", "absgeomodds_end", "geomoddsInf_start", "geomoddsInf_middle", "geomoddsInf_end", "geomoddsUni_start", "geomoddsUni_middle", "geomoddsUni_end",
                                                  #"geomoddswins_start", "geomoddswins_middle", "geomoddswins_end",  "geomoddsInfwins_start", "geomoddsInfwins_middle", "geomoddsInfwins_end", "geomoddsUniwins_start", "geomoddsUniwins_middle", "geomoddsUniwins_end",
                                                  #"geomoddsLimit_start", "geomoddsLimit_middle", "geomoddsLimit_end", "absgeomoddsLimit_start", "absgeomoddsLimit_middle", "absgeomoddsLimit_end", 
                                                  "unprofittime",  "RUPT", "shortsells", "marginbuysTaler", "marginbuysAsset", "marginbuys", "shortsells_Informed", "shortsells_Uninformed", "marginbuys_Informed", "marginbuys_Uninformed", "marginbuysAsset_Informed", "marginbuysAsset_Uninformed",
                                                  "NumActiveTrader", "NumTransactingTraders", "NumOfferingTraders", "ParticipationRate_Uninf", "ParticipationRate_Inf",
                                                  "HHInitialAssets", "HHEndAssets", "HHInitialEndowment", "HHEndEndowment", "HHEndEndowmentPun", "HHVolume", "HHPDbefore", "HHPDPun",
                                                  "HHI_InitialAssets","HHI_EndAssets","HHI_InitialEndowment", "HHI_EndEndowment", "HHI_EndEndowmentPun", "HHI_Volume", "HHI_PDbefore", "HHI_PDPun", 
                                                  "GiniPDbefore", "GiniPDPun", "GiniProfit", "GiniAssets", "GiniEndowment"
