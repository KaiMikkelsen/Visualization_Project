
Table suicidesTable;
Table socialMediaTable;
Table gdpTable;

int numberOfElements = 11;
String[] Years = new String[numberOfElements];
int[] Suicides = new int[numberOfElements];
int[] socialMediaUse = new int[numberOfElements];
int[] gdp_Per_Cap = new int[numberOfElements];

int xMainWindow = 1100;
int yMainWindow = 700;
float axisDisplaystartPercentage = 0.1;
float axisDisplayendPercentage = 0.90;

float[] xPositionsOfYears = new float[numberOfElements];
float[] yPositionOfSuicides = new float[numberOfElements];

float ystartPosition = 0;
float yEndPosition = 0;
float yAxisLength = 0;
float xstartPosition = 0;
float xEndPosition = 0;
float xAxisLength = 0;

int smallPieChartDiameter = (int) (0.03 * xMainWindow * axisDisplayendPercentage);
int bigPieChartDiameter = (int) (0.15 * xMainWindow * axisDisplayendPercentage);

int infoRecWidth = (int) (0.23 * xMainWindow * axisDisplayendPercentage);
int inforRecHeight = bigPieChartDiameter;
int infoRecCornerRadius = 28;

void fillDataArrays()
{
  
  //Years
  for(int i = 0; i < numberOfElements; i++)
  {
    String index = suicidesTable.getString(i, "Year");
    Years[i] = index;
    
  }
  
  //Suicides
  for(int i = 0; i < numberOfElements; i++)
  {
    String index = suicidesTable.getString(i, "Total Suicides");
    index = index.replace(",","");
    Suicides[i] = Integer.parseInt(index);
    
  }
  
  //Social Media
   for(int i = 0; i < numberOfElements; i++)
  {
    String index = socialMediaTable.getString(i, "Social Media Use");
    socialMediaUse[i] = Integer.parseInt(index);
  }
  
  //GDP
     for(int i = 0; i < numberOfElements; i++)
  {
    String index = suicidesTable.getString(i, "GDP_per_cap");
    gdp_Per_Cap[i] = Integer.parseInt(index);
  }
  

}



void setup() {
  size(1100, 700); //These have to be matching xMainWindow and yMainWindow Global Variables
  background(255);
  suicidesTable = loadTable("/Users/kai/Desktop/Data_Visualization/Total_Suicides_Data.csv", "header");
  socialMediaTable = loadTable("/Users/kai/Desktop/Data_Visualization/SocialMediaUse.csv", "header");
  
  
  fillDataArrays();

}




void drawXAxisSteps()
{


  float xStepSize = xAxisLength / numberOfElements;
  int steplineWidth = 10;

  int textYposition = 25;
  int textXoffset = 15;

  for(int i = 1; i < numberOfElements + 1; i++)
  {
    
    float xValue = xstartPosition + (i * xStepSize);
    line(xValue, yMainWindow * axisDisplayendPercentage + steplineWidth , xValue, yMainWindow * axisDisplayendPercentage - steplineWidth);
    text(Years[i-1], xValue - textXoffset, yMainWindow * axisDisplayendPercentage + textYposition); 
    xPositionsOfYears[i-1] = xValue;
    
  }

}

void drawYAxisSteps()
{


  float firstYSuicides = Suicides[0];
  float lastYsuicides = Suicides[Suicides.length-1];

  //Figure out how to well represent the y axis numerical values
  int topY = ceil(lastYsuicides/1000) * 1000;
  int bottomY = floor(firstYSuicides/1000) * 1000;
  float textStepSize = (topY - bottomY) / numberOfElements;
  

  //Figure out how to space the lines on the y axis
  float yStepSize = yAxisLength / numberOfElements;
  int steplineWidth = 10;
  textSize(15);
  int textXposition = 55;
  int textYoffset = 4;
  
  
 // Plot Y axis lines
  for(int i = numberOfElements; i >= 0; i--)
  {
    
    float yValue = yEndPosition - (i * yStepSize);
    line(xMainWindow * axisDisplaystartPercentage + steplineWidth, yValue , xMainWindow * axisDisplaystartPercentage - steplineWidth, yValue);

  }
 
 //Plot Y axis text values
  for(int i = numberOfElements; i >= 0; i--)
  {
    float yValue = yEndPosition - (i * yStepSize);
    text((int) (bottomY + ((i) * textStepSize) ), xMainWindow * axisDisplaystartPercentage - textXposition , yValue + textYoffset); 

  }
  
}

void getAxisPositions()
{
  
  ystartPosition = yMainWindow * axisDisplaystartPercentage;
  yEndPosition = yMainWindow * axisDisplayendPercentage;
  yAxisLength = yEndPosition - ystartPosition;
  
  xstartPosition = xMainWindow * axisDisplaystartPercentage;
  xEndPosition = xMainWindow * axisDisplayendPercentage;
  xAxisLength = xEndPosition - xstartPosition;
  
}

 
void drawAxis()
{

  stroke(0); 
  fill(0);
  strokeWeight(3);
  textSize(15);
  
  getAxisPositions();

  //X
  line(xMainWindow * axisDisplaystartPercentage, yMainWindow * axisDisplayendPercentage, xMainWindow * axisDisplayendPercentage, yMainWindow * axisDisplayendPercentage);
  //Y
  line(xMainWindow * axisDisplaystartPercentage, yMainWindow * axisDisplaystartPercentage , xMainWindow * axisDisplaystartPercentage , yMainWindow * axisDisplayendPercentage);
  
  drawXAxisSteps();
  drawYAxisSteps();
  
  
}



void drawPoints()
{
  

  strokeWeight(1);
  
  float firstYSuicides = Suicides[0];
  float lastYsuicides = Suicides[Suicides.length-1];
  
  int topY = ceil(lastYsuicides/1000) * 1000;
  int bottomY = floor(firstYSuicides/1000) * 1000;
  int yDifference = topY - bottomY;


  
  for(int i = 0; i < numberOfElements; i ++)
  {
  
     float normalizedSuicideRate = Suicides[i] - bottomY;
     float YAxisPointValue = (yAxisLength * normalizedSuicideRate) / yDifference; //Figure out what the value will be on our graph
     
     
     int socialMediaPercentage = (int) map(socialMediaUse[i], 0, 100, 0, 360); // Get the pie chart array values so we can map them
     int[] MediaAngles = {socialMediaPercentage, 360-socialMediaPercentage};
     
     pieChart(smallPieChartDiameter, MediaAngles, xPositionsOfYears[i], yEndPosition - YAxisPointValue);
     yPositionOfSuicides[i] = yEndPosition - YAxisPointValue;
  
  }
  
}


void pieChart(float diameter, int[] data,float x, float y) {
  float lastAngle = 0;
  for (int i = 0; i < data.length; i++) {
    float gray = map(i, 0, data.length, 0, 255);
    fill(gray);
    arc(x, y, diameter, diameter, lastAngle, lastAngle+radians(data[i]));
    lastAngle += radians(data[i]);
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void drawInfoRectangle(int year, int side)
{
    float infoSquareTextYPositionMultiplier = 0.07;
    float infoSquareTextLeftXPositionMultiplier = 0.07;
    float infoSquareTextRightXPositionMultiplier = 0.20;
  
      String[] InfoBoxTextInfo = new String[4];
      
      InfoBoxTextInfo[0] = "Year: " +  Years[year];
      InfoBoxTextInfo[1] = "Suicides: " + Suicides[year];
      InfoBoxTextInfo[2] = "SocialMedia Use: " + socialMediaUse[year] + "%";
      InfoBoxTextInfo[3] = "GDP per capita: " + gdp_Per_Cap[year];
      fill(0); 
      
      for(int i= 0; i < InfoBoxTextInfo.length; i++)
      {
        if(side == 1)
        {
          text(InfoBoxTextInfo[i], xPositionsOfYears[year] - (xMainWindow * infoSquareTextRightXPositionMultiplier), (yPositionOfSuicides[year] - (infoSquareTextYPositionMultiplier * yMainWindow) + (i * 0.03 * yMainWindow)));
         // text(suicideString, xPositionsOfYears[i] - (xMainWindow * infoSquareTextRightXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow)) + (1 * 0.03 * yMainWindow));
          //text(socialMediaUseString, xPositionsOfYears[i] - (xMainWindow * infoSquareTextRightXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow)) + (2 * 0.03 * yMainWindow));
      
        }
        if(side == 0)
        {
          
          text(InfoBoxTextInfo[i], xPositionsOfYears[year] + (xMainWindow * infoSquareTextLeftXPositionMultiplier), (yPositionOfSuicides[year] - (infoSquareTextYPositionMultiplier * yMainWindow) + (i * 0.03 * yMainWindow)));
          
        }
        
      }
      
      
  
}



void DetermineMouseOver()
{
  


  for(int i = 0; i < numberOfElements; i++)
  {
    
    boolean over = overCircle( (int) xPositionsOfYears[i], (int) yPositionOfSuicides[i], smallPieChartDiameter);

    int socialMediaPercentage = (int) map(socialMediaUse[i], 0, 100, 0, 360);
    int[] MediaAngles = {socialMediaPercentage, 360-socialMediaPercentage};
    //float infoSquareTextYPositionMultiplier = 0.07;
    //float infoSquareTextLeftXPositionMultiplier = 0.07;
    //float infoSquareTextRightXPositionMultiplier = 0.20;
    
    if(over)
    {
     // String yearString = "Year: " +  Years[i];
      //String suicideString = "Suicides: " + Suicides[i];
      //String socialMediaUseString = "SocialMedia Use: " + socialMediaUse[i] + "%";
      
      
      if(xPositionsOfYears[i] > xMainWindow/2)
      {
          
          
          fill(166);
          rect(xPositionsOfYears[i]- infoRecWidth, yPositionOfSuicides[i]- bigPieChartDiameter/2, infoRecWidth, inforRecHeight, infoRecCornerRadius);
          
          drawInfoRectangle(i, 1);
          //fill(0); 
          //text(yearString, xPositionsOfYears[i] - (xMainWindow * infoSquareTextRightXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow)));
          //text(suicideString, xPositionsOfYears[i] - (xMainWindow * infoSquareTextRightXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow)) + (1 * 0.03 * yMainWindow));
          //text(socialMediaUseString, xPositionsOfYears[i] - (xMainWindow * infoSquareTextRightXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow)) + (2 * 0.03 * yMainWindow));
        
      }
      else
      {
           
            //text(yearString, xPositionsOfYears[i], yPositionOfSuicides[i]- bigPieChartDiameter/2);
            fill(166);
            rect(xPositionsOfYears[i], yPositionOfSuicides[i]- bigPieChartDiameter/2, infoRecWidth, inforRecHeight, infoRecCornerRadius);
            
             drawInfoRectangle(i, 0);
             //fill(0); 
      //    text("test", xPositionsOfYears[i] + (xMainWindow * infoSquareTextLeftXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow)));
          //text(suicideString, xPositionsOfYears[i] + (xMainWindow * infoSquareTextLeftXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow) + (1 * 0.03 * yMainWindow)));
          //text(socialMediaUseString, xPositionsOfYears[i] + (xMainWindow * infoSquareTextLeftXPositionMultiplier), (yPositionOfSuicides[i] - (infoSquareTextYPositionMultiplier * yMainWindow) + (2 * 0.03 * yMainWindow)));

      }
      
      
      
      
      pieChart(bigPieChartDiameter, MediaAngles, xPositionsOfYears[i], yPositionOfSuicides[i]);
      
      
      
    }

    
  }
  

  
} 


void drawGDPLines()
{
  
    for(int i = 1; i < numberOfElements; i++)
    {
      
      if(gdp_Per_Cap[i-1] > gdp_Per_Cap[i])
      {
        
        
        
      }
      
      line(xPositionsOfYears[i],yPositionOfSuicides[i], xPositionsOfYears[i-1], yPositionOfSuicides[i-1]);
   
      
      
      
    }
    
  
  
}






 
void draw() {
  background(255);
  drawAxis();
  drawGDPLines();
  drawPoints();

  DetermineMouseOver();
  //println(mouseX);
  //println(mouseY);
  
  

  
  
} // function 
