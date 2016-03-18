import java.lang.Math.*;

public class Grids extends Shape{
  
  ShapeList[][][] grid;
  Box box;
  float delta_x;
  float delta_y;
  float delta_z;
  
  public Grids(ArrayList<Shape> shapes, Box box){
    this.box = box;
    int sideLength = (int)Math.cbrt(shapes.size()/2);
    
    float cell_x = (box.xmax-box.xmin)/(float)sideLength;
    float cell_y = (box.ymax-box.ymin)/(float)sideLength;
    float cell_z = (box.zmax-box.zmin)/(float)sideLength;
    
    delta_x = cell_x;
    delta_y = cell_y;
    delta_z = cell_z;
    
    boolean setX = true;
    boolean setY = true;
    boolean setZ = true;
    
    grid = new ShapeList[sideLength][sideLength][sideLength];
    for(int i=0; i<shapes.size(); i++){
      Point minPoint = shapes.get(i).minPoint();
      Point maxPoint = shapes.get(i).maxPoint();
      float xmin = box.xmax;
      float xmax = box.xmin;
      float ymin = box.ymax;
      float ymax = box.ymin;
      float zmin = box.zmax;
      float zmax = box.zmin;
      for(float x = box.xmin; x <=box.xmax; x+=cell_x){
        if(minPoint.getX() >= x && setX){
          xmin = x;
          setX = false;
        }
        if(maxPoint.getX() <= x){
          xmax = x;
          break;
        }
      }
      for(float y = box.ymin; y <= box.ymax; y+=cell_y){
        if(minPoint.getY() >= y && setY){
          ymin = y;
          setY = false;
        }
        if(maxPoint.getY() <= y){
          ymax = y;
          break;
        }
      }
      for(float z = box.zmin; z <= box.zmax; z+=cell_z){
        if(minPoint.getZ() >= z && setZ){
          zmin = z;
          setZ = false;
        }
        if(maxPoint.getZ() <= z){
          zmax = z;
          break;
        }
      }
      
      for(float a = xmin; a < xmax; a += cell_x){
        for(float b = ymin; b < ymax; b += cell_y){
          for(float c = zmin; c < zmax; c += cell_z){
            if(grid[(int)((a-xmin)/cell_x)][(int)((b-ymin)/cell_y)][(int)((c-zmin)/cell_z)] == null){
              grid[(int)((a-xmin)/cell_x)][(int)((b-ymin)/cell_y)][(int)((c-zmin)/cell_z)] = new ShapeList(shapes.get(i));
            }
            else{
              grid[(int)((a-xmin)/cell_x)][(int)((b-ymin)/cell_y)][(int)((c-zmin)/cell_z)].addShape(shapes.get(i));
            }
          }
        }
      }
    }
  }
  public String debug(){
    return "GRID";
  }
  
  public IntersectionObject intersects(Ray tempRay){
    Point origin = tempRay.getOrigin();
    PVector direction = tempRay.getDirection();
    
    IntersectionObject firstIntersection = box.intersects(tempRay);
    if(firstIntersection.getTime() < 0){
      return new IntersectionObject(-1, null);
    }
    
    Point firstPoint = firstIntersection.getIntersectionPoint();
    
    
    float delta_tx = delta_x/direction.x;
    float delta_ty = delta_y/direction.y;
    float delta_tz = delta_z/direction.z;
    
    int pos_x = 0;
    
    
    return firstIntersection;
  }
    
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
}