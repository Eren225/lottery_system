ErenConfig = ErenConfig or {}

ErenConfig.closeTime = 3*60 // time for the menu to close

ErenConfig.winAmount = 5000 // amount won for the winner for 

ErenConfig.joinCost = 5000 // cost to join the lotery

ErenConfig.leaderWin = 1000 // how much does the winner earns per player

ErenConfig.tempsChoixGagnant = 3*60 // time before knowing who wins

ErenConfig.cooldownLotto = 6*60 // cooldown between each lotery

ErenConfig.prefix = "!loterie" // prefix to open the lotery menu as a leader

ErenConfig.leaderTeam = {  // teams allowed to open the menu
    [TEAM_CITIZEN] = true,
    [TEAM_HOBO] = true,


}
