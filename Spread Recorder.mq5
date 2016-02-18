#property copyright   "Copyright 2013, Paulius 'zatec' R."  
#property link        "https://login.mql5.com/en/users/zatec"            
#property version     "1.0"                     
#property description "Indicator for displaying and recording spread fluctuations"   
#property icon        "logo.ico";   

#property indicator_chart_window
#include "Charts.mqh"
#resource "Close.bmp"  
#resource "Reset.bmp"  

enum PosS 
  {
   O1=0,     // Top Right Corner
   O2=1,     // Bottom Right Corner
   O3=2,     // Below the Bid Price
   O4=3,     // Do Not Display
  };
enum range 
  {
   R0=0,       // Disable
   R1=50,      // Last 50 Ticks
   R2=100,     // Last 100 Ticks
   R3=250,     // Last 250 Ticks
   R4=500,     // Last 500 Ticks   
   R5=750,     // Last 750 Ticks
   R6=1000,    // Last 1000 Ticks
  };  
//--- input parameters
input PosS     Display_Spread       = O3;
input int      FontSize             = 16;
input double   Spread_Level         = 10;
input color    Color_High           = clrRed;
input color    Color_Low            = clrGreen;
input bool     Display_Averages_Tab = true;
input range    Range_1              = R2;
input range    Range_2              = R6;

bool     Display_Range1_Tab   = true;
bool     Display_Range2_Tab   = true;

int Set_1 = Range_1;
int Set_2 = Range_2;
string IndName = "SpreadRecorder";
double MainArray[1000];
double TimeArraySpread[360];
double TimeArrayTicks[360];

//-------- Chart Properties 
color BarColor          = clrRed;
color BackGroundColor   = clrLightGray;
color DimColor          = clrGray;
bool IsCreated;
double Price,PriceLast;
double Spread,SpreadLast;
datetime LastCandleTime;
double CurrentCandleSpread;
int CurrentCandleTicks;

datetime TArrayLastTime;
double TSpread;
int TTicks;

datetime SinceTime;
double SinceSpread;
int SinceTicks;

string InpFileName; 

int X_B0 = 10;
int Y_B0 = 10;

int X_B1 = 10;
int Y_B1 = 190;

int X_B2 = 165;
int Y_B2 = 10;

//For Dragging Objects
bool mouseflag;
string box_name;
int  Drag_X,Drag_Y;  



string Array[3];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  { 
  if(Range_1 == 0) Display_Range1_Tab = false;
  if(Range_2 == 0) Display_Range2_Tab = false;
  if(Display_Range1_Tab)   Array[0] = "Last "+Set_1+" Ticks";  else Array[0] = "NONE Ticks";
  if(Display_Range2_Tab)   Array[1] = "Last "+Set_2+" Ticks";   else Array[1] = "NONE Ticks";
  if(Display_Averages_Tab) Array[2] = "Averages";            else Array[2] = "NONEAverages";

  if(!Display_Averages_Tab) { X_B2 = X_B1; Y_B2 = Y_B1; X_B1 = X_B0; Y_B1 = Y_B0; }
  if(!Display_Range1_Tab)  { X_B2 = X_B1; Y_B2 = Y_B1; }
   DeleteOld();  
   ObjectDelete(0,"Spread");
   ArrayInitialize(MainArray,-1);
   ArrayInitialize(TimeArraySpread,-1);
   ArrayInitialize(TimeArrayTicks,-1);
   InpFileName=IndName+" "+Symbol(); 
   Load();
   
   if(!ObjectFind(0,IndName+" "+Array[0]+" Background") || !ObjectFind(0,IndName+" "+Array[1]+" Background") || !ObjectFind(0,IndName+" "+Array[2]+" Background")) IsCreated = true;
   else IsCreated = false;

   
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
   {
   Save();
   if(reason == REASON_REMOVE)
      {
      DeleteWindow("");
      ObjectDelete(0,"Spread");      
      }

   }  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
 
   Spread = (double)SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
   Price = SymbolInfoDouble(Symbol(),SYMBOL_BID);
   if(SpreadLast == Spread && PriceLast == Price) return(0);
   if(Display_Spread != 3) ShowSpread(Spread,Price);

   SpreadLast = Spread; 
   PriceLast = Price;   
   MainArray_Update(Spread,MainArray);
 
//--+++ For Calc Timed averages   
   if(TArrayLastTime <= TimeCurrent()) 
      {
      if(TArrayLastTime == 0) TArrayLastTime = TimeCurrent();
      else
         {
         MainArray_Update(TSpread,TimeArraySpread);
         MainArray_Update(TTicks,TimeArrayTicks);         
         }
      TArrayLastTime = TArrayLastTime + 10;
      TSpread = 0;
      TTicks = 0;
      
      }
   TSpread +=Spread;
   TTicks++;

//--+++ For Calc Current Candle   
   datetime CurrentCandleTime=SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);
   if(CurrentCandleTime != LastCandleTime)
      {
      LastCandleTime = CurrentCandleTime;
      CurrentCandleSpread = 0;
      CurrentCandleTicks = 0;
      }
   CurrentCandleSpread += Spread;
   CurrentCandleTicks++;
//--+++ For Calc Since Time
   if(SinceTime == 0) 
      {
      SinceTime = TimeCurrent();
      if(ObjectFind(0,IndName+" Averages L8") != -1) ObjectSetString(0,IndName+" Averages L8",OBJPROP_TEXT,TimeToString(SinceTime,TIME_DATE|TIME_MINUTES));       
      SinceSpread = 0;
      SinceTicks = 0;
      }
   
   SinceSpread += Spread;
   SinceTicks++;   
//--+++
   if(Display_Range1_Tab && ObjectFind(0,IndName+" "+Array[0]+" Background") != -1 && IsCreated)   CalcB1(Set_1,MainArray,X_B1,Y_B1);
   if(Display_Range2_Tab && ObjectFind(0,IndName+" "+Array[1]+" Background") != -1 && IsCreated)   CalcB1(Set_2,MainArray,X_B2,Y_B2);   
   if(Display_Averages_Tab && ObjectFind(0,IndName+" "+Array[2]+" Background") == 0  && IsCreated) CalcAv("Averages",MainArray,X_B0,Y_B0);

   ChartRedraw(0);

   return(rates_total);
  }
  
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
   {
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,0,true); 
   switch(id)
      {
      case CHARTEVENT_OBJECT_CLICK:       
          for(int i = 0; i < ArraySize(Array); i++)
            { 
            string n = IndName+" "+Array[i]+" ButtonClose";   
            if(sparam == n) { DeleteWindow(Array[i]); return; } 
            } 
         if(sparam == "Spread" && IsCreated) { DeleteWindow(""); IsCreated = false; return;}
         if(sparam == "Spread" && !IsCreated) 
            {
            if(Display_Averages_Tab)  CalcAv("Averages",MainArray,X_B0,Y_B0); 
            if(Display_Range1_Tab)   CalcB1(Set_1,MainArray,X_B1,Y_B1);
            if(Display_Range2_Tab)   CalcB1(Set_2,MainArray,X_B2,Y_B2);
            IsCreated = true;
            ChartRedraw(0);
            return;         
            }
         if(sparam == IndName+" Averages ButtonReset") { Reset(); return; }
         break;
      case CHARTEVENT_KEYDOWN:
          if(lparam == 116 && !IsCreated)
               { 
               if(Display_Averages_Tab)  CalcAv("Averages",MainArray,X_B0,Y_B0); 
               if(Display_Range1_Tab)   CalcB1(Set_1,MainArray,X_B1,Y_B1); 
               if(Display_Range2_Tab)   CalcB1(Set_2,MainArray,X_B2,Y_B2);
               IsCreated = true;
               ChartRedraw(0);
               return;   
               } 
            if(lparam == 116 && IsCreated) { DeleteWindow(""); IsCreated = false; return; }
            break;
         case CHARTEVENT_MOUSE_MOVE:
            if(sparam == 1 && !mouseflag)
               {
               box_name = CheckCordinates(lparam,dparam);
               if(box_name == "") return;
               ChartSetInteger(0,CHART_MOUSE_SCROLL,false);
               mouseflag = true;
               }
            if(sparam == 0 && mouseflag && box_name != "")
               {
               mouseflag = false;
               box_name = "";
               ChartSetInteger(0,CHART_MOUSE_SCROLL,true);
               ChartRedraw(0);
               return;               
               }
            if(mouseflag && box_name != "")
               {
               MoveObjects(box_name,lparam,dparam);    
               ChartRedraw(0);
               }            
            break;               
      }  
   ChartRedraw(0);   
   }
//+------------------------------------------------------------------+
void GroupElements(double  &aAr[], double &aAr2[], double &aAr3[])
   {
   double numb;
   int poz;   
   for(int i = 0; i < ArraySize(aAr3); i++)
      {
      numb = aAr3[i];
      if(numb == -1) break;
      poz = SearchForElement(aAr,numb);
      if(poz == ArraySize(aAr)) 
         {
         ArrayResize(aAr,poz+1);
         ArrayResize(aAr2,poz+1);
         aAr[poz] = numb;
         aAr2[poz] = 1;
         }
      else 
         {
         aAr2[poz]++;
         }   
      }
   }
//+------------------------------------------------------------------+   
double CalcAverage(double  &aAr[], double &aAr2[], int set)
   {
   double a=0,b=0;
   for(int i = 0; i < ArraySize(aAr); i++)
      {
      a += aAr[i] * aAr2[i];
      b += aAr2[i];
      }
    if(a == 0 || b == 0 || b != set) return(0);  
    return(a/b);  
   }
//+------------------------------------------------------------------+   
double CalcAverage2(double  &aAr[], double &aAr2[], int count)
   {
   double a=0,b=0;
   if(count == 0) count = ArraySize(aAr);
   for(int i = 0; i < count; i++)
      {
      if(aAr[i] == -1 && aAr2[i] == -1) return(0);
      a += aAr[i];
      b += aAr2[i];
      }
    if(a == 0 || b == 0) return(0);  
    return(a/b);  
   } 
//+------------------------------------------------------------------+     
void MainArray_Update(double spread, double &aAr[])
   {
   for(int i = ArraySize(aAr)-2; i >= 0; i--)
      {
      aAr[i+1] = aAr[i];
      }
   aAr[0] = spread;   
   }
//+------------------------------------------------------------------+   
double SearchForElement(double  &aAr[], double element)
   {
   if(ArraySize(aAr) == 0) return(0);
   for(int j = 0; j < ArraySize(aAr); j++)
      {
      if(aAr[j] == element) return(j);
      }
  return(ArraySize(aAr));    
   }
//+------------------------------------------------------------------+   
void HoareUp(double  &aAr[], double &aAr2[], int aLeft, int aRight)
  {
   double tmp,tmp2;
   int i=aLeft;
   int j=aRight;
   if(ArraySize(aAr) == 0) return;
   double xx=aAr[(aLeft+aRight)/2];
   do
     {
      while(i<aRight && aAr[i]<xx)i++;
      while(j>aLeft && xx<aAr[j])j--;
      if(i<=j)
         {
         tmp=aAr[i];       tmp2=aAr2[i]; 
      
         aAr[i]=aAr[j];    aAr2[i]=aAr2[j];
         aAr[j]=tmp;       aAr2[j]=tmp2;
         i++;
         j--;
         }
     }
   while(i<=j);
   if(aLeft<j)HoareUp(aAr,aAr2,aLeft,j);
   if(i<aRight)HoareUp(aAr,aAr2,i,aRight);
   }  
//+------------------------------------------------------------------+     
void  DeleteWindow(string Aname)
   {
   if(Aname == "")
      {
      for(int i = ObjectsTotal(0)-1; i >= 0; i--)
         {
         string ObjName = ObjectName(0,i); 
         if(StringFind(ObjName,IndName) != -1) ObjectDelete(0,ObjName);
         } 
      ChartRedraw(0);
      return;         
      }
   for(int i = ObjectsTotal(0)-1; i >= 0; i--)
      {
      string ObjName = ObjectName(0,i);
      if(StringFind(ObjName,Aname) != -1) ObjectDelete(0,ObjName);
      } 
   ChartRedraw(0);         
   }
void DeleteOld()
   {
   for(int i = ObjectsTotal(0)-1; i >= 0; i--)
      {
      string ObjName = ObjectName(0,i);
      if(StringFind(ObjName,IndName) != -1 && StringFind(ObjName,Array[0]) == -1 && StringFind(ObjName,Array[1]) == -1 && StringFind(ObjName,Array[2]) == -1 )
         ObjectDelete(0,ObjName);
      }    
   ChartRedraw(0); 
   }   
//+------------------------------------------------------------------+   
int Load(void)     
   {
   string date;
   int file_handle=FileOpen(InpFileName,FILE_READ|FILE_BIN);
   if(file_handle!=INVALID_HANDLE)
     {
      //FileReadArray(file_handle,TestArray2);
      FileReadArray(file_handle,MainArray);
      FileReadArray(file_handle,TimeArraySpread);
      FileReadArray(file_handle,TimeArrayTicks);
      date = TimeToString(FileReadInteger(file_handle),TIME_DATE|TIME_MINUTES); 
      SinceSpread = FileReadDouble(file_handle);
      SinceTicks = FileReadInteger(file_handle);
      FileClose(file_handle);  
      }
   SinceTime =StringToTime(date);       
   return(0);
   }
//+------------------------------------------------------------------+   
int Save(void)
   {
   int file_handle=FileOpen(InpFileName,FILE_WRITE|FILE_BIN);
   if(file_handle!=INVALID_HANDLE)
     {
      //FileSeek(file_handle,0,SEEK_END);
      FileWriteArray(file_handle,MainArray);
      FileWriteArray(file_handle,TimeArraySpread);
      FileWriteArray(file_handle,TimeArrayTicks);
      FileWriteInteger(file_handle,SinceTime);
      FileWriteDouble(file_handle,SinceSpread);
      FileWriteInteger(file_handle,SinceTicks);
      FileClose(file_handle);
      }
   return(0); 
   }
//+------------------------------------------------------------------+   
void Reset()
   {
   ArrayInitialize(MainArray,-1);
   ArrayInitialize(TimeArraySpread,-1);
   ArrayInitialize(TimeArrayTicks,-1); 
   SinceTime = 0;
   TArrayLastTime = 0;
   TSpread = 0;
   TTicks = 0;
   CurrentCandleSpread = 0;
   CurrentCandleTicks = 0;
   SinceSpread = 0;
   SinceTicks = 0;


   if(Display_Range1_Tab && ObjectFind(0,IndName+" "+Array[0]+" Background") != -1 && IsCreated)   CalcB1(Set_1,MainArray,X_B1,Y_B1);
   if(Display_Range2_Tab && ObjectFind(0,IndName+" "+Array[1]+" Background") != -1 && IsCreated)   CalcB1(Set_2,MainArray,X_B2,Y_B2);
   if(Display_Averages_Tab && ObjectFind(0,IndName+" "+Array[2]+" Background") != -1 && IsCreated ) CalcAv("Averages",MainArray,X_B0,Y_B0);
  
   for(int i = ObjectsTotal(0); i >= 0 ; i--)
      {
      string ObjName = ObjectName(0,i);
      if(ObjectGetInteger(0,ObjName,OBJPROP_TYPE) == OBJ_LABEL)
         {
         if(StringFind(ObjName,Array[0]) != -1)
            {
            int a = ObjectGetString(0,ObjName,OBJPROP_TEXT);
            ObjectDelete(0,IndName+" "+Array[0]+" "+a+" Bar");
            ObjectDelete(0,IndName+" "+Array[0]+" "+a+" Bar |");
            ObjectDelete(0,IndName+" "+Array[0]+" "+a+" Bar Nr");           
            }
         if(StringFind(ObjName,Array[1]) != -1)
            {
            int a = ObjectGetString(0,ObjName,OBJPROP_TEXT);
            ObjectDelete(0,IndName+" "+Array[1]+" "+a+" Bar");
            ObjectDelete(0,IndName+" "+Array[1]+" "+a+" Bar |");
            ObjectDelete(0,IndName+" "+Array[1]+" "+a+" Bar Nr");           
            }         
         }
      }     
   ChartRedraw(0);
   }       
//+------------------------------------------------------------------+   
string CheckCordinates(int x, int y)
   {
   for(int i = 0; i < ArraySize(Array); i++)
      {
      string n = IndName+" "+Array[i]+" Background";
      int XStart  = ObjectGetInteger(0,n,OBJPROP_XDISTANCE);
      int YStart  = ObjectGetInteger(0,n,OBJPROP_YDISTANCE);
      int XEnd    = XStart + ObjectGetInteger(0,n,OBJPROP_XSIZE);
      int YEnd    = YStart + ObjectGetInteger(0,n,OBJPROP_YSIZE);      

      if( x > XStart && x < XEnd && y > YStart && y < YEnd ) 
         {
         Drag_X = x;
         Drag_Y = y;      
         return(Array[i]);
         }      
      }
   return("");
   }   
   