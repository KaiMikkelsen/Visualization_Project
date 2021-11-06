
Table suicidesTable;
Table socialMediaTable;
Table gdpTable;

int numberOfElements = 11;
String[] Years = new String[numberOfElements];
int[] Suicides = new int[numberOfElements];
int[] socialMediaUse = new int[numberOfElements];
int[] gdp_Per_Cap = new int[numberOfElements];

int xMainWindow = 1500;//1100;
int yMainWindow = 800;//700;
float xAxisDisplaystartPercentage = 0.11;//0.10;
float xAxisDisplayendPercentage = 0.77;//0.90;
float yAxisDisplaystartPercentage = 0.15;//0.10;
float yAxisDisplayendPercentage = 0.90;//0.90;

float[] xPositionsOfYears = new float[numberOfElements];
float[] yPositionOfSuicides = new float[numberOfElements];

float ystartPosition = 0;
float yEndPosition = 0;
float yAxisLength = 0;
float xstartPosition = 0;
float xEndPosition = 0;
float xAxisLength = 0;

int smallPieChartDiameter = (int) (0.03 * xMainWindow * xAxisDisplayendPercentage);
int bigPieChartDiameter = (int) (0.15 * xMainWindow * xAxisDisplayendPercentage);

int infoRecWidth = (int) (0.23 * xMainWindow * xAxisDisplayendPercentage);
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
  size(1500, 800); //These have to be matching xMainWindow and yMainWindow Global Variables
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
    line(xValue, yMainWindow * yAxisDisplayendPercentage + steplineWidth , xValue, yMainWindow * yAxisDisplayendPercentage - steplineWidth);
    text(Years[i-1], xValue - textXoffset, yMainWindow * yAxisDisplayendPercentage + textYposition); 
    xPositionsOfYears[i-1] = xValue;
    
  }

}

void drawYAxisSteps()
{


  float firstYSuicides = Suicides[0];
  float lastYsuicides = Suicides[Suicides.length-1];

  //Figure out how to well represent the y axis numerical values
  float topY = ceil(lastYsuicides/1000) * 1000;
  float bottomY = floor(firstYSuicides/1000) * 1000;
  float elements = 11;
  float textStepSize = (topY - bottomY) / elements;
  

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
    line(xMainWindow * xAxisDisplaystartPercentage + steplineWidth, yValue , xMainWindow * xAxisDisplaystartPercentage - steplineWidth, yValue);

  }
 
 //Plot Y axis text values
  for(int i = numberOfElements; i >= 0; i--)
  {
    float yValue = yEndPosition - (i * yStepSize);
    text((int) (bottomY + ((i) * textStepSize) ), xMainWindow * xAxisDisplaystartPercentage - textXposition , yValue + textYoffset); 

  }
  
}

void getAxisPositions()
{
  
  ystartPosition = yMainWindow * yAxisDisplaystartPercentage;
  yEndPosition = yMainWindow * yAxisDisplayendPercentage;
  yAxisLength = yEndPosition - ystartPosition;
  
  xstartPosition = xMainWindow * xAxisDisplaystartPercentage;
  xEndPosition = xMainWindow * xAxisDisplayendPercentage;
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
  line(xMainWindow * xAxisDisplaystartPercentage, yMainWindow * yAxisDisplayendPercentage, xMainWindow * xAxisDisplayendPercentage, yMainWindow * yAxisDisplayendPercentage);
  //Y
  line(xMainWindow * xAxisDisplaystartPercentage, yMainWindow * yAxisDisplaystartPercentage , xMainWindow * xAxisDisplaystartPercentage , yMainWindow * yAxisDisplayendPercentage);
  
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
   // float gray = map(i, 0, data.length, 0, 100);//255
   if(i == 0)
   {
     fill(0);
   }
   else
   {
     fill(255);
   }

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
    float infoSquareTextYPositionMultiplier = 0.35;
    float infoSquareTextLeftXPositionMultiplier = 0.93;
    float infoSquareTextRightXPositionMultiplier = 0.35;
  
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
         
          text(InfoBoxTextInfo[i], xPositionsOfYears[year] - infoRecWidth * infoSquareTextLeftXPositionMultiplier, yPositionOfSuicides[year] - (inforRecHeight * infoSquareTextYPositionMultiplier) + (i * 0.03 * yMainWindow) );

        }
        if(side == 0)
        {
          
          text(InfoBoxTextInfo[i], xPositionsOfYears[year] + infoRecWidth * infoSquareTextRightXPositionMultiplier, yPositionOfSuicides[year] - (inforRecHeight * infoSquareTextYPositionMultiplier) + (i * 0.03 * yMainWindow));
          
        }
        
      }
      
      
  
}



void determineMouseOver()
{
  


  for(int i = 0; i < numberOfElements; i++)
  {
    
    boolean over = overCircle( (int) xPositionsOfYears[i], (int) yPositionOfSuicides[i], smallPieChartDiameter);

    int socialMediaPercentage = (int) map(socialMediaUse[i], 0, 100, 0, 360);
    int[] MediaAngles = {socialMediaPercentage, 360-socialMediaPercentage};

    if(over)
    {

      
      if(xPositionsOfYears[i] > xMainWindow/2)
      {
          
          
          fill(166);
          rect(xPositionsOfYears[i]- infoRecWidth, yPositionOfSuicides[i]- bigPieChartDiameter/2, infoRecWidth, inforRecHeight, infoRecCornerRadius);
          
          drawInfoRectangle(i, 1);

        
      }
      else
      {
           
            fill(166);
            rect(xPositionsOfYears[i], yPositionOfSuicides[i]- bigPieChartDiameter/2, infoRecWidth, inforRecHeight, infoRecCornerRadius);
            
             drawInfoRectangle(i, 0);


      }
      
      
      
      
      pieChart(bigPieChartDiameter, MediaAngles, xPositionsOfYears[i], yPositionOfSuicides[i]);
      
      
      
    }

    
  }
  

  
} 


void drawGDPLines()
{
  
    //Stroke weight 0 - 3
    for(int i = 1; i < numberOfElements; i++)
    {
      
      float gdpDifference = (float) (gdp_Per_Cap[i] - gdp_Per_Cap[i-1]);
      float gdpStrokeWeight = map(gdpDifference, -1565.0, 2243.0, 0, 3);


      strokeWeight(gdpStrokeWeight);
      line(xPositionsOfYears[i],yPositionOfSuicides[i], xPositionsOfYears[i-1], yPositionOfSuicides[i-1]);
 
    }

}


void drawAxisLabels()
{
  float titleYPercentage = 0.07;
  
  fill(0);
  textAlign(CENTER);

  float yLabelYPosition = yEndPosition - yAxisLength/2;
  float yLabelXPosition = xstartPosition/2;
  
  float xLabelYPosition = yEndPosition + (yMainWindow - yEndPosition)/2;
  float xLabelXPosition = xEndPosition - xAxisLength/2;

  
  textSize(44);
  
  text("Social Media Use, Sucides and GDP", width/2, yMainWindow * titleYPercentage);
  
  textSize(25);
  
  text("Year", xLabelXPosition, xLabelYPosition);
  text("Number of \n Suicides", yLabelXPosition, yLabelYPosition);

  
  
}


void drawLegend()
{
  fill(255);
  float legendRectangleXPad = 30;
  float legendRectangleTextPad = 20;
  float legendRectangleYPositionPercentage = 0.55;
  float legendWidth = 480;
  float legendHeight = 130;
  rect(xMainWindow - legendWidth - legendRectangleXPad, yMainWindow * legendRectangleYPositionPercentage , legendWidth, legendHeight);
  
 
  fill(0);
  textSize(15);
  float legendTitleYPercentage = 0.10;
  textAlign(LEFT);
  textSize(25);
  text("Legend", xMainWindow - legendWidth - legendRectangleTextPad, (yMainWindow * legendRectangleYPositionPercentage) + 30 );
  textSize(15);
  text("Inter Point Line Thickness   =   GDP_per_capita change", xMainWindow - legendWidth - legendRectangleTextPad, (yMainWindow * legendRectangleYPositionPercentage) + 2* 30 );
  text("Pie Chart Black Area   =   Percentage of Population Using Social Media", xMainWindow - legendWidth - legendRectangleTextPad, (yMainWindow * legendRectangleYPositionPercentage) + 3 *  30 );
  
}

 
void draw() {
  background(255);
  textAlign(LEFT);
  drawAxis();
  drawGDPLines();
  drawPoints();
  determineMouseOver();
  drawAxisLabels();
  drawLegend();
  
  //println(mouseX);
  //println(mouseY);
  
  

  
  
} // function 
