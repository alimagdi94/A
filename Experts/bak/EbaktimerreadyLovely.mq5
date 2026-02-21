//+------------------------------------------------------------------+
//|                                                         A.mq5 |
//|                                    Professional Chart Trader - Compact A |
//|                  Production-Ready Delighter                      |
//|        Technical Excellence + Fast Execution (Auto-Pending)      |
//|        + Pin/Dock + Spread + R:R + Breakeven + Flash Feedback    |
//|        + Balance Display + "Ghost" Minimize Mode                 |
//+------------------------------------------------------------------+
#property version   "1.00"
#property description "Professional Chart Trader S. Production-Ready Delighter. Spread, R:R, Breakeven, Flash Feedback."
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

// --- TRADING INPUTS ---
input group "Risk Settings"
input double   InpDefRiskUnits= 0.001;     // Default Risk Units (1 unit = 0.1%)
input double   InpRiskStep    = 0.001;     // Risk Adjustment Step
input int      InpDefSL       = 5000;       // Default SL (points)
input int      InpDefTP       = 5000;       // Default TP (points)
input double   InpScalePct    = 50.0;     // Default Scale-out %
input int      InpAdjStep     = 200;        // Adjustment Step (points)
input int      InpEntryStep   = 50;         // Entry Line Step (points)
input int      InpMagic       = 7;    // Magic Number
input bool     InpIncLotStep  = false;     // Incremental Lot Increase (+1 step)

input group "Panel Colors"
input color    InpClrBg       = C'0,0,0';         // Panel Background (Deep Black)
input color    InpClrHeader   = C'20,20,20';      // Header Background (Dark Charcoal)
input color    InpClrGroupBox = C'20,20,20';      // Group Box Background (Dark Charcoal)
input color    InpClrBorder   = C'45,50,70';      // Border Color (Dark Blue-Grey)
input color    InpClrInput    = C'40,40,40';      // Input Box Background (Charcoal)
input color    InpClrText     = C'255,255,255';   // Label Text (White)
input color    InpClrTextIn   = C'255,255,255';   // Input Text Color (White)
input color    InpClrBuy      = C'60,60,60';      // Buy Button (Dark Grey)
input color    InpClrSell     = C'40,40,40';      // Sell Button (Charcoal)
input color    InpClrClose    = C'40,40,40';      // Close Button (Charcoal)
input color    InpClrScale    = C'40,40,40';      // Scale Out Button (Charcoal)
input color    InpClrReverse  = C'40,40,40';      // Reverse Button (Charcoal)
input color    InpClrActive   = C'100,100,100';   // Active Toggle (Medium Gray)
input color    InpClrInactive = C'20,20,20';      // Inactive Toggle (Dark Charcoal)
input color    InpClrBtnAdj   = C'40,40,40';      // +/- Adjuster Buttons (Charcoal)

input group "Visual Elements"
input color    InpClrAsgnSL   = C'40,40,40';      // Assign SL (Charcoal)
input color    InpClrAsgnTP   = C'40,40,40';      // Assign TP (Charcoal)
input color    InpClrTimer    = C'255,255,255';   // Timer Color (White)
input color    InpClrTimerTitle = C'180,180,180'; // Timer Title Color (Silver)
input color    InpClrSL       = C'255,255,255';   // SL Line Color (White)
input color    InpClrTP       = C'0,255,0';       // TP Line Color (Green)

input group "Information Colors"
input color    InpClrInfoPnLBase = C'0,0,0';      // PnL Base Color
input color    InpClrInfoPnLWin  = C'0,0,0';      // PnL Win Color
input color    InpClrInfoPnLLoss = C'0,0,0';      // PnL Loss Color
input color    InpClrInfoBal     = C'0,0,0';      // Balance Color
input color    InpClrInfoMarg    = C'0,0,0';      // Margin/Lot Cost Color
input color    InpClrInfoSprdBase= C'0,0,0';      // Spread Base Color
input color    InpClrInfoSprdGood= C'0,0,0';      // Spread Good Color
input color    InpClrInfoSprdMed = C'0,0,0';      // Spread Medium Color
input color    InpClrInfoSprdWide= C'0,0,0';      // Spread Wide Color
input color    InpClrInfoRRWin   = C'0,0,0';      // R:R Favorable Color
input color    InpClrInfoRRLoss  = C'0,0,0';      // R:R Unfavorable Color
input color    InpClrInfoPendBase= C'0,0,0';      // Pending Count Base Color
input color    InpClrInfoPendAct = C'0,0,0';      // Pending Count Active Color
input color    InpClrInfoPosBase = C'0,0,0';      // Position Base Color
input color    InpClrInfoPosBuy  = C'0,0,0';      // Position Buy Color
input color    InpClrInfoPosSell = C'0,0,0';      // Position Sell Color

input group "Panel Position & Size"
input int      InpPanelX      = 15;        // Panel X Position
input int      InpPanelY      = 50;        // Panel Y Position
input int      InpPanelW      = 270;       // Panel Width
input int      InpPanelH      = 340;       // Panel Height
input bool     InpShowBalance = true;      // Show Account Balance

input group "Keymapping"
input int      InpKeyDock     = 89;       // Dock Panel Hotkey ('Y' default)

// --- UI CONSTANTS ---
#define BTN_H        24
#define EDIT_H       18
#define FONT_MAIN    "Segoe UI"

// --- KEY MAP DEFINES ---
#define KEY_Q 81
#define KEY_W 87
#define KEY_E 69
#define KEY_R 82
#define KEY_T 84
#define KEY_F 70
#define KEY_G 71
#define KEY_H 72
#define KEY_J 74
#define KEY_K 75
#define KEY_L 76
#define KEY_Z 90
#define KEY_X 88
#define KEY_C 67
#define KEY_V 86
#define KEY_B 66
#define KEY_N 78
#define KEY_M 77
#define KEY_S 83
#define KEY_D 68
#define KEY_A 65
#define KEY_O 79
#define KEY_P 80
#define KEY_Y 89
#define KEY_U 85
#define KEY_I 73
#define KEY_TAB 9
#define KEY_BACKSLASH 220
#define KEY_COMMA     188
#define KEY_PERIOD    190

// --- OBJECT NAMES ---
#define PREFIX       "W_PRO_"
#define BG_PANEL     PREFIX + "BG"
#define LBL_T_TITLE  PREFIX + "TimerTitle"
#define BG_HEADER    PREFIX + "Head"
#define BG_INPUTS    PREFIX + "Inp"
#define LBL_PNL      PREFIX + "PnL"
#define LBL_BALANCE  PREFIX + "Bal"
#define LBL_TIMER    PREFIX + "Timer"
#define BTN_MINMAX   PREFIX + "Min"
#define BTN_RESET    PREFIX + "Reset"
#define BTN_DOCK     PREFIX + "Dock"

#define LBL_MARG_REQ PREFIX + "MargReq"
#define LBL_SPREAD   PREFIX + "Spread"
#define LBL_RR       PREFIX + "RR"
#define LBL_PEND     PREFIX + "PendCount"
#define LBL_POS_SUMMARY PREFIX + "PosSum"

#define LINE_SL      PREFIX + "LineSL"
#define LINE_TP      PREFIX + "LineTP"

// Inputs
#define EDIT_RISK    PREFIX + "EditRisk"
#define EDIT_LOT     PREFIX + "EditLot"
#define EDIT_SL      PREFIX + "EditSL"
#define EDIT_TP      PREFIX + "EditTP"
#define EDIT_SCALE   PREFIX + "EditScale" 

// Buttons
#define BTN_BUY      PREFIX + "Buy"
#define BTN_SELL     PREFIX + "Sell"
#define BTN_CLOSE    PREFIX + "Close"
#define BTN_SCALE    PREFIX + "Scale"   
#define BTN_REV      PREFIX + "Reverse"
#define BTN_C_BUY    PREFIX + "CloseBuy"
#define BTN_C_SELL   PREFIX + "CloseSell"
#define BTN_C_WIN    PREFIX + "CloseWin"
#define BTN_C_LOSS   PREFIX + "CloseLoss"
#define BTN_C_PEND   PREFIX + "ClosePend"
#define BTN_BE       PREFIX + "Breakeven"

// Toggles & Adjusters
#define BTN_USE_SL   PREFIX + "UseSL"     
#define BTN_USE_TP   PREFIX + "UseTP"     
#define BTN_SL_UP    PREFIX + "SL_Up"
#define BTN_SL_DN    PREFIX + "SL_Dn"
#define BTN_TP_UP    PREFIX + "TP_Up"
#define BTN_TP_DN    PREFIX + "TP_Dn"
#define BTN_RISK_UP  PREFIX + "Risk_Up"
#define BTN_RISK_DN  PREFIX + "Risk_Dn"
#define BTN_SCALE_UP PREFIX + "Scale_Up"
#define BTN_SCALE_DN PREFIX + "Scale_Dn"
#define BTN_ASGN_SL  PREFIX + "AsgnSL"
#define BTN_ASGN_TP  PREFIX + "AsgnTP"
#define BTN_DIR      PREFIX + "BtnDir"
#define BTN_MODE     PREFIX + "BtnMode"
#define LINE_ENTRY   PREFIX + "LineEntry"
#define BTN_ENTRY_UP PREFIX + "Entry_Up"
#define BTN_ENTRY_DN PREFIX + "Entry_Dn"

// --- MANUAL LOT MODE TOGGLE ---
#define BTN_TOGGLE_MODE PREFIX + "BtnToggleMode"
// --- GLOBAL STATE VARS (Performance Cache) ---
bool IsPanelVisible = true;
bool IsMinimized    = false;
bool IsLongMode     = true;
bool EnableSL       = true;  
bool EnableTP       = true;
int  PanelX         = 15;
int  PanelY         = 40;
int  TradeSequence  = 0;

// Internal State Cache (Avoids String Conversions)
double g_RiskUnits;
double g_LotSize;
long   g_SL_Points;
long   g_TP_Points;
double g_ScalePct;

// --- OPTIMIZATION CACHE ---
double last_PnL       = -DBL_MAX;
int    last_Positions = -1;
double last_PnLState  = -99;
bool   last_AlgoState = false;
double last_Mid       = 0;
int    last_SL        = -1;
int    last_TP        = -1;
double last_Lot       = -1;
bool   last_Mode      = true;

// --- NEW Execution Types ---
enum ENUM_EXEC_MODE { MODE_MARKET=0, MODE_PENDING=1 };
ENUM_EXEC_MODE g_ExecMode = MODE_MARKET;
double g_PendingPrice = 0; // Absolute price for pending execution
int    last_ExecMode = -1;

// --- Manual Lot Mode ---
bool g_IsManualLotMode = true; // Default Mode

// --- Dock State ---
bool g_IsDocked       = false; // When true, panel is locked and drag is prevented

// --- Drag State ---
bool g_IsDragging     = false;
int  g_DragOffsetX    = 0;
int  g_DragOffsetY    = 0;
bool g_ChartScrollSaved = true;  // Saved chart scroll state before drag

// --- Breakeven Key ---
#define KEY_1 49

// --- Click-and-Hold Repeat ---
int    g_RepeatAction  = 0;     // 0=none, see REPEAT_* defines below
bool   g_RepeatActive  = false; // Is repeat firing?
#define REPEAT_NONE      0
#define REPEAT_RISK_UP   1
#define REPEAT_RISK_DN   2
#define REPEAT_SL_UP     3
#define REPEAT_SL_DN     4
#define REPEAT_TP_UP     5
#define REPEAT_TP_DN     6
#define REPEAT_SCALE_UP  7
#define REPEAT_SCALE_DN  8
#define REPEAT_ENTRY_UP  9
#define REPEAT_ENTRY_DN  10

//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   trade.SetExpertMagicNumber(InpMagic);
   trade.SetAsyncMode(true);
   trade.SetDeviationInPoints(10);
   
   PanelX = InpPanelX;
   PanelY = InpPanelY;
   
   // Initialize State from Inputs
   g_RiskUnits = InpDefRiskUnits;
   g_SL_Points = InpDefSL;
   g_TP_Points = InpDefTP;
   g_ScalePct  = InpScalePct;
   g_LotSize   = 0.01; // Default Manual Lot Size
   g_IsManualLotMode = true; // Enforce default
   
   // Enable mouse move events for drag-and-drop
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   
   CreateGUI();
   UpdateToggleState(); 
   
   UpdateCalculatedLot(); // Initial calculation
   UpdateRealtimeStatistics(); 
   ChartRedraw();
   
   EventSetTimer(1); 
   
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
      Alert("Warning: Enable 'Algo Trading' button!");
   }
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Cleanup                                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Reset drag state and restore chart scrolling
   if(g_IsDragging) {
      g_IsDragging = false;
      ChartSetInteger(0, CHART_MOUSE_SCROLL, g_ChartScrollSaved);
   }
   ObjectsDeleteAll(0, PREFIX);
   EventKillTimer();
}

//+------------------------------------------------------------------+
//| OnTimer - Updates Candle Timer & Slow Update Tasks               |
//+------------------------------------------------------------------+
void OnTimer()
{
   // --- Click-and-Hold Repeat ---
   if(g_RepeatActive && g_RepeatAction != REPEAT_NONE) {
      FireRepeatAction();
      ChartRedraw();
      return; 
   }
   
   if(!IsPanelVisible) return;
   
   // --- Candle Timer ---
   datetime timeCurrent = TimeCurrent();
   datetime timeBar = iTime(_Symbol, _Period, 0);
   int secondsLeft = (int)(timeBar + PeriodSeconds(_Period) - timeCurrent);
   
   if(secondsLeft < 0) secondsLeft = 0;
   
   string timerText;
   if(_Period >= PERIOD_D1) {
      int hours = secondsLeft / 3600;
      int minutes = (secondsLeft % 3600) / 60;
      int seconds = secondsLeft % 60;
      timerText = StringFormat("%02d:%02d:%02d", hours, minutes, seconds);
   } else {
      int minutes = secondsLeft / 60;
      int seconds = secondsLeft % 60;
      timerText = StringFormat("%02d:%02d", minutes, seconds);
   }
   
   if(ObjectFind(0, LBL_TIMER) >= 0) {
      ObjectSetString(0, LBL_TIMER, OBJPROP_TEXT, timerText);
   }

   // Skip slow updates if minimized, but always update the timer above
   if(IsMinimized) {
      ChartRedraw();
      return;
   }
   
   // Force Sync occasionally to ensure PnL/Status match on idle ticks
   UpdateRealtimeStatistics();
   UpdateSpread();
   UpdatePendingCount();
   UpdatePositionSummary();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Fast Update Loop (OnTick)                                        |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsPanelVisible) return;
   
   bool needsRedraw = false;
   
   // 1. Update PnL (Fast)
   needsRedraw |= UpdatePnL();
   
   // 2. Update Header Status (Fast)
   needsRedraw |= UpdateHeader();
   
   // 3. Update Visual Guide Lines (Price Dependent)
   needsRedraw |= DrawVisualLines();
   
   // 4. Check for Balance Change to trigger Lot Recalc (Optimization)
   static double lastBalance = 0;
   double currBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   if(currBalance != lastBalance) {
      UpdateCalculatedLot();
      lastBalance = currBalance;
      needsRedraw = true; // Lot change affects text
   }
   
   if(needsRedraw) ChartRedraw();
}

//+------------------------------------------------------------------+
//| Update PnL Only                                                  |
//+------------------------------------------------------------------+
bool UpdatePnL() {
   
   double pnl = AccountInfoDouble(ACCOUNT_PROFIT);
   
   // Count open positions for this symbol
   int posCount = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      if(PositionGetSymbol(i) == _Symbol) posCount++;
   }
   
   // Optimization: Only update if value changed
   if(pnl != last_PnL || posCount != last_Positions) {
       if(ObjectFind(0, LBL_PNL) >= 0) {
          string pnlText = "PnL: " + DoubleToString(pnl, 2);
          if(posCount > 0) pnlText += " (" + IntegerToString(posCount) + ")";
          ObjectSetString(0, LBL_PNL, OBJPROP_TEXT, pnlText);
          
          // Color: Green when profit, Red when loss, White when flat
          color pnlColor = InpClrInfoPnLBase; // Default
          if(posCount > 0) {
             if(pnl > 0) pnlColor = InpClrInfoPnLWin;       // Green/Win
             else if(pnl < 0) pnlColor = InpClrInfoPnLLoss;  // Red/Loss
          }
          ObjectSetInteger(0, LBL_PNL, OBJPROP_COLOR, pnlColor);
       }
       last_PnL = pnl;
       last_Positions = posCount;
       return true; 
   }
   return false;
}

//+------------------------------------------------------------------+
//| Update Header                                                     |
//+------------------------------------------------------------------+
bool UpdateHeader() {
   bool changed = false;
   
   // Use position count from UpdatePnL (runs first in tick cycle via last_Positions)
   double pnl = AccountInfoDouble(ACCOUNT_PROFIT);
   double pnlState = (pnl >= 0) ? 1 : -1;
   
   // Reset TradeSequence when all positions closed
   if(last_Positions == 0 && pnlState != last_PnLState) {
       TradeSequence = 0;
       changed = true;
   }
   last_PnLState = pnlState;
   return changed;
}

//+------------------------------------------------------------------+
//| UpdateRealtimeStatistics - Helper                                |
//+------------------------------------------------------------------+
void UpdateRealtimeStatistics()
{
   UpdatePnL();
   UpdateHeader();
   UpdateMarginInfo();
   DrawVisualLines();
   UpdateRR();
   UpdateBalance();
}

void UpdateBalance() {
   if(!IsPanelVisible || !InpShowBalance) return;
   if(ObjectFind(0, LBL_BALANCE) >= 0) {
      double bal = AccountInfoDouble(ACCOUNT_BALANCE);
      string balText = "";
      // Compact formatting for large accounts to prevent header overflow
      if(bal > 99999) balText = "Bal: $" + DoubleToString(bal, 0);
      else balText = "Bal: $" + DoubleToString(bal, 2);
      
      ObjectSetString(0, LBL_BALANCE, OBJPROP_TEXT, balText);
      ObjectSetInteger(0, LBL_BALANCE, OBJPROP_COLOR, InpClrInfoBal);
   }
}

//+------------------------------------------------------------------+
//| Chart Event Handler                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   bool isAlgoOn = TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);

   if(id == CHARTEVENT_KEYDOWN) {
      int key = (int)lparam;
      if(key == InpKeyDock) {
         g_IsDocked = !g_IsDocked;
         if(ObjectFind(0, BTN_DOCK) >= 0) ObjectSetString(0, BTN_DOCK, OBJPROP_TEXT, g_IsDocked ? "L" : "U");
         ChartRedraw();
         return;
      }
      switch(key) {
         case KEY_Q: if(isAlgoOn) ExecuteOrder(ORDER_TYPE_BUY); break;
         case KEY_W: if(isAlgoOn) ExecuteOrder(ORDER_TYPE_SELL); break;
         case KEY_E: ClosePositions(0); break;                          // Close All
         case KEY_R: TogglePanel(); break;
         case KEY_V: ReversePositions(); break;
         case KEY_S: ScaleOut(); break;
         case KEY_O: AdjustLotOrRisk(-1); break;                        // Decrements Lot/Risk depending on mode
         case KEY_P: AdjustLotOrRisk(1); break;                         // Increments Lot/Risk depending on mode
         case KEY_BACKSLASH: ToggleLotMode(); break;                    // Toggle Risk/Lot Mode
         case KEY_J: EnableSL = !EnableSL; UpdateToggleState(); break;
         case KEY_K: AdjustEdit(EDIT_SL, -InpAdjStep); break;
         case KEY_L: AdjustEdit(EDIT_SL, InpAdjStep); break;
         case KEY_B: EnableTP = !EnableTP; UpdateToggleState(); break;
         case KEY_N: AdjustEdit(EDIT_TP, -InpAdjStep); break;
         case KEY_M: AdjustEdit(EDIT_TP, InpAdjStep); break;
         case KEY_U: AdjustScale(-5); break;
         case KEY_I: AdjustScale(5); break;
         case KEY_G: AssignSLToAll(); break;
         case KEY_H: AssignTPToAll(); break;
         case KEY_F: { IsMinimized = !IsMinimized; ObjectsDeleteAll(0, PREFIX); CreateGUI(); UpdateToggleState(); } break;
         case KEY_Z: ClosePositions(1); break;                          // Close Buys
         case KEY_X: ClosePositions(2); break;                          // Close Sells
         case KEY_A: ClosePending(); break;                             // Cancel Pending

         case KEY_COMMA: AdjustEntryLine(-InpEntryStep); break;         // Move Entry Down
         case KEY_PERIOD: AdjustEntryLine(InpEntryStep); break;         // Move Entry Up

         case KEY_TAB: { // Toggle Mode
            if(g_ExecMode == MODE_MARKET) g_ExecMode = MODE_PENDING;
            else g_ExecMode = MODE_MARKET;
            ObjectsDeleteAll(0, PREFIX + "Line");
            UpdateToggleState();
         } break;
          case KEY_C: ClosePositions(3); break;                          // Close Win
          case KEY_D: ClosePositions(4); break;                          // Close Loss
          case KEY_1: MoveToBreakeven(); break;                          // Breakeven
      }
      ChartRedraw();
   }

   if(id == CHARTEVENT_OBJECT_CLICK) {
      if(sparam == BTN_MINMAX)    { IsMinimized = !IsMinimized; ObjectsDeleteAll(0, PREFIX); CreateGUI(); UpdateToggleState(); ResetBtn(BTN_MINMAX); }
      else if(sparam == BTN_RESET) { PanelX = InpPanelX; PanelY = InpPanelY; ObjectsDeleteAll(0, PREFIX); CreateGUI(); UpdateToggleState(); UpdateCalculatedLot(); }
      else if(sparam == BTN_DOCK) { g_IsDocked = !g_IsDocked; ObjectSetString(0, BTN_DOCK, OBJPROP_TEXT, g_IsDocked ? "L" : "U"); ResetBtn(BTN_DOCK); }
      else if(sparam == BTN_BUY)  { if(isAlgoOn) ExecuteOrder(ORDER_TYPE_BUY); ResetBtn(BTN_BUY); }
      else if(sparam == BTN_SELL) { if(isAlgoOn) ExecuteOrder(ORDER_TYPE_SELL); ResetBtn(BTN_SELL); }
      else if(sparam == BTN_CLOSE){ ClosePositions(0); ResetBtn(BTN_CLOSE); }
      else if(sparam == BTN_C_BUY){ ClosePositions(1); ResetBtn(BTN_C_BUY); }
      else if(sparam == BTN_C_SELL){ ClosePositions(2); ResetBtn(BTN_C_SELL); }
      else if(sparam == BTN_C_WIN){ ClosePositions(3); ResetBtn(BTN_C_WIN); }
      else if(sparam == BTN_C_LOSS){ ClosePositions(4); ResetBtn(BTN_C_LOSS); }
      else if(sparam == BTN_C_PEND){ ClosePending(); ResetBtn(BTN_C_PEND); }
      else if(sparam == BTN_REV)  { ReversePositions(); ResetBtn(BTN_REV); }
      else if(sparam == BTN_SCALE){ ScaleOut(); ResetBtn(BTN_SCALE); }
      else if(sparam == BTN_USE_SL) { EnableSL = !EnableSL; UpdateToggleState(); ResetBtn(BTN_USE_SL); }
      else if(sparam == BTN_USE_TP) { EnableTP = !EnableTP; UpdateToggleState(); ResetBtn(BTN_USE_TP); }
       else if(sparam == BTN_SL_UP) { ResetBtn(BTN_SL_UP); }
       else if(sparam == BTN_SL_DN) { ResetBtn(BTN_SL_DN); }
       else if(sparam == BTN_TP_UP) { ResetBtn(BTN_TP_UP); }
       else if(sparam == BTN_TP_DN) { ResetBtn(BTN_TP_DN); }
       else if(sparam == BTN_RISK_UP) { ResetBtn(BTN_RISK_UP); }
       else if(sparam == BTN_RISK_DN) { ResetBtn(BTN_RISK_DN); }
       else if(sparam == BTN_SCALE_UP) { ResetBtn(BTN_SCALE_UP); }
       else if(sparam == BTN_SCALE_DN) { ResetBtn(BTN_SCALE_DN); }
       else if(sparam == BTN_ENTRY_UP) { ResetBtn(BTN_ENTRY_UP); }
       else if(sparam == BTN_ENTRY_DN) { ResetBtn(BTN_ENTRY_DN); }
      else if(sparam == BTN_TOGGLE_MODE) { ToggleLotMode(); ResetBtn(BTN_TOGGLE_MODE); }

      else if(sparam == BTN_MODE) {
         if(g_ExecMode == MODE_MARKET) g_ExecMode = MODE_PENDING;
         else g_ExecMode = MODE_MARKET;
         
         // Force hard refresh of lines
         ObjectsDeleteAll(0, PREFIX + "Line"); 
         UpdateToggleState();
         ResetBtn(BTN_MODE);
      }
       else if(sparam == BTN_ASGN_SL) { AssignSLToAll(); ResetBtn(BTN_ASGN_SL); }
       else if(sparam == BTN_ASGN_TP) { AssignTPToAll(); ResetBtn(BTN_ASGN_TP); }
       else if(sparam == BTN_BE) { MoveToBreakeven(); ResetBtn(BTN_BE); }
      ChartRedraw();
   }
   
   // Handle Line Dragging - Sync back to State
   if(id == CHARTEVENT_OBJECT_DRAG) {
      bool changed = false;
      if(sparam == LINE_ENTRY) {
         double price = ObjectGetDouble(0, LINE_ENTRY, OBJPROP_PRICE);
         g_PendingPrice = price;
         changed = true;
         DrawVisualLines(true);
      }
      if(sparam == LINE_SL) {
         double price = ObjectGetDouble(0, LINE_SL, OBJPROP_PRICE);
         // RELATIVE TO ENTRY!
         double refPrice = 0;
         if(g_ExecMode == MODE_MARKET) {
             double curAsk = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
             double curBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
             double mid = (curAsk + curBid) / 2.0;

             bool newMode = (price < mid); // SOUTH = BUY (true), NORTH = SELL (false)
             if(newMode != IsLongMode) {
                 IsLongMode = newMode;
                 UpdateToggleState(); 
             }
             refPrice = IsLongMode ? curAsk : curBid;
         } else {
             refPrice = ObjectGetDouble(0, LINE_ENTRY, OBJPROP_PRICE);
             bool newMode = (price < refPrice); // SOUTH = BUY, NORTH = SELL
             if(newMode != IsLongMode) {
                 IsLongMode = newMode;
                 UpdateToggleState();
             }
         }
         
         g_SL_Points = (long)(MathAbs(refPrice - price) / _Point);
         ObjectSetString(0, EDIT_SL, OBJPROP_TEXT, IntegerToString(g_SL_Points));
         changed = true;
         DrawVisualLines(true);
      }
      if(sparam == LINE_TP) {
         double price = ObjectGetDouble(0, LINE_TP, OBJPROP_PRICE);
         // RELATIVE TO ENTRY!
         double refPrice = 0;
         if(g_ExecMode == MODE_MARKET) {
             double curAsk = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
             double curBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
             double mid = (curAsk + curBid) / 2.0;

             bool newMode = (price > mid); // NORTH = BUY_TP (true), SOUTH = SELL_TP (false)
             if(newMode != IsLongMode) {
                 IsLongMode = newMode;
                 UpdateToggleState(); 
             }
             refPrice = IsLongMode ? curAsk : curBid;
         } else {
             refPrice = ObjectGetDouble(0, LINE_ENTRY, OBJPROP_PRICE);
             bool newMode = (price > refPrice); // NORTH = BUY_TP, SOUTH = SELL_TP
             if(newMode != IsLongMode) {
                 IsLongMode = newMode;
                 UpdateToggleState();
             }
         }
         
         g_TP_Points = (long)(MathAbs(refPrice - price) / _Point);
         ObjectSetString(0, EDIT_TP, OBJPROP_TEXT, IntegerToString(g_TP_Points));
         changed = true;
         DrawVisualLines(true);
      }
      if(changed) ChartRedraw(); 
      // Note: We don't call DrawVisualLines here to avoid fighting the drag
   }

   // Handle Manual edits in Box
   if(id == CHARTEVENT_OBJECT_ENDEDIT) {
      if(sparam == EDIT_RISK) { 
         if(g_IsManualLotMode) {
             g_LotSize = StringToDouble(ObjectGetString(0, EDIT_RISK, OBJPROP_TEXT));
             UpdateCalculatedLot(); // Refresh UI/Margin
         } else {
             g_RiskUnits = StringToDouble(ObjectGetString(0, EDIT_RISK, OBJPROP_TEXT)); 
             UpdateCalculatedLot(); 
         }
      }
      else if(sparam == EDIT_SL) { 
           g_SL_Points = StringToInteger(ObjectGetString(0, EDIT_SL, OBJPROP_TEXT)); 
           DrawVisualLines(true); 
      }
      else if(sparam == EDIT_TP) { 
           g_TP_Points = StringToInteger(ObjectGetString(0, EDIT_TP, OBJPROP_TEXT)); 
           DrawVisualLines(true); 
      }
      else if(sparam == EDIT_SCALE) { g_ScalePct = StringToDouble(ObjectGetString(0, EDIT_SCALE, OBJPROP_TEXT)); }
      
      ChartRedraw();
   }
   
   // --- DRAG-AND-DROP: Panel Movement via Mouse ---
   if(id == CHARTEVENT_MOUSE_MOVE && IsPanelVisible) {
      int mouseX = (int)lparam;
      int mouseY = (int)dparam;
      int mouseState = (int)StringToInteger(sparam); 
       bool leftDown = (mouseState & 1) != 0;
       
       // --- Click-and-Hold Repeat via hit-testing ---
       if(leftDown && !g_IsDragging && !IsMinimized) {
          int hitAction = HitTestAdjuster(mouseX, mouseY);
          if(hitAction != REPEAT_NONE && !g_RepeatActive) {
             StartRepeat(hitAction);
             // Fire immediate first action
             FireRepeatAction();
             ChartRedraw();
          }
       }
       
       // --- Stop repeat when mouse is released ---
       if(!leftDown && g_RepeatActive) {
          StopRepeat();
       }
       
        int panelH = IsMinimized ? 55 : InpPanelH;
      
       // HOVER PREVIEW LOGIC REMOVED — was auto-switching BUY/SELL preview
       // on mouse move, fighting the user's explicit T-key / button choice.
      
      if(leftDown && !g_IsDragging && !g_IsDocked) {
         // Check if mouse is within the panel bounds to start drag (blocked when docked)
         if(mouseX >= PanelX && mouseX <= PanelX + InpPanelW &&
            mouseY >= PanelY && mouseY <= PanelY + panelH) {
            g_IsDragging = true;
            g_DragOffsetX = mouseX - PanelX;
            g_DragOffsetY = mouseY - PanelY;
            // Suppress chart scrolling during drag
            g_ChartScrollSaved = (bool)ChartGetInteger(0, CHART_MOUSE_SCROLL);
            ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
         }
      }
      
      if(g_IsDragging) {
         if(leftDown) {
            // Move panel to follow mouse
            int newX = mouseX - g_DragOffsetX;
            int newY = mouseY - g_DragOffsetY;
            
            // Clamp to chart boundaries
            int chartW = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
            int chartH = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
            if(newX < 0) newX = 0;
            if(newY < 0) newY = 0;
            if(newX + InpPanelW > chartW) newX = chartW - InpPanelW;
            if(newY + panelH > chartH) newY = chartH - panelH;
            
            // Only rebuild if position actually changed
            if(newX != PanelX || newY != PanelY) {
               PanelX = newX;
               PanelY = newY;
               CreateGUI();
               ChartRedraw();
            }
         } else {
            // Mouse released — end drag
            g_IsDragging = false;
            ChartSetInteger(0, CHART_MOUSE_SCROLL, g_ChartScrollSaved);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Logic Handlers (Using State Vars)                                |
//+------------------------------------------------------------------+
void AdjustLotOrRisk(int direction) {
   if(g_IsManualLotMode) {
       // Manual Lot Adjustment
       double minPool = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
       double maxPool = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
       double stepPool = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
       
       // Change by 0.01 regardless of step if possible, otherwise by step
       double change = (stepPool > 0.01) ? stepPool : 0.01;
       
       g_LotSize += (direction * change);
       
       // Snap to step
       if(stepPool > 0) g_LotSize = MathFloor(g_LotSize / stepPool + 0.5) * stepPool;
       
       if(g_LotSize < minPool) g_LotSize = minPool;
       if(g_LotSize > maxPool) g_LotSize = maxPool;
       
       ObjectSetString(0, EDIT_RISK, OBJPROP_TEXT, DoubleToString(g_LotSize, 2));
       UpdateCalculatedLot(); // Update margin/info
   } else {
       // Risk Adjustment
       g_RiskUnits += (direction * InpRiskStep);
       if(g_RiskUnits < 0.001) g_RiskUnits = 0.001;
       
       ObjectSetString(0, EDIT_RISK, OBJPROP_TEXT, DoubleToString(g_RiskUnits, 3));
       UpdateCalculatedLot();
   }
}

void ToggleLotMode() {
   g_IsManualLotMode = !g_IsManualLotMode;
   // Refresh UI
   if(ObjectFind(0, BTN_TOGGLE_MODE) >= 0) {
        ObjectSetString(0, BTN_TOGGLE_MODE, OBJPROP_TEXT, g_IsManualLotMode ? "Manual Lot [\\] (O/P)" : "Risk Units [\\] (O/P)");
   }
   
   // Refresh Value in Edit Box
   if(g_IsManualLotMode) {
       ObjectSetString(0, EDIT_RISK, OBJPROP_TEXT, DoubleToString(g_LotSize, 2));
   } else {
       ObjectSetString(0, EDIT_RISK, OBJPROP_TEXT, DoubleToString(g_RiskUnits, 3));
   }
   
   // Hard refresh of inputs to reset read-only status or labels if we change them heavily
   // For now, EDIT_RISK is used for both. EDIT_LOT acts as secondary info.
   UpdateCalculatedLot();
}

void UpdateCalculatedLot() {
   if(IsMinimized) return;
   
   double min = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double max = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    
   if(!g_IsManualLotMode) {
       // --- RISK MODE: Calculate Lot from Risk ---
       double accountCapital = AccountInfoDouble(ACCOUNT_BALANCE);
       double riskPct = g_RiskUnits * 0.1; 
       double riskAmount = accountCapital * (riskPct / 100.0);
       double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
       double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
       double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
       
       if(tickValue != 0 && tickSize != 0) {
           // FIXED RISK BASE: 1000 points (normalized standard) or specific 100
           double lot = riskAmount / (100.0 * point * (tickValue / tickSize));
           
            if(lot < min) lot = min;
            if(lot > max) lot = max;
            if(step > 0) lot = MathFloor(lot / step + 0.5) * step;
           
           if(InpIncLotStep && TradeSequence > 0) {
              lot += (TradeSequence * step);
              if(lot > max) lot = max;
           }
           g_LotSize = lot; // Update State
       }
   } else {
       // --- MANUAL MODE: Just validate Lot ---
       // g_LotSize is already set by AdjustLotOrRisk or Edit box
       if(g_LotSize < min) g_LotSize = min;
       if(g_LotSize > max) g_LotSize = max;
       if(step > 0) g_LotSize = MathFloor(g_LotSize / step + 0.5) * step;
   }
   // Update Secondary Info (Right Box)
   // In Manual Mode, maybe show Risk %? Or just show the same Lot Size?
   // For now, keeping it as Lot Size display (consistent with X.mq5 behavior)
   ObjectSetString(0, EDIT_LOT, OBJPROP_TEXT, DoubleToString(g_LotSize, 2));
   
   // Update Primary Input (Left Box) if in Manual Mode to ensure valid step
   if(g_IsManualLotMode) {
       ObjectSetString(0, EDIT_RISK, OBJPROP_TEXT, DoubleToString(g_LotSize, 2));
   }

   UpdateMarginInfo();
   UpdateBalance(); // Sync balance text
   DrawVisualLines(); // Sync profit tooltips
}

void UpdateMarginInfo() {
   if(!IsPanelVisible) return;
   if(g_LotSize <= 0) return;
   
   double requiredMargin = 0;
   // This is the heavy function, called only when Lot changes or Timer
   if(!OrderCalcMargin(ORDER_TYPE_BUY, _Symbol, g_LotSize, SymbolInfoDouble(_Symbol, SYMBOL_ASK), requiredMargin)) {
       requiredMargin = 0;
   }
   
   if(ObjectFind(0, LBL_MARG_REQ) >= 0) {
       ObjectSetString(0, LBL_MARG_REQ, OBJPROP_TEXT, "$" + DoubleToString(requiredMargin, 2));
   }
}

void AdjustScale(double change) {
   g_ScalePct += change;
   if(g_ScalePct < 5) g_ScalePct = 5;
   if(g_ScalePct > 100) g_ScalePct = 100;
   
   ObjectSetString(0, EDIT_SCALE, OBJPROP_TEXT, DoubleToString(g_ScalePct, 0));
}

void ScaleOut() {
   if(g_ScalePct <= 0 || g_ScalePct > 100) return;
   
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
         double vol = PositionGetDouble(POSITION_VOLUME);
         double closeVol = vol * (g_ScalePct / 100.0);
         double min = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
         double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
         if(step > 0) closeVol = MathFloor(closeVol / step) * step;
         if(closeVol >= min) trade.PositionClosePartial(ticket, closeVol);
      }
   }
}

//+------------------------------------------------------------------+
//| Adjust Entry Line Helper (Absolute Price)                        |
//+------------------------------------------------------------------+
void AdjustEntryLine(int step) {
   if(g_ExecMode == MODE_MARKET) return;
   
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   if(point == 0) return;

   // Initialize if 0
   if(g_PendingPrice == 0) g_PendingPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK) + (100 * point);

   // Apply Step
   g_PendingPrice += (step * point);
   
   // Normalize
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   g_PendingPrice = NormalizeDouble(g_PendingPrice, digits);
   
   // Sync SL/TP State? 
   // We effectively keep SL/TP Points relative. No change needed to points.
   // But we should redraw.
   
   DrawVisualLines(true);
}

//+------------------------------------------------------------------+
//| Adjust Edit Helper (Updates State & GUI)                         |
//+------------------------------------------------------------------+
void AdjustEdit(string name, int step) {
   if(name == EDIT_SL) {
      g_SL_Points += step;
      if(g_SL_Points < 0) g_SL_Points = 0;
      ObjectSetString(0, name, OBJPROP_TEXT, IntegerToString(g_SL_Points));
   }
   else if(name == EDIT_TP) {
      g_TP_Points += step;
      if(g_TP_Points < 0) g_TP_Points = 0;
      ObjectSetString(0, name, OBJPROP_TEXT, IntegerToString(g_TP_Points));
   }
   
   DrawVisualLines(true);
   UpdateRR();
}

void AssignSLToAll() {
   if(g_SL_Points <= 0) return;

   // FIX: Use visual line price directly for positions (eliminates gap between line and order)
   bool useVisualSL = (ObjectFind(0, LINE_SL) >= 0);
   double visualSLPrice = useVisualSL ? ObjectGetDouble(0, LINE_SL, OBJPROP_PRICE) : 0;
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);

   // 1. Assign to Active Positions
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
         double newSL = 0;
         if(useVisualSL) {
            newSL = visualSLPrice;
         } else {
            long type = PositionGetInteger(POSITION_TYPE);
            double refPrice = (type == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
            newSL = (type == POSITION_TYPE_BUY) ? refPrice - g_SL_Points*_Point : refPrice + g_SL_Points*_Point;
         }
         newSL = NormalizeDouble(newSL, digits);
         if(!trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP)))
            Print("AssignSL Error: ", GetLastError());
      }
   }

   // 2. Assign to Pending Orders (use order's own open price as reference)
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL) == _Symbol) {
         long type = OrderGetInteger(ORDER_TYPE);
         double openPrice = OrderGetDouble(ORDER_PRICE_OPEN);
         
         double newSL = 0;
         if(useVisualSL) {
             newSL = visualSLPrice;
         } else {
             if(type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_BUY_LIMIT) {
                 newSL = openPrice - g_SL_Points*_Point;
             } else if(type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_SELL_LIMIT) {
                 newSL = openPrice + g_SL_Points*_Point;
             }
         }
         
         if(newSL != 0) {
            newSL = NormalizeDouble(newSL, digits);
            if(!trade.OrderModify(ticket, openPrice, newSL, OrderGetDouble(ORDER_TP), (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME), (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION)))
                Print("AssignSL Pending Error: ", GetLastError());
         }
      }
   }
}

void AssignTPToAll() {
   if(g_TP_Points <= 0) return;

   // FIX: Use visual line price directly for positions (eliminates gap between line and order)
   bool useVisualTP = (ObjectFind(0, LINE_TP) >= 0);
   double visualTPPrice = useVisualTP ? ObjectGetDouble(0, LINE_TP, OBJPROP_PRICE) : 0;
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);

   // 1. Assign to Active Positions
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
         double newTP = 0;
         if(useVisualTP) {
            newTP = visualTPPrice;
         } else {
            long type = PositionGetInteger(POSITION_TYPE);
            double refPrice = (type == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
            newTP = (type == POSITION_TYPE_BUY) ? refPrice + g_TP_Points*_Point : refPrice - g_TP_Points*_Point;
         }
         newTP = NormalizeDouble(newTP, digits);
         if(!trade.PositionModify(ticket, PositionGetDouble(POSITION_SL), newTP))
            Print("AssignTP Error: ", GetLastError());
      }
   }

   // 2. Assign to Pending Orders (use order's own open price as reference)
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL) == _Symbol) {
         long type = OrderGetInteger(ORDER_TYPE);
         double openPrice = OrderGetDouble(ORDER_PRICE_OPEN);
         
         double newTP = 0;
         if(useVisualTP) {
             newTP = visualTPPrice;
         } else {
             if(type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_BUY_LIMIT) {
                 newTP = openPrice + g_TP_Points*_Point;
             } else if(type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_SELL_LIMIT) {
                 newTP = openPrice - g_TP_Points*_Point;
             }
         }
         
         if(newTP != 0) {
            newTP = NormalizeDouble(newTP, digits);
            if(!trade.OrderModify(ticket, openPrice, OrderGetDouble(ORDER_SL), newTP, (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME), (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION)))
                Print("AssignTP Pending Error: ", GetLastError());
         }
      }
   }
}

void ExecuteOrder(ENUM_ORDER_TYPE type) {
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) { Alert("AutoTrading OFF!"); return; }
   
   UpdateCalculatedLot(); // Ensure latest lot before trade
   
   double sl = 0, tp = 0;
   double price = 0;
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   // --- FETCH PRICES FROM VISUAL LINES IF AVAILABLE (PRECISION FIX) ---
   bool useVisualEntry = (ObjectFind(0, LINE_ENTRY) >= 0);
   bool useVisualSL    = (ObjectFind(0, LINE_SL) >= 0);
   bool useVisualTP    = (ObjectFind(0, LINE_TP) >= 0);
   
    // 1. Determine Execution Price
    if(g_ExecMode == MODE_MARKET) {
       // Market execution uses current Ask/Bid
       price = (type==ORDER_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   } else {
       // Pending: Use Visual Line directly for absolute precision
       // If line exists, use it. If not (shouldn't happen), use g_PendingPrice.
       if(useVisualEntry) {
           price = ObjectGetDouble(0, LINE_ENTRY, OBJPROP_PRICE);
       } else {
           double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
           if(g_PendingPrice == 0) g_PendingPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK) + (100 * point);
           price = g_PendingPrice;
       }
   }
   
   // Normalize Price (Critical for OrderSend)
   price = NormalizeDouble(price, digits);
   
   // 2. Determine SL
   if(EnableSL) {
       if(useVisualSL) {
           // Use the exact price of the line
           sl = ObjectGetDouble(0, LINE_SL, OBJPROP_PRICE);
       } else if(g_SL_Points > 0) {
           // Fallback to relative calculation
           sl = (type==ORDER_TYPE_BUY) ? price - g_SL_Points*_Point : price + g_SL_Points*_Point;
       }
       if(sl > 0) sl = NormalizeDouble(sl, digits);
   }
   
   // 3. Determine TP
   if(EnableTP) {
       if(useVisualTP) {
           // Use the exact price of the line
           tp = ObjectGetDouble(0, LINE_TP, OBJPROP_PRICE);
       } else if(g_TP_Points > 0) {
           // Fallback to relative calculation
           tp = (type==ORDER_TYPE_BUY) ? price + g_TP_Points*_Point : price - g_TP_Points*_Point;
       }
       if(tp > 0) tp = NormalizeDouble(tp, digits);
   }
   
    if(g_ExecMode == MODE_MARKET) {
        if(type == ORDER_TYPE_BUY) { 
            if(trade.Buy(g_LotSize, _Symbol, 0, sl, tp, "Buy")) { TradeSequence++; }
            else Print("Buy Error: ", GetLastError());
        }
        else { 
            if(trade.Sell(g_LotSize, _Symbol, 0, sl, tp, "Sell")) { TradeSequence++; }
            else Print("Sell Error: ", GetLastError());
        }
    } else {
       
       // Pending Order Execution - AUTO DETECT STOP/LIMIT
       ENUM_ORDER_TYPE pendingType;
       string comment = "Pending";
       
       double curAsk = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
       double curBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
       
       if(type == ORDER_TYPE_BUY) {
           pendingType = (price > curAsk) ? ORDER_TYPE_BUY_STOP : ORDER_TYPE_BUY_LIMIT;
           comment = (pendingType == ORDER_TYPE_BUY_STOP) ? "Buy Stop" : "Buy Limit";
       } else {
           pendingType = (price < curBid) ? ORDER_TYPE_SELL_STOP : ORDER_TYPE_SELL_LIMIT;
           comment = (pendingType == ORDER_TYPE_SELL_STOP) ? "Sell Stop" : "Sell Limit";
       }
       
       double limitPrice = (pendingType == ORDER_TYPE_BUY_LIMIT || pendingType == ORDER_TYPE_SELL_LIMIT) ? price : 0.0;
 
       if(trade.OrderOpen(_Symbol, pendingType, g_LotSize, limitPrice, price, sl, tp, ORDER_TIME_GTC, 0, comment)) {
           TradeSequence++;
       } else {
           Print("OrderOpen Error: ", GetLastError());
       }
   }
}

// Filter: 0=All, 1=Buy, 2=Sell, 3=Win, 4=Loss
void ClosePositions(int filter) {
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
         bool shouldClose = false;
         long type = PositionGetInteger(POSITION_TYPE);
         double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
         
         if(filter == 0) shouldClose = true;
         else if(filter == 1 && type == POSITION_TYPE_BUY) shouldClose = true;
         else if(filter == 2 && type == POSITION_TYPE_SELL) shouldClose = true;
         else if(filter == 3 && profit > 0) shouldClose = true;
         else if(filter == 4 && profit < 0) shouldClose = true;
         
         if(shouldClose) {
             if(!trade.PositionClose(ticket)) {
                 Print("Close Error: ", GetLastError());
             }
         }
      }
   }
}

void ClosePending() {
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL) == _Symbol) {
          trade.OrderDelete(ticket);
      }
   }
}

void ReversePositions() {
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
         long type = PositionGetInteger(POSITION_TYPE); 
         double vol = PositionGetDouble(POSITION_VOLUME);
         
         // 1. Close Existing
         if(trade.PositionClose(ticket)) {
             // 2. Open Opposite
             if(type == POSITION_TYPE_BUY) {
                 if(!trade.Sell(vol, _Symbol, 0, 0, 0, "Reverse")) Print("Rev Sell Error: ", GetLastError());
             }
             else {
                 if(!trade.Buy(vol, _Symbol, 0, 0, 0, "Reverse")) Print("Rev Buy Error: ", GetLastError());
             }
         } else {
             Print("Reverse Close Error: ", GetLastError());
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Visual Lines - Optimized                                         |
//+------------------------------------------------------------------+
bool DrawVisualLines(bool forceUpdate = false) {
   if(!IsPanelVisible) {
      if(ObjectFind(0, LINE_SL) >= 0) ObjectDelete(0, LINE_SL);
      if(ObjectFind(0, LINE_TP) >= 0) ObjectDelete(0, LINE_TP);
      if(ObjectFind(0, LINE_ENTRY) >= 0) ObjectDelete(0, LINE_ENTRY);
      return false;
   }
   
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   double entryPrice = 0;
   
   if(g_ExecMode == MODE_MARKET) {
      entryPrice = IsLongMode ? ask : bid;
      if(ObjectFind(0, LINE_ENTRY) >= 0) ObjectDelete(0, LINE_ENTRY);
   } else {
       // PENDING - Absolute Price
       double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
       if(g_PendingPrice == 0) g_PendingPrice = ask + (100 * point);
       
       entryPrice = g_PendingPrice;
       
       if(ObjectFind(0, LINE_ENTRY) < 0) {
           ObjectCreate(0, LINE_ENTRY, OBJ_HLINE, 0, 0, entryPrice);
           ObjectSetInteger(0, LINE_ENTRY, OBJPROP_COLOR, C'255,215,0'); // Gold
           ObjectSetInteger(0, LINE_ENTRY, OBJPROP_STYLE, STYLE_SOLID);
           ObjectSetInteger(0, LINE_ENTRY, OBJPROP_WIDTH, 2); // Bolder Price Line
           ObjectSetInteger(0, LINE_ENTRY, OBJPROP_SELECTABLE, true);
           ObjectSetInteger(0, LINE_ENTRY, OBJPROP_SELECTED, true);
       } else {
           if((forceUpdate || !ObjectGetInteger(0, LINE_ENTRY, OBJPROP_SELECTED)) && ObjectGetDouble(0, LINE_ENTRY, OBJPROP_PRICE) != entryPrice) {
               ObjectMove(0, LINE_ENTRY, 0, 0, entryPrice);
           }
       }
   }

   // Optimization Check
   if(entryPrice == last_Mid && g_SL_Points == last_SL && g_TP_Points == last_TP && g_LotSize == last_Lot && IsLongMode == last_Mode && g_ExecMode == last_ExecMode && !forceUpdate) {
      return false;
   }
   
   last_Mid  = entryPrice; 
   last_SL   = (int)g_SL_Points;
   last_TP   = (int)g_TP_Points;
   last_Lot  = g_LotSize;
   last_Mode = IsLongMode;
   last_ExecMode = g_ExecMode;
   
   bool changed = false;

   // --- SL Logic ---
   if(EnableSL && g_SL_Points > 0) {
      double price = IsLongMode ? entryPrice - (g_SL_Points * _Point) : entryPrice + (g_SL_Points * _Point); 
      
      double profit = 0;
      if(!OrderCalcProfit(IsLongMode ? ORDER_TYPE_BUY : ORDER_TYPE_SELL, _Symbol, g_LotSize, entryPrice, price, profit)) profit = 0;
      
      string slTooltip = StringFormat("SL: %d pts (%s %.2f)", g_SL_Points, (profit >= 0 ? "+" : ""), profit);
      
      if(ObjectFind(0, LINE_SL) < 0) {
         ObjectCreate(0, LINE_SL, OBJ_HLINE, 0, 0, price);
         ObjectSetInteger(0, LINE_SL, OBJPROP_COLOR, InpClrSL);
         ObjectSetInteger(0, LINE_SL, OBJPROP_STYLE, STYLE_DOT);
         ObjectSetInteger(0, LINE_SL, OBJPROP_WIDTH, 2); // Bolder SL Line
         ObjectSetInteger(0, LINE_SL, OBJPROP_SELECTABLE, true);
         ObjectSetInteger(0, LINE_SL, OBJPROP_SELECTED, true); 
         ObjectSetString(0, LINE_SL, OBJPROP_TOOLTIP, slTooltip);
         changed = true;
      } else {
         if(ObjectGetString(0, LINE_SL, OBJPROP_TOOLTIP) != slTooltip) {
             ObjectSetString(0, LINE_SL, OBJPROP_TOOLTIP, slTooltip);
             changed = true;
         }
         
          if((forceUpdate || !ObjectGetInteger(0, LINE_SL, OBJPROP_SELECTED)) && ObjectGetDouble(0, LINE_SL, OBJPROP_PRICE) != price) {
             ObjectMove(0, LINE_SL, 0, 0, price);
             changed = true;
          }
      }
   } else {
      if(ObjectFind(0, LINE_SL) >= 0) { ObjectDelete(0, LINE_SL); changed = true; }
   }

   // --- TP Logic ---
   if(EnableTP && g_TP_Points > 0) {
      double price = IsLongMode ? entryPrice + (g_TP_Points * _Point) : entryPrice - (g_TP_Points * _Point);
      
      double profit = 0;
      if(!OrderCalcProfit(IsLongMode ? ORDER_TYPE_BUY : ORDER_TYPE_SELL, _Symbol, g_LotSize, entryPrice, price, profit)) profit = 0;
      
      string tpTooltip = StringFormat("TP: %d pts (%s %.2f)", g_TP_Points, (profit >= 0 ? "+" : ""), profit);
      
      if(ObjectFind(0, LINE_TP) < 0) {
          ObjectCreate(0, LINE_TP, OBJ_HLINE, 0, 0, price);
          ObjectSetInteger(0, LINE_TP, OBJPROP_COLOR, InpClrTP); 
          ObjectSetInteger(0, LINE_TP, OBJPROP_STYLE, STYLE_DOT);
          ObjectSetInteger(0, LINE_TP, OBJPROP_WIDTH, 2); // Bolder TP Line
          ObjectSetInteger(0, LINE_TP, OBJPROP_SELECTABLE, true);
          ObjectSetInteger(0, LINE_TP, OBJPROP_SELECTED, true);
          ObjectSetString(0, LINE_TP, OBJPROP_TOOLTIP, tpTooltip);
          changed = true;
      } else {
          if(ObjectGetString(0, LINE_TP, OBJPROP_TOOLTIP) != tpTooltip) {
              ObjectSetString(0, LINE_TP, OBJPROP_TOOLTIP, tpTooltip);
              changed = true;
          }
          if((forceUpdate || !ObjectGetInteger(0, LINE_TP, OBJPROP_SELECTED)) && ObjectGetDouble(0, LINE_TP, OBJPROP_PRICE) != price) {
              ObjectMove(0, LINE_TP, 0, 0, price);
              changed = true;
          }
      }
   } else {
      if(ObjectFind(0, LINE_TP) >= 0) { ObjectDelete(0, LINE_TP); changed = true; }
   }
   return changed;
}

void UpdateToggleState() {
   if(IsMinimized) return;
   if(ObjectFind(0, BTN_USE_SL) >= 0) { ObjectSetInteger(0, BTN_USE_SL, OBJPROP_BGCOLOR, EnableSL ? InpClrActive : InpClrInactive); ObjectSetString(0, BTN_USE_SL, OBJPROP_TEXT, EnableSL ? "✔" : "✖"); }
   if(ObjectFind(0, BTN_USE_TP) >= 0) { ObjectSetInteger(0, BTN_USE_TP, OBJPROP_BGCOLOR, EnableTP ? InpClrActive : InpClrInactive); ObjectSetString(0, BTN_USE_TP, OBJPROP_TEXT, EnableTP ? "✔" : "✖"); }
       
   if(ObjectFind(0, BTN_MODE) >= 0) {
       string mText = "MARKET (TAB)";
       if(g_ExecMode == MODE_PENDING) mText = "PEND (TAB)(,/.)";
       ObjectSetString(0, BTN_MODE, OBJPROP_TEXT, mText);
       ObjectSetString(0, BTN_MODE, OBJPROP_TOOLTIP, "TAB to Toggle Mode. Drag line to adjust price.");
       color mColor = InpClrHeader;
       if(g_ExecMode != MODE_MARKET) mColor = InpClrActive;
       ObjectSetInteger(0, BTN_MODE, OBJPROP_BGCOLOR, mColor);
   }
   
   if(g_ExecMode == MODE_MARKET) {
      if(ObjectFind(0, BTN_ENTRY_UP) >= 0) ObjectDelete(0, BTN_ENTRY_UP);
      if(ObjectFind(0, BTN_ENTRY_DN) >= 0) ObjectDelete(0, BTN_ENTRY_DN);
   }
   
   if(IsPanelVisible && !IsMinimized) CreateGUI(); 
   
   DrawVisualLines(true);
   ChartRedraw();
}



void ResetBtn(string name) { ObjectSetInteger(0, name, OBJPROP_STATE, false); }

//+------------------------------------------------------------------+
//| Click-and-Hold Repeat System                                      |
//+------------------------------------------------------------------+
bool IsMouseOverBtn(string btnName, int mx, int my) {
   if(ObjectFind(0, btnName) < 0) return false;
   int bx = (int)ObjectGetInteger(0, btnName, OBJPROP_XDISTANCE);
   int by = (int)ObjectGetInteger(0, btnName, OBJPROP_YDISTANCE);
   int bw = (int)ObjectGetInteger(0, btnName, OBJPROP_XSIZE);
   int bh = (int)ObjectGetInteger(0, btnName, OBJPROP_YSIZE);
   return (mx >= bx && mx <= bx + bw && my >= by && my <= by + bh);
}

int HitTestAdjuster(int mx, int my) {
   if(IsMouseOverBtn(BTN_SL_UP, mx, my))    return REPEAT_SL_UP;
   if(IsMouseOverBtn(BTN_SL_DN, mx, my))    return REPEAT_SL_DN;
   if(IsMouseOverBtn(BTN_TP_UP, mx, my))    return REPEAT_TP_UP;
   if(IsMouseOverBtn(BTN_TP_DN, mx, my))    return REPEAT_TP_DN;
   if(IsMouseOverBtn(BTN_RISK_UP, mx, my))  return REPEAT_RISK_UP;
   if(IsMouseOverBtn(BTN_RISK_DN, mx, my))  return REPEAT_RISK_DN;
   if(IsMouseOverBtn(BTN_SCALE_UP, mx, my)) return REPEAT_SCALE_UP;
   if(IsMouseOverBtn(BTN_SCALE_DN, mx, my)) return REPEAT_SCALE_DN;
   if(IsMouseOverBtn(BTN_ENTRY_UP, mx, my)) return REPEAT_ENTRY_UP;
   if(IsMouseOverBtn(BTN_ENTRY_DN, mx, my)) return REPEAT_ENTRY_DN;
   return REPEAT_NONE;
}

void StartRepeat(int action) {
   g_RepeatAction = action;
   g_RepeatActive = true;
   EventKillTimer();
   EventSetMillisecondTimer(120); // Fast repeat ~8 adjustments/sec
}

void StopRepeat() {
   g_RepeatActive = false;
   g_RepeatAction = REPEAT_NONE;
   EventKillTimer();
   EventSetTimer(1); // Restore normal 1-second timer
   
   // Reset all adjuster button states
   ResetBtn(BTN_SL_UP); ResetBtn(BTN_SL_DN);
   ResetBtn(BTN_TP_UP); ResetBtn(BTN_TP_DN);
   ResetBtn(BTN_RISK_UP); ResetBtn(BTN_RISK_DN);
   ResetBtn(BTN_SCALE_UP); ResetBtn(BTN_SCALE_DN);
   ResetBtn(BTN_ENTRY_UP); ResetBtn(BTN_ENTRY_DN);
   ChartRedraw();
}

void FireRepeatAction() {
   switch(g_RepeatAction) {
      case REPEAT_RISK_UP:  AdjustLotOrRisk(1); break;
      case REPEAT_RISK_DN:  AdjustLotOrRisk(-1); break;
      case REPEAT_SL_UP:    AdjustEdit(EDIT_SL, InpAdjStep); break;
      case REPEAT_SL_DN:    AdjustEdit(EDIT_SL, -InpAdjStep); break;
      case REPEAT_TP_UP:    AdjustEdit(EDIT_TP, InpAdjStep); break;
      case REPEAT_TP_DN:    AdjustEdit(EDIT_TP, -InpAdjStep); break;
      case REPEAT_SCALE_UP: AdjustScale(5); break;
      case REPEAT_SCALE_DN: AdjustScale(-5); break;
      case REPEAT_ENTRY_UP: AdjustEntryLine(InpEntryStep); break;
      case REPEAT_ENTRY_DN: AdjustEntryLine(-InpEntryStep); break;
   }
}
//+------------------------------------------------------------------+
//| GUI Creation                                                     |
//+------------------------------------------------------------------+
void CreateGUI() {
   // Reset Cache to force UI update
   last_PnL       = -DBL_MAX;
   last_Positions = -1;
   last_PnLState  = -99;
   last_AlgoState = !TerminalInfoInteger(TERMINAL_TRADE_ALLOWED); // Force mismatch
   last_Mid       = 0;
   last_SL        = -1; // Force line redraw
   
   if(!IsPanelVisible) return;
   int y = PanelY; int panelH = IsMinimized ? 45 : InpPanelH;

   ObjectCreate(0, BG_PANEL, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, BG_PANEL, OBJPROP_XDISTANCE, PanelX); ObjectSetInteger(0, BG_PANEL, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, BG_PANEL, OBJPROP_XSIZE, InpPanelW);    ObjectSetInteger(0, BG_PANEL, OBJPROP_YSIZE, panelH); 
   ObjectSetInteger(0, BG_PANEL, OBJPROP_BGCOLOR, InpClrBg); ObjectSetInteger(0, BG_PANEL, OBJPROP_COLOR, InpClrBorder); ObjectSetInteger(0, BG_PANEL, OBJPROP_ZORDER, 0); 

   ObjectCreate(0, BG_HEADER, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, BG_HEADER, OBJPROP_XDISTANCE, PanelX); ObjectSetInteger(0, BG_HEADER, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, BG_HEADER, OBJPROP_XSIZE, InpPanelW);    ObjectSetInteger(0, BG_HEADER, OBJPROP_YSIZE, 45); 
   ObjectSetInteger(0, BG_HEADER, OBJPROP_BGCOLOR, InpClrHeader); ObjectSetInteger(0, BG_HEADER, OBJPROP_COLOR, InpClrBorder); ObjectSetInteger(0, BG_HEADER, OBJPROP_ZORDER, 1);

   // Header Row: Centered Timer + Control Buttons
   CreateLbl(LBL_TIMER, "00:00", PanelX + (InpPanelW / 2) - 25, y + 12, InpClrTimer, 12, true);
   
   // Header buttons (top-right)
   CreateBtn(BTN_MINMAX, IsMinimized ? "+" : "−", PanelX + InpPanelW - 22, y + 2, 18, 18, InpClrInactive, 9);
   ObjectSetString(0, BTN_MINMAX, OBJPROP_TOOLTIP, "Minimize (F) / Hide (R)");
   CreateBtn(BTN_RESET, ShortToString(0x21BB), PanelX + InpPanelW - 42, y + 2, 18, 18, InpClrInactive, 10);
   ObjectSetString(0, BTN_RESET, OBJPROP_TOOLTIP, "Reset Position to Default");
   CreateBtn(BTN_DOCK, g_IsDocked ? "L" : "U", PanelX + InpPanelW - 62, y + 2, 18, 18, InpClrInactive, 9);
   ObjectSetString(0, BTN_DOCK, OBJPROP_TOOLTIP, "Dock/Lock Panel (" + ShortToString((ushort)InpKeyDock) + ")");
   
   if(IsMinimized) return;
   
   y += 50; // Compact gap before inputs container
   ObjectCreate(0, BG_INPUTS, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, BG_INPUTS, OBJPROP_XDISTANCE, PanelX + 5); ObjectSetInteger(0, BG_INPUTS, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, BG_INPUTS, OBJPROP_XSIZE, InpPanelW - 10);  ObjectSetInteger(0, BG_INPUTS, OBJPROP_YSIZE, 92); 
   ObjectSetInteger(0, BG_INPUTS, OBJPROP_BGCOLOR, InpClrGroupBox); ObjectSetInteger(0, BG_INPUTS, OBJPROP_BORDER_TYPE, BORDER_FLAT); ObjectSetInteger(0, BG_INPUTS, OBJPROP_ZORDER, 1);

   y += 5; // Internal top padding
   
    // Row 1: Mode Toggle & Lot/Risk Inputs
   CreateBtn(BTN_TOGGLE_MODE, g_IsManualLotMode ? "Lot [\\]" : "Risk [\\]", PanelX + 10, y, 65, EDIT_H, InpClrGroupBox, 8); 
   ObjectSetInteger(0, BTN_TOGGLE_MODE, OBJPROP_BORDER_COLOR, InpClrGroupBox); 
   ObjectSetInteger(0, BTN_TOGGLE_MODE, OBJPROP_COLOR, InpClrText); 
   
   CreateBtn(BTN_RISK_DN, "▼", PanelX + 78, y, 18, EDIT_H, InpClrBtnAdj, 8);
   CreateEdit(EDIT_RISK, g_IsManualLotMode ? DoubleToString(g_LotSize, 2) : DoubleToString(g_RiskUnits, 3), PanelX + 98, y, 40);
   CreateBtn(BTN_RISK_UP, "▲", PanelX + 140, y, 18, EDIT_H, InpClrBtnAdj, 8);
   CreateLbl(PREFIX+"L1", "Lot", PanelX + 165, y + 2, InpClrText, 8, true);
   CreateEdit(EDIT_LOT, DoubleToString(g_LotSize, 2), PanelX + 185, y, 40); 
   ObjectSetInteger(0, EDIT_LOT, OBJPROP_READONLY, true); 
   CreateLbl(LBL_MARG_REQ, "$0.00", PanelX + 228, y + 2, InpClrInfoMarg, 8, false);
   if(g_IsManualLotMode) {
      ObjectSetInteger(0, EDIT_LOT, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, EDIT_LOT, OBJPROP_SELECTED, false);
   }
   // Row 2: Stop Loss (Inline)
   y += 22;
   CreateLbl(PREFIX+"L2", "SL(J)", PanelX + 10, y + 2, InpClrText, 8, false); 
   CreateBtn(BTN_SL_DN, "▼", PanelX + 48, y, 18, EDIT_H, InpClrBtnAdj, 8); 
   CreateEdit(EDIT_SL, IntegerToString(g_SL_Points), PanelX + 68, y, 42); 
   CreateBtn(BTN_SL_UP, "▲", PanelX + 112, y, 18, EDIT_H, InpClrBtnAdj, 8); 
   CreateBtn(BTN_USE_SL, EnableSL ? "✔" : "✖", PanelX + 132, y, 18, EDIT_H, EnableSL ? InpClrActive : InpClrInactive, 8);
   CreateBtn(BTN_ASGN_SL, "ASGN (G)", PanelX + 154, y, 62, EDIT_H, InpClrAsgnSL, 8);
   // R:R moved to footer

   // Row 3: Take Profit (Inline)
   y += 22;
   CreateLbl(PREFIX+"L3", "TP(B)", PanelX + 10, y + 2, InpClrText, 8, false); 
   CreateBtn(BTN_TP_DN, "▼", PanelX + 48, y, 18, EDIT_H, InpClrBtnAdj, 8); 
   CreateEdit(EDIT_TP, IntegerToString(g_TP_Points), PanelX + 68, y, 42); 
   CreateBtn(BTN_TP_UP, "▲", PanelX + 112, y, 18, EDIT_H, InpClrBtnAdj, 8); 
   CreateBtn(BTN_USE_TP, EnableTP ? "✔" : "✖", PanelX + 132, y, 18, EDIT_H, EnableTP ? InpClrActive : InpClrInactive, 8);
   CreateBtn(BTN_ASGN_TP, "ASGN (H)", PanelX + 154, y, 62, EDIT_H, InpClrAsgnTP, 8);
   CreateBtn(BTN_BE, "B/E (1)", PanelX + 220, y, 45, EDIT_H, InpClrAsgnSL, 8);
   ObjectSetString(0, BTN_BE, OBJPROP_TOOLTIP, "Move SL to Break-Even for all positions (key: 1)");

   // Row 4: Scale Out (Inline)
   y += 22;
   CreateLbl(PREFIX+"L4", "Scale Out", PanelX + 10, y + 2, InpClrText, 8, false);
   CreateBtn(BTN_SCALE_DN, "▼", PanelX + 60, y, 18, EDIT_H, InpClrBtnAdj, 8);
   CreateEdit(EDIT_SCALE, DoubleToString(g_ScalePct, 0), PanelX + 80, y, 35);
   CreateBtn(BTN_SCALE_UP, "▲", PanelX + 117, y, 18, EDIT_H, InpClrBtnAdj, 8);
   CreateBtn(BTN_SCALE, "SCALE (S)", PanelX + 140, y, 70, EDIT_H, InpClrScale, 8);

   y += 25; // Step past BG_INPUTS (tightened)
   
   // Split Row: Mode [ MARKET (TAB) ] [ ▼ ▲ ] 
   int arrowW = 20;
   string modeText = "MARKET (TAB)";
   if(g_ExecMode == MODE_PENDING) modeText = "PEND (TAB)(,/.)";
   
   if(g_ExecMode == MODE_PENDING) {
      CreateBtn(BTN_MODE, modeText, PanelX + 10, y, 120, 22, InpClrHeader, 8);
      CreateBtn(BTN_ENTRY_DN, "▼", PanelX + 135, y, arrowW, 22, InpClrActive, 8);
      CreateBtn(BTN_ENTRY_UP, "▲", PanelX + 157, y, arrowW, 22, InpClrActive, 8);
      ObjectSetString(0, BTN_ENTRY_DN, OBJPROP_TOOLTIP, "Move Entry Line Down ( , )");
      ObjectSetString(0, BTN_ENTRY_UP, OBJPROP_TOOLTIP, "Move Entry Line Up ( . )");
   } else {
      CreateBtn(BTN_MODE, modeText, PanelX + 10, y, InpPanelW - 20, 22, InpClrHeader, 8);
      if(ObjectFind(0, BTN_ENTRY_UP) >= 0) ObjectDelete(0, BTN_ENTRY_UP);
      if(ObjectFind(0, BTN_ENTRY_DN) >= 0) ObjectDelete(0, BTN_ENTRY_DN);
   }

   y += 26; 
   int btnW = (InpPanelW - 25) / 2; 
   
   // --- PRIMARY BUTTONS ---
   CreateBtn(BTN_SELL, "SELL (W)", PanelX + 10, y, btnW, 28, InpClrSell, 10);
   CreateBtn(BTN_BUY, "BUY (Q)", PanelX + 15 + btnW, y, btnW, 28, InpClrBuy, 10);
   
   y += 32; 
   CreateBtn(BTN_REV, "REVERSE (V)", PanelX + 10, y, btnW, 24, InpClrReverse, 9); 
   CreateBtn(BTN_CLOSE, "CLOSE ALL (E)", PanelX + 15 + btnW, y, btnW, 24, InpClrClose, 9);
   
   // --- SECONDARY TIGHTER GRID ---
   y += 28;
   int btnW4 = (InpPanelW - 35) / 4; 
   CreateBtn(BTN_C_BUY, "BUY (Z)", PanelX + 10, y, btnW4, 20, InpClrClose, 8); 
   CreateBtn(BTN_C_SELL, "SELL (X)", PanelX + 15 + btnW4, y, btnW4, 20, InpClrClose, 8);
   CreateBtn(BTN_C_WIN, "WIN (C)", PanelX + 20 + (btnW4 * 2), y, btnW4, 20, InpClrClose, 8); 
   CreateBtn(BTN_C_LOSS, "LOSS (D)", PanelX + 25 + (btnW4 * 3), y, btnW4, 20, InpClrClose, 8);
   
   y += 24;
   CreateBtn(BTN_C_PEND, "CAN PEND(A)", PanelX + 10, y, InpPanelW - 20, 20, InpClrClose, 8);

   // --- FOOTER INFORMATION ---
   y += 28; 
   // Footer Row 1: PnL & Balance
   CreateLbl(LBL_PNL, "PnL: 0.00", PanelX + 10, y, InpClrInfoPnLBase, 10, true);
   if(InpShowBalance) CreateLbl(LBL_BALANCE, "Bal: $...", PanelX + 140, y + 1, InpClrInfoBal, 8, true);
   
   y += 18;
   // Footer Row 2: Spread | Pending | R:R | Pos Summary
   CreateLbl(LBL_SPREAD, "Sprd: 0", PanelX + 10, y, InpClrInfoSprdBase, 8, false);
   CreateLbl(LBL_PEND, "Pend: 0", PanelX + 65, y, InpClrInfoPendBase, 8, false);
   CreateLbl(LBL_RR, "R:R 1:0", PanelX + 115, y, InpClrInfoRRWin, 8, false);
   CreateLbl(LBL_POS_SUMMARY, "NET: ...", PanelX + 185, y, InpClrInfoPosBase, 8, false);

   // Initialize delighter displays
   UpdateRR();
   UpdateSpread();
   UpdatePendingCount();
}
void CreateEdit(string name, string text, int x, int y, int w) {
   if(ObjectFind(0, name) < 0) ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x); ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y); ObjectSetInteger(0, name, OBJPROP_XSIZE, w); ObjectSetInteger(0, name, OBJPROP_YSIZE, EDIT_H);
   ObjectSetString(0, name, OBJPROP_TEXT, text); ObjectSetInteger(0, name, OBJPROP_BGCOLOR, InpClrInput); ObjectSetInteger(0, name, OBJPROP_COLOR, InpClrTextIn);
   ObjectSetInteger(0, name, OBJPROP_ALIGN, ALIGN_CENTER); ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER); ObjectSetString(0, name, OBJPROP_FONT, FONT_MAIN); ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9); ObjectSetInteger(0, name, OBJPROP_ZORDER, 2);
}

void CreateBtn(string name, string text, int x, int y, int w, int h, color bg, int fontSize=9) {
   if(ObjectFind(0, name) < 0) ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x); ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y); ObjectSetInteger(0, name, OBJPROP_XSIZE, w); ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetString(0, name, OBJPROP_TEXT, text); ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg); ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, name, OBJPROP_FONT, FONT_MAIN); ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize); ObjectSetInteger(0, name, OBJPROP_STATE, false); ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER); ObjectSetInteger(0, name, OBJPROP_ZORDER, 2);
}

void CreateLbl(string name, string text, int x, int y, color clr, int fontSize=8, bool bold=false) {
   if(ObjectFind(0, name) < 0) ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x); ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y); ObjectSetString(0, name, OBJPROP_TEXT, text); ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER); ObjectSetString(0, name, OBJPROP_FONT, bold ? FONT_MAIN + " Bold" : FONT_MAIN); ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize); ObjectSetInteger(0, name, OBJPROP_ZORDER, 2);
}

void TogglePanel() {
   IsPanelVisible = !IsPanelVisible;
   
   // Reset drag state on toggle
   if(g_IsDragging) {
      g_IsDragging = false;
      ChartSetInteger(0, CHART_MOUSE_SCROLL, g_ChartScrollSaved);
   }
   
   if(IsPanelVisible) { 
      CreateGUI(); 
      UpdateToggleState(); 
      UpdateCalculatedLot();
      DrawVisualLines(); 
      ChartRedraw(); 
   }
    else { 
       ObjectsDeleteAll(0, PREFIX); 
       ChartRedraw(); 
    }
}

//+------------------------------------------------------------------+
//| DELIGHTER: Move All Positions SL to Break-Even                   |
//+------------------------------------------------------------------+
void MoveToBreakeven() {
   int modified = 0;
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
         long type = PositionGetInteger(POSITION_TYPE);
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentSL = PositionGetDouble(POSITION_SL);
         double currentTP = PositionGetDouble(POSITION_TP);
         
         // Only move SL if it would improve the stop (move towards profit side)
         bool shouldMove = false;
         if(type == POSITION_TYPE_BUY) {
            shouldMove = (currentSL < openPrice || currentSL == 0);
         } else {
            shouldMove = (currentSL > openPrice || currentSL == 0);
         }
         
         if(shouldMove) {
            double stopLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
            double currentPrice = (type == POSITION_TYPE_BUY) ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            
            if(MathAbs(currentPrice - openPrice) <= stopLevel) {
               Print("Breakeven failed ticket ", ticket, ": price too close to open (StopLevel limit)");
               continue;
            }
            
            double beSL = NormalizeDouble(openPrice, digits);
            if(trade.PositionModify(ticket, beSL, currentTP)) {
               modified++;
            } else {
               Print("Breakeven Error ticket ", ticket, ": ", GetLastError());
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| DELIGHTER: Live Spread Display                                   |
//+------------------------------------------------------------------+
void UpdateSpread() {
   if(!IsPanelVisible) return;
   if(ObjectFind(0, LBL_SPREAD) < 0) return;
   
   long spreadPts = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   string spreadText = "Sprd: " + IntegerToString(spreadPts);
   ObjectSetString(0, LBL_SPREAD, OBJPROP_TEXT, spreadText);
   
   // Color code: low spread green, high spread red
   color spreadClr = InpClrInfoSprdBase; // Default grey
   if(spreadPts <= 20) spreadClr = InpClrInfoSprdGood;       // Good
   else if(spreadPts <= 50) spreadClr = InpClrInfoSprdMed;  // Medium
   else spreadClr = InpClrInfoSprdWide;                       // Wide
   ObjectSetInteger(0, LBL_SPREAD, OBJPROP_COLOR, spreadClr);
}

//+------------------------------------------------------------------+
//| DELIGHTER: Risk:Reward Ratio Display                             |
//+------------------------------------------------------------------+
void UpdateRR() {
   if(!IsPanelVisible) return;
   if(ObjectFind(0, LBL_RR) < 0) return;
   
   if(g_SL_Points > 0 && g_TP_Points > 0 && EnableSL && EnableTP) {
      double rr = (double)g_TP_Points / (double)g_SL_Points;
      string rrText = StringFormat("R:R = 1:%.1f", rr);
      ObjectSetString(0, LBL_RR, OBJPROP_TEXT, rrText);
      
      // Color: favorable (>=1) green, unfavorable red
      color rrClr = (rr >= 1.0) ? InpClrInfoRRWin : InpClrInfoRRLoss;
      ObjectSetInteger(0, LBL_RR, OBJPROP_COLOR, rrClr);
   } else {
      ObjectSetString(0, LBL_RR, OBJPROP_TEXT, " ");
      ObjectSetInteger(0, LBL_RR, OBJPROP_COLOR, InpClrHeader); // Hide completely (match header bg)
   }
}

//+------------------------------------------------------------------+
//| DELIGHTER: Live Pending Order Count                              |
//+------------------------------------------------------------------+
void UpdatePendingCount() {
   if(!IsPanelVisible) return;
   if(ObjectFind(0, LBL_PEND) < 0) return;
   
   int pendCount = 0;
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL) == _Symbol) pendCount++;
   }
   
   string pendText = "Pend: " + IntegerToString(pendCount);
   ObjectSetString(0, LBL_PEND, OBJPROP_TEXT, pendText);
   
   // Color: grey when 0, cyan when active
   color pendClr = (pendCount > 0) ? InpClrInfoPendAct : InpClrInfoPendBase;
   ObjectSetInteger(0, LBL_PEND, OBJPROP_COLOR, pendClr);
}

//+------------------------------------------------------------------+
//| DELIGHTER: Position Summary (Net Volume)                         |
//+------------------------------------------------------------------+
void UpdatePositionSummary() {
   if(!IsPanelVisible) return;
   if(ObjectFind(0, LBL_POS_SUMMARY) < 0) return;
   
   double netVol = 0;
   int buyCount = 0;
   int sellCount = 0;
   
   for(int i = PositionsTotal()-1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
             netVol += PositionGetDouble(POSITION_VOLUME);
             buyCount++;
         } else {
             netVol -= PositionGetDouble(POSITION_VOLUME);
             sellCount++;
         }
      }
   }
   
   string text = "";
   color clr = InpClrInfoPosBase;
   
   if(buyCount == 0 && sellCount == 0) {
       text = " "; // Hide if flat (no open orders)
   } else {
       if(netVol > 0) {
           text = "BUY " + DoubleToString(netVol, 2);
           clr = InpClrInfoPosBuy; // Green
       } else if(netVol < 0) {
           text = "SELL " + DoubleToString(MathAbs(netVol), 2);
           clr = InpClrInfoPosSell; // Red
       } else {
           text = "FLAT " + DoubleToString(MathAbs(netVol), 2); // Hedged perfectly?
       }
   }
   
   ObjectSetString(0, LBL_POS_SUMMARY, OBJPROP_TEXT, text);
   ObjectSetInteger(0, LBL_POS_SUMMARY, OBJPROP_COLOR, clr);
}
