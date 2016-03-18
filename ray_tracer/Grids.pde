import java.lang.Math.*;
public class Grids extends Shape{
  
  ShapeList[][][] grid;
  Box box;
  
  float delta_x;
  float delta_y;
  float delta_z;
  
  
  public Grids(ArrayList<Shape> shapes, Box box){
    
    //float zmintemp = box.zmin;
    //box.zmin = box.zmax;
    //box.zmax = zmintemp;
    
    this.box = box;
    int sideLength = (int)Math.cbrt(shapes.size()/2);
    
    float delta_x = (box.xmax-box.xmin)/(float)sideLength;
    float delta_y = (box.ymax-box.ymin)/(float)sideLength;
    float delta_z = (box.zmax-box.zmin)/(float)sideLength;

    grid = new ShapeList[sideLength][sideLength][sideLength];
    for(int i=0; i<shapes.size(); i++){
      Point minPoint = shapes.get(i).minPoint();
      Point maxPoint = shapes.get(i).maxPoint();
      
      
      PVector minIndex = getGridIndicies(minPoint, new Point(box.xmin, box.ymin, box.zmin));
      PVector maxIndex = getGridIndicies(maxPoint, new Point(box.xmin, box.ymin, box.zmin));
      
      /**
      int xmin = floor((minPoint.getX()-box.xmin)/delta_x);
      int xmax = ceil((maxPoint.getX()-box.xmin)/delta_x);
      int ymin = floor((minPoint.getY()-box.ymin)/delta_y);
      int ymax = min(ceil((maxPoint.getY()-box.ymin)/delta_y), sideLength);
      // z is weird the xmin is actually the farthest away point
      //int zmin = floor((box.zmax - maxPoint.getZ())/delta_z);
      //int zmax = ceil((box.zmax - minPoint.getZ())/delta_z);
      
      int zmin = 0;
      int zmax = sideLength;
      **/
      
      //if(i==100){
      //  println(minIndex);
      //  println(maxIndex);
      //}

      for(int a = (int)minIndex.x; a < (int)maxIndex.x; a += 1){
        for(int b = (int)minIndex.y; b < (int)maxIndex.y; b += 1){
          for(int c = (int)minIndex.z; c < (int)maxIndex.z; c += 1){
            try{
              ShapeList currGrid = grid[a][b][c];
              if(currGrid == null){
                currGrid = new ShapeList(shapes.get(i));
              }
              else{
                currGrid.addShape(shapes.get(i));
              }
            }
            catch(ArrayIndexOutOfBoundsException e){
              //println("box dim: " + sideLength);
              //println(a);
              //println(b);
              //println(c);
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
    
    PVector step = new PVector(1, 1, 1);
    if(direction.x < 0){
      step.x = -1;
    }
    if(direction.y < 0){
      step.y = -1;
    }
    if(direction.z < 0){
      step.z = -1;
    }
    
    PVector out = new PVector(box.xmin, box.ymin, box.zmin);
    if(direction.x > 0){
      out.x = box.xmax;
    }
    if(direction.y > 0){
      out.y = box.ymax;
    }
    if(direction.z > 0){
      out.z = box.zmax;
    }
    
    Point firstPoint = firstIntersection.getIntersectionPoint();
    // if ray starts inside box
    if(box.inside(origin)){
      firstPoint = origin;
    }

    int start_x = 0;
    int start_y = 0;
    int start_z = 0;
    
        
    for(float x = box.xmin; x <= box.xmax; x+=delta_x){
      if(firstPoint.getX() >= x){
        start_x = (int)((x - box.xmin)/delta_x);
        break;
      }
    }
    
    for(float y = box.ymin; y <= box.ymax; y+= delta_y){
      if(firstPoint.getY() >= y){
        start_y = (int)((y - box.ymin)/delta_y);
        break;
      }
    }
    
    for(float z = box.zmax; z >= box.zmin; z-= delta_z){
        if(firstPoint.getZ() <= z){
          start_z = (int)((z-box.zmin)/delta_z);
          break;
        }
    }
    
    PVector currIndex = new PVector(start_x, start_y, start_z);
    PVector currPoint = new PVector(firstPoint.getX(), firstPoint.getY(), firstPoint.getZ());
    
    while(inBounds(currIndex)){
      ShapeList tempList = grid[(int)currIndex.x][(int)currIndex.y][(int)currIndex.z];
      if(tempList != null){
        float minTime = MAX_FLOAT;
        IntersectionObject intersectionInfo = null;
        // println(shapes.size());
        for(Shape a : tempList.getShapes()){
          IntersectionObject currIntersectionInfo = a.intersects(tempRay);
          if(currIntersectionInfo.getTime() > 0 && currIntersectionInfo.getTime() < minTime){
            minTime = currIntersectionInfo.getTime();
            intersectionInfo = currIntersectionInfo;
          }
        }
        // if intersectionInfo is not null, check that the point is inside the current voxel
        if(intersectionInfo != null){
          Point intersect = intersectionInfo.getIntersectionPoint();
          if(intersectionInVoxel(currIndex, intersect)){
            return intersectionInfo;
          }
        }
        // else we move onto the next box to check
        PVector nextIndex = new PVector(start_x + step.x, start_y + step.y, start_z + step.z);
        PVector nextPoint = getPointFromIndex(nextIndex);
        
        float delta_tx = (nextPoint.x-currPoint.x)/direction.x;
        float delta_ty = (nextPoint.y-currPoint.y)/direction.y;
        float delta_tz = (nextPoint.z-currPoint.z)/direction.z;
        if(delta_tx == min(delta_tx, delta_ty, delta_tz)){
          currIndex.x += step.x;
        }
        else if(delta_ty == min(delta_tx, delta_ty, delta_tz)){
          currIndex.y += step.y;
        }
        else{
          currIndex.z += step.z;
        }
        nextPoint = getPointFromIndex(currIndex);
      }
    
    }
        
    return new IntersectionObject(-1, null);
  }
    
  public PVector shapeNormal(Point hitPoint){
    return new PVector();
  }
  
  public PVector getPointFromIndex(PVector index){
    return new PVector(box.xmin + index.x * delta_x, box.ymin + index.y * delta_y, box.zmax - index.y*delta_y);
  }
  public PVector getGridIndicies(Point currPoint, Point startPoint){
    PVector diff = currPoint.subtract(startPoint);
    return new PVector((int)(diff.x/delta_x),(int)(diff.y/delta_y),(int)(diff.y/delta_z));
  }
  public boolean inBounds(PVector index){
    if((int)index.x < 0 || index.x >= grid.length){
      return false;
    }
    if(index.y < 0 || index.y >= grid.length){
      return false;
    }
    if(index.z < 0 || index.z >= grid.length){
      return false;
    }
    return true;
  }
  
  public boolean intersectionInVoxel(PVector index, Point intersection){
    PVector minPoint = getPointFromIndex(index);
    float x = intersection.getX();
    float y = intersection.getY();
    float z = intersection.getZ();
    if(!(x > minPoint.x && x < minPoint.x+delta_x)){
      return false;
    }
    if(!(y > minPoint.y && y < minPoint.y+delta_y)){
      return false;
    }
    if(z > minPoint.z || z < minPoint.z-delta_z){
      return false;
    }
    return true;
  }
}