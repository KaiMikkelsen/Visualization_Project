
Table agesData;
Table socialMediaTable;
Table gdpTable;

int xMainWindow = 1500;//1100;
int yMainWindow = 800;//700;
float xAxisDisplayStartPercentage = 0.15;//0.10;
float xAxisDisplayEndPercentage = 0.90;//0.90;
float yAxisDisplayStartPercentage = 0.30;//0.10;
float yAxisDisplayEndPercentage = 0.95;//0.90;

float yStartPosition = 0;
float yEndPosition = 0;
float yAxisLength = 0;
float xStartPosition = 0;
float xEndPosition = 0;
float xAxisLength = 0;
float yAxisMiddlePoint =0;

int numberOfYears = 11;
int numberOfRanges = 4;
int ageRangeArrayLength = 5;
float[][] suicideRangeArray = new float[numberOfYears][numberOfRanges];
float[][] socialMediaRangeArray = new float[numberOfYears][numberOfRanges];
int[] years = new int[numberOfYears];

float buttonBarStartingPoint = 0;
float individualYearButtonWidth = 0;
float individualyearButtonHeight = 0;
float lengthOfButtonBar = 0;
float percentageOfButtonBarLength = 0;
float individualyearButtonYStartingPoint = 0;

float[] buttonXPositions = new float[numberOfYears];
int[] clickedButton = {1,0,0,0,0,0,0,0,0,0,0};//new int[numberOfYears];
int[] ageRanges = {18, 30, 50, 65, 75};
float[] ageRangeXposition = new float[ageRangeArrayLength];

float largestSuicide = 0;

float xStepSize = 0;

int scrolledButton = 0;
int permanentClickedButton = 0;

int dataYearToShow = 0;

int buttonScrollOrClickedFlag = 1;
// 0 = scrolling
// 1 = not scrolling

void setup() {
  size(1500, 800); //These have to be matching xMainWindow and yMainWindow Global Variables
  background(255);
  agesData = loadTable("/Users/kai/Desktop/Data_Visualization/AgeRangeData.csv", "header");
  fillDataArrays();
  getAxisPositions();


}


void getAxisPositions()
{
  
  yStartPosition = yMainWindow * yAxisDisplayStartPercentage;
  yEndPosition = yMainWindow * yAxisDisplayEndPercentage;
  yAxisLength = yEndPosition - yStartPosition;
  
  xStartPosition = xMainWindow * xAxisDisplayStartPercentage;
  xEndPosition = xMainWindow * xAxisDisplayEndPercentage;
  xAxisLength = xEndPosition - xStartPosition;
  
  yAxisMiddlePoint = yStartPosition + yAxisLength/2;
  
}
void fillDataArrays()
{
  int first = 2005;
  for(int i = 0; i < numberOfYears; i++) 
  {
    years[i] = first + i;
  }
  
  //Suicides
  int i = 0;
  for(int year = 0; year < numberOfYears; year++) 
  {
    for(int ageRange = 0; ageRange < numberOfRanges; ageRange++)
    {
       String index = agesData.getString(i, "Suicides");
      suicideRangeArray[year][ageRange] = Float.parseFloat(index);
      
      if(suicideRangeArray[year][ageRange] > largestSuicide)
      {
        largestSuicide = suicideRangeArray[year][ageRange];
      }
      i++;
    }  
  }
  
  
  //Social Media
  i = 0;
  for(int year = 0; year < numberOfYears; year++) 
  {
    for(int ageRange = 0; ageRange < numberOfRanges; ageRange++)
    {
       String index = agesData.getString(i, "Social Media");
      socialMediaRangeArray[year][ageRange] = Integer.parseInt(index);
      i++;
    }  
  }
  
}



void drawYearButtons()
{
  percentageOfButtonBarLength = (1-xAxisDisplayStartPercentage);
  buttonBarStartingPoint = xMainWindow * xAxisDisplayStartPercentage;//(1 - percentageOfButtonBarLength)/2 * xMainWindow;
  lengthOfButtonBar = (xMainWindow * xAxisDisplayEndPercentage) - (xMainWindow * xAxisDisplayStartPercentage);//xMainWindow * percentageOfButtonBarLength;
  individualYearButtonWidth = lengthOfButtonBar/numberOfYears;
  individualyearButtonHeight = 75;
  float yPercentageTopofBar = 0.1;
  individualyearButtonYStartingPoint = yMainWindow * yPercentageTopofBar;
  
  for(int i= 0; i < numberOfYears; i++)
  {
 
    fill(255);
    buttonXPositions[i] = buttonBarStartingPoint + (i * individualYearButtonWidth);
    
    rect(buttonXPositions[i], individualyearButtonYStartingPoint, individualYearButtonWidth, individualyearButtonHeight); 
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(0);
    text(2005+i, buttonXPositions[i] + individualYearButtonWidth/2, individualyearButtonYStartingPoint + 30);

  }

}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void mouseOverButtons()
{
  
  if(overRect((int) buttonBarStartingPoint, (int) individualyearButtonYStartingPoint, (int) lengthOfButtonBar, (int) individualyearButtonHeight))
  {

    buttonScrollOrClickedFlag = 0;
    for(int i = 0; i < numberOfYears; i++)
    {
      if(overRect((int) buttonXPositions[i], (int) individualyearButtonYStartingPoint, (int) individualYearButtonWidth, (int) individualyearButtonHeight))
      {
           scrolledButton = i;
    
      }

    }
    
  }
  else
  {
    buttonScrollOrClickedFlag = 1;
  }
  
  
  
}

void mousePressed() 
{


    for(int i = 0; i < numberOfYears; i++)
    {
      
        if(overRect((int) buttonXPositions[i], (int) individualyearButtonYStartingPoint, (int) individualYearButtonWidth, (int) individualyearButtonHeight))
        {
            permanentClickedButton = i;
        }

      }

}

void clickedButton()
{
  
    fill(0);
    rect(buttonXPositions[permanentClickedButton], individualyearButtonYStartingPoint, individualYearButtonWidth, individualyearButtonHeight);  
    fill(255);
    text(2005+permanentClickedButton, buttonXPositions[permanentClickedButton] + individualYearButtonWidth/2, individualyearButtonYStartingPoint + 30);
  if(buttonScrollOrClickedFlag == 1) //not scrolling
  {
    
    dataYearToShow = permanentClickedButton;
    
    
  }
  else //scrolling
  {
    
    fill(200);
    rect(buttonXPositions[scrolledButton], individualyearButtonYStartingPoint, individualYearButtonWidth, individualyearButtonHeight); 
    fill(0);
    text(2005+scrolledButton, buttonXPositions[scrolledButton] + individualYearButtonWidth/2, individualyearButtonYStartingPoint + 30);

    dataYearToShow = scrolledButton;

}
}


void drawAxis()
{
  //X
  line(xStartPosition, yAxisMiddlePoint, xEndPosition, yAxisMiddlePoint);
  
  //Y
  line(xStartPosition, yStartPosition , xStartPosition , yEndPosition);
  drawXAxisSteps();
  drawTopYAxisSteps();
  drawBottomYAxisSteps();
  
  
}

void drawXAxisSteps()
{

  textSize(20);
  xStepSize = xAxisLength / (ageRangeArrayLength-1);
  //println("og stepsize is: " + xStepSize);
  int steplineWidth = 10;

  int textYOffset = 20;
  int textXoffset = 10;
  fill(0);
  for(int i = 0; i < ageRangeArrayLength; i++)
  {
    
    float xValue = xStartPosition + ((i) * xStepSize);
    line(xValue, yAxisMiddlePoint + steplineWidth , xValue, yAxisMiddlePoint - steplineWidth);
    if( i == 0)
    {
      text(ageRanges[i], xValue+10, yAxisMiddlePoint + 10); 
    }
    else
    {
      text(ageRanges[i], xValue, yAxisMiddlePoint + textYOffset); 
    }
    
    ageRangeXposition[i] = xValue;
    
  }

    


}

void drawTopYAxisSteps()
{


  float firstYSuicides = largestSuicide;
  float lastYsuicides = largestSuicide;

  //Figure out how to well represent the y axis numerical values
  float topY = 15000;//ceil(lastYsuicides/1500) * 1500;
  float bottomY = 0;
  float test = 11;
  float textStepSize = (topY - bottomY) / test;


  //Figure out how to space the lines on the y axis
  float yStepSize = (yAxisLength/2) / numberOfYears;
  int steplineWidth = 10;
  textSize(15);
  int textXposition = 40;
  int textYoffset = 0;
  
  
 // Plot Y axis lines
  for(int i = numberOfYears; i >= 0; i--)
  {
    
    float yValue = yAxisMiddlePoint - (i * yStepSize);
    line(xStartPosition + steplineWidth, yValue , xStartPosition - steplineWidth, yValue);

  }
 
 //Plot Y axis text values
  for(int i = numberOfYears; i >= 0; i--)
  {
    float yValue = yAxisMiddlePoint - (i * yStepSize);
    text((int) round(bottomY + ((i) * textStepSize) ), xStartPosition - textXposition , yValue + textYoffset); 

  }
  
}

void drawBottomYAxisSteps()
{


  float firstYSuicides = largestSuicide;
  float lastYsuicides = largestSuicide;

  //Figure out how to well represent the y axis numerical values
  float topY = 100;//ceil(lastYsuicides/1500) * 1500;
  float bottomY = 0;
  float test = 11;
  float textStepSize = (topY - bottomY) / test;


  //Figure out how to space the lines on the y axis
  float yStepSize = (yAxisLength/2) / numberOfYears;
  int steplineWidth = 10;
  textSize(15);
  int textXposition = 40;
  int textYoffset = 0;
  
  
 // Plot Y axis lines
  for(int i = numberOfYears; i >= 0; i--)
  {
    
    float yValue = yEndPosition - (i * yStepSize);
    line(xStartPosition + steplineWidth, yValue , xStartPosition - steplineWidth, yValue);

  }
 
 //Plot Y axis text values
  for(int i = numberOfYears; i >= 0; i--)
  {
    float yValue = yEndPosition - (i * yStepSize);
    text((int) round(bottomY + ((numberOfYears - i) * textStepSize) ), xStartPosition - textXposition , yValue + textYoffset); 

  }
  
}

void drawSuicideBars()
{
  
  float percentageWidth = 0.80;
  float barWidth = xStepSize * percentageWidth;
 // println(barWidth);
  
  

      for(int ageRange = 0; ageRange < numberOfRanges; ageRange++)
      {
        float suicideHeight = map(suicideRangeArray[dataYearToShow][ageRange], 0, largestSuicide, 0, yAxisLength/2);
        fill(100);
        rect((xStartPosition + ((ageRange) * xStepSize)) + (((1-percentageWidth)/2) * xStepSize), yAxisMiddlePoint ,barWidth, -suicideHeight);
      
      }  
    
   
  
}
  
void drawSocialMediaBars()
{
  
  float percentageWidth = 0.80;
  float barWidth = xStepSize * percentageWidth;
 // println(barWidth);
  
  

      for(int ageRange = 0; ageRange < numberOfRanges; ageRange++)
      {
        float suicideHeight = map(socialMediaRangeArray[dataYearToShow][ageRange], 0, 100, 0, yAxisLength/2);
        fill(200);
        rect((xStartPosition + ((ageRange) * xStepSize)) + (((1-percentageWidth)/2) * xStepSize), yAxisMiddlePoint ,barWidth, suicideHeight);
      
      }  


}

void drawAxisLabels()
{
  float titleYPercentage = 0.07;
  
  fill(0);
  textAlign(CENTER);

  float suicideLabelYPosition = yEndPosition - (yAxisLength * 0.75);
  float suicideLabelXPosition = xStartPosition/2 - 20;
  
  float socialMediaLabelYPosition = yEndPosition - (yAxisLength * 0.25);
  float socialMediaLabelXPosition = xStartPosition/2 - 20;
  
  float ageRangesLabelYPosition = yEndPosition + (yMainWindow - yEndPosition)/(2);
  float ageRangesLabelXPosition = xEndPosition - xAxisLength/2;

  
  textSize(44);
  
  text("Contrasting Social Media Use with Number of Suicides", width/2, yMainWindow * titleYPercentage);
  
  textSize(25);
  
  text("Age Ranges", ageRangesLabelXPosition, ageRangesLabelYPosition);
  text("Number of \n Suicides", suicideLabelXPosition, suicideLabelYPosition);
  text("% Using \n Social Media", socialMediaLabelXPosition, socialMediaLabelYPosition);

  
  
}



void draw() {
  background(255);
  drawYearButtons();
  mouseOverButtons();
  clickedButton();
  drawAxis();
  drawSuicideBars();
  drawSocialMediaBars();
  drawAxisLabels();

  
  
} // function 
