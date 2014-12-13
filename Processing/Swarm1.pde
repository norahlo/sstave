
import processing.opengl.*;
import plethora.core.*;
import toxi.geom.*;
import peasy.*;

//using peasycam
PeasyCam cam;

//declare plethora Terrain
Ple_Terrain pTer;

//declare a float array to store the image info
float [][] heights;

int DIMX = 1000;
int DIMY = 1000;

void setup() {
  size(1200, 600, OPENGL);
  smooth();
  cam = new PeasyCam(this, 600);

 //declare a vector as the location
  Vec3D location = new Vec3D(-DIMX/2,-DIMY/2,0);
  //initialize the terrain, specifying columns and rows and cell Size
  pTer = new Ple_Terrain(this, location,  200,200, 5, 5);
  
  //apply noise to heights
  pTer.noiseHeight(0, 100);
}

void draw() {
  background(235);
  
  stroke(0,90);
  strokeWeight(1);
  noFill();
  rect(-DIMX/2,-DIMY/2,    DIMX,DIMY);
  
  //define crop active and then specify values for boundry
  pTer.setCropActive(true);
  float cX = map(mouseX,0,width,-500,500);
  pTer.crop(-500,-500,-500,    cX,500,500);

  //call some of the functions of the terrain
  stroke(0,90);
  strokeWeight(2);
  pTer.display();
  
  //draw lines (horizontal, vertical or diagonal... or all of them!) 
  stroke(0,90);
  strokeWeight(1);
  pTer.drawLines(true,false,false);
  
}

