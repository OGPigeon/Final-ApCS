/* CSV Lab
   This is NOT a coding lab. 
   Study the code below. Make sure you understand how the code reads in
   a csv file and create a game/stage map.
   The code is from the tutorial: https://youtu.be/RhD6bzSHBeI
   
   Do the following:
   1) Modify the "map.csv" file and design a Platformer stage map with all of the tiles given
   in the data folder.
   2) Assume the Sprite scale where tiles are 50 x 50, modify the csv file to match
   the exact dimensions of the window(800 x 600). Since we haven't done scrolling, we can't
   see tiles outside of this range. 
*/


final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.6;
final static float jumpSpeed = 14;

final static float Right_Margin = 400;
final static float Left_Margin = 60;
final static float Vertical_Margin = 40;

//declare global variables
Sprite p;
PImage snow, crate, red_brick, brown_brick;
PImage img;
ArrayList<Sprite> platforms;

float view_x = 0;
float view_y = 0;
 
//initialize them in setup().
void setup(){
  size(802, 600);
  imageMode(CENTER);
  p = new Sprite("yellow.png", 0.04, 400, 300);
  p.change_x = 0;
  p.change_y = 0;
  platforms = new ArrayList<Sprite>();
  red_brick = loadImage("diamond.png");
  brown_brick = loadImage("craft2.png");
  crate = loadImage("craft.png");
  snow = loadImage("craft1.png");
  createPlatforms("map.csv");
}

// modify and update them in draw().
void draw(){
  img = loadImage("backgound.png");
  background(img);

  scroll();
  p.display();
  resolvePlatformCollisions(p, platforms);
  
  for(Sprite s: platforms)
    s.display();
} 

void scroll(){
  float right_boundary = view_x + width - Right_Margin;
  if(p.getRight() > right_boundary){
    view_x += p.getRight() - right_boundary;
  }
  
  float left_boundary = view_x + Left_Margin;
  if(p.getLeft() < left_boundary){
    view_x -= left_boundary - p.getLeft();
  }
  
  float bottom_boundary = view_y + height - Vertical_Margin;
  if(p.getBottom() > bottom_boundary){
    view_y += p.getBottom() - bottom_boundary;
  }
  
  float top_boundary = view_y + Vertical_Margin;
  if(p.getTop() < top_boundary){
    view_y -= top_boundary - p.getTop();
  }
  translate(-view_x, -view_y);
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  s.center_y +=5;
  ArrayList<Sprite> colList = checkCollisionList(s, walls);
  s.center_y -=5;
  if(colList.size() > 0){
    return true;
  }else
    return false;
  
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  s.change_y += GRAVITY;
  
  s.center_y += s.change_y;
  ArrayList<Sprite> colList= checkCollisionList(s, walls);
  if(colList.size()>0){
    Sprite collided = colList.get(0);
    if(s.change_y >0){
      s.setBottom(collided.getTop());
    }else if(s.change_y < 0){
      s.setTop(collided.getBottom()); 
    }
    s.change_y = 0;
  }
  
  
  s.center_x += s.change_x;
  colList= checkCollisionList(s, walls);
  if(colList.size()>0){
    Sprite collided = colList.get(0);
    if(s.change_x >0){
      s.setRight(collided.getLeft());
    }else if(s.change_x < 0){
      s.setLeft(collided.getRight()); 
    }
  }
}

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }else{
    return true;
  }
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collisionList = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s,p))
      collisionList.add(p);
  }
  return collisionList;
}


void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("1")){
        Sprite s = new Sprite(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("2")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("3")){
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("4")){
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
    }
  }
  
  
}

// called whenever a key is pressed.
void keyPressed(){
  if(keyCode == RIGHT){
    p.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT){
    p.change_x = -MOVE_SPEED;
  }
   else if(keyCode == UP && isOnPlatforms(p,platforms)){
    p.change_y = -jumpSpeed;
  }
}

// called whenever a key is released.
void keyReleased(){
  if(keyCode == RIGHT){
    p.change_x = 0;
  }
  else if(keyCode == LEFT){
    p.change_x = 0;
  }
}
