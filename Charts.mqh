void CreateMainObjects(string Aname, int X, int Y, int sizeX, int sizeY, int SizeTitle) 
   {
   string name = IndName+" "+Aname+" Background";
   if(ObjectFind(0,name) == -1)
      {   
      ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,sizeX);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,sizeY);  
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,BackGroundColor);  
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);   
      ObjectSetInteger(0,name,OBJPROP_COLOR,DimColor); 
      }  
   name = IndName+" "+Aname+" Box";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+5);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+10);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,sizeX-10);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,sizeY-15);  
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,BackGroundColor); 
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DOT);  
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);   
      ObjectSetInteger(0,name,OBJPROP_COLOR,DimColor); 
      }  
      
   name = IndName+" "+Aname+" ButtonClose";
   if(ObjectFind(0,name) == -1)
      {   
      ObjectCreate(0,name,OBJ_BITMAP_LABEL,0,0,0);
      ObjectSetString(0,name,OBJPROP_BMPFILE,1,"::Close.bmp");
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+sizeX-23);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+2);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,20);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,20);
      } 
      name = IndName+" "+Aname+" ChartName";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_EDIT,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+15);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+6);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,SizeTitle);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,13);         
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,BackGroundColor); 
      ObjectSetString(0,name,OBJPROP_TEXT,Aname); 
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);
      ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_LEFT);          
      } 
   if(Aname == "Averages")
      {
      name = IndName+" "+Aname+" ButtonReset";
      if(ObjectFind(0,name) == -1)
         {   
         ObjectCreate(0,name,OBJ_BITMAP_LABEL,0,0,0);
         ObjectSetString(0,name,OBJPROP_BMPFILE,1,"::Reset.bmp");
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+25);
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+sizeY-35);
         ObjectSetInteger(0,name,OBJPROP_XSIZE,30);
         ObjectSetInteger(0,name,OBJPROP_YSIZE,20);
         }  
      }                
   }
//+------------------------------------------------------------------+   
void CalcAv(string Aname, double &Arr[], int X, int Y)
   {
  
   int sizeX = 150;
   int sizeY = 175;
   CreateMainObjects(Aname,X,Y,sizeX,sizeY,60);
   
   string name = IndName+" "+Aname+" Background";
   if(ObjectFind(0,name) != -1)
      {
      X = ObjectGetInteger(0,name,OBJPROP_XDISTANCE);
      Y = ObjectGetInteger(0,name,OBJPROP_YDISTANCE);
      } 
   int Xcenter = X + sizeX/2 +20; 
   
   double Sum1 = 0;  
   double Sum2 = 0;  

   for(int i = 0; i < ArraySize(Arr); i++) { if(Arr[i] == -1) { Sum1 = 0; Sum2 = 0; break; } if(i < 100) Sum1 +=Arr[i]; Sum2 += Arr[i]; }

   if(Sum1 != 0)  CreateAvLabels("Last 100 Ticks",1,Xcenter,Y,Sum1/100); 
   else           CreateAvLabels("Last 100 Ticks",1,Xcenter,Y,0);
   
   if(Sum2 != 0)  CreateAvLabels("Last 1000 Ticks",2,Xcenter,Y,Sum2/1000);
   else           CreateAvLabels("Last 1000 Ticks",2,Xcenter,Y,0);
   
   if(CurrentCandleSpread != 0 && CurrentCandleTicks != 0)
                  CreateAvLabels("Current Candle",3,Xcenter,Y,CurrentCandleSpread/CurrentCandleTicks);
   else           CreateAvLabels("Current Candle",3,Xcenter,Y,0);                 

   CreateAvLabels("Last 10 Min",4,Xcenter,Y,CalcAverage2(TimeArraySpread,TimeArrayTicks,60));
   CreateAvLabels("Last 30 Min",5,Xcenter,Y,CalcAverage2(TimeArraySpread,TimeArrayTicks,180));
   CreateAvLabels("Last Hour",6,Xcenter,Y,CalcAverage2(TimeArraySpread,TimeArrayTicks,0));

   name = IndName+" Averages L7";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+15);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+120);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);       
      }
      
    if(SinceTime != 0) ObjectSetString(0,name,OBJPROP_TEXT,"Since: "+TimeToString(SinceTime,TIME_DATE|TIME_MINUTES));  
    else ObjectSetString(0,name,OBJPROP_TEXT,"Since: ");
   name = IndName+" Averages RL7";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+sizeX/2+30);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+145);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10); 
      }  
   if(SinceSpread == 0 || SinceTicks == 0)
      {
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
      ObjectSetString(0,name,OBJPROP_TEXT,"N/A");      
      }  
   else
      {
      double value = SinceSpread/SinceTicks;
      if(value > Spread_Level) ObjectSetInteger(0,name,OBJPROP_COLOR,Color_High);
      else ObjectSetInteger(0,name,OBJPROP_COLOR,Color_Low);
      ObjectSetString(0,name,OBJPROP_TEXT,DoubleToString(value,1));  
      }          
   name = IndName+" Averages RLT7";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+sizeX/2+30);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+160);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7); 
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
      }      
   ObjectSetString(0,name,OBJPROP_TEXT,"( "+SinceTicks+" )");     
   }
//+------------------------------------------------------------------+    
void CreateAvLabels(string Tname, int poz, int X,int Y,double value)
   {
   string name = IndName+" Averages L"+poz;
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+14+16*poz);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8); 
      ObjectSetString(0,name,OBJPROP_TEXT,Tname+":");  
      }   
   name = IndName+" Averages RL"+poz;
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+10);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+14+16*poz);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8); 
      } 
   if(value == 0) 
      {
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
      ObjectSetString(0,name,OBJPROP_TEXT,"N/A");
      return;
      } 
   color cc;    
   if(value > Spread_Level)  cc = Color_High; else cc = Color_Low;
   
   if(value == 0) 
      {
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
      ObjectSetString(0,name,OBJPROP_TEXT,"N/A");       
      return;
      }
   
   ObjectSetInteger(0,name,OBJPROP_COLOR,cc);
   ObjectSetString(0,name,OBJPROP_TEXT,DoubleToString(value,1));        
   }  
//+------------------------------------------------------------------+ 
void CalcB1(int size, double &Arr[],int X, int Y)
   {
   double MainA[];   
   ArrayCopy(MainA,Arr,0,0,size);

   double A_result[];
   double A_count[];   
   ArrayResize(A_result,0);
   ArrayResize(A_count,0);
   GroupElements(A_result,A_count,MainA);
   HoareUp(A_result,A_count,0,ArraySize(A_result)-1);     

   CreateBox(size,A_result,A_count,"Last "+size+" Ticks",X,Y);   
   }
//+------------------------------------------------------------------+  
void CreateBox(int Size, double &Arr1[], double &Arr2[], string Aname, int X, int Y)
   {
   int sizeX = 150;
   int sizeY = 120;
   CreateMainObjects(Aname,X,Y,sizeX,sizeY,85);
   
   string name = IndName+" "+Aname+" Background";
   if(ObjectFind(0,name) != -1)
      {   
      X = ObjectGetInteger(0,name,OBJPROP_XDISTANCE);
      Y = ObjectGetInteger(0,name,OBJPROP_YDISTANCE);      
      }
   int ShiftLeft = 29;   
   int ShiftRight = 15;
   int ShiftUp = 25;
   int ShiftDown = 25; 
   name = IndName+" "+Aname+" X_axis";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+ShiftLeft);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+sizeY-ShiftDown);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,sizeX-ShiftLeft-ShiftRight);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,1); 
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrNONE);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);             
      }   
   name = IndName+" "+Aname+" Y_axis";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+ShiftLeft);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+ShiftUp);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,1);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,sizeY-ShiftUp-ShiftDown); 
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrNONE);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);             
      } 
   int CountX = ArraySize(Arr1);
   int ASize = CountX;
   if(CountX == 0) return;
   
   int TotalWindowSizeX = sizeX - ShiftLeft - ShiftRight - 5;
   int TotalWindowSizeY = sizeY - ShiftDown - ShiftUp - 5;

   int space = 1;
   int fontsize = 8; 
   int barsize = ( TotalWindowSizeX - (space * (CountX - 1))) / CountX; 
   if(CountX >= 8) 
      { 
      fontsize = 7; 
      space = -1; 
      barsize = ( TotalWindowSizeX - (space * (8 - 1))) / 8;
      TotalWindowSizeX = CountX * (barsize + 1)  + space * (CountX -1);
      }
 
//---+++ Change Window size

   int C_Window_Size = TotalWindowSizeX + ShiftLeft + ShiftRight;
   if( C_Window_Size != sizeX )
      {
      name = IndName+" "+Aname+" Background";
      ObjectSetInteger(0,name,OBJPROP_XSIZE,C_Window_Size);
      name = IndName+" "+Aname+" Box";
      ObjectSetInteger(0,name,OBJPROP_XSIZE,C_Window_Size-10);
      name = IndName+" "+Aname+" ButtonClose";
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+C_Window_Size-23);
      }
//---+++  
   
   int maxvalue = Arr2[ArrayMaximum(Arr2)];
   
   int Ystart = Y + sizeY - TotalWindowSizeY - ShiftDown ;
   int x0 = X + ShiftLeft;
   int x1 = barsize + 1;    
   int y0,y1;

   Y_Axis(Aname,maxvalue,x0,TotalWindowSizeX,Ystart,TotalWindowSizeY);
        
   for(int i = 0; i < ASize; i++)
      {
      y0 = Ystart + ( maxvalue - Arr2[i] )* (TotalWindowSizeY + 1) / maxvalue;

      y1 = ( TotalWindowSizeY +1)  - ( y0 - Ystart);  
      CreateBar(Aname,Arr1[i],x0,x1,y0,y1,fontsize); 
      x0 += x1 + space;        
      }          
//---++++ istrinami nereikalingi stulpeliai   
   for(int i = ObjectsTotal(0); i >= 0 ; i--)
      {
      string ObjName = ObjectName(0,i);
      if(ObjectGetInteger(0,ObjName,OBJPROP_TYPE) == OBJ_LABEL && StringFind(ObjName,Aname) != -1)
         {
         int a = ObjectGetString(0,ObjName,OBJPROP_TEXT);
         bool F = false;
         for(int j = 0; j < ArraySize(Arr1); j++) if(Arr1[j] == a) { F = true; break; }    
         if(!F)
            {
            ObjectDelete(0,IndName+" "+Aname+" "+a+" Bar");
            ObjectDelete(0,IndName+" "+Aname+" "+a+" Bar |");
            ObjectDelete(0,IndName+" "+Aname+" "+a+" Bar Nr");
            }
         }
      }     
//---+++   Calc average
   name = IndName+" "+Aname+" Av";
   if(ObjectFind(0,name) == -1)
      {    
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+18);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+sizeY-17);            
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,BackGroundColor); 
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_CENTER);
      } 
   color cc;
   double av = CalcAverage(Arr1,Arr2,Size);
   if(av > Spread_Level) cc = Color_High;
   else cc = Color_Low;  
   
   if(av == 0) 
      {
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);        
      ObjectSetString(0,name,OBJPROP_TEXT,"N/A");
      return;    
      }  
   ObjectSetInteger(0,name,OBJPROP_COLOR,cc);        
   ObjectSetString(0,name,OBJPROP_TEXT,DoubleToString(av,1));   
    
   }   
//+------------------------------------------------------------------+  
void CreateBar(string SetName, double value, int x0, int x1, int y0, int y1, int FontSize)
   {
   string name = IndName+" "+SetName+" "+value+" Bar";
   if(ObjectFind(0,name) == -1)
      {
      ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
      ObjectSetString(0,name,OBJPROP_TEXT,value);  
      }
   if(value > Spread_Level) ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Color_High);
   else ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Color_Low);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x0);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y0);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,x1);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,y1);        
//--++++
   name = IndName+" "+SetName+" "+value+" Bar |";
   if(ObjectFind(0,name) == -1)
      {      
      ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
      ObjectSetInteger(0,name,OBJPROP_XSIZE,1);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,3);       
      } 
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x0+(x1/2));
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y0+y1);
//--++++      
   name = IndName+" "+SetName+" "+value+" Bar Nr";
   if(ObjectFind(0,name) == -1)
      {        
      ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,BackGroundColor); 
      ObjectSetString(0,name,OBJPROP_TEXT,value);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_CENTER);
      } 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x0+(x1/2));
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y0+y1+9);
   }
//+------------------------------------------------------------------+     
void Y_Axis(string SetName, int max, int x0, int x1, int y0, int y1)
   {
   string name;
   int l_count,level;
   if(max < 20) l_count = 2;
   else l_count = 3; 
   
   for(int i = 3; i >= 1; i--)
      {
      if( i == 3 && l_count == 2) level = (max / l_count) * 2;
      else level = (max / l_count) * i;  
      int y = y0 + ( max - level )* y1 / max;
            
      name = IndName+" "+SetName+i+" Yal";
      if(ObjectFind(0,name) == -1)
         {  
         ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrNONE);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrGray);
         ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_DOT);
         ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
         ObjectSetInteger(0,name,OBJPROP_YSIZE,1);         
         } 
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x0-3);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,x1+5);
//---+++ 
      name = IndName+" "+SetName+i+" Yall";   
      if(ObjectFind(0,name) == -1)
         {          
         ObjectCreate(0,name,OBJ_LABEL,0,0,0,0);
         ObjectSetInteger(0,name,OBJPROP_BGCOLOR,BackGroundColor);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x0-5);
         ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT); 
         }         
      ObjectSetString(0,name,OBJPROP_TEXT,level);
      
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      }
   }
//+------------------------------------------------------------------+  
void MoveObjects(string Aname, int x, int y)
   {
   int X_dif = x - Drag_X;
   int Y_dif = y - Drag_Y;
   for(int i = 0; i < ObjectsTotal(0); i++)
      {
      string ObjName = ObjectName(0,i);
      if(StringFind(ObjName,Aname) != -1) 
         {
         int objx =  ObjectGetInteger(0,ObjName,OBJPROP_XDISTANCE); 
         int objy =  ObjectGetInteger(0,ObjName,OBJPROP_YDISTANCE);
         ObjectSetInteger(0,ObjName,OBJPROP_XDISTANCE,objx+X_dif);
         ObjectSetInteger(0,ObjName,OBJPROP_YDISTANCE,objy+Y_dif);          
         }
      }
   Drag_X = x;
   Drag_Y = y;   
   }   
//+------------------------------------------------------------------+  
void ShowSpread(double spread, double price)
   {
   color cc;
   string name = "Spread";
   int X,Y;   
   switch(Display_Spread)
      {
      case 0: 
         if(ObjectFind(0,name) == -1) 
            {
            ObjectCreate(0,name,OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
            ObjectSetInteger(0,name,OBJPROP_XDISTANCE,30);
            ObjectSetInteger(0,name,OBJPROP_YDISTANCE,10);     
            ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);    
            }
         break;     
      case 1:
         if(ObjectFind(0,name) == -1) 
            {
            ObjectCreate(0,name,OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
            ObjectSetInteger(0,name,OBJPROP_XDISTANCE,30);
            ObjectSetInteger(0,name,OBJPROP_YDISTANCE,30);     
            ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_LOWER);    
            }          
         break;
      case 2:
         if(ObjectFind(0,name) == -1) 
            {
            ObjectCreate(0,name,OBJ_TEXT,0,0,0);
            ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
            }   
         ObjectSetDouble(0,name,OBJPROP_PRICE,price);
         ObjectSetInteger(0,name,OBJPROP_TIME,TimeCurrent()+PeriodSeconds());         
         break;
      }
   if(spread > Spread_Level) cc = Color_High;
   else cc = Color_Low;    
   ObjectSetString(0,name,OBJPROP_TEXT,spread);
   ObjectSetInteger(0,name,OBJPROP_COLOR,cc);      
   }    
   

      
    
